####Setting up working directory####
setwd("C:/Users/Stefan/Documents/GitHub/R-for-students-of-literature")

# You can also set up a working directory using one of R Studio's features: 
# Session -> Set working directory -> To source file location/Choose directory
# Also, one of the quirks of R as a programming language is that it almost never uses backslashes, 
# but forward slashes only.

getwd()

# Setting up an R studio theme
# Tools -> Global options -> Appearance

####Basic math in R ####

x <- 1+2 
x

# Shortcut for the arrow is alt + - 
# A possible alternative is =, but this isn't used that often and it can cause you complications later on
# This text will be ignored by the program

y <- 3-2
y

# Once you assign values to the objects, you can use the object themselves in mathematical operations
z <- x-y 
z

# Division (remember, you need to store the contents to an object if you would like to reuse them)
z/y 

# Multiplication
y*z 

# Exponentiation
2^3  

# Square root
sqrt(4)  

# This prints the contents of the object in the console (instead of just typing the object name and running it)
print(z)

# This opens the official R documentation for this function
?print 

# You can also overwrite the contents of the object with another one
x <- "Hello world!" 

# Spaces don't matter in R, but capitalization does
a<-1
A <- 2

# R considers the following as separate objects
a+A 

# Checking the class of objects - more about the different classes of objects next week
class(x) 

class(a)

# Multiple values can be combined into a vector
v <- c(1,2,3,4)

class(v)

# See the documentation for this function
?c 

# The exact same vector as above can be done like this
v <- 1:4

# Two letters + Tab choosing function

# Up arrow in console to get previous commands

# This function reveals the contents of your global environment
ls() 

# This can be used to clear the global environment - you can do the same with the little broom icon
rm(list=ls()) 

####Files and directories from the console####
# Now we'll be working a little bit on the level of files and folders

# This function tells you which files you have in the working directory that you specified earlier
dir() 

# This function does the same - sometimes R has functions that do the same thing
list.files() 

# You can check this with this function
identical(dir, list.files) 

#See what this function contains
?identical

# In addition to functions, it can also be applied to objects and values
identical(A, 2) 

# This function can reveal the arguments that you need to use in the function
args(identical) 

# This is the fastest way of creating a folder within your working directory
dir.create("testdir") 

# This function creates a file (you can try other file formats as well)
file.create("test.R")

# The "file.info()" function gives you some basic info about your file
file.info("test.R") 

# Renaming the file (argument 1 original file name, argument 2, new file name)
file.rename("test.R","test1.R") 

# You can see how this is explained in the function documentation
?file.rename 

# Creating a copy of a file - (argument 1 original, argument 2, new copy)
file.copy("test1.R", "test1_copy.R") 

# This function can test whether or not a certain file exists
file.exists("test1_copy.R") 

# Let's remove these two files
file.remove("test1.R", "test1_copy.R")

# When it comes to deleting the "testdir" directory, there does not seem to be an easy function to do this
# When using file.remove for this purpose there is an error - file.remove does not apply to dirs (folders)
file.remove("testdir") 

# Stackoverflow or Github can give you solutions for any such problems that might crop up
# Just Googling the warning/error message (displayed in the console) often does the trick

# The first Google result shows that this is how you delete directories from the working directory
unlink("testdir", recursive=TRUE)

# It works!

####Package of the week####

# The following is part of the package of the week part of the class 

# This is how you install packages
install.packages("swirl") 

# This chooses the package you'll be working with
library(swirl) 

# Take a look at the package documentation (you can also look at the CRAN page for more info)
?swirl 

# This is how you install courses (I recommend this one)
install_course("A_(very)_short_introduction_to_R") 

# The following is basically the same as the two abovementioned steps
swirl::install_course("A_(very)_short_introduction_to_R")

# Finally you can run the package - you can take the rest from here (just follow the instructions in the console)
swirl()
