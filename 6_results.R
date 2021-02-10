# Do stuff with the models ------------------------------------------------

# Extract the gdpPercap coefficient from the rstanarm models
gapminder_models_to_plot <- gapminder_models %>% 
  mutate(tidied = model %>% map(~ tidy(.x, intervals = TRUE, prob = 0.9))) %>% 
  unnest(tidied) %>% 
  filter(term == "gdpPercap")

# Plot the coefficients
ggplot(gapminder_models_to_plot, aes(x = estimate, y = continent)) +
  geom_vline(xintercept = 0) +
  geom_pointrangeh(aes(xmin = lower, xmax = upper, color = continent), size = 1) +
  labs(x = "Coefficient estimate (log GDP per capita)", y = NULL,
       caption = "Bars show 90% credible intervals") +
  scale_color_viridis_d(begin = 0, end = 0.9, name = NULL) +
  theme_grey() + theme(legend.position = "bottom")
