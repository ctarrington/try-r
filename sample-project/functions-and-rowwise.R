library(tidyverse)
library(stringr)
library(gapminder)

printRow <- function(row) {
  print(str_c(row$continent, row$country, row$year, row$pop, sep = ', '))
}

countries <- gapminder %>%
  filter(str_detect(country, 'A')) %>%
  select(country, continent, year, pop)

countries %>%
  rowwise() %>%
  printRow()
