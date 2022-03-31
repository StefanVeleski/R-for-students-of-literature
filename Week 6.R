install.packages("devtools")
install.packages("cli")

setwd("C:/Users/Stefan/OneDrive - MUNI/Github/R-for-students-of-literature")
getwd()

# I have no idea what this does but according to the package creator this removes an error that prevents the installation of the package
Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")
devtools::install_github("cutterkom/generativeart")
library(generativeart)

IMG_DIR <- "Generative art/img/"
IMG_SUBDIR <- "everything/"
IMG_SUBDIR2 <- "Generative art/img/handpicked/"
IMG_PATH <- paste0(IMG_DIR, IMG_SUBDIR)

LOGFILE_DIR <- "Generative art/logfile/"
LOGFILE <- "logfile.csv"
LOGFILE_PATH <- paste0(LOGFILE_DIR, LOGFILE)

# create the directory structure
generativeart::setup_directories(IMG_DIR, IMG_SUBDIR, IMG_SUBDIR2, LOGFILE_DIR)

# include a specific formula, for example:
my_formula <- list(
  x = quote(runif(1, -1, 1) * x_i^2 - sin(y_i^2)),
  y = quote(runif(1, -1, 1) * y_i^3 - cos(x_i^2))
)

generativeart::generate_img(
  formula = my_formula, nr_of_img = 5,
  polar = FALSE, color = "black",
  background_color = "white"
)
