#### tidyverse####

# The tidyverse is a collection of packages that streamline and optimize 
# certain data analysis procedures in data science. 
library(tidyverse)

# The components of the package are visible after loading it with the library function

# The tidyverse often relies on syntax that is a bit different than what we have
# used so far, which is optimized for data analysis. Hence, many data scientists prefer 
# it over base R, and its sheer user base and the wealth of material available 
# makes it indispensable for everyone using R.

# The tidyverse collection of packages can be the topic of a full course, so 
# let's only look at some of the main features of three of its most important packages: readr, 
# dplyr, and ggplot

#### readr#### 

# The readr package is one of the most commonly used tidyverse packages, and is often
# the default way of loading data into R. 

# Let's first set the working directory
setwd("C:/Users/Stefan/OneDrive - MUNI/Github/R-for-students-of-literature")
getwd()

# For the sake of reproducibility it is often preferable to record the process 
# used to load the dataset. Although using the "Import Dataset" button in the R 
# Studio environment may be enticing (and it also relies on the readr package), 
# actually recording the data importing process in the script is best practice. 
# Let's load in the two datasets that we'll be using in this session, available 
# in the course Github repository.

# I go into a bit more detail about the datasets in the respective youtube videos.
Dracula_adaptations <- read_csv("Datasets/Dracula adaptations.csv")
Main_dataset <- read_csv("Datasets/Main dataset.csv")

# This function is not to be confused with the base R function read.csv

#### dplyr####
# Dplyr is a core tidyverse package used in data wrangling, or data manipulation.
# Let's go through some of its most important functions

# select ()
Dracula_adaptations <- Dracula_adaptations[,-1] # standard base R way
Dracula_adaptations <- select(Dracula_adaptations, -1) # tidyverse
Dracula_adaptations <- select(Dracula_adaptations, -X) # benefit of tidyverse way, explicit naming
Dracula_adaptations <- Dracula_adaptations %>% select(-1)

# %>% is a so called pipe operator, adapted in dplyr and the tidyverse in general from 
# the magrittr package. This operator can massively improve the readability of nested code.
# Shortcuts: Ctrl + Shift + M (Windows) or Cmd + Shift + M (Mac)
# Check the documentation of the function
?`%>%`

# you can use the colon operator to select a range spanning multiple columns
Dracula_adaptations %>% 
  select(Director:Studio) 

# The filter function subsets a data frame according to certain conditions that you specify
# In the expression below, only the observations that have the value 1957 in the Year column are 
# retained

Dracula_adaptations %>% 
  filter(Year == 1957) %>% 
  select(Title:Year)

# The arrange function arranges the rows according to the values of a particular column. Very 
# similar to the Excel sort function. The expression below arranges the Dracula_adaptations data
# frame so that the years are in a descending order.
Dracula_adaptations %>% 
  arrange(desc(Year)) 

# The rename function changes the names of the variables/columns. 
rename(Dracula_adaptations, IMDB = ImdB)

# We'll go on a brief digression here connected with renaming column names. The janitor package
# can help us clean up the column names so that they fit the tidyverse style guide
library(janitor)

# We can use the colnames function to see the original column names
colnames(Dracula_adaptations)

# The following expression will change the names. This is probably a bad example because the names
# were pretty clean in the first place, but you get the idea. 

Dracula_adaptations %>% 
  clean_names() %>% 
  colnames()

# This is enough for now, some of the other dplyr functions will be mentioned in the later sessions

# We can save the new, freshly wrangled dataframes either with the base R write.csv function, or 
# preferably with the fwrite function from the data.table package.

data.table::fwrite(Dracula_adaptations, file = "adaptations.csv")
?fwrite # check the documentation

# data.table::fwrite() is much faster than the base R write.csv(), since it uses more CPU cores

#### ggplot2####
# The ggplot2 package is the tidyverse version of the base R plot function, but is much more 
# powerful and visually sophisticated. 

# Let's load one of the datasets that come with R to illustrate the power of the package.
data(mtcars)
str(mtcars) # see the contents of the dataset

?mtcars # check the documentation of the dataset

# First we need to convert some of the variables into factors 
mtcars$cyl <- as.factor(mtcars$cyl) 
mtcars$vs <- as.factor(mtcars$vs) 
mtcars$am <- as.factor(mtcars$am) 

mtcars$am # check factor levels
levels(mtcars$am)[1] <- "Automatic" 
levels(mtcars$am)[2] <- "Manual"

# Instead of just showing 0 and 1, the code above makes the factor labels more intelligible

# Here is a plot that is deliberately a bit of an overkill to illustrate as much as possible of 
# what ggplot can do.
ggplot(mtcars, aes(disp, hp, # data, variables on x and y axis
                   size = mpg, # the size of the datapoints dictated by mpg variable
                   color = cyl, # color dictated by color variable (factor, hence discrete colors,
                   # not shades of a single color)
                   shape = am)) + # shape dictated by the type of transmission
  geom_point(alpha = .3) + # geom_point - scatterplot, alpha - transparency
  labs( # The labels for each element of the legend
    title = "Control Legend Titles w/ labs ()",
    size = "Miles per \nGallon",
    color = "Cylinders", 
    shape = "Transmission" 
  )

# Avoid stuffing this much data in a single plot, as there are certain cognitive limits to 
# how much (visual) information we can process.

# Export in 5x7

#### ggpubr####
library(ggpubr)

# Although not officially a part of the tidyverse collection of packages, this package is made
# by Hadley Wickham, one of the founders of the tidyverse collection of packages, so it fits them 
# well. The main focus of the package is publication level quality of the plots it produces.

# The following visualization will present the correlation of the Goodreads and Open Syllabus data
# Use this to discourage R from using scientific notation (i.e. show 10000 as 10000 not 1e+04 )
options(scipen = 10000)
str(Main_dataset) # Check the structure of the dataset

# Convert relevant variables to factors or numberics respectively
Main_dataset$Ratings <- as.numeric(Main_dataset$Ratings)
Main_dataset$Syllabi <- as.numeric(Main_dataset$Syllabi)
Main_dataset$`Bestseller?` <- as.factor(Main_dataset$`Bestseller?`)

corr_plot <- ggscatter(Main_dataset, # data 
                       x = "Ratings", # x axis 
                       y = "Syllabi", # y axis 
                       add = "reg.line", conf.int = TRUE, # adding regression line and c. interval
                       color = "dimgray", # color (color code reference sheet available on ELF)
                       xscale = "log10", # making the x axis logarithmic
                       yscale = "log10", # making the y axis logarithmic
                       cor.coef = TRUE, # print correlation coefficient in the plot itself?
                       cor.method = "pearson", # specifying the correlation method used 
                       title = "Correlation of Open Syllabus and Goodreads data", # title
                       xlab = "Number of Goodreads ratings (log)", # x axis label
                       ylab = "Open Syllabus" # y axis label
)
corr_plot

# Export in 5x7

#### Package of the week####
# ggstatsplot

# This package aims to combine complex statistical operations with clear visualizations in the 
# same package. The package vignette is excellent and you can check it for additional information!

# Loading the package
library(ggstatsplot)

options(scipen = 10000)

# Taking care of the incomplete factor labels
# Gender column
Main_dataset$Gender <- as.factor(Main_dataset$Gender)
levels(Main_dataset$Gender)[1] <- "Female"
levels(Main_dataset$Gender)[2] <- "Male"
levels(Main_dataset$Gender)[3] <- "Unknown"

set.seed(123) # for reproducibility (there is a dose of randomness involved, i.e. jittered points)

library(ggstatsplot)                 
gender_plot <- ggbetweenstats( # there are other functions available at the package website
  data = Main_dataset, # data
  x = Gender, # data for x axis
  y = Ratings, # data for y axis
  title = "Gender and the present day popularity of late Victorian novels", # Title
  xlab = "The Author's Gender", # x axis label
  ylab = "Number of Ratings (log)" # y axis label
) +
  scale_y_log10() # making the y axis logarithmic
gender_plot

# Export in 5x7

# For the next visualizaion we will need to reload the original Dracula_adaptations dataset because
# we previously deleted one of the columns in the dplyr section
Dracula_adaptations <- read_csv("Datasets/Dracula adaptations.csv")

#Scatterplot of film adaptations of Dracula and The Beetle with ggplot

ggplot(Dracula_adaptations, # data
       aes(x=Year, y=ImdB)) + # x axis and y axis data
  geom_point(alpha = 0.5, # geom_point creates a scatterplot, alpha regulates the transparency
             size = 3, # size
             color = 'dimgray') + # color
  geom_rug(alpha = 1/2, # geom_rug adds density bars on each axis, alpha regulates transparency 
           position = "jitter") + # adding jittering for better readability. 
  labs(title = "Film adaptations of Dracula and the Beetle", # title
       x = "Year", # x axis label
       y ="Number of IMDB Ratings") # y axis label
# Check the documentation of geom_rug
?geom_rug

# Export in 5x7 resolution

#Scatterplot of film adaptations of Dracula and The Beetle with ggstatsplot

ggscatterstats( 
  data = Dracula_adaptations, # data frame used
  x = Year, # data for x axis
  y = ImdB, # data for y axis
  xlab = "Year", # label for x axis
  ylab = "Number of IMDB Ratings", # label for y axis
  label.var = Title, # variable for labeling data points
  label.expression = "ImdB > 20000 | Year < 1923", # expression that decides which points to label
  title = "Film adaptations of Dracula and the Beetle", # title text for the plot
  ggstatsplot.layer = FALSE, # turn off `ggstatsplot` theme layer
  marginal.type = "density", # type of marginal distribution to be displayed
  xfill = "dimgray", # color fill for x-axis marginal distribution
  yfill = "dimgray" # color fill for y-axis marginal distribution
)
# One of the downsides of this package is that some of its elements cannot be removed from 
# the visualization (we don't actually need the trend line and the confidence interval). We can 
# easily remove these in Adobe Illustrator though!

# Export as 5x7