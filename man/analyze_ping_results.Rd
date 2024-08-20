
\name{analyze_ping_results}
\alias{analyze_ping_results}
\title{Analyze Ping Results}
\description{Analyze your ping results}
\usage{
analyze_ping_results(ping_data)
}
\arguments{
\item{ping_data}{The framework that we have our results in}
}
\value{
The summary containing $Total_Pings, $Successful_Pings, $Average_Ping_Time, $Max_Ping_Time, $Min_Ping_Time
}
\examples{
ping_data <- read.csv("Path to the csv file")
summary <- analyze_ping_results(ping_data)
print(summary)

# $Total_Pings
# [1] 2

# $Successful_Pings
# [1] 2

# $Unsuccessful_Pings
# [1] 0

# $Average_Ping_Time
# [1] 131.5

# $Max_Ping_Time
# [1] 133

# $Min_Ping_Time
# [1] 130
}