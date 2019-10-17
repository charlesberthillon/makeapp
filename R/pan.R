eyeshadow_pan_percentage_over_time <- function(collection, usage) {
  eyeshadow_collection <- collection %>%
    dplyr::filter(category == "Eyeshadow")

  pan_date <- eyeshadow_collection %>%
    dplyr::filter(pan) %>%
    dplyr::distinct(date = date_panned)

  pans_by_date <- pan_date %>%
    dplyr::mutate(pans = purrr::map_dbl(
      date,
      ~ eyeshadow_collection %>%
        dplyr::filter(date_panned <= .x) %>%
        nrow()
    ))

  collection_by_date <- pan_date %>%
    dplyr::mutate(eyeshadows = purrr::map_dbl(
      date,
      ~ eyeshadow_collection %>%
        dplyr::filter(date_added <= .x & (is.na(date_finished) | date_finished >= .x)) %>%
        nrow()
    ))

  pans_by_date %>%
    dplyr::left_join(collection_by_date, by = "date") %>%
    dplyr::mutate(pan_percent = pans / eyeshadows)
}
