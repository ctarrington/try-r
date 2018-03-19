library(tidyverse)
library(keras)
library(zeallot)

source('../../sampling.R')

all_train <- read_csv('./train.csv') 
to_predict <- read_csv('./test.csv')

max_age <- max(all_train$Age, na.rm = TRUE)

conditionData <- function(tbl) {
  complete <- tbl %>% 
    filter(!is.na(Age)) %>% 
    filter(!is.na(Sex)) %>% 
    filter(!is.na(Pclass))
  
  conditioned <- complete %>%
    mutate(age = Age/max_age) %>% 
    select(-Age) %>% 
    
    # trying as a continuous variable
    mutate(passengerClass = Pclass / 3) %>% 
    select(-Pclass) %>% 
    
    mutate(gender = ifelse(Sex == 'male', 1, 0)) %>% 
    select(-Sex) %>% 
    
    select(-Name, -Cabin, -Ticket, -Embarked, -Fare, -Parch, -SibSp, -PassengerId)
}

extractDataAndLabels <- function(together) {
  labels <- together$Survived
  
  data <- together %>%
    select(-Survived)
    
  list(data, labels)
}

all_train <- conditionData(all_train)
to_predict <- conditionData(to_predict)

# split rows 
c(train_data, other_data) %<-%  split_data(all_train, 0.9)
c(holdout_data, validation_data) %<-% split_data(other_data, 0.5)

# seperate labels from data
c(train_x, train_y) %<-% extractDataAndLabels(train_data)
c(holdout_x, holdout_y) %<-% extractDataAndLabels(holdout_data)
c(validation_x, validation_y) %<-% extractDataAndLabels(validation_data)
rm(train_data, holdout_data, validation_data, other_data, all_train)

model <- keras_model_sequential() %>% 
  layer_dense(units = 1024, activation = "relu", input_shape = c(ncol(train_x))) %>%
  layer_dense(units = 2048, activation = "relu") %>%
  layer_dense(units = 1024, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  optimizer = "rmsprop",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)

history <- model %>% fit(
  as.matrix(train_x),
  train_y,
  epochs = 30,
  batch_size = 20,
  validation_data = list(as.matrix(validation_x), validation_y)
)

results <- model %>% evaluate(as.matrix(holdout_x), holdout_y)
results$acc

