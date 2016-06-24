library(plotly)

# easy
plot_ly(txhousing, x = ~sales)
plot_ly(txhousing, x = ~volume)
plot_ly(txhousing, x = ~median)
plot_ly(txhousing, x = ~listings)

# medium
plot_ly(txhousing, x = ~log(sales))
plot_ly(txhousing, x = ~sqrt(sales))

# hard
d <- density(log(txhousing$sales), na.rm = TRUE)
plot_ly() %>% add_area(x = d$x, ymax = d$y)
