library(keras)
library(tidyverse)
library(zeallot)
library(ramify)

mnist <- dataset_mnist()

c(train_images, train_labels) %<-% mnist$train
c(test_images, test_labels) %<-% mnist$test

image_dim <- ncol(train_images)
train_images <- array_reshape(train_images, c(60000, 28, 28, 1)) / 255
test_images <- array_reshape(test_images, c(10000, 28, 28, 1)) / 255

train_labels <- to_categorical(train_labels)
test_labels <- to_categorical(test_labels)

model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = 'relu', input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = 'relu') %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = 'relu') %>% 
  layer_flatten() %>%
  layer_dense(units = 64, activation = 'relu') %>%
  layer_dense(units = 10, activation = 'softmax')

model %>% compile(optimizer = 'rmsprop', loss = 'categorical_crossentropy', metrics = c('accuracy'))
model %>% fit(
  train_images, train_labels,
  epochs = 5, batch_size=64
)

metrics <- model %>% evaluate(test_images, test_labels)
metrics$acc

for (digit_index in 1:10) {
  digit <- mnist$test$x[digit_index, , ]
  plot(as.raster(digit, max = 255))
}

predictions <- model %>% predict_classes(test_images)
results <- tibble(row=1:nrow(test_labels))

results <- results %>% 
  mutate(predicted = predictions[row]) %>%
  mutate(actual = argmax(test_labels[row, ], rows = TRUE) - 1) %>%
  mutate(predicted = as.integer(predicted)) %>% 
  mutate(actual = as.integer(actual))

errors <- results %>% 
  filter(actual != predicted) %>% 
  group_by(predicted, actual) %>%
  summarise(count = n()) %>% 
  arrange(desc(count))

