library(shiny)
library(plotly)
library(dplyr)

sales <- readr::read_csv("data/sales.csv")

ui <- fluidPage(
  plotlyOutput("category"),
  plotlyOutput("sub_category")
)

server <- function(input, output) {
  
  output$category <- renderPlotly({
    sales %>%
      count(category, wt = sales) %>%
      plot_ly(x = ~category, y = ~n, source = "category")
  })
  
  output$sub_category <- renderPlotly({
    d <- event_data("plotly_click", source = "category")
    if (is.null(d)) return(NULL)
    
    sales %>%
      filter(category %in% d$x) %>%
      count(sub_category, wt = sales) %>%
      plot_ly(x = ~sub_category, y = ~n) %>%
      layout(xaxis = list(title = d$x))
  })
  
}

shinyApp(ui, server)