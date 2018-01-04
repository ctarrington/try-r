library(tidyverse)
library(gapminder)

widePopulation <- gapminder %>%
  select(country, continent, year, pop) %>% 
  spread(key = year, value = pop)
