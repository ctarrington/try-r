library(nycflights13)
library(tidyverse)

rm(list=ls())
cat("\014")
graphics.off()

twoHourDelay <- flights %>% filter(arr_delay >= 2*60)
uadSummer <- flights %>% filter(carrier %in% c('UA', 'AA', 'DL'), month >= 7, month <=9)

leaveOnTimeArriveLate <- flights %>% filter(arr_delay >= 2*60, dep_delay <= 0) %>% select(dep_delay, arr_delay, everything())

earlyDepartures <- flights %>% filter(hour >= 0, hour <= 6)

