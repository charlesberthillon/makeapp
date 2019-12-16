read_collection <- function() {
  googlesheets4::read_sheet("1FPMlptmefZZ9wtmOdogWR4UVd-WEEWI7u0KztRPNJuA", sheet = "Collection") %>%
    janitor::clean_names() %>%
    dplyr::mutate_at(dplyr::vars(dplyr::contains("date")), as.Date)
}

read_usage <- function() {
  googlesheets4::read_sheet("1FPMlptmefZZ9wtmOdogWR4UVd-WEEWI7u0KztRPNJuA", sheet = "Usage") %>%
    janitor::clean_names()
}
