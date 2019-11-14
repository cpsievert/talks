library(shiny)
library(plotly)

ui <- fluidPage(
  plotlyOutput("scatter"),
  plotlyOutput("bars")
)

server <- function(input, output) {
  
  output$scatter <- renderPlotly({
    plot_ly(
      diamonds, alpha = 0.2, 
      x = ~carat, y = ~price, 
      customdata = seq(1, nrow(diamonds)), 
      selected = list(marker = list(color = "red"))
    ) %>% 
      toWebGL() %>% 
      layout(dragmode = "select") %>%
      event_register("plotly_selecting")
  })
  
  output$bars <- renderPlotly({
    
    base <- diamonds %>%
      plot_ly(
        x = ~depth, alpha = 0.3, showlegend = FALSE,
        histnorm = "probability density"
      ) %>%
      add_histogram()
    
    d <- event_data("plotly_selecting")
    if (is.null(d))  return(base)
    
    # add the selection layer
    add_histogram(
      base, color = I("red"),
      data = slice(diamonds, d$customdata)
    )
  })
  
}

shinyApp(ui, server)
