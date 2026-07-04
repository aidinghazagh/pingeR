#' Analyze ping results
#'
#' Computes summary statistics from a ping log data.frame.
#'
#' @param ping_data A data.frame with columns: Timestamp, PingTime, Status (as produced by \code{ping_ip} or read from a CSV log).
#' @return A named list with: Total_Pings, Successful_Pings, Unsuccessful_Pings,
#'   Packet_Loss_Percent, Average_Ping_Time, Median_Ping_Time, P95_Ping_Time,
#'   P99_Ping_Time, Max_Ping_Time, Min_Ping_Time.
#' @export
#' @examples
#' \dontrun{
#' ping_data <- read.csv("ping_log.csv")
#' summary <- analyze_ping_results(ping_data)
#' print(summary)
#' }
analyze_ping_results <- function(ping_data) {
  ping_data$Timestamp <- as.POSIXct(ping_data$Timestamp, format = "%Y-%m-%d %H:%M:%OS")

  ping_data$PingTime[ping_data$Status != "Successful"] <- NA

  total_pings <- nrow(ping_data)
  successful_pings <- sum(ping_data$Status == "Successful", na.rm = TRUE)
  unsuccessful_pings <- sum(is.na(ping_data$PingTime))
  packet_loss_percent <- (unsuccessful_pings / total_pings) * 100

  avg_ping_time <- mean(ping_data$PingTime, na.rm = TRUE)
  max_ping_time <- max(ping_data$PingTime, na.rm = TRUE)
  min_ping_time <- min(ping_data$PingTime, na.rm = TRUE)
  median_ping_time <- stats::median(ping_data$PingTime, na.rm = TRUE)

  valid_times <- ping_data$PingTime[!is.na(ping_data$PingTime)]
  p95_ping <- if (length(valid_times) >= 2) stats::quantile(valid_times, 0.95, names = FALSE) else NA
  p99_ping <- if (length(valid_times) >= 2) stats::quantile(valid_times, 0.99, names = FALSE) else NA

  list(
    Total_Pings = total_pings,
    Successful_Pings = successful_pings,
    Unsuccessful_Pings = unsuccessful_pings,
    Packet_Loss_Percent = packet_loss_percent,
    Average_Ping_Time = avg_ping_time,
    Median_Ping_Time = median_ping_time,
    P95_Ping_Time = p95_ping,
    P99_Ping_Time = p99_ping,
    Max_Ping_Time = max_ping_time,
    Min_Ping_Time = min_ping_time
  )
}
