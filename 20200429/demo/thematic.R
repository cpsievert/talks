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

# Let's change the RStudio theme and re-plot...
# thematic picks up on the changes!
rstudioapi::applyTheme("Tomorrow Night Bright")
last_plot()

# Base plots are also auto-themed
hist(rnorm(100))

# Until we turn it off 
thematic_off()

# Until they're not
hist(rnorm(100))

# Without thematic, R plots won't reflect the app's CSS styles :(
runApp("apps/01")

# ...but they will with thematic! :)
thematic_on()
runApp("apps/01")


# If the app uses a Google Font, and you want R plots to use that same font...
thematic_on(font = "auto")
runApp("apps/02")

# bootstraplib: the modern approach to theming shiny apps
# (try changing the background/foreground/primary/font)
library(bootstraplib)
bs_theme_new()
bs_theme_base_colors(bg = "#0C0C0C", fg = "#E4E4E4")
bs_theme_accent_colors(primary = "#e39777")
bs_theme_fonts("Roboto Condensed")
bs_theme_preview()


# auto theming in rmarkdown::html_document()
# (press Knit after opening to see the result)
file.edit("reports/darkly.Rmd")
