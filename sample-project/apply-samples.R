mat <- matrix(10*rnorm(30), nrow = 5, ncol = 6)

row_sums <- mat %>% apply(MARGIN = 1, sum)
column_sums <- mat %>% apply(MARGIN = 2, sum)
scaled_cells <- apply(mat, MARGIN = c(1,2), function(val) {val/10})


addNoise <- function(val) { val + rnorm(1)/10 }
noisy <- sapply(1:20, addNoise)

replicate(10, rnorm(2
