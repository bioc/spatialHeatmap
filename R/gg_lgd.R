#' Adjust Legend Key Size and Rows in SHMs.
#'
#' @param gg.all A list of spatial heatmaps of ggplot.
#' @param size.key A numeric of legend key size. If \code{size.text} is NULL, it also applies to legend text size.
#' @param size.text.key A numeric of legend text size.
#' @param angle.text.key A value of key text angle in legend plot. The default is NULL, equivalent to 0.
#' @param position.text.key The position of key text in legend plot, one of "top", "right", "bottom", "left". Default is NULL, equivalent to "right".
#' @param legend.value.vdo Logical TRUE or FALSE. If TRUE, the numeric values of matching spatial features are added to video legend. The default is NULL.
#' @param sub.title.size The title size of ggplot.
#' @param row An integer of rows in legend key.
#' @param col An integer of columns in legend key.
#' @param label Logical. If TRUE, spatial features having matching samples are labeled by feature identifiers. The default is FALSE. It is useful when spatial features are labeled by similar colors. 
#' @param label.size The size of spatial feature labels in legend plot. The default is 4.
#' @param label.angle The angle of spatial feature labels in legend plot. Default is 0.
#' @param hjust The value to horizontally adjust positions of spatial feature labels in legend plot. Default is 0.
#' @param vjust The value to vertically adjust positions of spatial feature labels in legend plot. Default is 0.
#' @param opacity The transparency of colored spatial features in legend plot. Default is 1. If 0, features are totally transparent.
#' @param key Logical. The default is TRUE and keys are added in legend plot. If \code{label} is TRUE, the keys could be removed. 
#' @param aspect.ratio The ratio of width to height. The default is 1.
#' @return A list of ggplots.
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jzhan067@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

#' @references 
#' H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.

#' @importFrom ggplot2 theme layer_data ggplot_build scale_fill_manual unit element_text guide_legend ggplot_build

gg_lgd <- function(gg.all, sam=NULL, covis.type=NULL, gcol.lgd=NULL, size.key=NULL, size.text.key=8, angle.text.key=NULL, position.text.key=NULL, legend.value.vdo=NULL, sub.title.size=NULL, row=NULL, col=NULL, label=FALSE, label.size=3, label.angle=0, hjust=0, vjust=0, opacity=1, key=TRUE, aspect.ratio = NULL, lgd.space.x=NULL, title=NULL, verbose=TRUE) {
   # save(gg.all, sam, covis.type, gcol.lgd, size.key, size.text.key, angle.text.key, position.text.key, legend.value.vdo, sub.title.size, row, col, label, label.size, label.angle, hjust, vjust, opacity, key, aspect.ratio, lgd.space.x, title, verbose, file='gg.lgd.all')
  if (verbose==TRUE) message('Adjust legends in ggplots ...')
  feature <- x0 <- y0 <- NULL
  # Function to remove feature labels. 
  rm_label <- function(g) {    
    g.layer <- g$layer; if (length(g.layer)==1) return(g) 
    for (k in rev(seq_along(g.layer))) {
      na.lay <- unique(names(as.list(g.layer[[k]])$geom_params))
      if (all(c('check_overlap') %in% na.lay)) g$layers[[k]] <- NULL
    }; return(g)
  }
  for (i in seq_along(gg.all)) { 
    g <- gg.all[[i]]; nas <- names(gg.all); rast <- FALSE
    if (!is.null(size.key)) g <- g+theme(legend.key.height=unit(size.key, "npc"), legend.key.width=unit(size.key, "npc"), legend.text=element_text(size=ifelse(is.null(size.text.key), 8*size.key*33, size.text.key)))
    if (!is.null(sub.title.size)) g <- g+theme(plot.title=element_text(hjust=0.5, size=sub.title.size))
    if (!is.null(lgd.space.x)) g <- g+theme(legend.spacing.x = unit(lgd.space.x, 'npc'))
    if (!is.null(row)|!is.null(col)|label==TRUE|opacity!=1|!is.null(angle.text.key)|!is.null(position.text.key)|!is.null(legend.value.vdo)) {
      lay.dat <- layer_data(g); dat <- g$data
      if (nrow(lay.dat)==1) {
        lay.dat <- ggplot_build(g)$data[[2]]; rast <- TRUE 
      }
      dat <- g$data; g.col <- lay.dat$fill
      # Single cell dimensionality point plot.
      # if (all(is.na(g.col))|is.null(g.col)) g.col <- lay.dat$colour
      names(g.col) <- dat$feature
      # In videos, heat colors rather than legend colors are used, so the colors should be extracted from ggplots not the "gcol.lgd".
      # g.col <- gcol.lgd[grepl(paste0(nas[i], '$'), names(gcol.lgd))][[1]]
      df.tis <- as.vector(dat$feature)
      if (is.null(dat$value)) df.val <- NULL else df.val <- round(dat$value, 2) # Expression values.
      g.col <- g.col[!duplicated(names(g.col))]
      tis.path <- sub('__\\d+$', '', dat$feature)
      # ft.legend <- intersect(unique(sam.dat), unique(tis.path))
      # Single-cell data: length(ft.legend)==0.
      # if (length(ft.legend)==0) ft.legend <- unique(sub('__\\d+', '', names(g.col[!is.na(g.col) & !g.col=='NA'])))  
      # ft.legend <- setdiff(ft.legend, ft.trans) 
      # Identify tissues with colours: applies to regular bulk SHM and single cell.
      ft.legend <- unique(sub('__\\d+', '', names(g.col[!is.na(g.col) & !g.col=='NA'])))
      leg.idx <- !duplicated(tis.path) & (tis.path %in% ft.legend) & tis.path %in% sam
      # toBulk: sam is from cell data.
      if ('toBulk' %in% covis.type) leg.idx <- !duplicated(tis.path) & (tis.path %in% ft.legend)
      # df.tar <- df.tis[leg.idx]; lab <- path.tar <- tis.path[leg.idx]; val.tar <- df.val[leg.idx]
      trans <- g.col[g.col %in% 'NA'][1]
      tr.lab <- 'Unmeasured' 
      if (is.na(trans)) trans <- tr.lab <- NULL
      df.tar <- c(df.tis[leg.idx], names(trans))
      lab <- c(tis.path[leg.idx], tr.lab) 
      val.tar <- df.val[leg.idx]; path.tar <- tis.path[leg.idx]
      if (sum(legend.value.vdo)==1) {
        if (!is.null(val.tar)) lab <- paste0(path.tar, ' (', val.tar, ')') else lab <- path.tar
      }
      if (opacity!=1) g.col <- alpha(g.col, opacity)
      if (key==TRUE) gde <- guide_legend(title=NULL, nrow=row, ncol=col, label.theme=element_text(angle=angle.text.key, size=g$theme$legend.text$size), label.position=position.text.key)
      if (key==FALSE) gde <- FALSE
      if (!is.null(row)|!is.null(col)|opacity!=1|key==FALSE|!is.null(angle.text.key)|!is.null(position.text.key)|!is.null(legend.value.vdo)) g <- g+scale_fill_manual(values=g.col, breaks=df.tar, labels=lab, guide=gde)
      if (label==TRUE & rast==FALSE) {
        # nrow(lay.dat) >1: not superimposed with raster images.
        dat$x0 <- dat$y0 <- dat$label <- NA
        lab.idx <- dat$feature %in% path.tar
        dat1 <- dat[lab.idx, ]; dat1$label <- dat1$feature
        df.lab <- data.frame() 
        for (j in unique(dat1$feature)) {
          df0 <- subset(dat1, feature==j)
          x <- mean(df0$x); y <- mean(df0$y)
          df0$x0 <- x; df0$y0 <- y
          df.lab <- rbind(df.lab, df0)
         } 
         g <- rm_label(g)+geom_text(data=df.lab, aes(label=label, x=x0, y=y0), check_overlap=TRUE, size=label.size, angle=label.angle, hjust=hjust, vjust=vjust)
      }; gg.all[[i]] <- rm_label(g)
    } # if
    if (!is.null(title)) g <- g + labs(title=title) 
    if (label==FALSE & rast==FALSE) { g <- rm_label(g) }
    if (!is.null(aspect.ratio)) if (aspect.ratio > 0) g <- g + theme(aspect.ratio=1/aspect.ratio)
    gg.all[[i]] <- g 
  } # for 
  if (verbose==TRUE) message('Done!')
  return(gg.all)

}
