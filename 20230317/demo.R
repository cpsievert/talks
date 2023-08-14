library(bslib)
library(shiny)
library(crosstalk)
library(plotly)
library(leaflet)

# ************************************************
# Setup code ---- 
# (details here aren't important) 
# ************************************************

# Creates the "filter link" between the controls and plots
dat <- SharedData$new(dplyr::sample_n(diamonds, 1000))

# Sidebar elements (e.g., filter controls)
filters <- list(
  filter_select("cut", "Cut", dat, ~cut),
  filter_select("color", "Color", dat, ~color),
  filter_select("clarity", "Clarity", dat, ~clarity)
)

# plotly visuals
plots <- list(
  plot_ly(dat) |> add_histogram(x = ~price),
  plot_ly(dat) |> add_histogram(x = ~carat),
  plot_ly(dat) |> add_histogram(x = ~cut, color = ~clarity)
)
plots <- lapply(plots, \(x) config(x, displayModeBar = FALSE))

# map filter and visual
quake_dat <- SharedData$new(quakes)
map_filter <- filter_slider("mag", "Magnitude", quake_dat, ~mag)
map_quakes <- leaflet(quake_dat) |> 
  addTiles() |> 
  addCircleMarkers()


# ************************************************
# Fillable containers ----
# ************************************************

# HTMLWidgets, plotOutput(), etc default to 400px height
page_fixed(
  plots[[1]]
)

page_fillable( # fillable container
  plots[[1]]   # fill item
)

page_fillable( # fillable container
  plots[[1]],  # fill item
  plots[[2]],  # fill item
  plots[[3]]   # fill item
)

# Same as above
page_fillable(!!!plots)

# NOTE TO SELF: bring up sticky point


# ************************************************
# Cards ----
# ************************************************

page_fixed(
  card(
    card_header("Diamonds"),
    card_body(plots[[1]])
  )
)

page_fillable(
  card(
    card_header("Diamonds"),
    card_body(plots[[1]])
  )
)

page_fillable(
  card(
    card_header("Diamonds"),
    plots[[1]]
  )
)

page_fillable(
  card(
    card_header("Diamonds"),
    card_body(
      !!!plots,
      min_height = 400
    )
  )
)

# Even if not filling the window, you might want
# card_body_fillable() when full_screen = TRUE
page_fixed(
  card(
    full_screen = TRUE,
    card_header("Diamond price"),
    plots[[1]]
  ),
  card(
    full_screen = TRUE,
    card_header("Diamond price"),
    plots[[1]]
  )
)

# Helper function to wrap plots in full-screen cards
plot_card <- function(x, title) {
  card(
    card_header(
      title, class = "bg-dark"
    ),
    x,
    full_screen = TRUE
  )
}

plot_price <- plot_card(
  plots[[1]], "Diamond price"
)
plot_carat <- plot_card(
  plots[[2]], "Diamond carat"
)
plot_counts <- plot_card(
  plots[[3]], "Diamond counts"
)

# ************************************************
# Previewing components ----
# ************************************************

# No page container necessary (one is added for you)
plot_counts


# ************************************************
# Multi-column layout ----
# ************************************************

page_fillable(        # fillable    
  layout_column_wrap( # fill and fillable
    width = 1/2, 
    plot_price, 
    plot_carat
  ),
  plot_counts         # fill
)


# ************************************************
# Sidebar layouts ----
# ************************************************

histograms <- layout_column_wrap(
  width = 1/2, class = "mb-3",
  plot_price, 
  plot_carat
)


page_fillable(    # fillable
  layout_sidebar( # fill
    sidebar(bg = "#F1F3F5", !!!filters),
    histograms,
    plot_counts,
    fillable = TRUE
  ), 
  padding = 0
)

# Tip: set layout_sidebar(fillable = TRUE)
# for filling main content ☝️


# ************************************************
# Localizing sidebars ----
# A "global" sidebar may be bad UX!
# Keep controls near the things they affect!
# ************************************************

page_fillable(
  layout_sidebar(
    sidebar(bg = "#F1F3F5", !!!filters),
    histograms,
    plot_counts,
    plot_card(
      map_quakes, 
      "Not diamonds data!"
    ),
    fillable = TRUE
  ),
  padding = 0
)


# Helps a bit, but not an ideal layout
page_fillable(
  layout_sidebar(
    sidebar(bg = "#F1F3F5", !!!filters),
    histograms,
    plot_counts,
    fillable = TRUE
  ),
  plot_card(
    map_quakes, 
    "Not diamonds data!"
  )
)


# Tip: layout_sidebar() integrates nicely w/ card()
card_quakes <- card(
  full_screen = TRUE,
  card_header("Earthquake locations"),
  layout_sidebar(
    sidebar(map_filter, open = FALSE),
    map_quakes,
    fillable = TRUE
  )
)

card_quakes


# ************************************************
# Altogether now!
# ************************************************

page_diamonds <- layout_sidebar(
  sidebar(bg = "#F1F3F5", !!!filters),
  histograms,
  plot_counts,
  fillable = TRUE
)

page_navbar(
  title = "Sidebar demo",
  fillable = "Diamonds",
  nav("Diamonds", page_diamonds),
  nav("Earthquakes", card_quakes)
)

# Can also "share" the same sidebar across pages
page_navbar(
  title = "Shared sidebar",
  sidebar = sidebar(bg = "#F1F3F5", !!!filters),
  nav("Price", plots[[1]]),
  nav("Carat", plots[[2]]),
  nav("Counts", plots[[3]])
)

# Change page_navbar() to navs_tab_card()
# to get a card instead
navs_tab_card(
  title = "Sidebar demo",
  sidebar = sidebar(bg = "#F1F3F5", !!!filters),
  nav("Price", plots[[1]]),
  nav("Carat", plots[[2]]),
  nav("Counts", plots[[3]])
)


# ************************************************
# Value boxes ----
# ************************************************

boxes <- layout_column_wrap(
  width = 1/3, fill = FALSE,
  value_box(
    "Total diamonds",
    scales::comma(nrow(diamonds)),
    showcase = bsicons::bs_icon("gem")
  ),
  value_box(
    "Average price", 
    scales::dollar(mean(diamonds$price)),
    showcase = bsicons::bs_icon("coin"),
    theme_color = "success"
  ),
  value_box(
    "Average carat",
    scales::number(mean(diamonds$carat), accuracy = .1),
    showcase = bsicons::bs_icon("search"),
    theme_color = "dark"
  )
)

page_fillable(
  boxes,
  histograms, 
  plot_counts
)


# ************************************************
# Tip: can also do value_box(full_screen = TRUE).
# With clever usage, can implement 'expandable sparklines'
# https://rstudio.github.io/bslib/articles/value-boxes.html#expandable-sparklines
# ************************************************


# ************************************************
# Accordions ----
# ************************************************

# Group similar input controls
accordion_filters <- accordion(
  accordion_panel(
    "Dropdowns", icon = bsicons::bs_icon("menu-app"),
    !!!filters
  ),
  accordion_panel(
    "Numerical", icon = bsicons::bs_icon("sliders"),
    filter_slider("depth", "Depth", dat, ~depth),
    filter_slider("table", "Table", dat, ~table)
  )
)

layout_sidebar(
  sidebar(accordion_filters),
  plots[[1]]
)

# Accordions can also render standalone
accordion(
  accordion_panel("Section A", lorem::ipsum(2)),
  accordion_panel("Section B", lorem::ipsum(3)),
  accordion_panel("Section C", lorem::ipsum(3))
)

# ************************************************
# Histoslider ----
# ************************************************

shiny::runApp("demo-histoslider.R")
