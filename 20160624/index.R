## ------------------------------------------------------------------------
## Make sure you can install these!!!
## ------------------------------------------------------------------------
## install.packages("quantmod")
## install.packages("RColorBrewer")
## install.packages("devtools")
## # if you encounter errors, let me know!
## devtools::install_github("ropensci/plotly#628")

## ------------------------------------------------------------------------
c(0, 1)

## ------------------------------------------------------------------------
x <- c(0, 1)

## ------------------------------------------------------------------------
sum(x + 10)

## ------------------------------------------------------------------------
x <- list(a = 1:5, b = "red")
x$a
x[["a"]]
x["a"]

## ------------------------------------------------------------------------
range(mtcars$mpg)

## ------------------------------------------------------------------------
library(plotly)
p <- qplot(data = mpg, displ, hwy, geom = c("point", "smooth")) + facet_wrap(~drv)
ggplotly(p)

## ------------------------------------------------------------------------
str(volcano)

## ------------------------------------------------------------------------
str(~volcano)
f <- function() { str(~volcano) }
f()

## ---- message = TRUE, fig.width=5, fig.height=4.5------------------------
plot_ly(z = ~volcano)

## ---- eval = FALSE-------------------------------------------------------
## # equivalent to before, but more explicit
## add_heatmap(plot_ly(z = ~volcano))

## ---- eval = FALSE-------------------------------------------------------
## plot_ly(z = ~volcano) %>% add_surface() %>% plotly_POST()

## ---- eval = FALSE-------------------------------------------------------
## plotly_POST(add_surface(plot_ly(z = ~volcano)))

## ------------------------------------------------------------------------
library(plotly)
txhousing

## ---- message = TRUE-----------------------------------------------------
plot_ly(txhousing, x = ~sales)

## ------------------------------------------------------------------------
library(dplyr)
d <- txhousing %>% 
  group_by(city) %>%
  summarise(m = mean(sales, na.rm = TRUE))
d

## ------------------------------------------------------------------------
txhousing %>% 
  group_by(city) %>%
  summarise(m = mean(sales, na.rm = TRUE)) %>%
### <b>
  arrange(m) %>%
  plot_ly(x = ~m, y = ~city) %>%
  layout(title ="Average monthly sales, by city", margin = list(l = 120))
### </b>

## ------------------------------------------------------------------------
p <- txhousing %>%
  group_by(city) %>%
  plot_ly(x = ~date, y = ~sales, text = ~city) %>%
  layout(hovermode = "closest")
p

## ------------------------------------------------------------------------
add_lines(p, y = ~log(sales))

## ---- echo = FALSE-------------------------------------------------------
p %>%
  add_lines(y = ~log(sales), color = ~city, 
            line = list(color = "black"), hoverinfo = "text") %>% 
  layout(hovermode = "closest", showlegend = FALSE) %>%
  htmlwidgets::onRender('
    function(el, x) { 
      var graphDiv = document.getElementById(el.id);
      // reduce the opacity of every trace except for the hover one
      el.on("plotly_hover", function(e) { 
        var traces = [];
        for (var i = 0; i < x.data.length; i++) {
          if (i !== e.points[0].curveNumber) traces.push(i);
        }
        Plotly.restyle(graphDiv, "opacity", 0.2, traces);
      })
     el.on("plotly_unhover", function(e) { 
       var traces = [];
       for (var i = 0; i < x.data.length; i++) traces.push(i);
       Plotly.restyle(graphDiv, "opacity", 1, traces);
     })
    } 
  ')

## ---- echo = FALSE-------------------------------------------------------
p %>%
  add_lines(y = ~median, color = ~city, text = ~city, 
            line = list(color = "black"), hoverinfo = "text") %>%
  layout(hovermode = "closest", showlegend = FALSE) %>%
  htmlwidgets::onRender('
    function(el, x) { 
      var graphDiv = document.getElementById(el.id);
      // reduce the opacity of every trace except for the hover one
      el.on("plotly_hover", function(e) { 
        var traces = [];
        for (var i = 0; i < x.data.length; i++) {
          if (i !== e.points[0].curveNumber) traces.push(i);
        }
        Plotly.restyle(graphDiv, "opacity", 0.2, traces);
      })
     el.on("plotly_unhover", function(e) { 
       var traces = [];
       for (var i = 0; i < x.data.length; i++) traces.push(i);
       Plotly.restyle(graphDiv, "opacity", 1, traces);
     })
    } 
  ')

## ------------------------------------------------------------------------
top5 <- txhousing %>% 
  group_by(city) %>%
  summarise(m = mean(sales, na.rm = TRUE)) %>%
  arrange(desc(m)) %>%
  top_n(5)
top5

## ------------------------------------------------------------------------
top5plot <- txhousing %>%
  semi_join(top5) %>%
  plot_ly(x = ~date, y = ~sales, color = ~city)
add_lines(top5plot)

## ------------------------------------------------------------------------
RColorBrewer::display.brewer.all(type = "qual")

## ------------------------------------------------------------------------
add_lines(top5plot, colors = "Dark2")

## ------------------------------------------------------------------------
txhousing %>%
  semi_join(top5) %>%
  group_by(city) %>%
  do(p = plot_ly(., x = ~log(sales), name = .$city))

## ------------------------------------------------------------------------
txhousing %>%
  semi_join(top5) %>%
  group_by(city) %>%
  do(p = plot_ly(., x = ~log(sales), name = ~city)) %>%
### <b>
  .[["p"]] %>% 
  subplot(nrows = 5, shareX = TRUE)
### </b>

## ------------------------------------------------------------------------
economics 

## ------------------------------------------------------------------------
library(tidyr)
gather(economics, variable, value, -date)

## ------------------------------------------------------------------------
economics %>%
  gather(variable, value, -date) %>%
  group_by(variable) %>%
  summarise(m = min(value))

## ------------------------------------------------------------------------
economics %>%
  gather(variable, value, -date) %>%
  group_by(variable) %>%
  do(p = plot_ly(., x = ~date, y = ~value, name = ~variable)) %>%
  .[["p"]] %>%
  subplot(nrows = NROW(.), shareX = TRUE, titleX = FALSE)

## ------------------------------------------------------------------------
economics %>%
  plot_ly(x = ~uempmed, y = ~unemploy/pop) %>%
  add_markers(color = ~as.numeric(date), text = ~date, hoverinfo = "text")

## ------------------------------------------------------------------------
library(quantmod)
msft <- getSymbols("MSFT", auto.assign = F)
dat <- as.data.frame(msft)
dat$date <- index(msft)
head(dat)

names(dat) <- sub("^MSFT\\.", "", names(dat))

plot_ly(dat, x = ~date, xend = ~date, color = ~Close > Open,
        colors = c("red", "forestgreen"), hoverinfo = "none") %>%
  add_segments(y = ~Low, yend = ~High, line = list(width = 1)) %>%
  add_segments(y = ~Open, yend = ~Close, line = list(width = 3)) %>%
  layout(showlegend = FALSE, yaxis = list(title = "Price")) %>%
  toWebGL()

