% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_fr.R
\name{read_fr}
\alias{read_fr}
\title{Import Data from Tabular Files}
\usage{
read_fr(input, header = TRUE, sep = "auto", fill = TRUE, check.names = FALSE)
}
\arguments{
\item{input}{The file path.}

\item{header}{One of TRUE, FALSE, or "auto". Default is TRUE. Does the first data line contain column names, according to whether every non-empty field on the first data line is type character? If "auto" or TRUE is supplied, any empty column names are given a default name.}

\item{sep}{ The separator between columns. Defaults to the character in the set \code{[,\\t |;:]} that separates the sample of rows into the most number of lines with the same number of fields. Use \code{NULL} or \code{""} to specify no separator; i.e. each line a single character column like \code{base::readLines} does.}

\item{fill}{Logical (default is TRUE). If TRUE then in case the rows have unequal length, blank fields are implicitly filled.}

\item{check.names}{default is \code{FALSE}. If \code{TRUE} then the names of the variables in the \code{data.table} are checked to ensure that they are syntactically valid variable names. If necessary they are adjusted (by \code{\link{make.names}}) so that they are, and also to ensure that there are no duplicates.}
}
\value{
A data frame.
}
\description{
This function reads data from a tabular file, which is a wrapper of \link[data.table]{fread}. If the tabular file contains both character and numeric columns, it is able to maintain the character or numeric attribute for each column in the returned data frame. In addition, it is able to detect separators automatically.
}
\examples{
sh.tar <- system.file('extdata/shinyApp/data/target_arab.txt', package='spatialHeatmap')
target.sh <- read_fr(sh.tar); target.sh[60:63, ]
}
\references{
Matt Dowle and Arun Srinivasan (2019). data.table: Extension of `data.frame`. R package version 1.12.8. https://CRAN.R-project.org/package=data.table
}
\author{
Jianhai Zhang \email{jzhan067@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@ucr.edu}
}
