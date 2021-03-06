#' country_comparison UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import shiny
#' @importFrom shinycssloaders withSpinner
mod_country_comparison_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      selectInput(label = "Countries", inputId = ns("select_countries"), choices = NULL, selected = NULL, multiple = TRUE),
      textOutput(ns("from_nth_case"))
    ),
    withSpinner(uiOutput(ns("barplots"))),
    withSpinner(uiOutput(ns("lineplots"))),
    fluidRow(
      column(5,
             withSpinner(uiOutput(ns("rateplots")))
      ),
      column(7,
             withSpinner(uiOutput(ns("lines_points_plots")))
             )
    ),
    mod_add_table_ui(ns("add_table_countries"))
  )
}

#' country_comparison Server Function
#'
#' @param orig_data_aggregate reactive data.frame
#' @param data_filtered reactive data.frame
#' @param countries reactive data.frame
#' @param n min number of cases for a country to be considered. Default 1000
#' @param w number of days of outbreak. Default 7
#'
#' @import dplyr
#'
#' @noRd
mod_country_comparison_server <- function(input, output, session, orig_data_aggregate, data_filtered, countries, n = 1000, w = 7){
  ns <- session$ns

  # Data ----

  observe(
    updateSelectInput(session, "select_countries", choices = sort(countries()$Country.Region), selected = c("Switzerland", "Italy"))
  )

  observeEvent(input$select_countries,{
    if (input$select_countries != "") {
      # Data ----
      countries_data <- reactive({data_filtered() %>%
          filter(Country.Region %in% input$select_countries) %>%
          filter(contagion_day > 0) %>%
          arrange(desc(date))
      })

      output$from_nth_case <- renderText({
        paste0("Only countries with more than ", n, " confirmed cases, and outbreaks longer than ", w, " days considered. Condagion day 0 is the first day with more than ", n ," cases.")
      })

      # Bar plots ----

      output$barplots <- renderUI({
        lapply(input$select_countries, function(country){
          tagList(
            h2(country),
            mod_bar_plot_day_contagion_ui(ns(paste0(country,"_bar_plot_day_contagion")))
          )
        })
      })

      lapply(input$select_countries, function(country){
        country_data <- reactive({countries_data() %>%
            filter(Country.Region %in% country)})
        callModule(mod_bar_plot_day_contagion_server, paste0(country,"_bar_plot_day_contagion"), country_data)
      })
    }

    # Line plots ----
    output$lineplots <- renderUI({
      tagList(
        h2("Countries Comparison"),
        mod_lineplots_day_contagion_ui(ns("lineplots_day_contagion"))
      )
    })

    callModule(mod_lineplots_day_contagion_server, "lineplots_day_contagion", countries_data)

    # Rate plots ----
    output$rateplots <- renderUI({
      mod_growth_death_rate_ui(ns("rate_plots"))
    })

    callModule(mod_growth_death_rate_server, "rate_plots", countries_data, n = n)


    # Line with bullet plot

    output$lines_points_plots <- renderUI({
      mod_compare_nth_cases_plot_ui(ns("lines_points_plots"))
    })

    callModule(mod_compare_nth_cases_plot_server, "lines_points_plots", countries_data, n = n)

    # tables ----
    callModule(mod_add_table_server, "add_table_countries", countries_data, maxrowsperpage = 10)
  })

}
