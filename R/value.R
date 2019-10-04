#' @export
current_value <- function(collection) {
  collection %>%
    dplyr::filter(is.na(date_finished)) %>%
    dplyr::summarise(
      n = n(),
      value = sum(value)
    )
}

#' @export
current_value_by_category <- function(collection) {
  collection %>%
    dplyr::filter(is.na(date_finished)) %>%
    dplyr::group_by(category) %>%
    dplyr::summarise(
      n = sum(n),
      value = sum(value)
    )
}

#' @export
value_over_time <- function(collection) {
  added <- collection %>%
    dplyr::select(date = date_added, value)

  finished <- collection %>%
    dplyr::select(date = date_finished, value) %>%
    dplyr::mutate(value = -value)

  added_and_finished <- added %>%
    dplyr::bind_rows(finished) %>%
    dplyr::filter(!is.na(date))

  dates <- added_and_finished %>%
    dplyr::distinct(date) %>%
    dplyr::mutate_at(dplyr::vars(date), as.Date)

  dates %>%
    dplyr::mutate(value = purrr::map_dbl(
      date,
      ~ added_and_finished %>%
        dplyr::filter(date <= .x) %>%
        dplyr::summarise(value = sum(value)) %>%
        dplyr::pull(value)
    ))
}
