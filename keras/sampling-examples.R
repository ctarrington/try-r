library(tidyverse)
library(zeallot)

source('./sampling.R')

create_data <- function(size) {
  data <- tibble(
    id = 1:size,
    x = rnorm(size)*10,
    y = x * 8 + rnorm(1)/10
  )
}

############# Shuffle #####################
data <- create_data(10)
shuffled <- shuffle_data(data)

############# Asymetrical split ###########
data <- create_data(100)
c(train_data, other_data) %<-%  split_data(data, 0.8)
c(test_data, validation_data) %<-% split_data(other_data, 0.5)
rm('other_data', 'data')


################# K-Folds ##################
# https://www.safaribooksonline.com/library/view/deep-learning-with/9781617295546/kindle_split_013.html

other_data <- create_data(20)
data <- create_data(100)

folds <- create_folds(data, 4)
other_folds <- create_folds(other_data, 5)

c(validation_data1, train_data1) %<-% folds(1)
c(validation_data2, train_data2) %<-% folds(2)
c(other_validation_data2, other_train_data2) %<-% other_folds(2)
c(validation_data3, train_data3) %<-% folds(3)
c(validation_data4, train_data4) %<-% folds(4)
