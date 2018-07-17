library(tidyverse)
library(keras)
library(zeallot)

source('../../sampling.R')

# Titles with very low cell counts to be combined to "rare" level
rare_title <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don', 
                'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')

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
    filter(!is.na(Age)) %>% 
    mutate(Survived = ifelse(Survived == 0, 'Died', 'Survived')) %>% 
    mutate(Survived = factor(Survived, levels = c('Died', 'Survived'))) %>%
    mutate(FamilySize = Parch + SibSp + 1) %>% 
    mutate(SingleFamilySize = FamilySize == 1) %>% 
    mutate(SmallFamilySize = FamilySize > 1 & FamilySize < 5) %>% 
    mutate(Title = gsub('(.*, )|(\\..*)', '', Name)) %>%
    rowwise() %>%
    mutate(Surname = strsplit(Name, split = '[,.]')[[1]][1])
  
  complete$Title[complete$Title == 'Mlle']        <- 'Miss' 
  complete$Title[complete$Title == 'Ms']          <- 'Miss'
  complete$Title[complete$Title == 'Mme']         <- 'Mrs' 
  complete$Title[complete$Title %in% rare_title]  <- 'Rare Title'

  limited <- complete %>%
    select(-Surname, -FamilySize, -Name, -Cabin, -Ticket, -Embarked, -Parch, -SibSp, -PassengerId, -Fare)
}

all_train <- conditionData(all_train)

table(all_train$Sex, all_train$Title)
table(all_train$Survived, all_train$Title)

c(train_data, validation_data) %<-%  split_data(all_train, 0.80)

fit <- glm(Survived ~ ., data = train_data, family = binomial())
summary(fit)

prob <- predict(fit, validation_data, type = 'response')

pred <- factor(prob > 0.5, levels=c(FALSE, TRUE), labels = c('Died', 'Survived'))
perf <- table(validation_data$Survived, pred, dnn=c('Actual', 'Predicted'))
perf

performance <- validation_data %>% 
  bind_cols(as.tibble(prob)) %>%
  mutate(predictedSurvived = ifelse(value > 0.5, 'Survived', 'Died')) %>% 
  mutate(accurate = Survived == predictedSurvived)

count(performance %>% filter(accurate)) / count(performance)

