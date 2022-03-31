#### Token distribution####
# Token distribution is a relatively simple textual analysis that visualizes occurrences of certain words throughout the text.

# This part of the script will rely exclusively on base R (code adapted from Text Analysis for Students of Literature by Matthew Jockers)

# Setting a working directory
setwd("C:/Users/Stefan/OneDrive - MUNI/Github/R-for-students-of-literature")
getwd()

# Loading in the text from the course repository (remember to first clone the contents of the repository to your computer)
text_v <- scan("Text files/Dracula.txt", what = "character", sep = "\n")

# The original file has an extra empty line between the title and the body of the text, which is why text_v has two elements.

# The following line combines these two elements into one so that we get a character vector of length one.
dracula_v <- paste(text_v, collapse = " ")
dracula_v

# The next several lines prepare the data for plotting

dracula_lower_v <- tolower(dracula_v) # convert vector to lowercase
dracula_words_l <- strsplit(dracula_lower_v, "\\W") # splitting the string (character vector) into words. The output is a list.
dracula_words_v <- unlist(dracula_words_l) # unlist converts a list into a vector, basically a faster way of running as.vector. This practically flattens the list.
not_blanks_v <- which(dracula_words_v != "") # getting the index positions of all of the words that are not blank
dracula_words_v <- dracula_words_v[not_blanks_v] # overwriting dracula_words_v so that only the words that are not blanks are retained.
dracula_words_v
# Running the variable above produces only the first 1000 elements of the character vector
# The expression below allows you to override this limitation and to print big objects such as this one in their entirety.
options(max.print = 999999)

n_time_v <- seq(1:length(dracula_words_v)) # n_time_v stores a sequence that creates index positions for each word
dracula_w_v <- which(dracula_words_v == "dracula") # this creates an integer vector that stores all of the occurrences of the word dracula in the whole novel
d_count_v <- rep(NA, length(n_time_v)) # this creates a numeric vector with the same length as n_time_v, which contains NA values in each index position
d_count_v[dracula_w_v] <- 1 # this expression assigns value 1 to each position where the word dracula appears in the novel. So wherever the word dracula appears, d_count_v contains a 1, while words that are not dracula remain NAs.

# We can run the length () function on the dracula_w_v object to see how many times the word dracula is mentioned in the book
length(dracula_w_v)

# Plotting the occurrences of "dracula"

plot(d_count_v, # data
  main = "Occurrences of the eponymous character in Dracula", # title
  xlab = "Novel Time", # x axis label
  ylab = "dracula", # y axis label
  type = "h", # this indicates the type of the plot, in this case a histogram
  ylim = c(0, 1), # the range of observations depicted on the y axis
  yaxt = "n", # suppresses the occurrence of scales and labels on the y axis
  col = "brown1" # choosing a color. Google "colors in R" for the cheat sheet
)

# Export in 3x7 resolution

# Check the documentation of the function
?plot

# Plotting the occurrences of "helsing"
helsing_w_v <- which(dracula_words_v == "helsing") # storing all occurrences in integer vector
h_count_v <- rep(NA, length(n_time_v)) # mark each index position as NA
h_count_v[helsing_w_v] <- 1 # mark the occurrences with a 1

# How many times van helsing is mentioned in the book
length(helsing_w_v)

plot(h_count_v, # data
  main = "Occurrences of 'van helsing' in Dracula", # title
  xlab = "Novel Time", # x axis label
  ylab = "van helsing", # y axis label
  type = "h", # this indicates the type of the plot, in this case a histogram
  ylim = c(0, 1), # the range of observations depicted on the y axis
  yaxt = "n", # suppresses the occurrence of scales and labels on the y axis
  col = "cadetblue3" # choosing a color.
) 

# Export in 3x7 resolution

# Combining the two plots together

par(mfrow = c(2, 1)) # this base R function creates a matrix (two rows in this case)
# which is filled in with the plots

# Note that base R plots cannot be stored as objects, so we need to copy paste the code for the two visualizations above

plot(d_count_v,
  main = "Occurrences of the eponymous character in Dracula",
  xlab = "Novel Time",
  ylab = "dracula",
  type = "h",
  ylim = c(0, 1),
  yaxt = "n",
  col = "brown1"
)

plot(h_count_v,
  main = "Occurrences of 'van helsing' in Dracula",
  xlab = "Novel Time",
  ylab = "van helsing",
  type = "h",
  ylim = c(0, 1),
  yaxt = "n",
  col = "cadetblue3"
)

# export as 5x7

#### Working with Project Gutenberg data####

# Loading the Gutenbergr package and the tidyverse collection of packages
library(gutenbergr)
library(tidyverse)

gutenberg_works() # checking the full Project Gutenberg metadata
hardy_meta <- gutenberg_works(author == "Hardy, Thomas") # loading Thomas Hardy metadata

# You can try the same code for other authors, such as Henry James. The analysis will only deal with Hardy from here on out though.
james_meta <- gutenberg_works(author == "James, Henry")

# Downloading all of Hardy's texts on Project Gutenberg
hardy_texts <- gutenberg_download(hardy_meta$gutenberg_id,
  meta_fields = "title" # only title meta field retained
) 

str(hardy_texts) # title column character vector, but we need it to be a factor vector

hardy_texts$title <- as.factor(hardy_texts$title) # this converts this column to a factor

# We don't need to analyze all 26 of Hardy's novels. Let's create a character vector with four of his most popular novels
subset_v <- c(
  "Jude the Obscure", "Far from the Madding Crowd",
  "The Return of the Native", "Tess of the d'Urbervilles: A Pure Woman"
)

subset_f <- as.factor(subset_v) # converting it to a factor

# Retaining only the texts in the hardy_texts data frame that are featured in subset_f
hardy_subset <- filter(hardy_texts, hardy_texts$title %in% subset_f)

#### Tidy text####
library(tidytext)
# The tidytext package utilizes tidy data principles (but note that it is not a part of the tidyverse collection of packages). Instead of using character strings to store text, it uses data frames with one-token-per-row (word,line,sentence, etc.). The gutenbergr package is also based on tidy text principles so these two packages work great together.

# Counting the most frequent words of each of the four novels
book_words_subset <- hardy_subset %>%
  unnest_tokens(word, text) %>% # tidy text function that takes the text column and tokenizes it so that it stores one word per row.
  count(title, word, sort = TRUE) # this dplyr function counts each unique word per title and sorts them from most to least frequent

# This variable stores the total number of words in each of the four novels
total_words_subset <- book_words_subset %>%
  group_by(title) %>%
  summarize(total = sum(n))

# This overwrites the book_words_subset variable with book_words_subset + another column with the total number of words. This column is needed for the next visualization that looks at the frequency of each word as a fraction of the total number of words, in order to illustrate Zipf's law
book_words_subset <- left_join(book_words_subset, total_words_subset)

book_words_subset

#### Word frequency####
# First visualization - n(term frequency)/(total number of words of the book)

freq_plot <- ggplot(book_words_subset, aes(n / total, fill = title)) + # n/total frequency of words as a fraction of the total number of words. y axis count, x axis n/total - the color is determined by # the book in question
  geom_histogram(show.legend = FALSE) + # histogram visualization and no legend shown
  xlim(NA, 0.0009) + # limits on the x scale on either side, here the limit is on the right side
  facet_wrap(~title, ncol = 2, scales = "free_y") # facet wrapping is the division of the data frame according to some criterion, in this case the title (which is already a factor vector). The other arguments indicate that there will be 2 columns (4 factor levels - 2x2 grid). Also, the scales are free in one dimension (y axis) and fixed in the other (x axis). Check the documentation of facet_wrap for more info!
  freq_plot # note that with ggplot you can actually save the plots as objects in your environment

# Export as 5x7

#### Tf - idf####
# Term frequency - inverse document frequency disregards those words from individual texts that are also common in the other texts of the corpus, and only keeps the most common words unique to the text in question. In a way, this performs similarly to removing stop words from a document.

book_tf_idf <- book_words_subset %>%
  bind_tf_idf(word, title, n) # tidy text function that automatically determines the tf, idf and tf-idf values, and adds them as columns to the original data frame.
book_tf_idf

# If you run the book_tf_idf object you will see that words that are also common in the other books get a idf and tf-idf that is closer to zero. The following three lines of code remove the unnecessary total column and arrange the observations to show those with the largest tf-idf on the top

book_tf_idf <- book_tf_idf %>%
  select(-total) %>%
  arrange(desc(tf_idf))

# The following lines produce a similar plot to freq_plot, that show the top 15 words according to their highest tf-idf.

tf_idf_plot<- book_tf_idf %>% # data frame
  group_by(title) %>% # group by title (pretty self explanatory)
  slice_max(tf_idf, n = 15) %>% # keep only the top 15 observations according to tf-idf
  ungroup() %>% # remove grouping
  ggplot(aes(tf_idf, fct_reorder(word, tf_idf), fill = title)) + # reordering word column according to tf_idf column and coloring each facet of the plot according to the book in question
  geom_col(show.legend = FALSE) + # barplot plot type and disabling the legend
  facet_wrap(~title, ncol = 2, scales = "free") + # facet wrap according to title, 2 columns and free scales
  labs(x = "tf-idf", y = NULL) # label only on x axis
tf_idf_plot

# export as 5x7 

#### Package of the week####

library(wordcloud)

pal <- brewer.pal(8, "Dark2") # RColorBrewer is a required package for the wordcloud package, so we can immediately set the palette that we'll be using later on. This sets eight colors in total and the Dark 2 palette.
?brewer.pal # for more info

# Removing stopwords (i.e. words that don't add much meaning to the sentence, mostly function words - the, a, at, etc.)
book_words_subset <- book_words_subset %>%
  anti_join(stop_words)

# The end result is very similar to what we got by using the tf-idf method

set.seed(1234) # for reproducibility

# Make sure you clear all the previous plots from the R Studio cache first, because they interfere with this function for some reason.
wordcloud(
  words = book_words_subset$word, # the column that the function will use in the analysis
  freq = book_words_subset$n, # the column that will be used for setting the word frequency
  scale = c(5, 0.05), # sets the size of the biggest and the smallest words in the word cloud
  min.freq = 1, # the minimal frequency of the words that you'd like to be shown
  max.words = 150, # the maximum number of words that the function will visualize
  random.order = FALSE, # plot words in decreasing frequency, not randomly
  rot.per = 0.35, # the percentage (in this case 35%) of words in the word cloud that will be rotated by 90 degrees
  colors = pal # the colors used in the word cloud are determined by the pal variable above
) 

# Caveats of word cloud visualizations - area a poor metaphor of numeric value, differences of size poorly conceived by the human eye. Probably the biggest strength of this visualization is the fact that it's visually appealing! Longer words appear more represented because they take up more space. Recommended to use bar plots or lollipop plots instead, if accuracy is the main goal.
