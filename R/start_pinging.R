start_pinging <- function(destination, time = 5, ip = "4.2.2.4", feedback = TRUE, timeUnit = "secs"){
  # Initialize an empty data frame to store results
  ping_log <- data.frame(Timestamp = character(), PingTime = numeric(), Status = character(), stringsAsFactors = FALSE)
  
  # Define the duration to run the loop (e.g., 1 hour)
  end_time <- Sys.time() + as.difftime(5, units = timeUnit)
  
  # Run the pinging process
  tryCatch({
    while (Sys.time() < end_time) {
      ping_result <- ping_ip(ip)
      ping_log <- rbind(ping_log, ping_result)
      write.csv(ping_log, file = paste0(destination, "/ping_log.csv"), row.names = FALSE)
      if(feedback){
        cat("Ping time:",ping_result$PingTime[1], "\n")
      }
      Sys.sleep(1)  # Wait for 1 second between pings
    }
  }, interrupt = function(ex) {
    cat("Loop interrupted by the user!\n")
  })
}
start_pinging(destination = "C:/Users/u/R/pingeR")

