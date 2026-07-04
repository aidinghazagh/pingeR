#' Plot ping timeline with fluctuations and disconnections
#'
#' Creates a time-series plot showing ping latency over time, with failed pings
#' marked as disconnections and a rolling average to highlight trends.
#'
#' @param data A data.frame with columns: Timestamp, PingTime, Status.
#' @param destination Path to the directory where the plot PNG will be saved.
#' @param window Integer, number of pings for the rolling average window. Default is 10.
#' @param warn_threshold Numeric, ping time (ms) above which to highlight as high latency. Default is 100.
#' @export
#' @examples
#' \dontrun{
#' ping_data <- read.csv("ping_log.csv")
#' plot_ping_timeline(ping_data, ".")
#' }
plot_ping_timeline <- function(data, destination, window = 10, warn_threshold = 100) {
  data$Timestamp <- as.POSIXct(data$Timestamp, format = "%Y-%m-%d %H:%M:%S")

  # Separate successful and failed pings
  ok <- data[data$Status == "Successful", ]
  fail <- data[data$Status != "Successful", ]

  # Rolling average for successful pings
  if (nrow(ok) >= window) {
    ok$RollingAvg <- stats::filter(ok$PingTime, rep(1 / window, window), sides = 1)
  } else {
    ok$RollingAvg <- NA
  }

  p <- ggplot2::ggplot() +
    # Shaded band for high latency zone
    ggplot2::geom_hline(yintercept = warn_threshold, linetype = "dashed", color = "orange", alpha = 0.7) +
    # Successful pings as line + points
    ggplot2::geom_line(data = ok, ggplot2::aes(x = .data$Timestamp, y = .data$PingTime), color = "steelblue", alpha = 0.5) +
    ggplot2::geom_point(data = ok, ggplot2::aes(x = .data$Timestamp, y = .data$PingTime), color = "steelblue", size = 1) +
    # Rolling average line
    ggplot2::geom_line(data = ok, ggplot2::aes(x = .data$Timestamp, y = .data$RollingAvg), color = "darkblue", linewidth = 0.8) +
    # Failed pings plotted at y = 0 as disconnection markers
    ggplot2::geom_point(data = fail, ggplot2::aes(x = .data$Timestamp, y = 0), color = "red", shape = 4, size = 3, stroke = 1.2) +
    ggplot2::labs(
      title = "Ping Timeline: Fluctuations & Disconnections",
      x = "Time",
      y = "Ping (ms)",
      caption = paste0("Blue = ping, Dark blue = ", window, "-ping rolling avg, Red X = disconnection, Orange line = ", warn_threshold, "ms threshold")
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      plot.caption = ggplot2::element_text(size = 8, color = "gray40")
    )

  ggplot2::ggsave(filename = paste0(destination, "/ping_timeline.png"), plot = p, width = 12, height = 6, dpi = 300)
}
