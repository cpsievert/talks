library(plotly)

View(txhousing)

# for ggplot2 users...
p <- ggplot(txhousing) +
  geom_line(aes(x = date, y = median, group = city))

ggplotly(p)

# btw, this is equivalent...
p %>% ggplotly()


# non-ggplot2 interface 
# works with dplyr verbs (a la ggvis)
txhousing %>%
  group_by(city) %>%
  plot_ly(x = ~date, y = ~median) %>%
  add_lines(name = "All cities") %>%
  filter(city == "Houston") %>%
  add_lines(name = "Just Houston")

# ----------------------------------------------------------------
# from presentation to exploration
# ----------------------------------------------------------------

# define "city" as the "interaction unit"
library(crosstalk)
tx <- SharedData$new(txhousing, ~city, "Selected cities")

p <- ggplot(tx) +
  geom_line(aes(x = date, y = median, group = city))

p %>%
  ggplotly(tooltip = "city") %>%
  rangeslider() %>% 
  highlight(
    on = "plotly_hover", 
    off = "plotly_doubleclick", 
    dynamic = TRUE,
    selectize = TRUE,
    persistent = TRUE
  )




# -------------------------------------------------
# the power of linked views
# --------------------------------------------------

d <- SharedData$new(mpg)
dots <- plot_ly(d, color = ~class, x = ~displ, y = ~cyl)
boxs <- plot_ly(d, color = ~class, x = ~class, y = ~cty) %>% 
  add_boxplot()
bars <- plot_ly(d, color = ~class, x = ~class)

subplot(dots, boxs) %>%
  subplot(bars, nrows = 2) %>%
  layout(
    dragmode = "select",
    barmode = "overlay",
    showlegend = FALSE
  )


# generalized pair plot 
# nice for exploratory/descriptive purposes
library(GGally)
p <- ggpairs(flea[2:7])

# ggplotly() adds zoom/pan, identification, 
# and linked brushing
ggplotly(p, height = 600, width = 1000)
