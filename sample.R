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

# list types for each attribute
type_list <- sapply(dataset, class)

# take a peek at the first 5 rows of the data
peek <- head(dataset)

# list the levels for the class
my_levels <- levels(dataset$Species)

# summarize the class distribution
percentage <- prop.table(table(dataset$Species)) * 100
class_dist <- cbind(freq=table(dataset$Species), percentage=percentage)

# summarize attribute distributions
my_sum <- summary(dataset)

# split input and output
x <- dataset[,1:4]
y <- dataset[,5]

# barplot for class breakdown
plot_y <- plot(y)

# scatterplot matrix
plot_feat <- featurePlot(x=x, y=y, plot="ellipse")

# box and whisker plots for each attribute
plot_feat_box <- featurePlot(x=x, y=y, plot="box")

# density plots for each attribute by class value
scales <- list(x=list(relation="free"), y=list(relation="free"))
plot_feat_dens <- featurePlot(x=x, y=y, plot="density", scales=scales)

# Run algorithms using 10-fold cross validation
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"


# a) linear algorithms
set.seed(7)
fit.lda <- train(Species~., data=dataset, method="lda", metric=metric, trControl=control)

# b) nonlinear algorithms
# CART
set.seed(7)
fit.cart <- train(Species~., data=dataset, method="rpart", metric=metric, trControl=control)
# kNN
set.seed(7)
fit.knn <- train(Species~., data=dataset, method="knn", metric=metric, trControl=control)

# c) advanced algorithms
# SVM
set.seed(7)
fit.svm <- train(Species~., data=dataset, method="svmRadial", metric=metric, trControl=control)
# Random Forest
set.seed(7)
fit.rf <- train(Species~., data=dataset, method="rf", metric=metric, trControl=control)

# summarize accuracy of models
results <- resamples(list(lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, rf=fit.rf))
results_sum <- summary(results)

# compare accuracy of models
plot_results <- dotplot(results)

# summarize Best Model
lda_sum <- print(fit.lda)

# estimate skill of LDA on the validation dataset
predictions <- predict(fit.lda, validation)
plot_confm <- confusionMatrix(predictions, validation$Species)