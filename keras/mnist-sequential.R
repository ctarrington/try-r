library(keras)
library(tidyverse)
library(zeallot)
library(ramify)

mnist <- dataset_mnist()

c(train_images, train_labels) %<-% mnist$train
c(test_images, test_labels) %<-% mnist$test

image_dim <- ncol(train_images)
train_images <- array_reshape(train_images, c(nrow(train_images), image_dim * image_dim)) / 255
test_images <- array_reshape(test_images, c(nrow(test_images), image_dim * image_dim)) / 255

train_labels <- to_categorical(train_labels)
test_labels <- to_categorical(test_labels)

model <- keras_model_sequential() %>%
  layer_dense(units = 512, activation = 'relu', input_shape = c(image_dim * image_dim)) %>%
  layer_dense(units = 10, activation = 'softmax')

model %>%
  compile(optimizer = 'rmsprop', loss = 'categorical_crossentropy', metrics = c('accuracy'))

model %>% fit(train_images, train_labels, epochs = 5, batch_size = 128)

metrics <- model %>% evaluate(test_images, test_labels)
metrics$acc

model %>% predict_classes(test_images[1:10, ])

for (digit_index in 1:10) {
  digit <- mnist$test$x[digit_index, , ]
  plot(as.raster(digit, max = 255))
}

predictions <- model %>% predict_classes(test_images)
results <- tibble(row=1:nrow(test_labels))

results %>% 
  mutate(predicted = predictions[row]) %>%
  mutate(actual = argmax(test_labels[row, ], rows = TRUE) - 1)

