r = getOption("repos")
r["CRAN"] = "https://cloud.r-project.org"
options(repos = r)
if(!require(caret)) install.packages("caret", dependencies = TRUE)

library(caret)

# attach the iris dataset to the environment
data(iris)
# rename the dataset
dataset <- iris

# create a list of 80% of the rows in the original dataset we can use for training
validation_index <- createDataPartition(dataset$Species, p=0.80, list=FALSE)

#select 20% of the data for validation
validation <- dataset[-validation_index,]

# use the remaining 80% of data to training and testing the models
dataset <- dataset[validation_index,]

# Dimensionality
dimensions <- dim(dataset)

pkgs_info = installed.packages()

info = Sys.info()
a <- 1
b <- 3
c <- a + b 
data = 1:20