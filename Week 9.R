#### Introduction####
# Topic modeling is a widespread computational method of discovering latent topics 
# in a collection of documents. Each document is assigned a probability of  belonging 
# to a latent theme or “topic”.

#### stm package####

# We first need to load in the texts used in the analysis
# Let's load in the required packages
library(tidyverse)
library(gutenbergr)
library(tidytext)

# Downloading the data
hardy_meta <- gutenberg_works(author == "Hardy, Thomas") # Download metadata for Hardy's works
hardy_meta <- hardy_meta %>% 
  slice(c(1,2,3,4,5,6,7,8,10,11,13,18,22,23,24))

hardy_tidy_texts <- gutenberg_download(hardy_meta$gutenberg_id, 
                                       meta_fields = "title") 

hardy_tidy_texts <- hardy_tidy_texts %>% # data
  mutate(line = row_number()) %>% # keep track of which line each word is coming from
  unnest_tokens(word, text) %>% # one word per row instead of one line per row
  anti_join(stop_words) # remove stop words

# See most frequent words
hardy_tidy_texts %>% 
count(word, sort = TRUE)

hardy_tf_idf <- hardy_tidy_texts %>%
  count(title, word, sort = TRUE) %>% # how many times each word was used in each novel
  bind_tf_idf(word, title, n) %>% # column, the book, counts
  arrange(-tf_idf) %>% # arrange in a descending order
  group_by(title) %>% # group by the book
  top_n(10) %>% #we take the top 
  ungroup

hardy_tf_idf %>%
  mutate(word = reorder_within(word, tf_idf, title)) %>% # show words in the same order as tf_idf
  ggplot(aes(word, tf_idf, fill = title)) + #word x axis, tf_idf y axis, color tied to book
  geom_col(alpha = 0.8, show.legend = FALSE) + #barplot, transparency 0.8, no legend
  facet_wrap(~ title, scales = "free", ncol = 5) + #facet according to title, free scales, 3 cols
  scale_x_reordered() +
  coord_flip() + #flip plots so that they are horizontal
  theme(strip.text=element_text(size=11)) + # indicating theme for better aesthetics
  labs(x = NULL, y = "tf-idf", # labels
       title = "Highest tf-idf words in Thomas Hardy's novels")

# Structural topic modeling uses metadata about the collection of texts to improve the process
library(quanteda) # used to create the structure
library(stm) # structured topic modeling

hardy_dfm <- hardy_tidy_texts %>%
  count(title, word, sort = TRUE) %>% # word frequency per book, descending order
  cast_dfm(title, word, n) # create document frequency matrix (quanteda)

hardy_sparse <- hardy_tidy_texts %>%
  count(title, word, sort = TRUE) %>%
  cast_sparse(title, word, n)

topic_model <- stm(hardy_dfm, K = 9, 
                   verbose = FALSE, init.type = "Spectral")

td_beta <- tidy(topic_model) # tidy function of broom package

# Top words for each topic (beta visualization)
td_beta %>%
  group_by(topic) %>% 
  top_n(10, beta) %>% # top words per topic
  ungroup() %>% 
  mutate(topic = paste0("Topic ", topic),
         term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = as.factor(topic))) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y") +
  coord_flip() +
  scale_x_reordered() +
  labs(x = NULL, y = expression(beta),
       title = "Highest word probabilities for each topic",
       subtitle = "Different words are associated with different topics")

# In which documents (novels) can the topics be found?

td_gamma <- tidy(topic_model, matrix = "gamma",                     
                 document_names = rownames(hardy_dfm))

td_gamma %>% 
ggplot(aes(gamma, fill = as.factor(topic))) + # histogram so only one variable needed
  geom_histogram(alpha = 0.8, show.legend = FALSE) + 
  facet_wrap(~ topic, ncol = 3) + # facet wrap according to topic
  labs(title = "Distribution of document probabilities for each topic",
       subtitle = "Each topic is associated with 1-3 novels",
       y = "Number of novels", x = expression(gamma))

#### Tidymodels package####
library(topicmodels)

titles <- c("Dracula", 
            "The War of the Worlds",
            "Tess of the d'Urbervilles: A Pure Woman", 
            "Elizabeth and Her German Garden")

books <- gutenberg_works(title %in% titles) %>%
  gutenberg_download(meta_fields = "title")

??`%in%`
# divide into documents, each representing one chapter
by_chapter <- books %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(
    text, regex("^chapter ", ignore_case = TRUE)
  ))) %>%
  ungroup() %>%
  filter(chapter > 0) %>%
  unite(document, title, chapter)

# split into words
by_chapter_word <- by_chapter %>%
  unnest_tokens(word, text)

# find document-word counts
word_counts <- by_chapter_word %>%
  anti_join(stop_words) %>%
  count(document, word, sort = TRUE) %>%
  ungroup()

word_counts

# document term matrix of all chapters
chapters_dtm <- word_counts %>%
  cast_dtm(document, word, n)

chapters_dtm

# running the topic model
chapters_lda <- LDA(chapters_dtm, k = 4, control = list(seed = 1234)) # data, num. of topics, seed
chapters_lda

chapter_topics <- tidy(chapters_lda, matrix = "beta")
chapter_topics

top_terms <- chapter_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 5) %>% 
  ungroup() %>%
  arrange(topic, -beta)

top_terms
str(top_terms)
top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

chapters_gamma <- tidy(chapters_lda, matrix = "gamma")
chapters_gamma

chapters_gamma <- chapters_gamma %>%
  separate(document, c("title", "chapter"), sep = "_", convert = TRUE)

chapters_gamma

# reorder titles in order of topic 1, topic 2, etc before plotting
chapters_gamma %>%
  mutate(title = reorder(title, gamma * topic)) %>%
  ggplot(aes(factor(topic), gamma)) +
  geom_boxplot() +
  facet_wrap(~ title) +
  labs(x = "topic", y = expression(gamma))

chapter_classifications <- chapters_gamma %>%
  group_by(title, chapter) %>%
  slice_max(gamma) %>%
  ungroup()

chapter_classifications

book_topics <- chapter_classifications %>%
  count(title, topic) %>%
  group_by(title) %>%
  slice_max(n, n = 1) %>% 
  ungroup() %>%
  transmute(consensus = title, topic)

chapter_classifications %>%
  inner_join(book_topics, by = "topic") %>%
  filter(title != consensus)

assignments <- augment(chapters_lda, data = chapters_dtm)
assignments

assignments <- assignments %>%
  separate(document, c("title", "chapter"), 
           sep = "_", convert = TRUE) %>%
  inner_join(book_topics, by = c(".topic" = "topic"))

assignments

library(scales)

assignments %>%
  count(title, consensus, wt = count) %>%
  mutate(across(c(title, consensus), ~str_wrap(., 20))) %>%
  group_by(title) %>%
  mutate(percent = n / sum(n)) %>%
  ggplot(aes(consensus, title, fill = percent)) +
  geom_tile() +
  scale_fill_gradient2(high = "darkred", label = percent_format()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.grid = element_blank()) +
  labs(x = "Book words were assigned to",
       y = "Book words came from",
       fill = "% of assignments")

wrong_words <- assignments %>%
  filter(title != consensus)

wrong_words

wrong_words %>%
  count(title, consensus, term, wt = count) %>%
  ungroup() %>%
  arrange(desc(n))

####Package of the week####
# We will also use the mallet package 

# The package is originally written in Javascript, and the package is simply an R wrapper 
# for it. This means that we will need to install the appropriate version of Java, available
# here: https://www.java.com/en/download/manual.jsp 

# You are likely to encounter an error when running the package. The solution can be found in the
# following link (I've included it in the code below)
# https://www.r-bloggers.com/2012/08/how-to-load-the-rjava-package-after-the-error-java_home-cannot-be-determined-from-the-registry/

Sys.setenv(JAVA_HOME = "C:/Program Files/Java/jre1.8.0_291")
library(rJava)
library(mallet)

# create a vector with one string per chapter
collapsed <- by_chapter_word %>%
  anti_join(stop_words, by = "word") %>%
  mutate(word = str_replace(word, "'", "")) %>%
  group_by(document) %>%
  summarize(text = paste(word, collapse = " "))

# create an empty file of "stopwords"
file.create(empty_file <- tempfile())
docs <- mallet.import(collapsed$document, collapsed$text, empty_file)

mallet_model <- MalletLDA(num.topics = 4)
mallet_model$loadDocuments(docs)
mallet_model$train(1000)

# from here on out the process is essentially the same as with the previous visualizations!
# word-topic pairs
tidy_mallet_a <- tidy(mallet_model) 

top_terms_mallet <- tidy_mallet_a %>%
  group_by(topic) %>%
  slice_max(beta, n = 5) %>% 
  ungroup() %>%
  arrange(topic, -beta)

top_terms_mallet %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

# document-topic pairs
tidy_mallet_b <- tidy(mallet_model, matrix = "gamma")
tidy_mallet_b <- tidy_mallet_b %>% 
  separate(document, c("title", "chapter"), sep = "_", convert = TRUE)

tidy_mallet_b %>%
  mutate(title = reorder(title, gamma * topic)) %>%
  ggplot(aes(factor(topic), gamma)) +
  geom_boxplot() +
  facet_wrap(~ title) +
  labs(x = "topic", y = expression(gamma))