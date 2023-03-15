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
page_fixed(!!!plots)

# They grow/shrink when _direct children_ of a fillable container with opinionated height
page_fillable( # fillable container
  !!!plots     # fill items
)

# TODO: make this point sticky and maybe give example of the requirement 

# ************************************************
# Cards ----
# ************************************************

page_fillable( # fillable 
  card(        # fill contents (and fillable)
    card_header("Diamonds"),
    card_body( # fill (NOT FILLABLE)
      !!!plots # fill contents
    )
  )
)

page_fillable(
  card(
    card_header("Diamonds"),
    card_body_fillable(
      !!!plots            
    )
  )
)

# Even if not filling the window, you might want
# card_body_fillable() when full_screen = TRUE
page_fixed(
  card(
    full_screen = TRUE,
    card_header("Diamond carat"),
    card_body(plots[[2]])
  ),
  card(
    full_screen = TRUE,
    card_header("Diamond price"),
    card_body_fillable(plots[[1]])
  )
)

# Helper function to wrap plots in full-screen cards
plot_card <- function(x, title) {
  card(
    card_header(
      title, class = "bg-dark"
    ),
    card_body_fillable(x),
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
    fillable = TRUE # Make main content container fillable
  ), 
  padding = 0
)


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
    fillable = TRUE
  ),
  plot_card(
    map_quakes, 
    "Not diamonds data!"
  )
)

# NOTE TO SELF: move plot_card() down

# ************************************************
# Tip: layout_sidebar() integrates nicely w/ card()
# ************************************************

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

# ************************************************
# Tip: can also put multiple tabs in a card.
# https://rstudio.github.io/bslib/articles/cards.html#multiple-tabs
# ************************************************



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
  accordion_panel("Section A", lorem::ipsum(3)),
  accordion_panel("Section B", lorem::ipsum(3)),
  accordion_panel("Section C", lorem::ipsum(3))
)

# ************************************************
# Histoslider ----
# ************************************************

library(histoslider)
library(dplyr)

ui <- page_fixed(
  layout_sidebar(
    sidebar(
      input_histoslider("carat", "Carat", diamonds$carat)
    ),
    plotlyOutput("price")
  )
)

server <- function(input, output) {
  output$price <- renderPlotly({
    diamonds |>
      filter(between(carat, input$carat[1], input$carat[2])) |>
      plot_ly(x = ~price) |>
        add_histogram()
  })
}

shinyApp(ui, server)
