library(tidyverse)
library(stringr)
library(gapminder)

printRow <- function(continent, country, year, pop) {
  print(str_c(continent, country, year, pop, sep = ', '))
  print('foo')
  return(TRUE)
}

countries <- gapminder %>%
  filter(!str_detect(country, '^C.*a$')) %>%
  select(country, continent, year, pop)

countries %>%
  rowwise() %>%
  mutate(dummy = printRow(continent, country, year, pop))

