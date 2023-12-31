#' Check data validity and process dimension names
#'
#' @inheritParams spatial_hm
#' @param assay.na Applicable when \code{data} is "SummarizedExperiment" or "SingleCellExperiment", where multiple assays could be stored. The name of target assay to use. The default is \code{NULL}.
#' @param usage One of "shm", "aggr", "filter", "norm", "other". The default is "other". If the "data" is SummarizedExperiment, this argument is only relevant to "aggr_rep", "filter_data", "spatial_hm".
#' @return A list of 4 components: dat, fct.cna, col.meta, row.meta, con.na
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jzhan067@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

#' @references
#' SummarizedExperiment: SummarizedExperiment container. R package version 1.10.1 \cr R Core Team (2018). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/
#' \cr Amezquita R, Lun A, Becht E, Carey V, Carpp L, Geistlinger L, Marini F, Rue-Albrecht K, Risso D, Soneson C, Waldron L, Pages H, Smith M, Huber W, Morgan M, Gottardo R, Hicks S (2020). “Orchestrating single-cell analysis with Bioconductor.” Nature Methods, 17, 137–145. https://www.nature.com/articles/s41592-019-0654-x

#' @importFrom SummarizedExperiment assay colData rowData

check_data <- function(data, assay.na=NULL, sam.factor=NULL, con.factor=NULL, usage='other') {
  # save(data, sam.factor, con.factor, usage, file='check.all')
  options(stringsAsFactors=FALSE)
  dat <- fct.cna <- col.meta <- row.meta <- con.na <- NULL
  if (is(data, 'data.frame')|is(data, 'matrix')|is(data, 'DFrame')|is(data, 'dgCMatrix')) {
    # Convert "dgCMatrix" to "matrix": compatible with most data operations (cbind, etc).
    if (is(data, 'dgCMatrix')) data <- as.matrix(data)
    data <- as.data.frame(data); rna <- rownames(data); cna <- make.names(colnames(data))
    if (!identical(cna, colnames(data))) cat('Syntactically valid column names are made! \n')
    # Only in replicate aggregation, data normalization, data filter, replicates are allowed. 
    if (!(usage %in% c('aggr', 'norm', 'filter'))) if (any(duplicated(cna))) stop("Please use function \'aggr_rep\' to aggregate replicates!") 
    na <- vapply(seq_len(ncol(data)), function(i) { tryCatch({ as.numeric(data[, i]) }, warning=function(w) { return(rep(NA, nrow(data)))
    }, error=function(e) { stop("Please make sure input data are numeric!") }) }, FUN.VALUE=numeric(nrow(data)) )
    if (nrow(data)==1) na <- matrix(na, byrow=TRUE, ncol=ncol(data))
    na <- as.data.frame(na); rownames(na) <- rna
    # app <- apply(na, 2, is.na): requires much more memory than vapply.
    vap <- df_is_as(na, is.na); rownames(vap) <- rna
    # Exclude rows of all NAs.
    vap <- vap[!rowSums(vap)==ncol(vap), , drop=FALSE]
    idx <- colSums(vap)!=0
    row.meta <- data[idx] # aggr_rep filter_data, submatrix 
    dat <- na[!idx]; colnames(dat) <- fct.cna <- cna[!idx]
    # spatial_hm
    if (usage=='shm') { form <- grepl("__", fct.cna); if (sum(form)==0) { colnames(dat) <- paste0(fct.cna, '__', 'con'); con.na <- FALSE } else con.na <- TRUE }

  } else if (is(data, 'SummarizedExperiment') | is(data, 'SingleCellExperiment')) {
    if (is.null(assay.na)) {
      if (length(assays(data)) > 1) stop("Please specify which assay to use by assigning the assay name to 'assay.na'!") else if (length(assays(data)) == 1) assay.na <- 1
    }
    dat <- assays(data)[[assay.na]]; r.na <- rownames(dat); cna <- make.names(colnames(dat))
    dat <- df_is_as(dat, as.numeric)
    rownames(dat) <- r.na; colnames(dat) <- cna
    if (!identical(cna, colnames(dat))) cat('Syntactically valid column names are made! \n')
    col.meta <- as.data.frame(colData(data))
    # filter_data
    row.meta <- as.data.frame(rowData(data))[, , drop=FALSE]
    # Factors teated by paste0/make.names are vectors.
    if (!is.null(sam.factor) & !is.null(con.factor)) { fct.cna <- colnames(dat) <- paste0(col.meta[, sam.factor], '__', col.meta[, con.factor]); con.na <- TRUE } 

    if (usage=='shm') {
      if (!is.null(sam.factor) & is.null(con.factor)) { sam.na <- as.vector(col.meta[, sam.factor]); fct.cna <- paste0(sam.na, "__", "con"); con.na <- FALSE } else if (is.null(sam.factor)) { form <- grepl("__", cna); if (sum(form)==0) { fct.cna <- paste0(cna, '__', 'con'); con.na <- FALSE } else con.na <- TRUE }
      if (!is.null(fct.cna)) { colnames(dat) <- make.names(fct.cna); if (!identical(fct.cna, make.names(fct.cna))) cat('Syntactically valid column names are made! \n') }
      if (any(duplicated(colnames(dat)))) stop("Please use function \'aggr_rep\' to aggregate \'sample__condition\' replicates!")
    } else if (usage %in% c('aggr', 'filter')) { 
      if (!is.null(sam.factor) & is.null(con.factor)) {  fct.cna <- as.vector(col.meta[, sam.factor]) } else if (is.null(sam.factor) & !is.null(con.factor)) { fct.cna <- as.vector(col.meta[, con.factor]) } else fct.cna <- colnames(dat)
      if (!identical(fct.cna, make.names(fct.cna))) cat('Syntactically valid column names are made! \n')
      fct.cna <- colnames(dat) <- make.names(fct.cna) 
    }
    col.meta <- DataFrame(col.meta)
    rownames(col.meta) <- fct.cna
  } else { stop('Accepted data classes are "data.frame", "matrix", "DFrame", "dgCMatrix", "SummarizedExperiment", or "SingleCellExperiment" except that "spatial_hm" also accepts a "vector".') 
  };
  cname <- colnames(dat); form <- grepl('__', cname) 
  # con <- gsub("(.*)(__)(.*)", "\\3", cname[form]) 
  if (sum(form)>0) con <- gsub("(.*)(__)(.*)", "\\3", cname)  
  sam <- gsub("(.*)(__)(.*)", "\\1", cname)
  if (is(data, 'SummarizedExperiment') | is(data, 'SingleCellExperiment')) {
    rownames(dat) <- rownames(row.meta)
    se <- SummarizedExperiment(assays=list(data=as.matrix(dat)), colData=DataFrame(col.meta), rowData=DataFrame(row.meta))
  } else se <- SummarizedExperiment(assays=list(data=as.matrix(dat)))
  se$spFeature <- sam; if (sum(form)>0) se$variable <- con
  return(list(dat=dat, fct.cna=fct.cna, col.meta=col.meta, row.meta=row.meta, con.na=con.na, se=se)) 
}
