library(shiny)
library(ggplot2)

thematic::thematic_shiny()

shinyApp(
  ui = fluidPage(
    theme = shinythemes::shinytheme("superhero"),
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
    }, res = 96)
    output$lattice <- renderPlot(lattice::show.settings(), res = 96)
    output$base <- renderPlot({
      image(volcano, col = thematic::thematic_get_option("sequential", hcl.colors(12, "YlOrRd", rev = TRUE)))
    }, res = 96)
  }
)
