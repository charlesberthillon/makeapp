app_server <- function(input, output, session) {
  collection <- googlesheets4::read_sheet(Sys.getenv("MAKEAPP_SHEET"), sheet = "Collection") %>%
    janitor::clean_names() %>%
    dplyr::mutate_at(dplyr::vars(date_finished), as.Date)

  usage <- googlesheets4::read_sheet(Sys.getenv("MAKEAPP_SHEET"), sheet = "Usage") %>%
    janitor::clean_names()

  collection_current_value <- current_value(collection)

  output$collection_current_value <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(glue::glue("{scales::dollar(collection_current_value[['value']])} ({collection_current_value[['n']]} items)"), "Current Collection", icon = shiny::icon("dollar-sign"), color = "purple")
  })

  collection_value_over_time <- value_over_time(collection)

  output$collection_value_over_time <- plotly::renderPlotly(
    plotly::ggplotly(
      ggplot2::ggplot(collection_value_over_time,
                      ggplot2::aes(x = date,
                                   y = value)) +
        ggplot2::geom_line() +
        ggplot2::scale_y_continuous("Collection Value", labels = scales::dollar) +
        ggplot2::scale_x_date("Date") +
        ggplot2::theme_minimal()
    )
  )

  callModule(mod_usage_table_server, "eyeshadow_top", usage = usage, collection = collection, category = "Eyeshadows", direction = "Top", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "eyeshadow_bottom", usage = usage, collection = collection, category = "Eyeshadows", direction = "Bottom", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "eyes_top", usage = usage, collection = collection, category = "Eye", direction = "Top", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "eyes_bottom", usage = usage, collection = collection, category = "Eye", direction = "Bottom", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "face_top", usage = usage, collection = collection, category = "Face", direction = "Top", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "face_bottom", usage = usage, collection = collection, category = "Face", direction = "Bottom", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "lip_top", usage = usage, collection = collection, category = "Lip", direction = "Top", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
  callModule(mod_usage_table_server, "lip_bottom", usage = usage, collection = collection, category = "Lip", direction = "Bottom", start_date = shiny::reactive(input$start_date), end_date = shiny::reactive(input$end_date))
}
