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

# Enable thematic (up until the next app exits)
thematic_shiny()
runApp("apps/01")

# Downstream code is unaffected
plot(1:10)

# Let's look at the app...
file.edit("apps/01/app.R")

# If the app uses a Google Font, and you want R plots to use that same font...
file.edit("apps/02/app.R")

# Demo of how auto-theming works under-the-hood
# (Note how the 'auto-theming' here doesn't require thematic)
file.edit("apps/03/app.R")

# Access styles for any shiny output!
file.edit("apps/04/app.R")

# bslib: more customizable than shinythemes and less painful than CSS
# https://rstudio.github.io/bslib
library(bslib)
# thematic_shiny(font = "auto")
bs_theme_preview(auto_theme = FALSE)


# Auto-theming in rmarkdown::html_document() via bslib
# (press Knit after opening to see the result)
file.edit("reports/darkly.Rmd")
