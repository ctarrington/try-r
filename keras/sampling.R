library(tidyverse)
library(zeallot)

create_data <- function(size) {
  data <- tibble(
    id = 1:size,
    x = rnorm(size)*10,
    y = x * 8 + rnorm(1)/10
  )
}

############# Asymetrical split ###########

split_data <- function(raw_data, ratio) {
  first_indices <- sample(1:nrow(raw_data), size = ratio * nrow(raw_data))
  first <- raw_data[first_indices, ]
  second <- raw_data[-first_indices, ]
  
  list(first, second)
}

data <- create_data(100)
c(train_data, other_data) %<-%  split_data(data, 0.8)
c(test_data, validation_data) %<-% split_data(other_data, 0.5)
rm('other_data', 'data')


################# K-Folds ##################
# Note - all folds are ordered
# Todo - shuffle first?
# Todo - better name for function

create_fold_holder <- function(raw_data, fold_count) {
  indices <- sample(1:nrow(raw_data))
  folds <- cut(indices, breaks = fold_count, labels = FALSE)
  
  fold_holder <- function(fold_index) {
    matches <- which(folds == fold_index, arr.ind = TRUE)
    first <- raw_data[matches, ]
    second <- raw_data[-matches, ]
    
    list(first, second)
  }
  
  fold_holder
}

other_data <- create_data(20)
data <- create_data(100)

folds <- create_fold_holder(data, 4)
other_folds <- create_fold_holder(other_data, 5)

c(validation_data1, train_data1) %<-% folds(1)
c(validation_data2, train_data2) %<-% folds(2)
c(other_validation_data2, other_train_data2) %<-% other_folds(2)
c(validation_data3, train_data3) %<-% folds(3)
c(validation_data4, train_data4) %<-% folds(4)
