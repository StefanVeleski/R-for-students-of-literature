#### Logical operators####

# TRUE and FALSE - boolean values. Logical operators allow you to work with
# these values.
# You can think of boolean values as placeholders for logical expressions made
# with numbers.
# Equality operator (you can group logical expressions by parentheses)
(FALSE == TRUE) == FALSE

# Remember that the = operator basically does the same as the <- operator.

# Numbers, less than/ greater than
2 < 3
3 > 2

# Less or equal/ greater than or equal
1 <= 2
1 >= 1

# Not equal operator
1 != 2

# Not operator
# Like the other logical operators this one too can be used with both boolean
# values and numbers
!FALSE
!3 == 4

# Try to guess the result of this expression, without actually running it!
(TRUE == FALSE) != !(2 <= 3)

# The result should be FALSE

# & operators
# A single & operator iterates over each of the elements of the vector on the
# right side, and prints a vector of logical values
TRUE & c(TRUE, FALSE, FALSE)

# The && operator just works with the first element of the vector. This will
# become important later on, when we'll be working with loops
TRUE && c(TRUE, FALSE, FALSE)

# Or operator. At least one of the compared boolean values needs to be TRUE for
# the expression to evaluate to true.
TRUE | c(TRUE, FALSE, FALSE)

# The || operator works in basically the same way as the && operator, taking
# just the first element of the vector.
TRUE || c(TRUE, FALSE, FALSE)

# When we have both & and | in an expression, & is run first. Here's a quick
# rundown of how this process works. Run parts of the expression below, before
# running the full expression to better understand how it works.

2 > 5 || 7 != 9 && 3 < 3.9

# Exclusive or (TRUE only if the arguments differ)
xor(TRUE, FALSE)

# Which of the elements are true. The output is a vector, saying which elements
# of the vector are TRUE.

which(c(TRUE, FALSE, FALSE))

# Are all values true?

all(c(TRUE, FALSE, FALSE))

# Is any of the values true?
any(c(TRUE, FALSE, FALSE))

# These next two functions, which simply check whether the logical expression
# enclosed in the brackets is TRUE or FALSE
isTRUE(1 < 3)
isFALSE(1 < 3)

# Roger Peng's R programming swirl course has an excellent lesson on logical
# operators which I highly recommend. I suggest you go through it at least once
# or twice before the exam. Also the entire course is really good and I actually
# based a lot of the previous two scripts on this swirl course.

#### Subsetting#####

# Subsetting is another word for selecting elements of a data structure.
# Let's start off by creating a character vector

# Vectors
x <- c("a", "b", "c", "d")

# This is how you select the first element of the vector
x[1]

# You can put a sequence of numbers in the square brackets, selecting a
# certain range of elements.
x[1:4]

# This is how you can select everything except for a particular element
x[x != "b"]

# You can do the same a bit faster like this
x[-2]

# Everything except for a particular sequence
x[-(2:4)]

# Selecting several elements of a vector
x[c(1, 3)]

# Matrices

# Matrices are two dimensional data structures so subsetting is somewhat
# different for them than for vectors. Let's first create a matrix
m <- matrix(1:15, nrow = 3, ncol = 5)

# This is how you can select rows
m[1, ]

# This is how you select columns
m[, 1]

# This is how you select a particular "cell" in the matrix
m[1, 1]

# Dataframes
# The subsetting process is similar for data frames

# Let's first load in the built in iris data frame into the environment
data(iris)

# Selecting a particular row, column, and "cell" is the same as in matrices.
iris[, 5]

iris[1, ]

iris[1, 1]

# Because the columns of data frames have names, you can use $ to toggle between
# the different columns. Press Tab after typing the dollar sign for the columns
# to show up.
iris$Sepal.Length

# Lists
# Lists are single dimensional data structures, that can hold elements of
# various data classes. This shapes the ways we can subset lists. Let's first
# make a list
l <- list(x = 1:5, y = c("a", "b"))

# This selects the second element of the list, which is a named (y) character
# vector. As you can notice y does not show up as an object in the environment.
l[2]

# This also gives you the contents of the second element of the list, but the
# name is not printed because you explicitly named it. Think of this expression
# as "the element of l named y".
l$y

# Ditto, but the name is printed in the console this time around
l["y"]

# Extracting multiple elements of a list
l[c(1, 2)]

# Nested elements of lists

# This expression extracts the first element of the second element of the list
l[[c(2, 1)]]

# The fourth element of the first element of the list
l[[c(1, 4)]]

# Removing NA values

# A common use case for subsetting is removing NAs, or missing values from
# different data structures. Usually these missing values need to be removed
# as they can contribute nothing to the data analysis

# Let's first make a vector containing missing values
x <- c(1, 2, NA, 4, NA, 5)

# Now let's make a vector containing all the NA elements of x. We can do this
# with the is.na() function.
bad <- is.na(x)

# If you print the contents of the object bad, you get a logical vector, which
# returns TRUE for each element
bad

# Now you can overwrite x with the cleaned up vector.
x <- x[!bad]

# This approach works too. Make sure you load in the vector from line 178
good <- !is.na(x)
good

x <- x[good]

#### Functions####

# We will only cover the basics today, and we will look at more complicated
# functions and more importantly various kinds of loops during the next session

# This is an empty function
f <- function() {

}

# Functions have their own class
class(f)

# Execute this function
f()

# Let's make our first function. In the parentheses, we put the variables of
# the function, in this case x. In the curled brackets we put in the body of
# the function. Here we would like the function to print "Hello, world!"
# if x is less than 5.
f <- function(x) {
  if (x < 5) cat("Hello, world!\n")
}

# We can now run the function, and use different values for the variable
# depending on whether we'd like "Hello, world!" to be printed in the console.
f(x = 3)

# Remember that you are not creating a variable in the environment by doing so. 
# Try to create an object x with a certain numeric value and run the f () 
# function with x as an argument. 

# Feel free to play around with this and to create different functions

# You noticed that in the f () function that we created above,
# we used the if statement. The simplest version of this statement is the
# good old IF THEN version, where if certain conditions are met, something
# happens. This is demonstrated in the example above. Another basic control
# structure is IF ELSE, demonstrated in the function below.

f2 <- function(x) {
  if (x >= 0) print("Non-negative number") else print("Negative number")
}

f2(x = -2)

# Change the x variable to get both outcomes printed in the console

#### Progress tracker in R####
# With the help of this function you will be able to track your reading, and 
# you will be encouraged along the way. Inspiration - Alex Mesoudi, who 
# originally used it to track his grading. 
# First we need to name the function, and assign the variables.

reading_progress <- function(total, read){
# Let's start with writing the output. The cat() function is basically a 
# combination of the c() and print () functions, which returns a character 
# vector. This is the text that shows what percentage of the book we have read. 
# The 2 argument of the round function is the number of decimal points that the 
# function has.
  cat("\nYou are", round(read/total*100, 2),"% done!")
  
# This is the text that will show up when you'll read the full book.
  if (total == read) cat(" Congratulations!")
  
# Using the same condition, we can assign a sound with the beep function of the
# beeper package (package of the week, see the next section)
  if (total == read) beep(8)
  
# Text that will print after reading more than 90% of the book  
  if (read >= total/1.1 & read < total) cat(" Almost there!")
  if (read >= total/1.1 & read < total) beep(5)
  
# Text that will print once you have read between 50% and 90% of the book.  
  if (read >= total/2 & read < total/1.1) 
    cat(" More than halfway done, hang in there!")
  if (read >= total/2 & read < total/1.1) beep (2)
  
# Text that will print when you have read anywhere between 1 page and 50% of 
# the book
  if (read <= total/2 & read > 0) cat( " Great job, keep grinding!")
  if (read <= total/2 & read > 0) beep(10)

# Text that will print when you haven't started reading yet
  if (read == 0) cat(" So are you planning to get started or what?")
  if (read == 0) beep(9) 

# This is the number of bars that the progress chart will contain
  max_bar <- 40

# The following code shapes the appearance of the bar itself. The current
# version is made for the "▮", and "▯", bars. If you'd like to useo
# other elements for the chart you will probably need to adjust the number of 
# dashes in the rep function (more or fewer dashes than 104)
  cat("\n", "┏", rep("-",104), "┓", "\n", sep="")
  cat(c(" ",rep("▮", round(read/total*max_bar,0)), 
        rep("▯", max_bar-round(read/total*max_bar,0))),"")
  cat ("\n", "┗", rep("-",104), "┛", "\n\n", sep="")
  
  
}
# That's the entire function. Now you can run the function with your numbers
reading_progress(total = 100, read = 100)

# You can imagine this as a dashboard of sorts, where you will enter 
# the total number of pages of the book you are currently reading, as well as
# the number of pages you've read so far. Use 100 here to better calibrate the 
# percentages of the prompts in the function itself. 


#### Package of the week####
install.packages("beepr")
library(beepr)

# This function opens all the documentation for packages, more information than
# the question mark operator.
help(package = "beepr")

# Opening the help page will show you the different sound files that will play
# after 
beep(8)


