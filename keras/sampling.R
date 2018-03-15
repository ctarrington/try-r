############# Shuffle #####################
shuffle_data <- function(raw_data) {
  indices <- sample(1:nrow(raw_data))
  shuffled <- raw_data[indices, ]
}

############# Asymetrical split ###########
split_data <- function(raw_data, ratio) {
  first_indices <- sample(1:nrow(raw_data), size = ratio * nrow(raw_data))
  first <- raw_data[first_indices, ]
  second <- raw_data[-first_indices, ]
  
  list(first, second)
}

################# K-Folds ##################
# https://www.safaribooksonline.com/library/view/deep-learning-with/9781617295546/kindle_split_013.html

create_folds <- function(raw_data, fold_count) {
  indices <- sample(1:nrow(raw_data))
  folds <- cut(indices, breaks = fold_count, labels = FALSE)
  
  getfold <- function(fold_index) {
    matches <- which(folds == fold_index, arr.ind = TRUE)
    first <- shuffle_data(raw_data[matches, ])
    second <- shuffle_data(raw_data[-matches, ])
    
    list(first, second)
  }
}