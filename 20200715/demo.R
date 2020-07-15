library(thematic)
library(bootstraplib)
library(shiny)
library(plotly)

# Notice how each theme change generates R code to reproduce it
thematic_shiny(font = "auto")
bs_theme_preview()

# Currently thematic is *not* enabled
p <- ggplot(diamonds[sample(nrow(diamonds), 1000), ], aes(carat, price)) +
  geom_point(alpha = 0.2) +
  geom_smooth() +
  facet_wrap(~cut) + ggtitle("Diamond price by carat and cut")

p

# Enable auto coloring 'globally'
thematic_on()
p

# Bonus: also works with ggplotly()
ggplotly(p)

# Let's change the RStudio theme and re-plot...
# thematic picks up on the changes!
rstudioapi::applyTheme("Tomorrow Night 80s")
p

rstudioapi::applyTheme("Tomorrow Night Bright")
p

# To disable thematic
thematic_off()
p
