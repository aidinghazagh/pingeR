#' Plot hourly ping counts
#'
#' Creates a bar chart of successful and unsuccessful pings per hour and saves it as a PNG.
#'
#' @param data A data.frame with columns: Timestamp, PingTime, Status.
#' @param destination Path to the directory where the plot PNG will be saved.
#' @export
#' @examples
#' \dontrun{
#' ping_data <- read.csv("ping_log.csv")
#' plot_hour_count(ping_data, "C:/Users/Desktop")
#' }
plot_hour_count <- function(data, destination) {
  data$Timestamp <- as.POSIXct(data$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  data$hour <- format(data$Timestamp, "(%Y-%m-%d) %H:00")
  data$Status[is.na(data$PingTime)] <- "Unsuccessful"

  summary_data <- data %>%
    dplyr::group_by(.data$hour, .data$Status) %>%
    dplyr::summarise(count = dplyr::n(), .groups = "drop")

  p <- ggplot2::ggplot(summary_data, ggplot2::aes(x = .data$hour, y = .data$count, fill = .data$Status)) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    ggplot2::labs(
      title = "Number of Successful and Unsuccessful Pings per Hour",
      x = "Hour",
      y = "Number of Pings"
    ) +
    ggplot2::scale_fill_manual(values = c("Successful" = "cyan", "Unsuccessful" = "brown1")) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  ggplot2::ggsave(filename = paste0(destination, "/ping_plot.png"), plot = p, width = 10, height = 6, dpi = 300)
}
