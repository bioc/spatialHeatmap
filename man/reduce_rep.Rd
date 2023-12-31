% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reduce_rep.R
\name{reduce_rep}
\alias{reduce_rep}
\title{Reduce sample replicates}
\usage{
reduce_rep(dat, n = 3, sim.meth = "pearson")
}
\arguments{
\item{dat}{Abundance matrix in form of \code{data.frame} or \code{matrix}, where columns and rows are samples and biological molecules respectively. For example, gene exression matrix generated in RNA-seq.}

\item{n}{An integer, the max number of replicates to keep per sample (e.g. tissue type). Within each sample, pairwise correlations are calculated among all replicates, and the correlations between one replicate and other relicates are summed. The replicates with top n largest sums are retained in each sample.}

\item{sim.meth}{One of \code{pearson} (default), \code{kendall}, or \code{spearman}, indicating which correlation coefficient method to use for calculating similarities between replicates.}
}
\value{
A \code{matrix}.
}
\description{
In an expression profile matrix such as RNA-seq count table, where columns and rows are samples and biological molecules respectively, reduce sample replicates according to sum of correlation coefficients (Pearson, Spearman, Kendall).
}
\examples{

# Random abundance matrix.
dat <- matrix(rnorm(100), nrow=10)
# Two samples, each has 5 replicates.
colnames(dat) <- c(rep('sampleA', 5), rep('sampleB', 5))
rownames(dat) <- paste0('gene', seq_len(nrow(dat)))
reduce_rep(dat)
}
\author{
Jianhai Zhang \email{jzhan067@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@ucr.edu}
}
