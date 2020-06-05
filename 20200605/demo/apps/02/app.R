library(shiny)
library(ggplot2)
library(thematic)

thematic_shiny(font = "auto")

shinyApp(
  ui = fluidPage(
    tags$link(href="https://fonts.googleapis.com/css?family=Pacifico", rel="stylesheet"),
    tags$style(HTML("body{font-family: Pacifico}")),
    theme = shinythemes::shinytheme("darkly"),
    tabsetPanel(type = "pills",
                tabPanel("ggplot", plotOutput("ggplot")),
                tabPanel("lattice", plotOutput("lattice")),
                tabPanel("base", plotOutput("base"))
    )
  ),
  server = function(input, output) {
    output$ggplot <- renderPlot({
      ggplot(diamonds[sample(nrow(diamonds), 1000), ], aes(carat, price)) +
        geom_point(alpha = 0.2) +
        geom_smooth() +
        facet_wrap(~cut) + ggtitle("Diamond price by carat and cut")
    })
    output$lattice <- renderPlot(lattice::show.settings())
    output$base <- renderPlot({
      image(volcano, col = thematic::thematic_get_option("sequential", hcl.colors(12, "YlOrRd", rev = TRUE)))
    })
  }
)
