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
    mutate(sex = ifelse(Sex == 'male', 1, 0)) %>% 
    mutate(isFirstClass = ifelse(Pclass == 1, 1, 0)) %>%  
    mutate(isSecondClass = ifelse(Pclass == 2, 1, 0)) %>%  
    mutate(isThirdClass = ifelse(Pclass == 3, 1, 0)) %>%  
    mutate(gender = ifelse(Sex == 'male', 1, 0)) %>% 
    mutate(FamilySize = Parch + SibSp + 1) %>% 
    mutate(SingleFamilySize = ifelse(FamilySize == 1, 1, 0)) %>% 
    mutate(SmallFamilySize = ifelse(FamilySize > 1 & FamilySize < 5, 1, 0)) %>% 
    select(-SibSp, -Parch, -Age, -Pclass, -Sex, -Cabin, -Ticket, -Embarked, -Fare, -PassengerId)
  
  conditioned <- conditioned %>%
    mutate(Title = gsub('(.*, )|(\\..*)', '', Name)) %>%
    mutate(isMiss = ifelse(Title %in% c('Miss', 'Mlle', 'Ms'), 1, 0)) %>% 
    mutate(isMrs = ifelse(Title %in% c('Mrs', 'Mme'), 1, 0)) %>% 
    mutate(isMr = ifelse(Title %in% c('Mr'), 1, 0)) %>% 
    mutate(isMaster = ifelse(Title %in% c('Master'), 1, 0)) %>% 
    select(-Title, -Name)
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
rm(holdout_data, other_data, all_train)

model <- keras_model_sequential() %>% 
  layer_dense(units = 800, activation = "relu", input_shape = c(ncol(train_x))) %>%
  layer_dropout(rate = 0.6) %>%
  layer_dense(units = 1400, activation = "relu") %>%
  layer_dropout(rate = 0.6) %>%
  layer_dense(units = 800, activation = "relu") %>%
  layer_dropout(rate = 0.6) %>%
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


###############
fit <- glm(Survived ~ ., data = train_data, family = binomial())
summary(fit)

prob <- predict(fit, validation_data, type = 'response')

pred <- factor(prob > 0.5, levels=c(FALSE, TRUE), labels = c('Died', 'Survived'))
perf <- table(validation_data$Survived, pred, dnn=c('Actual', 'Predicted'))
perf

performance <- validation_data %>% 
  bind_cols(as.tibble(prob)) %>%
  mutate(predictedSurvived = ifelse(value > 0.5, 1, 0)) %>% 
  mutate(accurate = Survived == predictedSurvived)

count(performance %>% filter(accurate)) / count(performance)
