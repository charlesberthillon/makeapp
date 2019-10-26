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
      ~ eyeshadow_collection %>%
        dplyr::filter(date_panned <= .x) %>%
        nrow()
    ))

  collection_by_date <- dates %>%
    dplyr::mutate(eyeshadows = purrr::map_dbl(
      date,
      ~ eyeshadow_collection %>%
        dplyr::filter(date_added <= .x & (is.na(date_finished) | date_finished >= .x)) %>%
        nrow()
    ))

  pans_by_date %>%
    dplyr::left_join(collection_by_date, by = "date") %>%
    dplyr::mutate(pan_percent = pans / eyeshadows) %>%
    dplyr::arrange(date)
}
