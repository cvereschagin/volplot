
#'
#' Perform Linear Regression with Rolling Window Size
#'
#' @param data A Wide data frame with n columns containing log returns, first column is date, second is the independent variable returns, and the rest are dependent variables' returns.
#' @param window The window size in days for which to run a regression on. 30 means it will run a regression on days 1-30 then 2-31 and so on
#'
#' @returns A table with summary statistics for each regression pair
#' @export
#'
#' @import stats tibble
#'
#' @examples
#'
#' \dontrun{roll_regress(stocks_2, window = 60)}



roll_regress <- function(data, window) {
  n <- nrow(data)

  dep_names <- names(data)[-c(1,2)]  # all stocks
  ind_name <- names(data)[2]         # SPY
  alpha <- matrix(NA_real_, n, length(dep_names))
  beta  <- matrix(NA_real_, n, length(dep_names))
  colnames(alpha) <- paste0(dep_names, "_alpha")
  colnames(beta)  <- paste0(dep_names, "_beta")

  for (i in window:n) {
    df <- data[(i - window + 1):i, ]

    for (j in seq_along(dep_names)) {
      fit <- lm(df[[dep_names[j]]] ~ df[[ind_name]])
      alpha[i, j] <- coef(fit)[1]
      beta[i, j]  <- coef(fit)[2]
    }
  }

  tibble::tibble(date = data[[1]]) %>%
    dplyr::bind_cols(
      as.data.frame(alpha),
      as.data.frame(beta)
    ) %>%
    tidyr::drop_na()
}
