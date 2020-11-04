library(thematic)
library(bslib)
library(shiny)
library(plotly)

# Each theme change generates R code to reproduce it
thematic_shiny(font = "auto")
bs_theme_new()
bs_theme_base_colors(bg = "#0C0B0B", fg = "#FBF5F5")
bs_theme_accent_colors(primary = "#E700FF")
bs_theme_preview()


# Currently thematic is *not* enabled
p <- ggplot(diamonds[sample(nrow(diamonds), 1000), ], aes(carat, price)) +
  geom_point(alpha = 0.2) +
  geom_smooth() +
  facet_wrap(~cut) + ggtitle("Diamond price by carat and cut")

p

# Enables auto coloring for _every future plot_
thematic_on()
p

# Change the RStudio theme and re-plot...
rstudioapi::applyTheme("Tomorrow Night 80s")
p

rstudioapi::applyTheme("Tomorrow Night Bright")
p

# thematic can also work with different 
theme_set(theme_minimal())
p

# even more minimal
theme_set(ggthemes::theme_tufte())
p

# go back to the default
theme_set(theme_gray())
p



# Works with lattice graphics
xyplot(
  decrease ~ treatment, OrchardSprays, groups = rowpos,
  type = "a", auto.key = list(space = "right", points = FALSE, lines = TRUE)
)

# Base graphics
plot(1:10, 1:10)

# And also ggplotly()!
ggplotly(p)


# Note that all variants of thematic_on() have a handful of controls...
?thematic_on

# Main colors default to 'auto', but you can also specify them
# (more on this later)
thematic_on(bg = "darkblue", fg = "skyblue", accent = "orange")
p


# To disable thematic
thematic_off()
p
