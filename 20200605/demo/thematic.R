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

rstudioapi::applyTheme("Tomorrow Night 80s")
last_plot()

# Any plot is not auto-themed
hist(rnorm(100))

# Until we turn it off 
thematic_off()
hist(rnorm(100))

# Without thematic, R plots won't reflect the app's styles :(
runApp("apps/01")

# ...but they will with thematic enabled! :)
thematic_on_app()
shiny::runApp("apps/01")

# Using thematic_on_app() ensures that, after app exits, 
# downstream code is unaffected
plot(1:10)

# Let's look at the app...
file.edit("apps/01/app.R")

# If the app uses a Google Font, and you want R plots to use that same font...
thematic_on(font = "auto")
runApp("apps/02")

# The main idea behind auto-theming in shiny
file.edit("apps/03/app.R")

# Styles may be targeted and accessed in extensible ways
file.edit("apps/04/app.R")

# bootstraplib: more customizable than shinythemes and less painful than CSS
# https://rstudio.github.io/bootstraplib
library(bootstraplib)
bs_theme_new()
bs_theme_base_colors(bg = "#0C0C0C", fg = "#E4E4E4")
bs_theme_accent_colors(primary = "#e39777")
bs_theme_fonts("Roboto Condensed")
bs_theme_preview()


# Auto theming in rmarkdown::html_document()
# (press Knit after opening to see the result)
file.edit("reports/darkly.Rmd")
