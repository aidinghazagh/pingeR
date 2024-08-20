
\name{ping_ip}
\alias{ping_ip}
\title{Ping ip}
\description{Will attempt to ping the given IP}
\usage{
ping_ip("4.2.2.4")
}
\arguments{
\item{ip}{The IP you're trying to ping}
}
\value{
A dataframe containing 3 columns (Timestamp, pingTime, Status)
}
\examples{
dataframe <- ping_ip()
print(dataframe)
# Timestamp PingTime     Status
# 1 2024-08-20 14:30:12      119 Successful
}