
\name{plot_hour_count}
\alias{plot_hour_count}
\title{Plot Hour Count}
\description{Plot the ping results with hourly count}
\usage{
plot_hour_count(data, destination)
}
\arguments{
\item{data}{The framework that we have our results in}
\item{destination}{The destination that our png file will be saved in}
}
\value{
No returning value
}
\examples{
ping_data <- read.csv("Path to the csv file")
destination <- "C:/Users/u/Desktop" # Forward slash
plot_hour_count(ping_data, destination)
}