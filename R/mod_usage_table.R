#' @export
mod_usage_table_ui <- function(id, category, direction) {
  ns <- NS(id)
  tagList(
    shinydashboard::box(
      title = if (direction %in% c("Top", "Bottom")) {
        glue::glue("{direction} 10 {ifelse(direction == 'Top', 'Most', 'Least')} Used {category}{ifelse(category == 'Eyeshadows', '', ' Products')}")
      } else {
        glue::glue("{category} Products Usage")
      },
      width = 6,
      status = ifelse(direction == "Top", "success", "danger"),
      collapsible = TRUE,
      shiny::tableOutput(ns("usage"))
    )
  )
}

#' @export
mod_usage_table_server <- function(input, output, usage, collection, session, category, direction, start_date, end_date) {
  ns <- session$ns

  output$usage <- shiny::renderTable({
    product_usage_summary <- product_usage(usage, start_date(), end_date())

    product_usage_summary %>%
      rank_usage_by_category(collection, category, direction, start_date(), end_date()) %>%
      dplyr::select(Brand = brand, Item = item, Shade = shade, `Number of uses` = n)
  })
}

## To be copied in the UI
# mod_usage_table_ui("usage_table_ui_1")

## To be copied in the server
# callModule(mod_usage_table_server, "usage_table_ui_1")
