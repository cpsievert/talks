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



