% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opt_violin.R
\name{opt_violin}
\alias{opt_violin}
\title{Violin plots of co-clustering validation results}
\usage{
opt_violin(
  data,
  para.na,
  bar.width = 0.1,
  thr = NULL,
  title = NULL,
  title.size = 25,
  xlab = NULL,
  ylab = NULL,
  axis.title.size = 25,
  x.text.size = 25,
  y.text.size = 25,
  x.agl = 0,
  x.vjust = 0.6
)
}
\arguments{
\item{data}{A \code{data.frame} of co-clustering validation results.}

\item{para.na}{Targe parameters, which are one or multiple column names in \code{data}.}

\item{bar.width}{Width of the bar.}

\item{thr}{A y-axis threshold, which will be used to draw a horizontal line.}

\item{title, title.size}{The plot title and its size.}

\item{xlab, ylab}{The x and y axis label respectively.}

\item{axis.title.size}{The size of x and y axis labels.}

\item{x.text.size, y.text.size}{The size of x and y axis text.}

\item{x.agl, x.vjust}{The angle and vertical position of x-axis text.}
}
\value{
An object of ggplot.
}
\description{
Violin plots of co-clustering validation results
}
\examples{
set.seed(10)
data <- data.frame(auc=round(runif(30, 0, 1), 2), accuracy=round(runif(30, 0, 1), 2))
opt_violin(data=data, para.na=c('auc', 'accuracy'))
}
\references{
H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.
}
\author{
Jianhai Zhang \email{jzhan067@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@ucr.edu}
}
