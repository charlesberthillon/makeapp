app_server <- function(input, output, session) {
  googlesheets4::sheets_deauth()
  collection <- googlesheets4::read_sheet("1FPMlptmefZZ9wtmOdogWR4UVd-WEEWI7u0KztRPNJuA", sheet = "Collection") %>%
    janitor::clean_names() %>%
    dplyr::mutate_at(dplyr::vars(date_finished), as.Date)

  usage <- googlesheets4::read_sheet("1FPMlptmefZZ9wtmOdogWR4UVd-WEEWI7u0KztRPNJuA", sheet = "Usage") %>%
    janitor::clean_names()

  output$collection_current_value <- shinydashboard::renderValueBox({
    collection_current_value <- current_value(collection)

    shinydashboard::valueBox(glue::glue("{scales::dollar(collection_current_value[['value']])} ({collection_current_value[['n']]} items)"), "Current Collection", icon = shiny::icon("dollar-sign"), color = "purple")
  })

  output$current_value_by_category <- plotly::renderPlotly({
    current_value_by_category <- current_value_by_category(collection)

    plotly::plot_ly(current_value_by_category,
      x = ~main_category, y = ~value, type = "bar",
      hoverinfo = "text",
      text = ~ paste0("$", value, " (", n, " items)")
    ) %>%
      plotly::layout(xaxis = list(title = "Category"), yaxis = list(title = "Value", tickprefix = "$")) %>%
      plotly::config(displayModeBar = FALSE)
  })

  output$collection_value_over_time <- plotly::renderPlotly({
    collection_value_over_time <- value_over_time(collection)
    plotly::plot_ly(collection_value_over_time,
      x = ~date, y = ~value,
      type = "scatter",
      mode = "lines+markers",
      hoverinfo = "text",
      text = ~ paste0(date, ": $", value, " (", n, " items)")
    ) %>%
      plotly::layout(
        xaxis = list(title = "Date"),
        yaxis = list(title = "Collection Value", tickprefix = "$")
      ) %>%
      plotly::config(displayModeBar = FALSE)
  })

  callModule(mod_usage_table_server, "eyeshadow_top", usage = usage, collection = collection, category = "Eyeshadows", direction = "Top", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "eyeshadow_bottom", usage = usage, collection = collection, category = "Eyeshadows", direction = "Bottom", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "eyes", usage = usage, collection = collection, category = "Eye", direction = "All", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "face", usage = usage, collection = collection, category = "Face", direction = "All", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "lips", usage = usage, collection = collection, category = "Lip", direction = "All", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
}
