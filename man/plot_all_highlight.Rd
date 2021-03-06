% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots.R
\name{plot_all_highlight}
\alias{plot_all_highlight}
\title{plot all countries but highlight first 10}
\usage{
plot_all_highlight(
  df,
  log = F,
  text = "",
  n_highligth = 10,
  percent = F,
  date_x = F
)
}
\arguments{
\item{df}{data.frame with column called Date and Value column to plot}

\item{log}{logical for applying log scale}

\item{text}{element for tooltip}

\item{n_highligth}{number of elements to highlight}

\item{percent}{logical to make the y axis in percent}

\item{date_x}{logical to convert x-axis labels to dates}
}
\description{
plot all countries but highlight first 10
}
