library(tidyverse)

numbers <- tribble(
  ~a, ~b, ~c,
  1,2,3,
  4,5,6,
  7,8,9,
  10,11,12
)

numbers[2:3]

# the dot allows you to reference the tibble in a pipe sequence
numbers %>% 
  filter(a %% 2 == 0) %>%
  .[2:3]