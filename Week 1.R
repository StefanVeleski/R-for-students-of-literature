####Setting up working directory####

setwd("C:/Users/Stefan/Documents/GitHub/R-for-students-of-literature")
#you can also do this using one of R Studio's features. Session -> Set working directory -> To source file location or
#Choose directory
#one of the quirks of R as a programming language is that it almost never uses backslashes, but forward slashes only.
getwd()

#Setting up an R studio theme
#Tools -> Global options -> Appearance

####Basic math in R ####
x <- 1+2 #Shortcut for the arrow is alt+ - 

#Alternative is =, but this isn't used that often and it can cause you complications later on
x #This text will be ignored by the program

y <- 3-2
y

z <- x-y #once you assign values to the objects, you can use the object themselves in mathematical operations
z

z/y #division - remember, you need to store the contents

y*z #multiplication

2^2

sqrt(4)

print(z) #you can just print the value of the object in this way, but you can do the same thing


x <- "I like the stock!" #Overwriting the contents of the object with another one

print(x) #this prints the contents of the object in the console

?print #this opens the official R documentation for this function

#Spaces don't matter in R, but capitalization does
a<-1
A <- 2

a+A

class(x) #checking the class of objects - more about the different classes of objects next week
class(a)

rm(list=ls()) #this can be used to Clear the environment - you can do the same with the little broom

vector <- c(1,2,3,4)

?C


#Two letters + Tab choosing function

#up arrow in console to get previous commands

?ls() #putting a question mark before the function

####Files and directories from the console####

dir() #this function tells you which files you have in the directory that you specified

list.files() #Sometimes R has overlapping functions, that basically accomplish the same thing

identical(dir, list.files) #You can check this by using the identical function
?identical

identical(A, 2) #This does not necessarily need to be applied to functions, but also to objects and simple values

args(identical) #This function can actually reveal the actual hidden structure


dir.create("testdir")
getwd()

file.create("test.R")

file.info("test.R")

file.rename("test.R","test1.R")
?file.rename

file.copy("test.R", "test_copy.R")

file.exists("test_copy.R")

file.remove("testdir")

#At this point I can go to Stackoverflow and show them how to look for solutions for questions like these.

unlink('testdir', recursive=TRUE)


file.remove("test.R", "test_copy.R")

####Package of the week####

#The following is part of the package of the week part of the class - 

install.packages("swirl") #this is how you install packages
library(swirl) #this chooses the package you'll be working with - in normal circumstances, one would
swirl::install_course("A_(very)_short_introduction_to_R") #this is basically the same as the two abovementioned steps, 
#basically forcing an installation and selecting the course
install_course("A_(very)_short_introduction_to_R") #if you have done the first two steps, you're fine with just this

swirl()
