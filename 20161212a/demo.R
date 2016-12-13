library(plotly)
library(GGally)

# generalized pair plot 
# nice for exploratory/descriptive purposes
p <- ggpairs(flea[2:7])
# ggplotly() adds zoom/pan, identification, 
# and linked brushing
ggplotly(p, height = 600, width = 1000)

# automatic/manual should be a factor
mtcars$am <- factor(ifelse(mtcars$am == 0, "automatic", "manual"))
# fit a linear model
mod <- lm(mpg ~ wt + qsec + am, data = mtcars)

# produce diagnostic plots, coloring by automatic/manual
pm <- ggnostic(mod, mapping = aes(color = am))
ggplotly(pm, height = 600, width = 800) %>% 
  highlight("plotly_click")

# -----------------------------------------------------------------
# Outside of GGally, you have to define a "key" variable for linking
# -----------------------------------------------------------------

# define the "unit of interaction" as class
library(crosstalk)
m <- SharedData$new(mpg, ~class)

p <- ggplot(m, aes(displ, hwy, colour = class)) +
  geom_point() +
  geom_smooth(se = FALSE, method = "lm")

ggplotly(p, height = 400, width = 800) %>% 
  highlight("plotly_hover")














# # generalized pair plot 
# # nice for exploratory/descriptive purposes
# m <- SharedData$new(mpg)
# p <- ggpairs(m, aes(colour = class), c(3, 5, 8, 11))
# ggplotly(p, height = 650, width = 1200)
# ggplotly(p, height = 650, width = 1200) %>% highlight("plotly_click")
# 
# 
# 
# p <- ggpairs(flea, aes(colour = species))
# ggplotly(p, height = 650, width = 1200)
# 
# 
# names(mpg)
# 
