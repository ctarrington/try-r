library(tidyverse)
library(dplyr)
library(keras)

source('./vectorize-sequences.R')
source('./decode-word.R')

word_index <- dataset_imdb_word_index()
reverse_word_index <- names(word_index)
names(reverse_word_index) <- word_index

reverse_word_index[4]
reverse_word_index[[4]]
word_index$fawn

imdb <- dataset_imdb(num_words = 10000)
c(c(train_data, train_labels), c(test_data, test_labels)) %<-% imdb


decoded_review <- sapply(train_data[[1]], decodeWord)
decoded_review
train_labels[[1]]

x_train <- vectorize_sequences(train_data)
x_test <- vectorize_sequences(test_data)

y_train <- as.numeric(train_labels)
y_test <- as.numeric(test_labels)

val_indices <- 1:10000

x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]

model <- keras_model_sequential() %>% 
  layer_dense(units = 16, activation = "relu", input_shape = c(10000)) %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  optimizer = "rmsprop",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)

history <- model %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val, y_val)
)

results <- model %>% evaluate(x_test, y_test)
results$acc

probabilities <- model %>% 
  predict(x_test[1:20,])

probabilities <- as_tibble(probabilities) %>%
  mutate(predictedPositive = ifelse(V1 > 0.5,1,0)) %>%
  bind_cols(as_tibble(y_test[1:20]))


decoded_review <- sapply(test_data[[8]], decodeWord)
