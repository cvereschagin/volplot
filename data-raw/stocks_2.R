## code to prepare `stocks_2` dataset goes here

stocks_2 <-
  tidyquant::tq_get(
    c("SPY", "AAPL"),
    from = "2020-01-01",
    to = "2025-01-01",
    get = "stock.prices"
  ) %>%
  dplyr::select(date, series = symbol, value = adjusted) %>%
  dplyr::group_by(series)

usethis::use_data(stocks_2, overwrite = TRUE)
