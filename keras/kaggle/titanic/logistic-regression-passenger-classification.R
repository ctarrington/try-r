library(tidyverse)
library(keras)
library(zeallot)

source('../../sampling.R')

col_spec <- cols(
  PassengerId = col_integer(),
  Pclass = col_factor(levels = c('1', '2', '3')),
  Name = col_character(),
  Sex = col_factor(c('male', 'female')),
  Age = col_double(),
  SibSp = col_integer(),
  Parch = col_integer(),
  Ticket = col_character(),
  Fare = col_double(),
  Cabin = col_character(),
  Embarked = col_character(),
  Survived = col_factor(levels = c('1', '0'))
)

all_train <- read_csv('./train.csv', col_types = col_spec) 

max_age <- max(all_train$Age, na.rm = TRUE)
mean_age <- mean(all_train$Age, na.rm = TRUE)
max_sibsp <- max(all_train$SibSp)
max_parch <- max(all_train$Parch)


conditionData <- function(tbl) {
  complete <- tbl %>% 
    mutate(Age = ifelse(is.na(Age), mean_age, Age))
  
  limited <- complete %>%
    select(-Name, -Cabin, -Ticket, -Embarked, -Parch, -SibSp, -PassengerId)
}

all_train <- conditionData(all_train)
c(train_data, validation_data) %<-%  split_data(all_train, 0.8)

fit <- glm(Survived ~ ., data = train_data, family = binomial())
summary(fit)

prob <- predict(fit, validation_data, type = 'response')

performance <- validation_data %>% 
  bind_cols(as.tibble(prob)) %>%
  mutate(predictedSurvived = ifelse(value < 0.5, 1, 0)) %>% 
  mutate(accurate = Survived == predictedSurvived)

