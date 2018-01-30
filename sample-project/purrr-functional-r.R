library(tidyverse)
library(stringr)


n <- 4
inputs <- tibble(
  a = rnorm(n),
  b = rnorm(n),
  letters = sample(letters, size = n, replace = TRUE),
  c = rnorm(n),
  d = rnorm(n)
)

results <- inputs %>%
  select(a, b, c, d) %>%
  map_dbl(mean)

results

namesAndGreetings <- tibble(
  names = c('fred', 'ted', 'dred'),
  greetings = c('hi', 'yo', 'hello')
)

printIt <- function(greeting, name) {
  print(str_c(greeting, name, sep = ' there '))
}

concatenate <- function(greeting, name) {
  str_c(greeting, name, sep = ' there ')
}

messages <- pmap(list(namesAndGreetings$greetings, namesAndGreetings$names), concatenate)
pwalk(list(namesAndGreetings$greetings, namesAndGreetings$names), printIt)
pwalk(list(c('hey', 'hi ho'), c('sally', 'liza')), printIt)
