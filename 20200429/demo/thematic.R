library(thematic)
library(ggplot2)
library(shiny)

ggplot(diamonds[sample(nrow(diamonds), 1000), ], aes(carat, price)) +
  geom_point(alpha = 0.2) +
  geom_smooth() +
  facet_wrap(~cut) + ggtitle("Diamond price by carat and cut")

# Auto theme plot based on current plotting environment
thematic_on()
last_plot()

plotly::ggplotly()

# Now any future plot will be themed
hist(rnorm(100))

# Until we turn it off 
thematic_off()

# No longer themed
hist(rnorm(100))

# Have you ever styled a shiny app and wish your R plots reflected that styling?
runApp("apps/01")

# Now you can!
thematic_on()
runApp("apps/01")


# Also, if your app uses a Google Font, and you want R plots to use that same font...
thematic_on(font = "auto")
runApp("apps/02")

# bootstraplib: the modern approach to theming shiny apps
# (try changing the background/foreground/primary/font)
library(bootstraplib)
bs_theme_new()
bs_theme_preview()


# auto theming in rmarkdown::html_document()
file.edit("reports/darkly.Rmd")
file.edit("reports/superhero.Rmd")
