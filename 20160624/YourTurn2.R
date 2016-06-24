library(plotly)
library(dplyr)

txhousing %>%
  semi_join(top5) %>%
  plot_ly(x = ~date, y = ~log(sales)) %>% 
  add_lines(linetype = ~city)

txhousing %>%
  semi_join(top5) %>%
  plot_ly(x = ~date, y = ~log(sales)) %>% 
  add_lines(symbol = ~city)
