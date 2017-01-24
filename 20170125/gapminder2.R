#+ setup, include=FALSE
knitr::opts_chunk$set(message = FALSE, echo = FALSE, warning = FALSE)

#+ plot
library(plotly)
library(gapminder)
library(crosstalk)

countryByArea <- read.table(
  "https://gist.githubusercontent.com/cpsievert/d4a4ccb7ce61e2cfaecf9736de4f67fa/raw/9b7d01c2c939d721bdf2f47a6596ac4c055205d3/countryByArea.txt",
  header = TRUE, stringsAsFactors = FALSE
)

gap <- gapminder %>%
  dplyr::left_join(countryByArea, by = "country") %>%
  transform(popDen = pop / area) %>%
  transform(country = forcats::fct_reorder(country, popDen))


gapKey <- crosstalk::SharedData$new(gap, ~country)

p1 <- plot_ly(gap, y = ~country, x = ~popDen, hoverinfo = "x") %>%
  add_markers(alpha = 0.1, color = I("black")) %>%
  add_markers(data = gapKey, frame = ~year, ids = ~country, color = I("red")) %>%
  layout(xaxis = list(type = "log"))

p2 <- plot_ly(gap, x = ~gdpPercap, y = ~lifeExp, size = ~popDen, 
              text = ~country, hoverinfo = "text") %>%
  add_markers(color = I("black"), alpha = 0.1) %>%
  add_markers(data = gapKey, frame = ~year, ids = ~country, color = I("red")) %>%
  layout(xaxis = list(type = "log"))

subplot(p1, p2, nrows = 1, widths = c(0.3, 0.7), titleX = TRUE) %>%
  hide_legend() %>%
  # TODO: why is this broken?
  #animation_opts(1000) %>%
  layout(dragmode = "select", hovermode = "y", margin = list(l = 100)) %>%
  highlight(off = "plotly_deselect", color = "blue", opacityDim = 1, hoverinfo = "none")
