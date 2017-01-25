#' ---
#' title: "Quick overview of the R package plotly"
#' author: "Carson Sievert"
#' ---

#+ setup, include=FALSE
knitr::opts_chunk$set(message = FALSE)

#' The package bundles data named `txhousing` which contains monthly
#' housing sales in various Texan cities.

library(plotly)
txhousing

#' The `ggplotly()` function converts a ggplot object to a plotly object.
#' If you already use ggplot2, this makes it easy to leverage 
#' simple interactive techniques (tooltips, pan, and zoom) .

p <- ggplot(txhousing) +
  geom_line(aes(x = date, y = median, group = city))

ggplotly(p)

#' As a side-note, using `%>%` (aka, the pipe operator) allows humans to read 
#' your code from left-to-right rather than inside-out. It does this
#' by inserting the object on left-hand side into a function on the right-hand side.

#+ eval = FALSE
# this code is equivalent to ggplotly(p)
p %>% ggplotly()


#' The R package also has a non-ggplot2 interface which embraces the pipe 
#' and works well with dplyr's data manipulation verbs (a la ggvis). 
#' To read more about this interface, see 
#' [this section](https://cpsievert.github.io/plotly_book/a-case-study-of-housing-sales-in-texas.html) 
#' of the plotly for R book.

txhousing %>%
  group_by(city) %>%
  plot_ly(x = ~date, y = ~median) %>%
  add_lines(name = "All cities") %>%
  filter(city == "Houston") %>%
  add_lines(name = "Just Houston")

#' Highlighting (or annotating) something interesting is generally a good idea 
#' when *presenting* graphics to someone else. However, we often don't know 
#' what is actually interesting at runtime. In this case, it is nice to have 
#' tools for interactively highlighting interesting "units". The `SharedData` 
#' class from the **crosstalk** package provides a mechanism for you to declare 
#' an "interaction unit". In this case, we specify city as the interaction unit,
#' then use the `highlight()` function from **plotly** for extra control 
#' over the *type* of interaction which triggers a selection.

library(crosstalk)
tx <- SharedData$new(txhousing, ~city, "Selected cities")

p <- ggplot(tx) +
  geom_line(aes(x = date, y = median, group = city))

p %>%
  ggplotly(tooltip = "city") %>%
  highlight(
    on = "plotly_hover", 
    off = "plotly_doubleclick", 
    dynamic = TRUE,
    persistent = TRUE,
    selectize = TRUE
  )

#' <p></p><span style="color:red"> 
#' **Your Turn**: Use the `color` argument to supply your own dynamic color 
#' palette. Highlight 'South Padre Island' one color and 'San Marcos' another. 
#' What do you see? Is there a better way we could 'guide' selections if we are
#' interested in understanding missing values? See [here](missing.html) 
#' for my solution.
#' </span><p></p>


#' Highlighting can help combat overplotting, but becomes much more powerful 
#' when applied to multiple linked views. There are a number of ways to arrange
#' and link multiple views -- one of them being via **ggplot2**'s facetting 
#' (i.e., trellis display) functionality. A trellis display is a special
#' class of "small multiples" where each panel displays a different subset of 
#' the data. Below is a trellis display of median house price versus 
#' of month of year across different cities. Since there are multiple years
#' for each city, we can set the "interaction unit" to year and explore how 
#' house prices fluctuate across cities for a given year.

tx <- SharedData$new(txhousing, ~year, "Selected years")

p <- ggplot(tx) +
  geom_line(aes(x = month, y = median, group = year)) + 
  facet_wrap(~city)

p %>%
  ggplotly(tooltip = "year", width = 1200, height = 600) %>%
  highlight(
    on = "plotly_click", 
    off = "plotly_doubleclick", 
    selectize = TRUE
  )

#' <p></p><span style="color:red"> 
#' **Your Turn**: `ggplotly()` can also 
#' convert ggmatrix objects from the **GGally** package (ggmatrix objects are
#' the foundation of the `ggpairs()` and `ggduo()` functions). 
#' First, make a scatterplot matrix of median, volume, listings,
#' and inventory via `ggpairs()`. Second, make it interactive with `ggplotly()`
#' and highlight points with high inventory. What do you see? 
#' </span><p></p>


#' Sometimes it's useful to "animate selections" -- especially if the unit of
#' interest has a natural ordering. Both `ggplotly()` and `plot_ly()` respect
#' a `frame` aesthetic, which is similar to facetting, but panels
#' are overlayed in an animation, rather than into small multiples.

txhousing %>%
  filter(city == "Houston") %>%
  group_by(year) %>%
  plot_ly(x = ~month, y = ~median, color = I("black")) %>%
  add_lines(alpha = 0.2) %>%
  add_lines(frame = ~year, ids = ~month) %>%
  hide_legend()


#' <p></p><span style="color:red"> 
#'  **Your turn**: 
#'  1. Use the animation_opts() function to alter the speed and easing of the 
#'  animation above.
#'  2. Modify our first faceted plot to animate through the years
#' </span><p></p>
