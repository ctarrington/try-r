library(tidyverse)

rm(list=ls())
cat("\014")
dev.off(dev.list()["RStudioGD"])


mpg <- ggplot2::mpg

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = hwy))


mpg %>%
  summarise_all(funs(n_distinct(.)))

View(
  mpg %>%
    select(manufacturer, class, drv, fl, year) %>%
    distinct %>%
    arrange(manufacturer, class, drv, fl)
  ,"Overview"
)

View(
  mpg %>%
    filter(hwy > 35) %>%
    arrange(hwy, manufacturer)
  ,"High HWY MPG"
)
    

mpg %>% 
  filter(manufacturer == "audi") %>% 
  select(class, displ, cyl, hwy) %>% 
  distinct %>%
  arrange(hwy,class, displ, cyl) %>%
  ggplot() + 
    geom_point(mapping = aes(x = displ, y = hwy, color = cyl)) +
    labs(title = "Audi")
