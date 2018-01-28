library(tidyverse)

n <- 2000
inputs <- tibble(
  a = rnorm(n),
  b = rnorm(n),
  letters = sample(letters, size = n, replace = TRUE),
  c = rnorm(n),
  d = rnorm(n)
)

results <- vector('double', ncol(inputs))
for (index in seq_along(inputs)) {
  names(results)[[index]] <- names(inputs)[[index]]
  
  if (typeof(inputs[[index]]) == 'double') {
    results[[index]] <- mean(inputs[[index]])
  } else {
    results[[index]] <- NA
  }
}

results
mean(results, na.rm = TRUE)


# biased coin used to get unbiased result
# because P(HT) == P(TH) 
flip <- function() {
  sample(c("T", "H", "H"), size = 2, replace = TRUE)
}


flips <- 0
nheads <- 0
ntails <- 0 
count <- 100000

while (flips < count) {
  result <- flip()
  if (result[[1]] == 'H' & result[[2]] == 'T') {
    nheads <- nheads + 1
    flips <- flips + 1
  } else if (result[[1]] == 'T' & result[[2]] == 'H'){
    ntails <- ntails + 1
    flips <- flips + 1
  }
}

nheads/count
ntails/count