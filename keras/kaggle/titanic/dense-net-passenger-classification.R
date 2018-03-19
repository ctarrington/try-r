library(tidyverse)
library(keras)
library(zeallot)

source('../../sampling.R')

all_train <- read_csv('./train.csv') 
to_predict <- read_csv('./test.csv')

max_age <- max(all_train$Age, na.rm = TRUE)
mean_age <- mean(all_train$Age, na.rm = TRUE)
max_sibsp <- max(all_train$SibSp)
max_parch <- max(all_train$Parch)


conditionData <- function(tbl) {
  complete <- tbl %>% 
    mutate(Age = ifelse(is.na(Age), -max_age, Age))
  
  conditioned <- complete %>%
    mutate(age = Age/max_age) %>% 
    mutate(isFirstClass = Pclass == 1) %>%  
    mutate(isSecondClass = Pclass == 2) %>%  
    mutate(isThirdClass = Pclass == 3) %>%  
    mutate(gender = ifelse(Sex == 'male', 1, 0)) %>% 
    mutate(sibsp = SibSp / max_sibsp) %>% 
    mutate(parch = Parch / max_parch) %>% 
    select(-Age, -Pclass, -Sex, -Name, -Cabin, -Ticket, -Embarked, -Fare, -Parch, -SibSp, -PassengerId)
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
  layer_dense(units = 512, activation = "relu", input_shape = c(ncol(train_x))) %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 1024, activation = "relu") %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 512, activation = "relu") %>%
  layer_dropout(rate = 0.5) %>%
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

