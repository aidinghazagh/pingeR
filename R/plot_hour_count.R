
plot_hour_count <- function (data, destination){
  library(ggplot2)
  library(dplyr)
  
  data$Timestamp <- as.POSIXct(data$Timestamp, format="%Y-%m-%d %H:%M:%S")
  data$hour <- format(data$Timestamp, "(%Y-%m-%d) %H:00")
  data$Status[is.na(data$PingTime)] <- "Unsuccessful"
  summary_data <- data %>%
    group_by(hour, Status) %>%
    summarise(count = n())
  
  p <- ggplot(summary_data, aes(x=hour, y=count, fill=Status)) +
    geom_bar(stat="identity", position="dodge") +
    labs(title="Number of Successful and Unsuccessful Pings per Hour",
         x="Hour",
         y="Number of Pings") +
    scale_fill_manual(values = c("Successful" = "cyan", "Unsuccessful" = "brown1")) + # Reverse colors here
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(filename = paste0(destination, "/ping_plot.png"), plot = p, width = 10, height = 6, dpi = 300)
  
}
