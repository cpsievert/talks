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
