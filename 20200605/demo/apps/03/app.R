library(shiny)

shinyApp(
  fluidPage(
    tags$style(HTML("body {background-color: black; color: white; }")),
    tags$style(HTML("body a {color: purple}")),
    plotOutput("p")
  ),
  function(input, output) {
    output$p <- renderPlot({
      info <- getCurrentOutputInfo()
      par(bg = info$bg(), fg = info$fg(), col.axis = info$fg(), col.main = info$fg())
      plot(1:10, col = info$accent(), pch = 19)
      title("A simple R plot that uses its CSS styling")
    })
  }
)
