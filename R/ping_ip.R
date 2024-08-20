ping_ip <- function(ip = "4.2.2.4") {
  # Execute the ping command using Windows syntax (-n 1)
  ping_result <- tryCatch({
    system(paste("ping -n 1", ip), intern = TRUE)
  }, error = function(e) {
    return(NULL)
  })
  
  # Initialize variables
  ping_time <- NA
  status <- "Unknown"
  
  # Check if ping_result is NULL or empty
  if (is.null(ping_result) || length(ping_result) == 0) {
    status <- "Unsuccessful"
  } else {
    matched <- grep("time=", ping_result, value = TRUE)
    if (length(matched) > 0) {
      ping_time <- sub(".*time=([0-9]+)ms.*", "\\1", matched)
      ping_time <- as.numeric(ping_time)
      status <- "Successful"
    } else {
      if (any(grepl("Request timed out", ping_result))) {
        status <- "Unsuccessful"
      } else {
        status <- "Unsuccessful"
      }
    }
  }
  
  timestamp <- Sys.time()
  data.frame(Timestamp = timestamp, PingTime = ping_time, Status = status, stringsAsFactors = FALSE)
}