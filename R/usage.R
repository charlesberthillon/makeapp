#' @export
product_usage <- function(usage, start_date, end_date) {
  usage %>%
    dplyr::filter(date >= lubridate::ymd(start_date) & date <= lubridate::ymd(end_date)) %>%
    dplyr::count(category, brand, item, shade)
}

#' @export
rank_usage_by_category <- function(product_usage, collection, category = c("Face", "Eye", "Lip", "Eyeshadows"), direction = c("Top", "Bottom", "All"), start_date, end_date) {
  category_product_usage <- product_usage %>%
    dplyr::left_join(product_categories, by = "category") %>%
    dplyr::filter(main_category %in% !!category) %>%
    dplyr::select(brand, item, shade, n)

  if (direction == "Top") {
    category_product_usage %>%
      dplyr::arrange(-n) %>%
      dplyr::filter(dplyr::row_number() %in% 1:10)
  } else if (direction == "Bottom") {
    category_collection <- collection %>%
      dplyr::left_join(product_categories, by = "category") %>%
      dplyr::filter(
        main_category %in% !!category,
        date_added >= lubridate::ymd(start_date),
        (is.na(date_finished) | date_finished >= lubridate::ymd(start_date))
      )

    category_collection_usage <- category_collection %>%
      dplyr::left_join(category_product_usage, by = c("brand", "item", "shade")) %>%
      dplyr::mutate(n = dplyr::coalesce(n, 0L))

    category_collection_usage %>%
      dplyr::arrange(n) %>%
      dplyr::filter(dplyr::row_number() %in% 1:10)
  } else if (direction == "All") {
    category_collection <- collection %>%
      dplyr::left_join(product_categories, by = "category") %>%
      dplyr::filter(
        main_category %in% !!category,
        date_added >= lubridate::ymd(start_date),
        (is.na(date_finished) | date_finished >= lubridate::ymd(start_date))
      )

    category_collection_usage <- category_collection %>%
      dplyr::left_join(category_product_usage, by = c("brand", "item", "shade")) %>%
      dplyr::mutate(n = dplyr::coalesce(n, 0L))

    category_collection_usage %>%
      dplyr::arrange(-n)
  }
}
