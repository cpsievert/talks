library(thematic)
library(ggplot2)
library(shiny)

p <- ggplot(diamonds[sample(nrow(diamonds), 1000), ], aes(carat, price)) +
  geom_point(alpha = 0.2) +
  geom_smooth() +
  facet_wrap(~cut) + ggtitle("Diamond price by carat and cut")

# Auto theme plot based on current plotting environment
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

library(bslib)
thematic_shiny(font = "auto")
bs_theme_preview()

# Auto-theming in rmarkdown::html_document() via bslib
# (press Knit after opening to see the result)
file.edit("reports/darkly.Rmd")
