#### Sequences and numbers####

# The simplest way of creating sequences of numbers
1:20

# R has several built-in constants (ready-made objects embedded in base R):
# LETTERS, letters, month.abb, month.name, pi.
# Run these objects to see their contents.

# We can use one of them to illustrate sequences of real numbers (decimal).
pi:10

# Sequences of numbers work in reverse as well!
10:1

# Just like with functions, we can check the documentation for operators as well!
# You just need to enclose the operator in quotation marks or backticks.
?":"
?`:`

# You can have more control over a sequence with the seq () function. The following
# line does the same as the first example in the script (which used a colon).
seq(1, 10)

# Adding the by argument changes the increments of the sequence.
seq(1, 10, by = 0.5)

# The length argument is pretty self-explanatory - it changes the length of the
# sequence, instead of the increments. For obvious reasons, the two arguments
# are mutually exclusive.
x <- seq(1, 10, length = 30)

# Base R also has the length () function, which gives you the length of any object
# you pass as an argument. This will come in handy later on.
length(x)

# The rep () function is short for replicate. This example replicates a value ten
# times.
rep(1, times = 10)

# The argument can be a vector, or any other kind of data structure (see the
# data structures section to see what that is).
rep(c(0, 1, 2), times = 10)

# You can repeat each component of the vector a certain number of times.
rep(c(0, 1, 2), each = 10)

#### Data types/classes####

# All of the objects we used last week were vectors, but most of them had a
# length of one. This is the most common data structure. The most important
# thing about a vector is that it can only contain objects of the same class.

# A list is represented as a vector but can contain objects of different classes,
# which is its primary use case.

# Run the following lines of code to generate a data frame with the different
# data types/classes and data structures.

data_types <- c("character", "numeric", "integer", "logical", "complex")
data_structures <- c("(atomic) vector", "list", "matrix", "data frame", "factors")
tvs_df <- data.frame(data_types, data_structures)

# Clicking on the tvs_df object in the environment will open up a table that
# you can consult.

# R has five basic or "atomic" classes of objects (which are demonstrated
# with several example vectors depicted below)

# The first two classes represent numbers

# Numeric (real numbers)

x <- c(0.1, 0.2, 1)

# Integer (easily differentiated from numerics by placing an L suffix)
y <- c(1L, 2L, 3L, 4L)

# Some other information connected to numbers that you should know is that
# dividing 1 by 0 gives us an infinite value (Inf)
1 / 0

# The result of dividing 0 by 0 is displayed as NaN (not a number)
0 / 0

# Back to the other data types/classes...

# Character (each element of the vector needs to be put in quotation marks)

z <- c("1", "2", "3")

# Logical (TRUE/FALSE)

l <- c(TRUE, FALSE)

# This class comes in handy when we work with logical operators. More on that
# next week.

# The complex class is not necessary for our particular use case.

# If we try combining multiple data types/classes in a single vector, then R
# will try to convert some elements to match the others. This is called
# implicit coercion. Some data classes have priority over others (more specific
# types are converted in more general ones -  logical < integer < numeric <
# complex < character).

# Combining a numeric and a character results in a character vector

y <- c(1.7, "a")
y

# Combining a logical and a numeric results in a numeric vector.

y <- c(TRUE, 2)

# Combining a character and a logical results in a character vector.

y <- c("a", TRUE)

# You get the idea.

# In addition to implicit, there is also explicit coercion - which can be done
# via the functions below.

as.integer(x)

as.numeric(x)

as.character(x)

# Feel free to experiment with explicit coercion on your own objects

# Sometimes, R can't figure out how to coerce an object and this can result in 
# NAs (not available) being produced.

# When nonsensical coercion takes place, you will usually get a warning from R.
x <- c("a", "b", "c")
as.numeric(x)

# The following is a common situation that arises when importing .csv files from
# Microsoft Excel. The columns are sometimes mistakenly considered as character
# instead of numeric vectors. We often need to manually do this conversion so
# that we can properly work with the data.

x <- c("1", "2", "3")
x

as.numeric(x)
x

#### Data structures####
# Refer to the tvs_df data frame again.There are five main data structures in R:
# vectors, lists, matrices, data frames, and factors.
# The following code creates a data frame explaining the crucial differences
# between the first four data structures. Study this table carefully.

d1d2_df <- data.frame(
  c("1-D", "2-D"), c("atomic vector", "matrix"),
  c("list", "dataframe")
)
names(d1d2_df) <- c("Dimensions", "Homogenous", "Heterogeneous")

#### Lists####
# Lists are a special type of vector that can contain elements of different 
# classes. As shown in d1d2_df, they are one dimensional data structures, 
# just like vectors. 
# Lists can be explicitly created using the list() function, which takes an 
# arbitrary number of arguments.

x <- list(1, "a", TRUE)
x

#### Matrices####
# Matrices are vectors with a dimension attribute (look at d1d2_df). 

m <- matrix(nrow = 2, ncol = 3)
m

# The dimension attribute is  itself an integer vector of length 2 (number of 
# rows, number of columns).The dim function returns the number of rows and 
# columns that the matrix has.

dim(m)

# Matrices are constructed column-wise, i.e. stating from the top left and 
# running down the columns.
m <- matrix(1:6, nrow = 2, ncol = 3)
m

# Let's make two integer vectors
x <- 1:3
y <- 10:12

# The cbind () function allows you to combine these vectors into a matrix as 
# columns.

m <- cbind(x, y)

# The rbind function does the same, but treats the vectors as rows.

m <- rbind(x, y)

# The nrow () and ncol () functions show you how many rows and columns the 
# matrix contains.

nrow(m)

ncol(m)

#### Data frames####
# Data frames are used to store tabular data in R. They are probably the most 
# important type of object that we will use throughout the course. The fifth 
# session will be specially dedicated to working with data frames - importing 
# them, creating them from scratch, tidying them, and finally visualizing them.  
# We will mostly be relying on the tidyverse collection on packages to do so, 
# but we'll get back to that in a couple of weeks. 

# Data frames can be thought of as lists with a dimension attribute. Look at 
# the d1d2_df. The main differences are that every element of the list has to have
# the same length. Each element of the list can be thought of as a column 
# and the length of each element of the list is the number of rows.

# Unlike matrices, data frames can store different classes of objects in each 
# column. Matrices must have every element be the same class (e.g. all integers 
# or all numeric).

# Data frames are usually created by reading in a dataset. You can load in a 
# dataframe (we'll mostly be using .csv files in the course) using the import
# dataset shortcut in the environment panel, or by using the read.table() or 
# read.csv() functions. Data frames can also be created explicitly with the 
# data.frame() function or they can be coerced from other types of objects like 
# lists.

# Just like the built-in constant mentioned on line 6, R has some ready-made 
# data frames as well. One of the most commonly used ones is the iris dataframe.

iris

# We need to store it in our environment first if we'd like to manipulate it in
# any way. 
iris_df <- iris

# You can find two different ways of constructing data frames on lines 60 and 157.

# The following is the third and imo the cleanest way of explicitly creating 
# dataframes.

example_df <- data.frame(foo = 1:4, bar = c(T, T, F, F))
example_df

# What follows is a quick rundown of the most common data frame related functions.
# 

# The following two functions are generic functions, which can be extended to 
# other classes
# The first, head () gives you the first parts of the object (the first six
# rows of the data frame in this case).

head(iris_df)

# The tail () function shows you the last 6 rows. 
tail(iris_df)

# The following three functions were used in the matrices section as well. Try 
# them out.

dim(iris_df)

nrow(iris_df)

ncol(iris_df)

# The str () function, short for structure, is a very handy way of looking at 
# the structure of an object. Most commonly used for data frames as the most 
# complex data structure.

str(iris_df) 

####Factors####
# Factors are used to represent categorical data. Peng suggests looking at them
# as integer vectors, where each integer has a label. Factors are very useful 
# for visualization purposes in data frames where the observations (rows) can be 
# broadly divided in several groups. These can be visualized as different box
# plots, or as different colors on a scatterplot. 

countrynames_f <- factor(c("Czech Republic", "Slovakia", "Austria", "Hungary"))

countrynames_f

#### Package of the week####
# This week's package of the week will be styler, a package specially designed
# to reformat your code according to the generally accepted tidyverse style
# guide.The style guide and the styler documentation are posted on ELF.
install.packages("styler")
library(styler)

# You can take a look at the documentation of the package in R itself.
# The good old ? operator works for packages as well!
?styler
