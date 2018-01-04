library(dplyr)

values <- read.csv('./values-for-mutations.csv', na.string = 'NULL')

byGender <- values %>%
  mutate(rank = min_rank(desc(value))) %>%
  group_by(gender) %>%
  do(mutate(.,meanForGender = mean(.$value,na.rm=TRUE), aboveMean = value - meanForGender))

