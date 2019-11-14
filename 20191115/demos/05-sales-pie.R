library(shiny)

ui <- fluidPage(
  plotlyOutput("plot"),
  uiOutput("btn")
)

server <- function(input, output, session) {
  
  # For managing the selected category
  category <- reactiveVal(NULL)
  
  # If no selected category, show sales by category
  # If selected category, show sales by sub_category
  output$plot <- renderPlotly({
    if (is.null(category())) {
      sales %>%
        count(category, wt = sales) %>%
        plot_ly(x = ~category, y = ~n, source = "category")
    } else {
      sales %>%
        filter(category %in% category()) %>%
        count(sub_category, wt = sales) %>%
        plot_ly(x = ~sub_category, y = ~n)
    }
  })
  
  # Update the value of category() 
  observe({
    d <- event_data("plotly_click", source = "category")
    category(d$x)
  })
  
  # If we've clicked a category, render a 'back' button
  output$btn <- renderUI({
    if (is.null(category())) return(NULL)
    actionButton("btn", "Back", icon("chevron-left"))
  })
  
  # Clicking the back button clears the category
  observeEvent(input$btn, {
    category(NULL)
  })
  
}

shinyApp(ui, server)