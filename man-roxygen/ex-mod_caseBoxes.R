if (interactive()) {
  library(shiny)
  long_title <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
  ui <- fluidPage(
    tagList(
      Covid19:::golem_add_external_resources(),
      Covid19:::mod_caseBoxes_ui("boxes")
    )
  )
  server <- function(input, output, session) {
    counts <- reactive({
      invalidateLater(2000)
      stats::setNames(sample.int(1000, 4), c("deaths", "active", "recovered", "confirmed"))
    })
    callModule(Covid19:::mod_caseBoxes_server, "boxes", counts = counts)
  }
  runApp(shinyApp(ui = ui, server = server), launch.browser = TRUE)
}

