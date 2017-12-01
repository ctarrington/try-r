library(tidyverse)


rm(list=ls())
cat("\014")
graphics.off()

colors <- read.csv('colors.csv')

colorCountsById <- colors %>%
  group_by(id, color) %>%
  summarise(count = n())

result <- colorCountsById %>%
  group_by(id) %>%
  filter(count == max(count))



