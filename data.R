# We'll use gapminder data to estimate the relationship between health and 
# wealth in each continent using a Bayesian model

# Process and manipulate data locally
# Nest continent-based data frames into one larger data frame
gapminder_to_model <- gapminder %>% 
  group_by(continent) %>% 
  nest() %>% 
  # Not enough observations here, so ignore it
  filter(continent != "Oceania")
gapminder_to_model
#> # A tibble: 4 x 2
#>   continent data              
#>   <fct>     <list>            
#> 1 Asia      <tibble [396 × 5]>
#> 2 Europe    <tibble [360 × 5]>
#> 3 Africa    <tibble [624 × 5]>
#> 4 Americas  <tibble [300 × 5]> 
