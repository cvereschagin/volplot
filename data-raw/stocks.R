## code to prepare `stocks` dataset goes here

stocks <-
  tidyquant::tq_get(
    c("SPY", "AAPL"),
    from = "2020-01-01",
    to = "2025-01-01",
    get = "stock.prices"
  ) %>%
  dplyr::select(date, series = symbol, value = adjusted) %>%
  dplyr::group_by(series)

usethis::use_data(stocks, overwrite = TRUE)


