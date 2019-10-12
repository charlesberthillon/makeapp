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
    dplyr::left_join(product_categories, by = "category") %>%
    dplyr::group_by(main_category) %>%
    dplyr::summarise(
      n = n(),
      value = sum(value)
    )
}

#' @export
value_over_time <- function(collection) {
  added <- collection %>%
    dplyr::select(date = date_added, value) %>%
    dplyr::mutate(n = 1)

  finished <- collection %>%
    dplyr::select(date = date_finished, value) %>%
    dplyr::mutate(value = -value) %>%
    dplyr::mutate(n = -1)

  added_and_finished <- added %>%
    dplyr::bind_rows(finished) %>%
    dplyr::filter(!is.na(date))

  dates <- added_and_finished %>%
    dplyr::distinct(date) %>%
    dplyr::mutate_at(dplyr::vars(date), as.Date)

  dates %>%
    dplyr::mutate(data = purrr::map(
      date,
      ~ added_and_finished %>%
        dplyr::filter(date <= .x) %>%
        dplyr::summarise(value = sum(value),
                         n = sum(n)) %>%
        dplyr::select(value, n)
    ),
    value = purrr::map_dbl(data, "value"),
    n = purrr::map_dbl(data, "n")) %>%
    dplyr::select(-data)
}
