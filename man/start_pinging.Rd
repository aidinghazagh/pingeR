
\name{start_pinging}
\alias{start_pinging}
\title{Start Pinging}
\description{Will start pinging and saving the results}
\usage{
start_pinging(destination, time = 1, ip = "8.8.8.8", feedBack = FALSE, timeUnit = "hours")
}
\arguments{
\item{destination}{The destination of the saving csv file}
\item{time}{measurement of time}
\item{ip}{The IP you're trying to ping}
\item{feedBack}{If set to TRUE will log every ping attemp to the console}
\item{timeUnit}{The Unit of time ex: hours, secs}
}
\value{
No returning value
}
\examples{
destination <- "C:/Users/u/Desktop" # Forward slash
start_pinging(destination, time = 1, ip = "8.8.8.8", feedBack = FALSE, timeUnit = "hours")
}