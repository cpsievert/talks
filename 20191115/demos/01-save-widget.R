library(plotly)
library(htmlwidgets)

bars <- plot_ly(diamonds, x = ~cut, color = ~clarity, colors = "Accent")

# printing object opens HTML page
bars

# plotly is highly customizable.
bars_finished <- bars %>%
  layout(
    hovermode = "x",
    title = "Diamond cut",
    xaxis = list(title = ""),
    font = list(family = "Roboto")
  ) %>%
  config(displayModeBar = FALSE)

# Save a self-contained HTML file of the plot.
# Learn more about different ways of saving HTML (and other formats) here
# https://plotly-r.com/saving.html
saveWidget(bars_finished, "bars.html")

# Open that HTML file
browseURL("bars.html")

# Delete that file
unlink("bars.html")

