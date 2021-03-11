####Sequences and numbers####
1:20

pi:10

10:1

?`:`

seq(1,10)

?seq

seq(1, 10, by = 0.5)

x <- seq(1, 10, length=30)

length(x)

rep(1, times=10)

rep(c(0,1,2), times = 10)

rep(c(0,1,2), each = 10)

####Data types/classes####

#R has five basic or "atomic" classes of objects:

#numeric (real numbers)

x <- c(0.1,0.2, 1)

#integer
y <- c(1L,2L,3L,4L)


1/0

0/0

#character

z <- c("1","2","3")

#logical (TRUE/FALSE)

l <- c(TRUE, FALSE)

#complex - not necessary

y <- c(1.7, "a")
y

y <- c(TRUE, 2)

y <- c("a", TRUE)

as.integer(x)

as.numeric(y)

as.character(x)

x <- c("a","b","c")
as.numeric(x)

####Data structures####

####Lists####
x <- list(1, "a", TRUE)
x
####Matrices####
m <- matrix(nrow = 2, ncol = 3)
m

dim(m)

m <- matrix(1:6, nrow = 2, ncol = 3)
m

x <- 1:3
y <- 10:12

cbind(x,y)

rbind(x, y)

nrow(x)

ncol(x)

iris
iris <- iris

mpg
####Data frames####
x <- data.frame(foo=1:4, bar=c(T, T, F, F))
x

head(iris)

tail(iris)

dim(iris)

nrow(iris)

ncol(iris)

str(iris) #important

names(iris)
colnames(iris)

identical(names, colnames)

####Names####
x <- 1:3
names(x)

names(x) <- c("New York", "Seattle", "Los Angeles")
x

names(x)

x <- list("LA" = 1, "Boston" = 2, "London" = 3)
x

####Package of the week####
install.packages("styler")
library(styler)

