#### Calculating MATTR and sentiment####
install.packages("koRpus")
install.packages("koRpus.lang.en")
install.koRpus.lang("en")
library(koRpus)
library(koRpus.lang.en)
library(tidyverse)
library(gutenbergr)
library(tidytext)

# Downloading the metadata and the texts
hardy_meta <- gutenberg_works(author == "Hardy, Thomas") # Download metadata for Hardy's works
hardy_meta <- hardy_meta %>% # Manually selecting only Hardy's novels
  slice(c(1,2,3,4,5,6,7,8,10,11,13,18,22,23,24))

# Downloading the texts
hardy_tidy_texts <- gutenberg_download(hardy_meta$gutenberg_id, 
                                       meta_fields = c("title","gutenberg_id")) 

# Making a list of the texts according to the title column
split_hardy <- split(hardy_tidy_texts, hardy_tidy_texts$title)

# Selecting only the text column in each element of the list
hardy_strings <- lapply(split_hardy, function(x) x%>% select(text))

# Converting these columns to strings (creating a character vector)
hardy_strings <- sapply(hardy_strings, toString)

# Collecting the names of the books and assigning them as names of each element of the 
# hardy_strings character vector (in order to remove characters not allowed as names for files in
# Windows)

names(hardy_strings) <-  c("A Laodicean-A Story of To-day", "A Pair of Blue Eyes","Desperate Remedies", "Far from the Madding Crowd", "Jude the Obscure", "Tess of the d'Urbervilles", "The Hand of Ethelberta", "The Mayor of Casterbridge", "The Return of the Native", "The Romantic Adventures of a Milkmaid", "The Trumpet-Major", "The Well-Beloved", "The Woodlanders", "Two on a Tower","Under the Greenwood Tree")

# Saving each element of the character vector as a .txt file in the working directory
for (i in 1:length(hardy_strings)) {
  write.csv(hardy_strings[i], file=paste0(names(hardy_strings)[i], ".txt")) #paste0 faster version
  # of paste, with sep = "" as a default argument
}

# The files were manually moved to the "Text files/Week 10/" subfolder

# Assigning the filenames to an object
filenames <- list.files(path="Text files/Week 10/", pattern="*.txt", full.names=T, recursive=FALSE)

# Tokenizing all of the novels (the MATTR function needs to be run on koRpus objects)
text.tagged <- lapply(filenames, function(x) koRpus::tokenize(x, lang="en"))

# Applying the MATTR function on every element of the list (the koRpus object of each book)
raw_MATTR_values <- lapply(text.tagged, MATTR, window = 100)

# Extracting only the MATTR values from the resulting data structure
final_MATTR_values <- sapply(lapply(raw_MATTR_values,slot,'MATTR'),'[',c('MATTR'))

# Sapply didn't convert the output to a vector so we have to do it with the unlist function
final_MATTR_values <- unlist(final_MATTR_values)

# Assigning names to the elements of the numeric vector
names(final_MATTR_values) <- c("A Laodicean-A Story of To-day", "A Pair of Blue Eyes","Desperate Remedies", "Far from the Madding Crowd", "Jude the Obscure", "Tess of the d'Urbervilles", "The Hand of Ethelberta", "The Mayor of Casterbridge", "The Return of the Native", "The Romantic Adventures of a Milkmaid", "The Trumpet-Major", "The Well-Beloved", "The Woodlanders", "Two on a Tower","Under the Greenwood Tree")

# The following converts
final_MATTR_values <- data.frame(final_MATTR_values)
library(data.table)
# We use the setDT() function from the data.table package to convert the rownames to values of a
# separate column
final_MATTR_values<- setDT(final_MATTR_values, keep.rownames = TRUE)[]
colnames(final_MATTR_values)[1] <- "Title"

# We now have the final MATTR values for each of Hardy's novels. We will also need another variable
# of measurements, as clustering needs at least two. We will now add sentiment related information
# to the dataframe, which we did during the 8th session.

library(sentimentr)
library(magrittr)

hardy_sentiment <- hardy_tidy_texts %>% 
  mutate(sentences = get_sentences(text)) %$% # exposition pipe, exposing specific variables to function
  sentiment_by(sentences, title)

# combining the two plots together

clustering_dataset <- cbind(final_MATTR_values, hardy_sentiment) %>% 
  select(-3) %>% 
  rename(title=Title) 

####k means clustering####
install.packages("broom")
library(broom)

# Power law distributions are very bad for K means clustering, because the resulting classification # is very uneven. 

# Check distribution of variables
ggplot(clustering_dataset, aes(clustering_dataset$ave_sentiment))+ #check final_MATTR_values too
  geom_histogram()

# All clustering that we are doing here needs to be done with data that is normally distributed. 
# When it comes to power law distribution, a large role is played by sheer chance, so correlation 
# is unwarranted.
library(ggrepel)

ggplot(clustering_dataset, aes(final_MATTR_values, ave_sentiment)) +
  geom_point()

km_fit <- clustering_dataset %>% 
  select(final_MATTR_values, ave_sentiment) %>% 
  kmeans(centers = 3, nstart = 10) #arguments - cluster centers, number of restarts of the algorithm
?kmeans
clustering_plot <- km_fit %>% 
  augment(clustering_dataset) %>% 
  ggplot() +
  aes(x = final_MATTR_values, y = ave_sentiment) +
  geom_point(
    aes(color = .cluster)
  ) +
  geom_point(
    data = tidy(km_fit),
    aes(fill = cluster),
    shape = 21, color = "black", size = 4
  ) +
  guides(color = "none")

clustering_plot <- clustering_plot +
  geom_label_repel((aes(label = title)),
      box.padding   = 0.35, 
      point.padding = 0.5,
      segment.color = 'grey50') +
      theme_classic() +
  ggtitle("K means clustering of Hardy's novels (avg. sentiment and MATTR)") +
  xlab("MATTR values") +
  ylab("avg. sentiment")
clustering_plot

#export as 6x9

# Determining number of clusters for the dataset
calc_withinss <- function(data, centers) {
  km_fit <- select(data, where(is.numeric)) %>%
    kmeans(centers = centers, nstart = 10)
  km_fit$tot.withinss
}
tibble(centers = 1:10) %>%
  mutate(
    within_sum_squares = map_dbl(
      centers, ~calc_withinss(clustering_dataset, .x)
    )
  ) %>%
  ggplot() +
  aes(centers, within_sum_squares) +
  geom_point() +
  geom_line()

#### Hierarchical clustering####
# The base R dist function computes 
dist <- dist(clustering_dataset[ , c(2,5)] , diag=TRUE) # selecting only the 2nd and 5th column
?dist

# Hierarchical clustering with hclust
hc <- hclust(dist)

# Plot the result
plot(hc,
     labels = clustering_dataset$title, 
     main = "Dendrogram of Hardy's Novels",
     xlab = "Distance", 
     ylab = "Height")
rect.hclust(hc, k = 3, border = 2:4)
?rect.hclust
# export in 9x6

####Package of the week#### 
library(FactoMineR)
library(factoextra)

# Partition clustering

# Loading and preparing data
df <- clustering_dataset[,c(2,5)] #
# Computing k-means
set.seed(123)
km.res <- kmeans(df, 3, nstart = 10)
# Visualization
str(clustering_dataset)
part_cluster_plot <- fviz_cluster(km.res, data = df,
             geom = "point",
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             main = "Partitioning Clustering Plot"
)

part_cluster_plot <- part_cluster_plot +
  geom_label_repel((aes(label = clustering_dataset$title)),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50') +
  theme_classic()
part_cluster_plot

# export in 6x9  