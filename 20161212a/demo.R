library(plotly)
library(GGally)

View(flea)

# generalized pair plot 
# nice for exploratory/descriptive purposes
p <- ggpairs(flea[2:7])
# ggplotly() adds zoom/pan, identification, and linked brushing
ggplotly(p)


# automatic/manual should be a factor
mtcars$am <- factor(ifelse(mtcars$am == 0, "automatic", "manual"))
# fit a linear model
mod <- lm(mpg ~ wt + qsec + am, data = mtcars)

# produce diagnostic plots, coloring by automatic/manual
pm <- ggnostic(mod, mapping = aes(color = am))
# ggplotly() will automatically add rownames as a key if none is provided
ggplotly(pm) %>% highlight("plotly_click")
