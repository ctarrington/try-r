library(tidyverse)
library(forcats)

View(gss_cat)

gss_cat %>%
  count(denom)

# ggplot(gss_cat, aes(rincome)) +  geom_bar() +  scale_x_discrete(drop = FALSE)

relig_denom <- gss_cat %>%
  filter(denom != 'Not applicable') %>%
  select(relig, denom)

relig_denom_tally <- tally(group_by(relig_denom, relig, denom), sort = TRUE)
View(relig_denom_tally)

relig_summary <- gss_cat %>%
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )