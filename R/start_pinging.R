#' Start continuous pinging
#'
#' Pings the given IP address repeatedly and logs results to a CSV file.
#'
#' @param destination Path to the directory where the CSV log will be saved.
#' @param time Duration to run the pinging loop. Default is 5.
#' @param ip IP address to ping. Default is "4.2.2.4".
#' @param feedback If TRUE, prints each ping result to the console. Default is TRUE.
#' @param timeUnit Unit of time for the duration: "secs", "mins", "hours". Default is "secs".
#' @param interval Seconds between pings. Default is 1.
#' @export
#' @examples
#' \dontrun{
#' start_pinging("C:/Users/Desktop", time = 10, ip = "8.8.8.8", timeUnit = "secs")
#' }
start_pinging <- function(destination, time = 5, ip = "4.2.2.4", feedback = TRUE, timeUnit = "secs", interval = 1) {
  ping_log <- list()

  end_time <- Sys.time() + as.difftime(time, units = timeUnit)

  csv_path <- paste0(destination, "/ping_log.csv")
  first_write <- TRUE

  tryCatch({
    while (Sys.time() < end_time) {
      ping_result <- ping_ip(ip)
      ping_log <- c(ping_log, list(ping_result))

      if (first_write) {
        write.csv(ping_result, file = csv_path, row.names = FALSE)
        first_write <- FALSE
      } else {
        write.table(ping_result, file = csv_path, sep = ",", append = TRUE, row.names = FALSE, col.names = FALSE)
      }

      if (feedback) {
        cat("Ping time:", ping_result$PingTime[1], "\n")
      }
      Sys.sleep(interval)
    }
  }, interrupt = function(ex) {
    cat("Loop interrupted by the user!\n")
  })

  invisible(do.call(rbind, ping_log))
}
