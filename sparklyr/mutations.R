library(sparklyr)
library(dplyr)

sc <- spark_connect(master = 'local')

iris_tbl <- copy_to(sc, iris)
flights_tbl <- copy_to(sc, nycflights13::flights, 'flights')
batting_tbl <- copy_to(sc, Lahman::Batting, 'batting')
src_tbls(sc)

start <- proc.time()
delay_tbl <- flights_tbl %>% 
  group_by(tailnum) %>%
  summarise(count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(count > 20, dist < 2000, !is.na(delay)) %>%
  collect
elapsed <- proc.time() - start

slow_tbl <- delay_tbl %>% 
  filter(delay > 10)

slow_tbl %>% 
  collect()

start <- proc.time()
nospark_delay <- nycflights13::flights %>% 
  group_by(tailnum) %>%
  summarise(count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(count > 20, dist < 2000, !is.na(delay)) 
elapsed <- proc.time() - start



