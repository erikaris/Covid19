% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots.R
\name{from_contagion_day_bar_plot}
\alias{from_contagion_day_bar_plot}
\title{Evolution from contagion day}
\usage{
from_contagion_day_bar_plot(df)
}
\arguments{
\item{df}{data.frame with column called Contagion_day and x column to plot}
}
\value{
barplot of given variable by contagion

p ggplot object
}
\description{
Evolution from contagion day
}
\examples{
\dontrun{
df <- get_timeseries_full_data() \%>\%
 get_timeseries_by_contagion_day_data() \%>\%
 aggregate_province_timeseries_data() \%>\%
 filter(Country.Region == "Italy")
 select(Country.Region, contagion_day, confirmed)

 df <- df \%>\%
 mutate(status = as.factor(Country.Region)) \%>\%
 mutate(value = confirmed) \%>\%
 capitalize_names_df()

df \%>\% from_contagion_day_bar_plot()
}

}
