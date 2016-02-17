# git checkout rewrite
# R CMD install ./

library(plotly)
g <- ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point() + geom_smooth(se = F) + facet_wrap(~cyl)
ggplotly(g)

g + theme_bw()
ggplotly(g + theme_bw())

g + ggthemes::theme_solarized()
ggplotly(g + ggthemes::theme_solarized())
