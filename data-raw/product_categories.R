product_categories <- tibble::tribble(
  ~category, ~main_category,
  "Blush", "Face",
  "Face primer", "Face",
  "Foundation", "Face",
  "Highlighter", "Face",
  "Powder", "Face",
  "Setting spray", "Face",
  "Eye primer", "Eye",
  "Eyebrow", "Eye",
  "Eyeliner", "Eye",
  "Mascara", "Eye",
  "Eye glitter", "Eye",
  "Cream eyeshadow", "Eye",
  "Eyeshadow", "Eyeshadows",
  "Lipgloss", "Lip",
  "Lipstick", "Lip"
)

usethis::use_data(product_categories, overwrite = TRUE)
