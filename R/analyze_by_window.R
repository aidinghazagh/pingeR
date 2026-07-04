#' Analyze ping results by time window
#'
#' Groups ping data into time windows and computes per-window statistics.
#'
#' @param ping_data A data.frame with columns: Timestamp, PingTime, Status.
#' @param window_mins Integer, size of each time window in minutes. Default is 60.
#' @return A data.frame with columns: Window_Start, Ping_Count, Mean_Ping,
#'   Median_Ping, P95_Ping, Packet_Loss_Percent.
#' @export
#' @examples
#' \dontrun{
#' ping_data <- read.csv("ping_log.csv")
#' windowed <- analyze_by_window(ping_data, window_mins = 30)
#' print(windowed)
#' }
analyze_by_window <- function(ping_data, window_mins = 60) {
  ping_data$Timestamp <- as.POSIXct(ping_data$Timestamp, format = "%Y-%m-%d %H:%M:%OS")
  ping_data$PingTime[ping_data$Status != "Successful"] <- NA

  window_secs <- window_mins * 60
  min_time <- min(ping_data$Timestamp, na.rm = TRUE)
  ping_data$Window <- as.POSIXct(
    as.numeric(min_time) + floor((as.numeric(ping_data$Timestamp) - as.numeric(min_time)) / window_secs) * window_secs,
    origin = "1970-01-01"
  )

  windows <- split(ping_data, ping_data$Window)

  result <- do.call(rbind, lapply(names(windows), function(w) {
    chunk <- windows[[w]]
    valid <- chunk$PingTime[!is.na(chunk$PingTime)]
    n_total <- nrow(chunk)
    n_fail <- sum(is.na(chunk$PingTime))

    data.frame(
      Window_Start = as.POSIXct(w, origin = "1970-01-01"),
      Ping_Count = n_total,
      Mean_Ping = if (length(valid) > 0) mean(valid) else NA,
      Median_Ping = if (length(valid) > 0) stats::median(valid) else NA,
      P95_Ping = if (length(valid) >= 2) stats::quantile(valid, 0.95, names = FALSE) else NA,
      Packet_Loss_Percent = (n_fail / n_total) * 100,
      stringsAsFactors = FALSE
    )
  }))

  rownames(result) <- NULL
  result
}
