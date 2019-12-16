eyeshadow_pan_percentage_over_time <- function(collection, usage) {
  eyeshadow_collection <- collection %>%
    dplyr::filter(category == "Eyeshadow")

  dates <- eyeshadow_collection %>%
    dplyr::select(date_added, date_finished, date_panned) %>%
    tidyr::pivot_longer(
      cols = c(date_added, date_finished, date_panned),
      names_to = "type",
      values_to = "date",
      names_prefix = "date_"
    ) %>%
    dplyr::filter(!is.na(date)) %>%
    dplyr::distinct(date)

  pans_by_date <- dates %>%
    dplyr::mutate(pans = purrr::map_dbl(
      date,
      ~ pans_by_date(eyeshadow_collection, .x)
    ))

  collection_by_date <- dates %>%
    dplyr::mutate(eyeshadows = purrr::map_dbl(
      date,
      ~ collection_by_date(eyeshadow_collection, .x)
    ))

  pans_by_date %>%
    dplyr::left_join(collection_by_date, by = "date") %>%
    dplyr::mutate(pan_percent = pans / eyeshadows) %>%
    dplyr::arrange(date)
}

pans_by_date <- function(collection, date) {
  collection %>%
    dplyr::filter(date_panned <= date & (!(date_finished <= date) | is.na(date_finished))) %>%
    nrow()
}

collection_by_date <- function(collection, date) {
  collection %>%
    dplyr::filter(date_added <= date & (!(date_finished <= date) | is.na(date_finished))) %>%
    nrow()
}
