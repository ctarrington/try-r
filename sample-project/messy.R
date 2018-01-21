library(tidyverse)
library(gapminder)

widePopulation <- gapminder %>%
  select(country, continent, year, pop) %>% 
  spread(key = year, value = pop)

View(table4a)

tidied <- table4a %>%
  gather(`1999`:`2000`,key='year',value='cases')

View(tidied)