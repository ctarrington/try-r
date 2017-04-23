library(tidyverse)

rm(list=ls())
cat("\014")
dev.off(dev.list()["RStudioGD"])


mpg <- ggplot2::mpg %>% filter(class != "2seater")

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
    
View(
  mpg %>% 
    filter(manufacturer == "audi") %>% 
    select(class, displ, cyl) %>% 
    distinct %>%
    arrange(class, displ, cyl)
    , "Audi"
)

mpg %>% 
  filter(manufacturer == "audi") %>% 
  ggplot() + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  labs(title = "Audi")

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~class, nrow = 2)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) +
  geom_smooth()
