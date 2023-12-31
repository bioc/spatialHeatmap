#' Combining two SE or SCE objects.
#' 

#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jzhan07@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

#' @importFrom SummarizedExperiment colData colData<- 

cbind_se <- function(x, y) {
  intr <- intersect(rownames(x), rownames(y))
  if (length(intr)==0) {
    msg <- 'When combining two SE or SCE objects, no common rownames are detected!'
    return(msg); stop(msg) 
  }; cdatx <- colData(x); cdaty <- colData(y)
  int <- intersect(colnames(cdatx), colnames(cdaty))
  if (length(int)==0) {
    message('When combining two SE or SCE objects, the "colData" slots do not have common columns!')
    colData(x) <- colData(y) <- NULL
  }; colData(x) <- cdatx[, int]; colData(y) <- cdaty[, int]
  pkg <- check_pkg('BiocGenerics'); if (is(pkg, 'character')) stop(pkg)
  return(BiocGenerics::cbind(x[intr,], y[intr, ]))
}

#' Scaling all rows in a data frame as a whole
#'
#' @param dat A data frame or matrix of of numeric data. 

#' @return A scaled data frame.
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jzhan07@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

scale_all <- function(dat) {
  dat <- data.frame(dat) 
  vals <- scale(data.frame(value=unlist(dat)))[, 1]
  dat.s <- as.data.frame(matrix(vals, nrow=nrow(dat), byrow=FALSE))
  dimnames(dat.s) <- dimnames(dat); return(dat.s)
}

#' Construct an \code{SummarizedExperiment} object.
#' @keywords Internal
#' @noRd
#' @references
#' Morgan M, Obenchain V, Hester J, Pagès H (2022). SummarizedExperiment: SummarizedExperiment container. R package version 1.28.0, https://bioconductor.org/packages/SummarizedExperiment.
#' Pagès H, Lawrence M, Aboyoun P (2023). S4Vectors: Foundation of vector-like and list-like containers in Bioconductor. R package version 0.36.2, https://bioconductor.org/packages/S4Vectors.
 
#' @importFrom SummarizedExperiment SummarizedExperiment colData<- rowData<-
#' @importFrom S4Vectors DataFrame

s4se <- function(assay, cdat=NULL, rdat=NULL) {
  if (!(is(assay, 'data.frame')|is(assay, 'matrix')|is(assay, 'DFrame')|is(assay, 'dgCMatrix'))) {
    msg <- "'assay' should be one of 'data.frame', 'matrix', 'DFrame', or 'dgCMatrix'!"
    warning(msg); return(msg)
  }
  se <- SummarizedExperiment(assays=list(data=as.matrix(assay)))
  if (!is.null(cdat)) { 
    if (!(is(cdat, 'data.frame')|is(cdat, 'DFrame'))) {
      msg <- "'cdat' should be one of 'data.frame', or 'DFrame'!"
      warning(msg); return(msg)
    }
    if (ncol(assay)!=nrow(cdat)) {
      msg <- "The number of columns in 'assay' should be the same as rows in 'cdat'!"
      warning(msg); return(msg)
    }; colData(se) <- DataFrame(cdat)
  }
  if (!is.null(rdat)) { 
    if (!(is(rdat, 'data.frame')|is(rdat, 'DFrame'))) {
    msg <- "'rdat' should be one of 'data.frame', or 'DFrame'!"
    warning(msg); return(msg)
    }
    if (nrow(assay)!=nrow(rdat)) {
      msg <- "'assay' and 'rdat' should have the same number of rows!"
      warning(msg); return(msg)
    }; rowData(se) <- DataFrame(rdat)
  }; se
}
#' Check an expression.
#' @keywords Internal
#' @noRd
check_exp <- function(x) {
  tryCatch(x , warning = function(w){ 'w' }, error = function(e){ 'e' }) 
}

#' Check availability of packages.
#' @keywords Internal
#' @noRd

check_pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    msg <- paste0("'", x, "' is not installed!")
    warning(msg); return(msg)
  } else return(TRUE)
}

#' Check validity of an object
#'
#' @param x An object.

#' @return TRUE or FALSE
#' @keywords Internal
#' @noRd

check_obj <- function(x) {
  check0 <- function(y) {
    if (isS4(y)) return(TRUE)
    # data.frame can have 0 row.
    if (is(y, 'data.frame')|is(y, 'DFrame')|is(y, 'matrix')|is(y, 'dgCMatrix')) return(TRUE)
    # Only check one-element vector. 
    if (length(y)>1) return(TRUE); if (length(y)==0) return(FALSE)
    if (is.na(y)) return(FALSE)
    # 0==FALSE is TRUE
    if (is(y, 'logical')) if (y==FALSE) return(FALSE)
    if (y=='') return(FALSE)
    return(TRUE)
  }
  if (!is(x, 'list')) return(check0(x))
  # As long as one element is one of NA, NULL, FALSE, or length(x)==0, FALSE is return for the whole list.
  if (is(x, 'list')) {
    if (length(x)==0) return(FALSE) 
    all.lis <- unlist(lapply(x, function(i) check0(i)))
    # all(NULL) is TRUE.
    if (length(all.lis)==0) return(FALSE)
    all(all.lis)
  }
}

#' Show popup window
#'
#' @param msg The main content to show.

#' @return A pop-up window in Shiny app.
#' @keywords Internal
#' @noRd

#' @importFrom shiny modalDialog span HTML div tagList modalButton checkboxInput

modal <- function(title = NULL, msg=NULL, img=NULL, img.w="70%", easyClose=FALSE, modbut='Dismiss', show=TRUE, idshow='idshow', footer.width='90%') { 
  modalDialog(title = title, span(msg), 
    if (!is.null(img)) div(style = 'overflow-y:scroll;overflow-x:scroll;margin-top:20px', 
      HTML(paste0("<img ", "src='image/", img, "' width='", img.w, "'>")) 
    ), 
    size = c("m"), easyClose=easyClose,
    footer = if (TRUE %in% show) div(class='shiny-split-layout', style=paste0('width:', footer.width), checkboxInput(idshow, label='Do not show again', value = FALSE), modalButton(modbut)) else modalButton(modbut)

  ) 
}  

#' Shown popup window
#'
#' @param msg The main content to show.

#' @return A pop-up window in Shiny app.
#' @keywords Internal
#' @noRd

#' @importFrom shiny showModal

show_mod <- function(lgc, msg, img=NULL, title=NULL) {
  if (!lgc) showModal(modal(title=title, msg = msg, img=img))
}


#' Check if SVGs are paired with templates of raster images
#'
#' @param svg.na SVG names or paths.
#' @param raster.ext A vector of raster image file extensions such as \code{c('.jpg', '.JPG', '.png', '.PNG')}.
#' @param shiny If used in Shiny app, the value should be \code{TRUE}.

#' @return The raster path.
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jianhai.zhang@@email.ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

#' @importFrom shiny showModal

svg_raster <- function(svg.na, raster.ext, shiny=TRUE) {                                                                                           
  ext <- paste0('\\', c('.svg', raster.ext), '$', collapse='|')
  # Ensure the raster and paired SVG names are same except for extensions.
  paired <- all(table(sub(ext, '', svg.na))==2)
  if (!paired) {
    msg <- 'If raster images are provided as templates, ensure they have the same names with corresponding aSVG images. E.g. test.png, test.svg.'
    if (shiny==TRUE) {
      showModal(modal(msg=msg)); validate(need(try(paired), ''))                                                                                            
    } else return(msg)
  } else return()
}

#' Extract tmplate path for a selected SVG
#'
#' @param svg.paths,svg.nas All svg/raster paths and names, which are in the same order.
#' @param svg.na Selected SVG name.
#' @return The raster path.
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jianhai.zhang@@email.ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

raster_path <- function(svg.paths, svg.nas, svg.na, raster.ext){
  raster.pat <- sub('\\.svg', paste0('(', paste0('\\', raster.ext, '$', collapse='|'), ')'), svg.na)
  raster.pa <- svg.paths[grepl(raster.pat, svg.nas)]; return(raster.pa)
}

#' Apply basic functions on data frame/matrix columns.
#'
#' @param data A data frame or matrix.
#' @param fun The function to apply on the column: \code{is.numeric}, \code{is.na}, \code{as.numeric}.
#' @return A matrix.
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jianhai.zhang@@email.ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

df_is_as <- function(data, fun=is.numeric) {                                                                                     
  dim.na <- dimnames(data)
  # apply(na, 2, is.na): requires much more memory than vapply.                                                                                                     
  if (identical(fun, is.na)) vap <- vapply(seq_len(ncol(data)), function(i) { fun(data[, i]) }, logical(nrow(data))) else if (identical(fun, as.numeric)) vap <- vapply(seq_len(ncol(data)), function(i) { fun(data[, i]) }, numeric(nrow(data))) else if (identical(fun, is.numeric)) vap <- vapply(seq_len(ncol(data)), function(i) { fun(data[, i]) }, logical(1))                        
  # is.numeric always returns one value.
  if (nrow(data)==1 | identical(fun, is.numeric)) vap <- matrix(vap, byrow=TRUE, ncol=ncol(data))                                
  if (!identical(fun, is.numeric)) dimnames(vap) <- dim.na else { rownames(vap) <- dim.na[[1]][1]; colnames(vap) <- dim.na[[2]] }
  return(vap)
}    

#' Check validity of a function on data
#'
#' @param data A vector of single value.
#' @param fun The function to apply on the data: \code{is.numeric}, \code{is.na}, \code{as.numeric}.
#' @return A vector, 'warning', or 'error'.
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jzhan067@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

dat_fun <- function(data, fun) {                                                                                                  
  er.wa <- tryCatch({ fun(data) }, error=function(e){ return('e') }, warning=function(w) { return('w') } )            
  return(er.wa)                                                                                                                  
}
