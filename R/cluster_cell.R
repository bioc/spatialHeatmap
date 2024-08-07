#' Cluster single cells or combination of single cells and bulk
#'
#' Cluster only single cell data or combination of single cell and bulk data. Clusters are created by first building a graph, where nodes are cells and edges represent connections between nearest neighbors, then partitioning the graph. The cluster labels are stored in the \code{cluster} column of \code{colData} slot of \code{SingleCellExperiment}.

#' @param sce The single cell data or combination of single cell and bulk data at log2 scale after dimensionality reduction in form of \code{SingleCellExperiment}.
#' @param graph.meth Method to build a nearest-neighbor graph, \code{snn} (see \code{\link[scran]{buildSNNGraph}}) or \code{knn} (default, see \code{\link[scran]{buildKNNGraph}}). The clusters are detected by first creating a nearest neighbor graph using \code{snn} or \code{knn} then partitioning the graph. 
#' @param dimred A string of \code{PCA} (default) or \code{UMAP} specifying which reduced dimensions to use for creating a nearest neighbor graph. 
#' @param knn.gr Additional arguments in a named list passed to \code{\link[scran]{buildKNNGraph}}.
#' @param snn.gr Additional arguments in a named list passed to \code{\link[scran]{buildSNNGraph}}.
#' @param cluster The clustering method. One of \code{wt} (\code{\link[igraph]{cluster_walktrap}}, default), \code{fg} (\code{\link[igraph]{cluster_fast_greedy}}), \code{le} (\code{\link[igraph]{cluster_leading_eigen}}), \code{sl} (\code{\link[igraph]{cluster_fast_greedy}}), \code{eb} (\code{\link[igraph]{cluster_edge_betweenness}}).  
#' @param wt.arg,fg.arg,sl.arg,le.arg,eb.arg A named list of arguments passed to \code{wt}, \code{fg}, \code{le}, \code{sl},       \code{eb} respectively.

#' @return A \code{SingleCellExperiment} object. 

#' @examples

#' library(scran); library(scuttle) 
#' sce <- mockSCE(); sce <- logNormCounts(sce)
#' # Modelling the variance.
#' var.stats <- modelGeneVar(sce)
#' sce.dimred <- denoisePCA(sce, technical=var.stats, subset.row=rownames(var.stats)) 
#' \donttest{
#' sce.clus <- cluster_cell(sce=sce.dimred, graph.meth='snn', dimred='PCA')
#' # Clusters.
#' table(colData(sce.clus)$label)
#'
#' }
#' # See details in function "coclus_meta" by running "?coclus_meta".

#' @author Jianhai Zhang \email{jzhan067@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

#' @references
#' Morgan M, Obenchain V, Hester J, Pagès H (2021). SummarizedExperiment: SummarizedExperiment container. R package version 1.24.0, https://bioconductor.org/packages/SummarizedExperiment.
#' Amezquita R, Lun A, Becht E, Carey V, Carpp L, Geistlinger L, Marini F, Rue-Albrecht K, Risso D, Soneson C, Waldron L, Pages H, Smith M, Huber W, Morgan M, Gottardo R, Hicks S (2020). “Orchestrating single-cell analysis with Bioconductor.” Nature Methods, 17, 137–145. https://www.nature.com/articles/s41592-019-0654-x.
#' Lun ATL, McCarthy DJ, Marioni JC (2016). “A step-by-step workflow for low-level analysis of single-cell RNA-seq data with Bioconductor.” F1000Res., 5, 2122. doi: 10.12688/f1000research.9501.2.
#' Csardi G, Nepusz T: The igraph software package for complex network research, InterJournal, Complex Systems 1695. 2006. https://igraph.org

#' @export 
#' @importFrom SummarizedExperiment colData
#' @importFrom SingleCellExperiment SingleCellExperiment 

cluster_cell <- function(sce, graph.meth='knn', dimred='PCA', knn.gr=list(), snn.gr=list(), cluster='wt', wt.arg=list(steps = 4), fg.arg=list(), sl.arg=list(spins = 25), le.arg=list(), eb.arg=list()) {
  pkg <- check_pkg('scran'); if (is(pkg, 'character')) { warning(pkg); return(pkg) }
  if (!is(sce, 'SingleCellExperiment')) stop('The "sce" should be an "SingleCellExperiment" object!')
  if (!dimred %in% reducedDimNames(sce)) stop('The "dimred" is not detected in "reducedDimNames"!')
  if ('cluster' %in% colnames(colData(sce))) stop('The "cluster" is a reserved colname in "colData" to store cluster assignments in this function!')
  # Only one is accepted: assay.type = "logcounts" or use.dimred="PCA".
  if (graph.meth=='knn') { 
    gr.sc <- do.call(scran::buildKNNGraph, c(list(x=sce, use.dimred=dimred), knn.gr))
  }
  if (graph.meth=='snn') {
    gr.sc <- do.call(scran::buildSNNGraph, c(list(x=sce, use.dimred=dimred), snn.gr))
  }
  # cluster: detected cell clusters. label: customer clusters.

  clus.all <- detect_cluster(graph=gr.sc, clustering=cluster, wt.arg=wt.arg, fg.arg=fg.arg, sl.arg=sl.arg, le.arg=le.arg, eb.arg=eb.arg)
  if (is.null(clus.all)) return()
  clus <- as.character(clus.all$membership)

  # clus <- as.character(do.call(cluster_walktrap, c(list(graph=gr.sc), cluster.wk))$membership)
  clus <- paste0('clus', clus)
  cdat.sc <- colData(sce); rna <- rownames(cdat.sc)
  lab.lgc <- 'label' %in% make.names(colnames(cdat.sc))
  if (lab.lgc) {
    cdat.sc <- cbind(cluster=clus, cdat.sc)
    idx <- colnames(cdat.sc) %in% c('cluster', 'label')
    cdat.sc <- cdat.sc[, c(which(idx), which(!idx))]
  } else cdat.sc <- cbind(cluster=clus, cdat.sc)
  # "cbind" removes row names in "cdat.sc". If "cdat.sc" has no row names, the existing column names in "sce" are erased.
  rownames(cdat.sc) <- rna
  colnames(cdat.sc) <- make.names(colnames(cdat.sc))
  colData(sce) <- cdat.sc; return(sce)
}
