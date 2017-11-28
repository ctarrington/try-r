library(tidyverse)


rm(list=ls())
cat("\014")
graphics.off()

characters <- read.csv('characters.csv')
jobs <- read.csv('jobs.csv')

together <- jobs %>% full_join(characters, by = c('personId' = 'id'))
jobless <- together %>% filter(is.na(job) & !is.na(name))
unfilled <- together %>% filter(!is.na(job) & is.na(name))


together %>% filter(gender == 'Male') %>% write.csv('males.csv', row.names=FALSE)


