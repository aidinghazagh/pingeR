#' Ping multiple IP addresses
#'
#' Pings a vector of IP addresses once each and returns the combined results.
#'
#' @param ips Character vector of IP addresses to ping.
#' @return A data.frame with columns: Timestamp, IP, PingTime, Status.
#' @export
#' @examples
#' \dontrun{
#' results <- ping_multi(c("8.8.8.8", "1.1.1.1", "4.2.2.4"))
#' print(results)
#' }
ping_multi <- function(ips) {
  results <- do.call(rbind, lapply(ips, function(ip) {
    res <- ping_ip(ip)
    data.frame(
      Timestamp = res$Timestamp,
      IP = ip,
      PingTime = res$PingTime,
      Status = res$Status,
      stringsAsFactors = FALSE
    )
  }))
  rownames(results) <- NULL
  results
}
