#### Logical operators####
# TRUE and FALSE - boolean values. In addition to arithmetic operators there 
# are also logical operators.
# Equality operator - all logical operators can be grouped by parentheses.
(FALSE==TRUE)==FALSE

# Remember that the = operator basically does the same as the <- operator.

# Numbers, less than/ greater than
2<3

# Less or equal/ greater than or equal, try both
1<=2
1<=1

# Not equal operator
1!=2

# Not operator
# Can be used with both boolean values and numbers
!FALSE
!3==4

# Try to guess the result of this expression, without actually running it!
(TRUE == FALSE) != !(2 <= 3) #The result should be FALSE

# And operators
# A single & operator produces a vector that iterates over each of the elements
# of the vector
TRUE & c(TRUE, FALSE, FALSE)  
# Double && operator just works with the first element of the vector. This will 
# become important later on.
TRUE && c(TRUE, FALSE, FALSE) 

# Or operator. At least one of the compared boolean values needs to be TRUE for 
# the expression to evaluate to true.
  
TRUE | c(TRUE, FALSE, FALSE)  
# The || operator works in basically the same way as the && operator. 
TRUE || c(TRUE, FALSE, FALSE) 

# & is run first. Quick rundown of how this process works
  
2 > 5 || 7 != 9 && 3 < 3.9

# Exclusive or (TRUE only if the arguments differ)
xor(TRUE,FALSE)

# Which of the elements are true. The output is a vector, saying which elements
# of the vector are TRUE.
  
which(c(TRUE, FALSE, FALSE))

# Are all values true?

all(c(TRUE, FALSE, FALSE))

# Is any of the values true?
any(c(TRUE, FALSE, FALSE))

# These next two functions, which 
isTRUE(1<3)
isFALSE(1<3)

# Roger Peng's R programming course has an excellent lessen on logical 
# operators which I highly recommend. I suggest you go through it at least once
# or twice before the exam. Also the entire course is really good and I actually
# based a lot of the previous two scripts on this swirl course. 

#### Subsetting#####

# Vector

x <- c("a", "b", "c", "d")

x[1]

x[1:4]

x[x!="a"]

x[-2]

x[-(2:4)]

x[c(1,3)]

# Matrix

m <- matrix(1:15,nrow = 3, ncol = 5)

m[1, ]

m[, 1]

m[1, 1]

# Dataframes
# The subsetting process is exactly the same for data frames

data(iris)

iris[,5]

iris[1, ]

iris[1, 1]

iris$Sepal.Length

iris[[5]]

class(iris$Species)

# Lists
l <- list(x = 1:5, y = c("a", "b"))

l[2]

l$x

l["y"]

# Extracting multiple elements of a list

l[c(1, 2)]

# Nested elements of lists - dataframes - each column - equal number of 
# observations

l[[c(2,1)]]

l[[c(1,4)]]

# Removing NA values

x <- c(1, 2, NA, 4, NA, 5)
bad <- is.na(x)

print(bad)

x[!bad]

good <- !is.na(x)
good

x[good]

# If you'd like to remove NAs from two objects
x <- c(1, 2, NA, 4, NA, 5)
y <- c("a", "b", NA, "d", NA, "f")

good <- complete.cases(x, y)
good

good[x]

x[good]

y[good]

#### Functions####

# We will only cover the basics today, and we will look at more complicated 
# functions and more importantly various kinds of loops during the last session.


f <- function() {
          ## This is an empty function
 }
# Functions have their own class
class(f)  

# Execute this function
f()       

f <- function(x) {
    if(x<5) cat("Hello, world!\n")
}

f(x=3)

# If statements

if (test_expression) {
  statement
}

x <- -1

if (x > 0) print("Non-negative number") else print ("Negative number")


#### Progress tracker in R####
# With the help of this function you will be able to track your reading, and 
# you will be encouraged along the way. Inspiration - Alex Mesoudi, who 
# originally used it to track his grading. 
# First we need to name the function, and assign the variables.

reading_progress <- function(total, read){
# Let's start with writing the output. The cat() function is basically a combination
# of the c() and print () functions, which returns a character vector.
# This is the text that shows what percentage of the book we have read. The
# 2 argument of the round function is the number of decimal points that the 
# function has.
  cat("\nYou are", round(read/total*100, 2),"% done!")
# This is the text that will 
  if (total == read) cat(" Congratulations!")
  if (total == read) beep(8)
  
  if (read >= total/1.1 & read < total) cat(" Almost there!")
  if (read >= total/1.1 & read < total) beep(5)
  
  if (read >= total/2 & read < total/1.1) 
    cat(" More than halfway done, hang in there!")
  if (read >= total/2 & read < total/1.1) beep (2)
  
  if (read <= total/2 & read > 0) cat( " Great job, keep grinding!")
  if (read <= total/2 & read > 0) beep(10)

  if (read == 0) cat(" So are you planning to get started or what?")
  if (read == 0) beep(9) 
  
  max_bar <- 40
  
  cat("\n", "┏", rep("-",104), "┓", "\n", sep="")
  cat(c(" ",rep("▮", round(read/total*max_bar,0)), 
        rep("▯", max_bar-round(read/total*max_bar,0))),"")
  cat ("\n", "┗", rep("-",104), "┛", "\n\n", sep="")
  
  
}

# Write this secons so that they know how the controls of the function will 
# actually work!

reading_progress(total = 100, read = 100)


#### Package of the week####

install.packages("beepr")
library(beepr)

# This function opens all the documentation for packages, more information than
# the questionmark operator.
help(package = "beepr")
# While we're on this topic, the following function can help you find whatever
# you want in R
beep(8)
?beepr

