#### tidyverse####

# The tidyverse is a collection of packages that streamline and optimize 
# certain data procedures in data science. 
library(tidyverse)

# The components of the package are visible after loading it with the library function

# The tidyverse often relies on syntax that is a bit different than what we have
# used so far, which is optimized for data analysis. Hence, many data scientists prefer 
# it over base R, and its sheer user base and the wealth of material available 
# makes it indispensable for everyone using R.

# The tidyverse collection of packages can be the topic of a full course, so 
# let's only look at three of its most important packages: readr, dplyr, and ggplot

#### readr#### 

# The readr package is one of the most commonly used tidyverse package, and is often
# the default way of loading data into R. 
# Let's first set the working directory
setwd("C:/Users/Stefan/OneDrive - MUNI/Github/R-for-students-of-literature")
getwd()
# For the sake of reproducibility it is often preferable to record the process 
# used to load the dataset.

Dracula_adaptations <- read.csv("Datasets/Dracula adaptations.csv")
Main_dataset <- read.csv("Datasets/Main dataset.csv")

?read.csv # this uses base R, but let's use readr, which is a part of the 
#tidyverse universe

# problem from loading data in R with different tools, so make sure this is 
# specified in the script that you will be using!

#### dplyr####
# select function
Dracula_adaptations <- Dracula_adaptations[,-1] # standard base R way
Dracula_adaptations <- select(Dracula_adaptations, -1) # tidyverse
Dracula_adaptations <- select(Dracula_adaptations, -X) # benefit of tidyverse way, explicit naming
Dracula_adaptations <- Dracula_adaptations %>% select(-1)

# try out the same with : -(:) to select multiple columns
# try ends_with and starts_with
# try explicitly naming each of the columns we may need

Dracula_adaptations %>% 
  filter(Year == 1957) %>% 
  select(Title:Year)

# very close to the subset function
Dracula_adaptations %>% 
  arrange(desc(Year)) # do just year and then do desc(year)

rename(Dracula_adaptations, IMDB = ImdB)

#mutate( )
#group_by()
#Dracula_adaptations %>% 
#  summarise()
# This is pretty much everything we can do with these two data sets, I will mention some 
# of the other dplyr functions during some of the next sessions.

# Cleaning up column names so that they fit the tidyverse style guide
library(janitor)
# Original names
colnames(Dracula_adaptations)

Dracula_adaptations %>% 
  clean_names() %>% 
  colnames()

# this is not an assignment operator! 
# %>% Ctrl + Shift + M (Windows) or Cmd + Shift + M (Mac)
# pull out this visualization at this point
# This should be your preferred 

data.table::fwrite(Dracula_adaptations, file = "adaptations.csv")
?fwrite

# data.table::fwrite() to write CSV files is SIGNIFICANTLY faster than the write.csv(). 

#### ggplot####

data(mtcars)
str(mtcars)
?mtcars

mtcars$cyl <- as.factor(mtcars$cyl) 
mtcars$vs <- as.factor(mtcars$vs) 
mtcars$am <- as.factor(mtcars$am) 

mtcars$am # check factor levels
levels(mtcars$am)[1] <- "Automatic"
levels(mtcars$am)[2] <- "Manual"

# Do this first!
ggplot(mtcars, aes(disp, hp, size = mpg, color = cyl, shape = am)) +
  geom_point(alpha = .3) +
  labs(
    title = "Control Legend Titles w/ labs ()",
    size = "Miles per \nGallon",
    color = "Cylinders", 
    shape = "Transmission"
  )

#### ggpubr####
library(ggpubr)

# Although not a part of the tidyverse collection of packages, this package is a
# 
# Correlation of Goodreads and Open Syllabus data
options(scipen = 10000)
str(Main_dataset)

Main_dataset$Ratings <- as.numeric(Main_dataset$Ratings)
Main_dataset$Syllabi <- as.numeric(Main_dataset$Syllabi)
Main_dataset$`Bestseller?` <- as.factor(Main_dataset$`Bestseller?`)

corr_plot <- ggscatter(Main_dataset,
                       x = "Ratings", 
                       y = "Syllabi",
                       add = "reg.line", conf.int = TRUE,
                       color = "dimgray",
                       xscale = "log10",
                       yscale = "log10",
                       cor.coef = TRUE, 
                       cor.method = "pearson",
                       title = "Correlation of Open Syllabus and Goodreads data",
                       xlab = "Number of Goodreads ratings (log)",
                       ylab = "Open Syllabus"
)
corr_plot

#### Package of the week####

# ggstatsplot

# We had a lot of packages this week, but this one is different enough to warrant 
# inclusion as package of the week.

# Loading the package
library(ggstatsplot)

#use this to discourage R from using scientific notation
options(scipen = 10000)
library(tidyverse)

# We need to reload the original Dracula_adaptations dataset because we previously 
# deleted one of the columns in the dplyr section

Main_dataset <- read_csv("Datasets/Main dataset.csv")

options(scipen = 10000)
# Taking care of the incomplete factor labels
# Gender column
Main_dataset$Gender <- as.factor(Main_dataset$Gender)
levels(Main_dataset$Gender)[1] <- "Female"
levels(Main_dataset$Gender)[2] <- "Male"
levels(Main_dataset$Gender)[3] <- "Unknown"

# Bestseller? column
Main_dataset$`Bestseller?` <- as.factor(Main_dataset$`Bestseller?`)
levels(Main_dataset$`Bestseller?`)[1] <- "No"
levels(Main_dataset$`Bestseller?`)[2] <- "Yes"
Main_dataset$`Bestseller?`

set.seed(123)

library(ggstatsplot)                 
gender_plot <- ggbetweenstats(
  data = Main_dataset,
  x = Gender,
  y = Ratings,
  xlab = "The Author's Gender",
  ylab = "Number of Ratings (log)"
) +
  scale_y_log10()
gender_plot

#Scatterplot of film adaptations of Dracula and The Beetle with ggplot
ggplot(Dracula_adaptations, aes(x=Year, y=ImdB)) +
  geom_point(alpha = 0.5, size = 3, color = 'dimgray') +
  geom_rug(alpha = 1/2, position = "jitter") +
  labs(title = "Film adaptations of Dracula", 
       x = "Year", 
       y ="Number of IMDB Ratings")

#Scatterplot of film adaptations of Dracula and The Beetle with ggstatsplot

# We need to reload the original Dracula_adaptations dataset because we previously 
# deleted one of the columns in the dplyr section
Dracula_adaptations <- read.csv("Datasets/Dracula adaptations.csv")

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