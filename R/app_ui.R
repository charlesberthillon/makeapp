app_ui <- function() {
  tagList(
    # List the first level UI elements here
    shinydashboard::dashboardPage(
      skin = "purple",
      shinydashboard::dashboardHeader(),
      shinydashboard::dashboardSidebar(disable = TRUE),
      shinydashboard::dashboardBody(
        shiny::fluidRow(
          shiny::tags$head(shiny::tags$style(shiny::HTML(".small-box {height: 200px}"))),
          shinydashboard::valueBoxOutput("collection_current_value", width = 4),

          shinydashboard::box(
            plotly::plotlyOutput("current_value_by_category", height = "175px"),
            width = 8,
            height = "200px"
          )
        ),
        shiny::fluidRow(
          shinydashboard::box(
            plotly::plotlyOutput("collection_value_over_time", height = "175px"),
            width = 6,
            height = "200px"
          )
        ),
        shiny::fluidRow(
          shinydashboard::box(
            width = 12,
            shiny::splitLayout(
              shiny::dateInput("start_date", "Usage Start", value = lubridate::today() %m-% months(1)),
              shiny::dateInput("end_date", "Usage End")
            )
          )
        ),
        shiny::fluidRow(
          mod_usage_table_ui("eyeshadow_top", "Eyeshadows", "Top"),
          mod_usage_table_ui("eyeshadow_bottom", "Eyeshadows", "Bottom")
        ),
        shiny::fluidRow(
          mod_usage_table_ui("eyes", "Eye", "All"),
          mod_usage_table_ui("face", "Face", "All")
        ),
        shiny::fluidRow(
          mod_usage_table_ui("lips", "Lip", "All")
        )
      )
    )
  )
}
