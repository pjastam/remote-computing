# Fit a Bayesian model with naive normal priors on the coefficients and
# intercept on each of the continents. In real life, you'd want to use less
# naive priors and rescale your data, but this is just an example.
model_to_run <- function(df) {
  model_stan <- stan_glm(lifeExp ~ gdpPercap + country, 
                         data = df, family = gaussian(),
                         prior = normal(), prior_intercept = normal(),
                         chains = 4, iter = 2000, warmup = 1000, seed = 1234)
  return(model_stan)
}

# Use future_map to outsource each of the continent-based models to a different
# remote computer, where it will be run with all 4 remote cores
tic()
gapminder_models <- gapminder_to_model %>% 
  mutate(model = data %>% future_map(~ model_to_run(.x)))
toc()
#> 27.786 sec elapsed

# That's so fast!

# It worked!
gapminder_models
#> # A tibble: 4 x 3
#>   continent data               model        
#>   <fct>     <list>             <list>       
#> 1 Asia      <tibble [396 × 5]> <S3: stanreg>
#> 2 Europe    <tibble [360 × 5]> <S3: stanreg>
#> 3 Africa    <tibble [624 × 5]> <S3: stanreg>
#> 4 Americas  <tibble [300 × 5]> <S3: stanreg>
