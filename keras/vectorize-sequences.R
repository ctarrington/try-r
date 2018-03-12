vectorize_sequences <- function(sequences, dimension = 10000) {
  results <- matrix(0, nrow = length(sequences), ncol = dimension)
  for (i in 1:length(sequences)) {
    results[i, sequences[[i]]] <- 1
  }
  results
}