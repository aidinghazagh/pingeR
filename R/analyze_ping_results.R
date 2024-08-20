analyze_ping_results <- function(ping_data) {
  # Convert Timestamp to POSIXct
  ping_data$Timestamp <- as.POSIXct(ping_data$Timestamp, format = "%Y-%m-%d %H:%M:%OS")
  
  # Identify unsuccessful pings
  ping_data$PingTime[ping_data$Status != "Successful"] <- NA
  
  # Basic summary
  total_pings <- nrow(ping_data)
  successful_pings <- sum(ping_data$Status == "Successful", na.rm = TRUE)
  unsuccessful_pings <- sum(is.na(ping_data$PingTime))
  
  # Calculate statistics for successful pings
  avg_ping_time <- mean(ping_data$PingTime, na.rm = TRUE)
  max_ping_time <- max(ping_data$PingTime, na.rm = TRUE)
  min_ping_time <- min(ping_data$PingTime, na.rm = TRUE)
  
  # Create a summary list
  summary <- list(
    Total_Pings = total_pings,
    Successful_Pings = successful_pings,
    Unsuccessful_Pings = unsuccessful_pings,
    Average_Ping_Time = avg_ping_time,
    Max_Ping_Time = max_ping_time,
    Min_Ping_Time = min_ping_time
  )
  
  return(summary)
}
