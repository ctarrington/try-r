library(tidyverse)

people <- tribble(
  ~fullname, ~age, ~fullId,
  #--/--/--,
  'smith,john', 25, 'A1234-12',
  'smythe , sally', 25, 'B4321-21'
)

normalized <- people %>%
  extract(col = fullname, into = c('lastName', 'firstName'), regex = '([a-z]+)\\W+([a-z]+)' ) %>%
  extract(col = fullId, into = c('group', 'sectionId', 'personId'), regex = '([A-Z])([0-9]{4})-([0-9]{2})')

normalized
