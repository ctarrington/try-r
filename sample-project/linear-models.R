library(modelr)
options(na.action = na.warn)


# my best guess vs model

sim1_model <- lm(y ~ x, data = sim1)
sim1_model

ggplot(data = sim1, aes(x, y)) +
  geom_abline(aes(intercept = 4, slope = 2, color = 'guess')) +
  geom_abline(aes(intercept = sim1_model$coefficients[[1]], slope = sim1_model$coefficients[[2]], color = 'model')) +
  geom_point()

grid <- sim1 %>% data_grid(x) %>%
  add_predictions(sim1_model)

ggplot() +
  geom_point(data = sim1, aes(x, y)) +
  geom_point(data = grid, aes(x, pred, color = 'predicted'))

sim1 <- sim1 %>%
  add_residuals(sim1_model)

ggplot() +
  geom_ref_line(h = 0) +
  geom_point(data = sim1, aes(x, resid))
  
