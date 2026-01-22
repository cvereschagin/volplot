
#'
#' Plot logarithmic returns of a stock series
#'
#' @param data A long dataframe containing dates and adjusted closing prices for stocks, first column is date and second column is the ticker and 3rd column is adjusted close price.
#'
#' @returns ggplot object that illustrates historical performance of a stocks returns.
#' @export
#'
#' @import ggplot2
#' @importFrom dplyr group_by mutate arrange ungroup coalesce
#' @importFrom stats lag
#'
#' @examples
#' fp_plot(stocks)
#'

fp_plot <- function(data) {
  x_col <- names(data)[1]
  group_col <- names(data)[2]
  val_col <- names(data)[3]

  data %>%
    dplyr::group_by(.data[[group_col]]) %>%
    dplyr::arrange(.data[[x_col]], .by_group = TRUE) %>%
    dplyr::mutate(
      log_returns = log(.data[[val_col]] / dplyr::lag(.data[[val_col]])),
      cum_ret = cumsum(dplyr::coalesce(.data$log_returns, 0))
    ) %>%
    dplyr::ungroup() %>%
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[[x_col]],
        y = .data$cum_ret,
        colour = .data[[group_col]]
      )
    ) +
    ggplot2::geom_line() +
    ggplot2::labs(x = "Date", y = "Cumulative log return")
}
