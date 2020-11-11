library(shiny)

shinyApp(
  fluidPage(
    tags$style(HTML("#info {background-color: teal; color: orange; }")),
    "Computed CSS styles for the output named info:",
    tagAppendAttributes(
      textOutput("info"),
      class = "shiny-report-theme"
    )
  ),
  function(input, output) {
    output$info <- renderText({
      info <- getCurrentOutputInfo()
      jsonlite::toJSON(
        list(
          bg = info$bg(),
          fg = info$fg(),
          accent = info$accent(),
          font = info$font()
        ),
        auto_unbox = TRUE
      )
    })
  }
)
