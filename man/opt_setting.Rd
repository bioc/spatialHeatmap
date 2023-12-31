% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opt_setting.R
\name{opt_setting}
\alias{opt_setting}
\title{Bar plots of co-clustering optimization results.}
\usage{
opt_setting(df.res, nas, summary = "mean")
}
\arguments{
\item{df.res}{A \code{data.frame} of validation results in co-clustering optimization.}

\item{nas}{The target metrics, which are column names of \code{df.res}.}

\item{summary}{The method to summarize ranks of \code{nas} across datasets.}
}
\value{
An object of ggplot.
}
\description{
Bar plots of co-clustering optimization results.
}
\examples{
set.seed(10)
dimred <- c('PCA', 'UMAP'); dims <- seq(5, 80, 15) 
graph <- c('knn', 'snn'); cluster <- c('wt', 'fg', 'le') 
df.para <- expand.grid(dataset=c('dataset1', 'dataset2'), norm='FCT', fil='fil1', dimred=dimred, dims=dims, graph=graph, cluster=cluster, stringsAsFactors = FALSE) 
df.para$auc <- round(runif(nrow(df.para), 0, 1), 2)
df.para$accuracy <- round(runif(nrow(df.para), 0, 1), 2)
df.para[1:5, ] 
opt_setting(df.para, nas=c('auc', 'accuracy'))
}
\author{
Jianhai Zhang \email{jzhan067@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@ucr.edu}
}
