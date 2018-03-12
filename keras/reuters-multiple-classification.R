library(tidyverse)
library(keras)

source('./vectorize-sequences.R')
source('./decode-word.R')

reuters <- dataset_reuters(num_words = 10000)
c(c(train_data, train_labels), c(test_data, test_labels)) %<-% reuters

x_train <- vectorize_sequences(train_data)
x_test <- vectorize_sequences(test_data)


one_hot_train_labels <- to_categorical(train_labels)
one_hot_test_labels <- to_categorical(test_labels)

test_labels[4]
one_hot_test_labels[4,5]  # plus one - presumably a 1 in first means unknown? 
label_count <- length(one_hot_test_labels[4,])

model <- keras_model_sequential() %>% 
  layer_dense(units = 64, activation = 'relu', input_shape = c(10000)) %>%
  layer_dense(units = 64, activation = 'relu') %>%
  layer_dense(units = 46, activation = 'softmax')

model %>% compile(
  optimizer = 'rmsprop',
  loss = 'categorical_crossentropy',
  metrics = c('accuracy')
)

val_indices <- 1:1000
x_val <- x_train[val_indices,]
x_partial_train <- x_train[-val_indices,]

y_val <- one_hot_train_labels[val_indices,]
y_partial_train <- one_hot_train_labels[-val_indices,]

history <- model %>% fit(
  x_partial_train,
  y_partial_train,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val, y_val)
)

results <- model %>% evaluate(x_test, one_hot_test_labels)
results$acc

predictions <- model %>% predict(x_test)
which.max(predictions[1,])

prediction_count <- dim(predictions)[1]
results <- tibble(row=1:prediction_count)
results <- results %>% 
  rowwise() %>%
  mutate(category = which.max(predictions[row,]) - 1) %>% 
  mutate(probability = predictions[row,category+1]) %>% 
  mutate(expected = test_labels[row])


