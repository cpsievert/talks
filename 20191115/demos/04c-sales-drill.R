library(shiny)
library(plotly)
library(dplyr)

sales <- readr::read_csv("data/sales.csv")

ui <- fluidPage(
  plotlyOutput("category"),
  plotlyOutput("sub_category"),
  plotlyOutput("order_date")
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
      plot_ly(x = ~sub_category, y = ~n, source = "sub_category") %>%
      layout(xaxis = list(title = d$x))
  })
  
  output$order_date <- renderPlotly({
    d <- event_data("plotly_click", source = "sub_category")
    if (is.null(d)) return(NULL)
    
    sales %>%
      filter(sub_category %in% d$x) %>%
      count(order_date, wt = sales) %>%
      plot_ly(x = ~order_date, y = ~n) %>%
      add_lines() %>%
      layout(xaxis = list(title = d$x))
  })
  
}

shinyApp(ui, server)