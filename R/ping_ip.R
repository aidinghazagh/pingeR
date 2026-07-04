#' Ping a single IP address
#'
#' Executes a single ping command to the given IP and returns the result.
#'
#' @param ip Character string of the IP address to ping. Default is "4.2.2.4".
#' @return A data.frame with columns: Timestamp, PingTime, Status.
#' @export
#' @examples
#' \dontrun{
#' result <- ping_ip("8.8.8.8")
#' print(result)
#' }
ping_ip <- function(ip = "4.2.2.4") {
  os <- Sys.info()["sysname"]
  ping_flag <- if (os == "Windows") "-n 1" else "-c 1"

  ping_result <- tryCatch({
    system(paste("ping", ping_flag, ip), intern = TRUE)
  }, error = function(e) {
    return(NULL)
  })

  ping_time <- NA
  status <- "Unknown"

  if (is.null(ping_result) || length(ping_result) == 0) {
    status <- "Unsuccessful"
  } else {
    matched <- grep("time=", ping_result, value = TRUE)
    if (length(matched) > 0) {
      ping_time <- sub(".*time=([0-9.]+)ms.*", "\\1", matched)
      ping_time <- as.numeric(ping_time)
      status <- "Successful"
    } else {
      status <- "Unsuccessful"
    }
  }

  timestamp <- Sys.time()
  data.frame(Timestamp = timestamp, PingTime = ping_time, Status = status, stringsAsFactors = FALSE)
}
