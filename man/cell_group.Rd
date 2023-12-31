% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cell_group.R
\name{cell_group}
\alias{cell_group}
\title{Add manual cell group labels to SingleCellExperiment}
\usage{
cell_group(sce, df.group, cell, cell.group)
}
\arguments{
\item{sce}{A \code{SingleCellExperiment}.}

\item{df.group}{A \code{data.frame} of manually created single cell groups. At least two columns are required, corresponding to cell identifiers that are present in \code{rownames(colData(sce))} and the manually created group labels respectively.}

\item{cell}{The column name in \code{df.group} indicating cells.}

\item{cell.group}{The column name in \code{df.group} indicating cell group labels.}
}
\value{
An object of \code{SingleCellExperiment}.
}
\description{
Add manually created cell group labels in a \code{data.frame} to \code{SingleCellExperiment}.
}
\examples{
set.seed(10); library(SummarizedExperiment)
# Read single cell data.
sce.pa <- system.file("extdata/shinyApp/data", "cell_mouse_brain.rds", package="spatialHeatmap")
sce <- readRDS(sce.pa)
# Quality control, normalization, dimensionality reduction on the single cell data.
sce.dimred <- process_cell_meta(sce, qc.metric=list(subsets=list(Mt=rowData(sce)$featureType=='mito'), threshold=1))
# Read manual cell group labels.
manual.clus.mus.sc.pa <- system.file("extdata/shinyApp/data", "manual_cluster_mouse_brain.txt", package="spatialHeatmap") 
manual.clus.mus.sc <- read.table(manual.clus.mus.sc.pa, header=TRUE, sep='\t')
# Include manual cell group labels in "SingleCellExperiment".
sce.clus <- cell_group(sce=sce.dimred, df.group=manual.clus.mus.sc, cell='cell', cell.group='cluster')
}
\references{
Morgan M, Obenchain V, Hester J, Pagès H (2022). SummarizedExperiment: SummarizedExperiment container. R package version 1.26.1, https://bioconductor.org/packages/SummarizedExperiment
}
\author{
Jianhai Zhang \email{jzhan067@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@ucr.edu}
}
