#' Draw Each Spatial Heatmap and Legend Plot
#'
#' @param gene The gene expession matrix, where rows are genes and columns are tissue/conditions.
#' @param geneV The gene expression values used to construct the colour bar.
#' @param con.na Logical, TRUE or FALSE. Default is TRUE, meaning conditions are available.
#' @param cordn The coordidates extracted from the SVG file..
#' @param raster.path The path of the template image in the form of raster/bitmap. The template is used to create aSVGs and can be overlaid with spatial heatmaps.
#' @param charcoal Logical, if \code{TRUE} the raster image will be turned black and white.
#' @param alpha.overlay The opacity of top-layer spatial heatmaps if a raster image is added at the bottom layer. The default is 1. 
#' @param ID All gene ids selected after the App is launched. 
#' @param cols All the color codes used to construct the color bar.
#' @param lis.rematch A list for rematching features. In each slot, the slot name is an existing feature in the data, and the slot contains a vector of features in aSVG that will be rematched to the feature in the slot name. \emph{E.g.} \code{list(featureData1 = c('featureSVG1', 'featureSVG2'), featureData2 = c('featureSVG3'))}, where features \code{c('featureSVG1', 'featureSVG2')}, \code{c('featureSVG3')} in the aSVG are rematched to features \code{'featureData1'}, \code{'featureData2'} in data, respectively. 
#' @param ft.trans A character vector of tissue/spatial feature identifiers that will be set transparent. \emph{E.g} c("brain", "heart"). This argument is used when target features are covered by  overlapping features and the latter should be transparent.
#' @param ft.trans.shm A character vector of aSVG feature identifiers that will be set transparent only in SHMs not legend.
#' @param sub.title.size A numeric of the subtitle font size of each individual spatial heatmap. The default is 11.
#' @param sub.title.vjust A numeric of vertical adjustment for sub title. The default is \code{2}.
#' @param ft.legend One of "identical", "all", or a character vector of tissue/spatial feature identifiers from the aSVG file. The default is "identical" and all the identical/matching tissues/spatial features between the data and aSVG file are indicated in the legend plot. If "all", all tissues/spatial features in the aSVG are shown. If a vector, only the tissues/spatial features in the vector are shown.
#' @param legend.col A character vector of colors for the keys in the legend plot. The lenght must be equal to the number of target samples shown in the legend. 
#' @param legend.ncol An integer of the total columns of keys in the legend plot. The default is NULL. If both \code{legend.ncol} and \code{legend.nrow} are used, the product of the two arguments should be equal or larger than the total number of shown spatial features.
#' @param legend.nrow An integer of the total rows of keys in the legend plot. The default is NULL. It is only applicable to the legend plot. If both \code{legend.ncol} and \code{legend.nrow} are used, the product of the two arguments should be equal or larger than the total number of matching spatial features.
#' @param legend.key.size A numeric of the legend key size ("npc"), applicable to the legend plot. The default is 0.02. 
#' @param legend.text.size A numeric of the legend label size, applicable to the legend plot. The default is 12.
#' @param line.width The thickness of each shape outline in the aSVG is maintained in spatial heatmaps, \emph{i.e.} the stroke widths in Inkscape. This argument is the extra thickness added to all outlines. Default is 0.2 in case stroke widths in the aSVG are 0.
#' @param line.color A character of the shape outline color. Default is "grey70".
#' @param legend.plot.title The title of the legend plot. The default is NULL. 
#' @param legend.plot.title.size The title size of the legend plot. The default is 11.
#' @param ... Other arguments passed to \code{\link[ggplot2]{ggplot}}.
#' @inheritParams ggplot2::theme

#' @return A nested list of spatial heatmaps of ggplot2 plot grob, spatial heatmaps of ggplot, and legend plot of ggplot.
#' @keywords Internal
#' @noRd


#' @author Jianhai Zhang \email{jzhan067@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

#' @references
#' H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016. \cr R Core Team (2018). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. RL https://www.R-project.org/ \cr Mustroph, Angelika, M Eugenia Zanetti, Charles J H Jang, Hans E Holtan, Peter P Repetti, David W Galbraith, Thomas Girke, and Julia Bailey-Serres. 2009. “Profiling Translatomes of Discrete Cell Populations Resolves Altered Cellular Priorities During Hypoxia in Arabidopsis.” Proc Natl Acad Sci U S A 106 (44): 18843–8

#' @importFrom ggplot2 ggplot aes theme element_blank margin element_rect scale_y_continuous scale_x_continuous expansion ggplotGrob geom_polygon scale_fill_manual ggtitle element_text labs guide_legend alpha coord_fixed annotation_raster theme_void element_rect
#' @importFrom parallel detectCores mclapply

gg_shm <- function(svg.all, gene, col.idp=FALSE, con.na=TRUE, geneV, tar.bulk=NULL, tar.cell=NULL, charcoal=FALSE, alpha.overlay=1, ID, cols, covis.type=NULL, lis.rematch = NULL, ft.trans=NULL, ft.trans.shm=NULL, sub.title.size, sub.title.vjust=2, ft.legend='identical', legend.ncol=NULL, legend.nrow=NULL, legend.position='bottom', legend.direction=NULL, legend.key.size=0.02, legend.text.size=12, legend.plot.title=NULL, legend.plot.title.size=11, line.width=0.2, line.color='grey70', verbose=TRUE, ...) {
  # svg_separ <- spatialHeatmap:::svg_separ
  # diff_cols <- spatialHeatmap:::diff_cols
  # value2color <- spatialHeatmap:::value2color
  # save(svg.all, gene, col.idp, con.na, geneV, tar.bulk, tar.cell, charcoal, alpha.overlay, ID, cols, covis.type, lis.rematch, ft.trans, ft.trans.shm, sub.title.size, sub.title.vjust, ft.legend, legend.ncol, legend.nrow, legend.position, legend.direction, legend.key.size, legend.text.size, legend.plot.title, legend.plot.title.size, line.width, line.color, verbose, file='gg.shm.arg')
  # Main function to create SHMs (by conditions) and legend plot.
  g_list <- function(con, lgd=FALSE, ...) {
    if (is.null(con)) { if (verbose==TRUE) cat('Legend plot ... \n') 
    } else { if (verbose==TRUE) cat(con, ' ') }
    value <- feature <- Feature <- x <- y <- NULL
    tis.df <- as.vector(unique(cordn$feature))
    # Since ggplot2 '3.3.5', 'NA' instead of NA represents transparency.
    legend.col[legend.col == 'none'] <- NA
    # tis.path and tis.df have the same length by default, but not entries, since tis.df is appended '__\\d+' at the end.
    # Assign default colours to each path.
    g.col <- rep(NA, length(tis.path)); names(g.col) <- tis.df
    gcol.na.dup <- sub('__\\d+$', '', names(g.col))
    if (lgd==FALSE) {
      # Keep global text/legend colors in the main SHM. No change on the local legend colors so they are all NA. The line widths of local legend will be set 0.
      g.col <- legend.col[grep('_globalLGD$', names(legend.col))][gcol.na.dup]
      names(g.col) <- tis.df # Resolves legend.col['feature'] is NA by default. 
      # Un-related aSVG mapped to data.
      if (rematch.dif.svg) {
        # The data column index of data features that are assinged new aSVG features under a specific condition.
        tis.tar.idx <- cname %in% paste0(tis.tar, '__', con)
        # Target features may not be profiled in every contidion.
        tis.tar <- unique(gsub('(.*)__(.*)', '\\1', cname[tis.tar.idx]))
        if (length(tis.tar)>0) {
          # In data columns, feature__conditions and colors have the same index. 
          tis.tar.col <- color.dat[tis.tar.idx]
          names(tis.tar.col) <- tis.tar
          # Copy colors of target features in data to corresponding aSVG features according to lis.rematch. 
          col.ft.rematch <- NULL; for (i in names(lis.rematch[tis.tar])) {
            ft.svg <- lis.rematch[tis.tar][[i]]
            col0 <- rep(tis.tar.col[i], length(ft.svg))
            names(col0) <- ft.svg
            col.ft.rematch <- c(col.ft.rematch, col0)
          }
          for (i in names(col.ft.rematch)) g.col[tis.path %in% i] <- col.ft.rematch[i]
        }
       } else {
        con.idx <- grep(paste0("^", con, "$"), cons)
        # Target tissues and colors in data columns.
        tis.col1 <- tis.col[con.idx]
        color.dat1 <- color.dat[con.idx]
        for (i in unique(tis.path)) {
          # Map target colors to target tissues.
          tis.idx <- which(tis.col1 %in% i)
          if (length(tis.idx)==1) {
            # Account for single-shape feature without '__\\d+$' and multi-shape feature with '__\\d+$'.
            pat <- paste0(paste0('^', i, '$'), '|', paste0('^', i, '__\\d+$'))
            g.col[grep(pat, tis.df)] <- color.dat1[tis.idx] # names(g.col) is tis.df 
          }
        }
        # Rematch features between the same pair of data-aSVG.
        if (is.list(lis.rematch) & FALSE %in% col.idp) {
          for (i in seq_along(lis.rematch)) {
            lis0 <- lis.rematch[i]; if (!is.character(lis0[[1]])) next
            # Color for remathing: picked up from original color pool.
            col0 <- color.dat[paste0(names(lis0), '__', con)]
            # Rematching. 
            g.col[tis.path %in% lis0[[1]]] <- col0
           }
         }
       }
      # lis.rematch: data feature (names(lis.rematch)) in tis.path but not in the matched SVG feature is set NA.
      if (is(lis.rematch, 'list') & FALSE %in% col.idp) {
        match.na <- names(lis.rematch); match.ft.uni <- unique(unlist(lis.rematch)) 
        dat.ft.no <- match.na[match.na %in% unique(tis.path) & (!match.na %in% match.ft.uni)]
        g.col[gcol.na.dup %in% dat.ft.no] <- NA
      }
      # Covis independent coloring.
      if (TRUE %in% col.idp) {
        if ('toBulk' %in% covis.type) {
          g.col[!gcol.na.dup %in% unlist(lis.rematch[tar.cell])] <- NA
        } else if ('toCell' %in% covis.type) {
          g.col[!gcol.na.dup %in% tar.bulk] <- NA
        }
      }
    } 
    # The colors might be internally re-ordered alphabetically during mapping, so give them names to fix the match with tissues. E.g. c('yellow', 'blue') can be re-ordered to c('blue', 'yellow'), which makes tissue mapping wrong. Correct: colours are not re-ordered. The 'tissue' in 'data=cordn' are internally re-ordered according to a factor. Therfore, 'tissue' should be a factor with the right order. Otherwise, disordered mapping can happen. Alternatively, name the colors with corresponding tissue names.
    # aes() is passed to either ggplot() or specific layer. Aesthetics supplied to ggplot() are used as defaults for every layer. 
    # Show selected or all samples in legend.
    if (length(ft.legend)==1) if (ft.legend=='identical') {
      ft.legend <- intersect(sam.uni, unique(tis.path))
      if (rematch.dif.svg | is(lis.rematch, 'list')) {
        ft.legend.remat <- intersect(unlist(lis.rematch), unique(tis.path)) 
      } else ft.legend.remat <- NULL
      ft.legend <- unique(c(ft.legend, ft.legend.remat))
    } else if (ft.legend=='all') ft.legend <- unique(tis.path)
    
    ft.trans <- unique(c(ft.trans, ft.trans.shm))
    if (lgd==FALSE) { # Legend plot.
      # Make selected tissues transparent by setting their colours NA.
      if (!is.null(ft.trans)) g.col[sub('__\\d+$', '', tis.df) %in% ft.trans] <- NA # This step should not be merged with 'lgd=TRUE'.
      ft.legend <- setdiff(ft.legend, ft.trans) 
      leg.idx <- !duplicated(tis.path) & (tis.path %in% ft.legend)
      # Bottom legends are set for each SHM and then removed in 'ggplotGrob', but a copy with legend is saved separately for later use in video.
      # Since ggplot2 '3.3.5', 'NA' instead of NA represents transparency.
      g.col[is.na(g.col)] <- 'NA'
      scl.fil <- scale_fill_manual(values=g.col, breaks=tis.df[leg.idx], labels=tis.path[leg.idx], guide=guide_legend(title=NULL, ncol=legend.ncol, nrow=legend.nrow))
    } else { 
      # Assign legend key colours if identical samples between SVG and matrix have colors of "none".
      legend.col1 <- legend.col[ft.legend] # Only includes features to show. 
      if (any(is.na(legend.col1))) {
        n <- sum(is.na(legend.col1)); col.na <- diff_cols(n) 
        legend.col1[is.na(legend.col1)] <- col.na[seq_len(n)]
      }
      # toBulk: if one cell label is mapped to multiple bulk tissues, these multiple bulk tissues need to have the same color. legend.col1: tissue to show in legend, so only change colors in legend.col1 rather than legend.col.
      if (!is.null(covis.type)) {
        if (covis.type=='toBulk' & is(lis.rematch, 'list')) {
          for (i in seq_along(lis.rematch)) {
            lis0  <- lis.rematch[[i]]
            if (length(lis0) > 0) {
              legend.col1[lis0] <- legend.col1[lis0][1]
            }; remove(lis0)
        }
      }
      if (TRUE %in% col.idp & is(lis.rematch, 'list')) {
        if ('toBulk' %in% covis.type) ft.trans <- unique(c(ft.trans, setdiff(tis.path, unlist(lis.rematch))))
        if ('toCell' %in% covis.type) ft.trans <- unique(c(ft.trans, setdiff(tis.path, names(lis.rematch))))
      }
      # if (covis.type %in% c('toBulk', 'toCell')) ft.trans <- unique(c(ft.trans, ft.trans.shm))
      }
       # Map legend colours to tissues.
       # Exclude transparent tissues.
       ft.legend <- setdiff(ft.legend, ft.trans) 
       leg.idx <- !duplicated(tis.path) & (tis.path %in% ft.legend)
       legend.col1 <- legend.col1[ft.legend]
       # Keep all colors in the original SVG.
       g.col <- legend.col[gcol.na.dup]
       names(g.col) <- tis.df # Resolves "legend.col['feature'] is NA" by default.
       # g.col[g.col=='none'] <- NA 
       # Make selected tissues transparent by setting their colours NA.
       if (!is.null(ft.trans)) g.col[sub('__\\d+$', '', tis.df) %in% ft.trans] <- NA
       # Copy colors across same numbered tissues. 
       g.col <- lapply(seq_along(g.col), function(x) {
         # In lapply each run must return sth.
         if (!is.na(g.col[x])) return(g.col[x])
         g.col0 <- legend.col1[sub('__\\d+$', '', names(g.col[x]))]
         if (!is.na(g.col0)) g.col[x] <- g.col0
         return(g.col[x])
         } 
       ); g.col <- unlist(g.col)
       # No matter the tissues in coordinate data frame are vector or factor, the coloring are decided by the named color vector (order of colors does not matter as long as names are right) in scale_fill_manual.
       # Since ggplot2 '3.3.5', 'NA' instead of NA represents transparency.
       g.col[is.na(g.col)] <- 'NA'
       trans <- g.col[g.col %in% 'NA'][1]; tr.lab <- 'Unmeasured'
       if (is.na(trans)) trans <- tr.lab <- NULL
       br <- c(tis.df[leg.idx], names(trans))
       br.lab <- c(tis.path[leg.idx], tr.lab) 
       scl.fil <- scale_fill_manual(values=g.col, breaks=br, labels=br.lab, guide=guide_legend(title=NULL, ncol=legend.ncol, nrow=legend.nrow)) 
    }
    lgd.par <- theme(legend.position=legend.position, legend.direction=legend.direction, legend.background = element_rect(fill=alpha(NA, 0)), legend.key.height=unit(legend.key.size, "npc"), legend.key.width=unit(legend.key.size, "npc"), legend.text=element_text(size=legend.text.size), legend.margin=margin(l=0.1, r=0.1, unit='npc'))
    ## Add 'feature' and 'value' to coordinate data frame, since the resulting ggplot object is used in 'ggplotly'. Otherwise, the coordinate data frame is applied to 'ggplot' directly by skipping the following code.
    cordn$gene <- k; cordn$condition <- con; cordn$value <- NA
    cordn$Feature <- sub('__\\d+$', '', cordn$feature)
    # Assign values to each tissue.
    if (!is.null(con) | lgd==FALSE) {
      col.na <- paste0(cordn$Feature, '__', cordn$condition)
      idx1 <- col.na %in% colnames(gene)
      if (sum(idx1) > 0) {
      df0 <- cordn[idx1, ]
      # df0$value <- unlist(gene[df0$gene[1], col.na[idx1]]) # Slow in large data.
      col.na1 <- unique(col.na[idx1])
      tab0 <- table(col.na[idx1])[col.na1]
      lis.v <- lapply(col.na1, function(i) { rep(gene[df0$gene[1], i], tab0[i][[1]]) } )
      df0$value <- unlist(lis.v); cordn[idx1, ] <- df0
      }
    }
    cordn$line.width <- cordn$line.width+line.width
    # Set the widths of text-similar legends to 0.1. If larger than 0.1, there could be noisy lines.
    idx.txt.lgd <- grepl('_localLGD$|_localLGD__\\d+$|_globalLGD$|_globalLGD__\\d+$', cordn$feature)
    cordn$line.width[idx.txt.lgd] <- 0.1
    if (lgd==FALSE) { # Set line size as 0 for local legends. 
      idx.local <- grepl('_localLGD$|_localLGD__\\d+$', cordn$feature)
      cordn$line.width[idx.local] <- 0
    }
    # No need to move colored features on top, since un-colored features are transparent.
    # tis.mat <- names(g.col[!grepl('NA', g.col)])
    # if (length(tis.mat)>0) {
    #  idx.mat <- cordn$feature %in% tis.mat 
    #  cordn <- rbind(cordn[!idx.mat, ], cordn[idx.mat, ])
    # }
    # In geom_polygon, the order to plot tissues is the factor level. If a tissue is the 1st according to factor level but is last in the coordinate data frame, it will be plotted first, and the 2nd tissue in the level can cover it if all tissues are colored.
    # cordn$feature <- as.vector(cordn$feature)
    cordn$feature <- factor(cordn$feature, levels=unique(as.vector(cordn$feature))) 
    # If "data" is not in ggplot(), g$data slot is empty. x, y, and group should be in the same aes(). 
    g <- ggplot(data=cordn, aes(x=x, y=y, value=value, group=feature, text=paste0('feature: ', Feature, '\n', 'value: ', value)), ...)+raster.g+geom_polygon(aes(fill=feature), color=line.color, linewidth=cordn$line.width, linetype='solid', alpha=alpha.overlay)+scl.fil+theme_void()+theme(plot.title=element_text(hjust=0.5, vjust=sub.title.vjust, size=sub.title.size), plot.margin=margin(0.005, 0.005, 0.005, 0.005, "npc"), legend.box.margin=margin(-3, 0, 2, 0, unit='pt'), legend.background=element_rect(color=NA, fill='transparent'), aspect.ratio = 1/aspect.ratio)+labs(x="", y="")+scale_y_continuous(expand=expansion(mult=c(0, 0)))+scale_x_continuous(expand=expansion(mult=c(0, 0)))+lgd.par

    # The aspect ratio should not be calculated by margins that are inferred from original width/height (mar.lb <- (1-w.h/w.h.max*0.99)/2). It works on single plot, but will squeeze the subplots in arrangeGrob/grid.arrange. Rather the "aspect ratio" in theme should be used, which will not squeeze subplots.
    # After theme(aspect.ratio) is set, change in only top or left margin will not distort the image. Rather width/height will scale propotionally, since the aspect ratio is fixed.
    # if (is.null(mar.lb)) g <- g+theme(plot.margin=margin(0.005, 0.005, 0.005, 0.005, "npc")) else g <- g+theme(plot.margin=margin(mar.lb[2], mar.lb[1], mar.lb[2], mar.lb[1], "npc"))
    if (con.na==FALSE) g.tit <- ggtitle(k) else g.tit <- ggtitle(paste0(k, "_", con)); g <- g+g.tit
    if (lgd==TRUE) {
      g <- g+theme(plot.margin=margin(0.005, 0.005, 0.2, 0, "npc"), plot.title=element_text(hjust=0.5, vjust=sub.title.vjust, size=legend.plot.title.size))+ggtitle(legend.plot.title)
    }; return(list(g=g, g.col=g.col))
  }

  svg.sel <- svg_separ(svg.all)
  cordn <- svg.sel$cordn; tis.path <- svg.sel$tis.path
  legend.col <- svg.sel$fil.cols; raster.path <- svg.sel$raster.path 
  aspect.ratio <- svg.sel$aspect.r

  # Map colours to samples according to expression level.
  # Column names without '__' are not excluded so as to keep one-to-one match with color.dat.
  cname <- colnames(gene)
  cons <- gsub("(.*)(__)(.*)", "\\3", cname)
  sam.uni <- unique(gsub("(.*)(__)(.*)", "\\1", cname)); ft.trans <- make.names(ft.trans)
  # Template image.
  raster.g <- NULL; if (is.character(raster.path)) if (all(file.exists(raster.path))) {
    pkg <- check_pkg('magick'); if (is(pkg, 'character')) stop(pkg)
    raster <- magick::image_read(raster.path)
    if (charcoal==TRUE) raster <- magick::image_charcoal(raster)
    raster.g <- annotation_raster(raster, -Inf, Inf, -Inf, Inf)
  }

  g.lis.all <- gcol.lis.all <- NULL; for (k in ID) {
    # Match color key values to selected genes.
    color.dat <- value2color(gene[k, , drop=FALSE], geneV, cols)

    # idx <- grep("__", cname); c.na <- cname[idx]
    # Column names without '__' are also included so as to keep one-to-one match with color.dat.
    tis.col <- gsub("(.*)(__)(.*)", "\\1", cname)
    # Valid/target tissues.
    tis.col.uni <- unique(tis.col); tis.path.uni <- unique(tis.path)
    tis.col.path.idx <- tis.col.uni %in% tis.path.uni
    tis.tar <- tis.col.uni[tis.col.path.idx]
    # Un-related aSVG mapped to data.
    rematch.dif.svg <- is.list(lis.rematch) & length(tis.tar)==0
    if (rematch.dif.svg) {
      # Take the features in data that are assinged new aSVG features.
      tis.tar <- unlist(lapply(names(lis.rematch), function(i) {
        vec0 <- lis.rematch[[i]]
        if (!is.null(vec0)) if (any(vec0 %in% tis.path.uni)) return(i)
      }))
    }; if (length(tis.tar)==0) return(NULL)
    cname1 <- cname[grepl(paste0('^(', paste0(tis.tar, collapse='|'), ')__'), cname)]
    if (length(cname1)==0) return()
    # Only conditions paired with valid tissues (have matching samples in data) are used. 
    con.vld <- gsub("(.*)(__)(.*)", "\\3", cname1); con.vld.uni <- unique(con.vld)
    na0 <- paste0(k, "_", con.vld.uni); if (verbose==TRUE) cat('ggplot: ', k, ', ', sep = '')
    g.lis <- lapply(con.vld.uni, g_list, ...); if (verbose==TRUE) cat('\n')
    # ggplots.
    gg.lis <- lapply(g.lis, function(x) return(x$g))
    names(gg.lis) <- na0; g.lis.all <- c(g.lis.all, gg.lis)
    # Spatial feature Colors. 
    gcol.lis <- lapply(g.lis, function(x) return(x$g.col))
    names(gcol.lis) <- paste0('col_', na0); gcol.lis.all <- c(gcol.lis.all, gcol.lis)
  }; g.lgd.lis <- g_list(con=NULL, lgd=TRUE, ...) 
  g.lgd <- g.lgd.lis$g; gcol.lgd <- g.lgd.lis$g.col
  return(list(g.lgd = g.lgd, gcol.lgd=gcol.lgd, g.lis.all = g.lis.all, gcol.lis.all=gcol.lis.all))
}

#' Convert SHMs of Ggplot to Grobs
#'
#' @param gg.lis A list of SHMs of ggplot, returned by \code{\link{gg_shm}}.
#' @param cores The number of CPU cores for parallelization, relevant for aSVG files with size larger than 5M. The default is NA, and the number of used cores is 1 or 2 depending on the availability.
#' @param lgd.pos Legend position, one of \code{none}, \code{right}, \code{left}, \code{top}, \code{bottom}.
#' @return A list of grob SHMs.
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jzhan067@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

#' @importFrom parallel detectCores mclapply

grob_shm <- function(gg.lis, cores=1, lgd.pos='none', verbose=TRUE) {
  # save(gg.lis, cores, lgd.pos, file='grob.shm.arg')
  tmp <- normalizePath(tempfile(), winslash='/', mustWork=FALSE)
  if (verbose==TRUE) cat('Converting "ggplot" to "grob" ... \n')
  # mclapply does not give speed gain here.
  # Child jobs (on each core) are conducted in different orders, which can be reflected by "cat", but all final jobs are assembled in the original order.
  # Repress popups by saving it to a png file, then delete it.
  nas <- names(gg.lis)
  png(tmp); if (!is.na(cores)) grob.lis <- mclapply(seq_along(gg.lis), function(x) {
    if (verbose==TRUE) cat(nas[x], ' '); x <- gg.lis[[x]]
    # Remove legends in SHMs.
    if (!is.null(lgd.pos)) x <- x + theme(legend.position=lgd.pos); ggplotGrob(x) 
  }, mc.cores=cores) else { 
  grob.lis <- lapply(seq_along(gg.lis), function(x) {
    if (verbose==TRUE) cat(nas[x], ' '); x <- gg.lis[[x]]
    # Remove legends in SHMs.
    if (!is.null(lgd.pos)) x <- x + theme(legend.position=lgd.pos); ggplotGrob(x) 
  }) }; dev.off(); if (verbose==TRUE) cat('\n')
  names(grob.lis) <- nas; return(grob.lis)
}

#' Extract contrasting colors.
#'
#' @param n Total number of contasting colors required.
#' @return A a vector of contrasting colors.
#' @keywords Internal
#' @noRd

#' @author Jianhai Zhang \email{jzhan067@@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@@ucr.edu}

#' @importFrom grDevices colors

diff_cols <- function(n) {
  col.all <- grDevices::colors()[grep('lightyellow3|seashell4|honeydew|aliceblue|white|gr(a|e)y|lightsteelblue|lightsteelblue(1|2)', grDevices::colors(), invert=TRUE)]
  col.na <- col.all[seq(from=1, to=length(col.all), by=floor(length(col.all)/n))]; return(col.na)
}


#' Extract SVG attributes for plotting SHMs.
#'
#' @param svg.all A \code{coord} object containing only one SVG instance. 
#' @return A a list.
#' @keywords Internal
#' @noRd

#' @references
#' Wickham H, François R, Henry L, Müller K (2022). _dplyr: A Grammar of Data Manipulation_. R package version 1.0.9, <https://CRAN.R-project.org/package=dplyr>
#' @importFrom dplyr mutate %>%

svg_separ <- function(svg.all) {
  feature <- NULL
  g.df <- coordinate(svg.all)[[1]]; dimen <- dimension(svg.all)[[1]] 
  aspect.r <- dimen['width']/dimen['height']
  names(aspect.r) <- NULL
  # Multiple shapes with suffix "'__\\d+$" may represent the same feature, so "unique" should be in "sub" not outside "sub". If not, these shapes will be collapsed to one. 
  tis.path <- sub('__\\d+$', '', unique(as.vector(g.df$feature)));
  df.attr <- attribute(svg.all)[[1]][, c('feature', 'fill', 'stroke')]
  df.attr <- df.attr[!duplicated(df.attr), ]
  fil.cols <- df.attr$fill; names(fil.cols) <- df.attr$feature
  if (!'line.width' %in% colnames(g.df)) {    
    g.df <- g.df %>% mutate(line.width=cvt_vector(df.attr$feature, df.attr$stroke, sub('__\\d+$', '', feature)))
  }
  raster.pa <- raster_pa(svg.all)
  if (length(raster.pa)==0) raster.pa <- NULL else if (length(raster.pa) > 0) raster.pa <- raster.pa[[1]] 
  return(list(cordn=g.df, tis.path=tis.path, fil.cols=fil.cols, raster.path=raster.pa, aspect.r=aspect.r))
}


#' Translate expression values to colors.
#'
#' @param data Assay matrix of one row.
#' @param values,colors All numeric values and colors in the color key.
#' @return A vector of colors.
#' @keywords Internal
#' @noRd

value2color <- function(data, values, colors) {
  data <- as.matrix(data)
  color.dat <- NULL; for (i in data) { 
    ab <- abs(i-values); col.ind <- which(ab==min(ab))[1]
    color.dat <- c(color.dat, colors[col.ind])
  }; names(color.dat) <- colnames(data); return(color.dat)
}

