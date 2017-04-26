library(tidyverse)

rm(list=ls())
cat("\014")
dev.off(dev.list()["RStudioGD"])


mpg <- ggplot2::mpg %>% filter(class != "2seater")

mpg %>%
  summarise_all(funs(n_distinct(.)))

View(
  mpg %>%
    arrange(manufacturer, displ)
  )

View(
  mpg %>%
    filter(hwy > 35) %>%
    arrange(hwy, manufacturer)
  ,"High HWY MPG"
)

computed_cars <- 
  mpg %>% 
  group_by(manufacturer, year, displ, class) %>% 
  summarize(
    models = n(),
    mean.hwy = mean(hwy, na.rm = TRUE)
  )

computed_cars %>% 
  ggplot() + 
  geom_point(mapping = aes(x = displ, y = mean.hwy, color = class)) +
  facet_wrap(~manufacturer, nrow = 3) +
  labs(title = "Mean HWY Values")

mpg %>% 
  ggplot() + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  facet_wrap(~manufacturer, nrow = 3) +
  labs(title = "Raw HWY Values")

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth() +
  labs(title = "Displacement vs HWY (no jitter)")

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class), position = "jitter") +
  geom_smooth() +
  labs(title = "Displacement vs HWY (with jitter)")

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, year == 1999), mapping = aes(linetype = "1999")) +
  geom_smooth(data = filter(mpg, year == 2008), mapping = aes(linetype = "2008"))


ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~class, nrow = 2)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) +
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = fl)) +
  geom_point()

ggplot(data = mpg) +
  geom_bar(mapping = aes(x = displ, fill = drv))

displ_hwy_summary <- ggplot(data = mpg) +
  stat_summary(mapping = aes(x = displ, y = hwy),
     fun.ymin = min,
     fun.ymax = max,
     fun.y = median
  )

displ_hwy_summary

displ_hwy_summary + 
  facet_wrap(~ year, nrow = 2)
