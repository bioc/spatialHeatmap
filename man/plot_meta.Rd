% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/covis.R
\name{plot_meta}
\alias{plot_meta}
\title{Meta function for plotting spatial heatmaps or co-visualizing bulk and single cell data}
\usage{
plot_meta(
  svg.path,
  bulk,
  cell = NULL,
  match.lis = NULL,
  assay.na = NULL,
  sam.factor = NULL,
  con.factor = NULL,
  aggr = "mean",
  ID,
  var.cell = NULL,
  dimred = "PCA",
  cell.group = NULL,
  tar.cell = NULL,
  tar.bulk = NULL,
  size.pt = 1,
  alpha.pt = 0.8,
  shape = NULL,
  col.idp = FALSE,
  decon = FALSE,
  profile = TRUE,
  charcoal = FALSE,
  alpha.overlay = 1,
  lay.shm = "gene",
  ncol = 2,
  h = 0.99,
  size.r = 1,
  col.com = c("yellow", "orange", "red"),
  col.bar = "selected",
  thr = c(NA, NA),
  cores = NA,
  bar.width = 0.08,
  bar.title = NULL,
  bar.title.size = 0,
  scale = "no",
  ft.trans = NULL,
  tis.trans = ft.trans,
  legend.r = 0,
  lgd.plots.size = NULL,
  sub.title.size = 11,
  sub.title.vjust = 3,
  legend.plot = "all",
  ft.legend = "identical",
  bar.value.size = 10,
  legend.plot.title = "Legend",
  legend.plot.title.size = 11,
  legend.ncol = NULL,
  legend.nrow = NULL,
  legend.position = "bottom",
  legend.direction = NULL,
  legend.key.size = 0.02,
  legend.text.size = 12,
  angle.text.key = NULL,
  position.text.key = NULL,
  legend.2nd = FALSE,
  position.2nd = "bottom",
  legend.nrow.2nd = 2,
  legend.ncol.2nd = NULL,
  legend.key.size.2nd = 0.03,
  legend.text.size.2nd = 10,
  angle.text.key.2nd = 0,
  position.text.key.2nd = "right",
  dim.lgd.pos = "bottom",
  dim.lgd.nrow = 2,
  dim.lgd.key.size = 4,
  dim.lgd.text.size = 13,
  dim.axis.font.size = 8,
  dim.capt.size = 13,
  size.lab.pt = 5,
  hjust.lab.pt = 0.5,
  vjust.lab.pt = 1.5,
  add.feature.2nd = FALSE,
  label = FALSE,
  label.size = 4,
  label.angle = 0,
  hjust = 0,
  vjust = 0,
  opacity = 1,
  key = TRUE,
  line.width = 0.2,
  line.color = "grey70",
  relative.scale = NULL,
  out.dir = NULL,
  animation.scale = 1,
  selfcontained = FALSE,
  aspr = 1,
  video.dim = "640x480",
  res = 500,
  interval = 1,
  framerate = 1,
  bar.width.vdo = 0.1,
  legend.value.vdo = NULL,
  verbose = TRUE,
  ...
)
}
\arguments{
\item{svg.path}{File paths of aSVG files.}

\item{bulk, cell}{File paths of bulk and single cell data that are saved with \link{saveRDS} respectively.}

\item{match.lis}{The file path of matching list that is saved with \link{saveRDS}. See \code{match} in \link{SPHM}.}

\item{assay.na}{The name of target assay to use when \code{data} is \code{SummarizedExperiment}.}

\item{sam.factor}{The column name corresponding to spatial features in \code{colData} of \code{SummarizedExperiment}. If the column names in the \code{assay} slot already follows the scheme "spatialFeature__variable", then the \code{colData} slot is not required and accordingly this argument could be NULL.}

\item{con.factor}{The column name corresponding to experimental variables in \code{colData} of \code{SummarizedExperiment}. It can be NULL if column names of in the \code{assay} slot already follows the scheme "spatialFeature__variable", or no variable is associated with the data.}

\item{aggr}{Aggregate "sample__condition" replicates by "mean" or "median". The default is "mean". If the \code{data} argument is a \code{SummarizedExperiment}, the "sample__condition" replicates are internally formed by connecting samples and conditions with "__" in \code{colData} slot, and are subsequently replace the original column names in \code{assay} slot. If no condition specified to \code{con.factor}, the data are aggregated by sample replicates. If "none", no aggregation is applied.}

\item{ID}{A character vector of assyed items (\emph{e.g.} genes, proteins) whose abudance values are used to color the aSVG.}

\item{var.cell}{The column name in the \code{colData} slot of \code{SingleCellExperiment} that indicates the experimental variables. If \code{NULL}, no variables are considered.}

\item{dimred}{One of \code{PCA}, \code{UMAP}, \code{TSNE} in \code{sce.dimred}, specifying which reduced dimension to use in co-visualization plots.}

\item{cell.group}{Applicable when co-visualizing bulk and single-cell data with cell grouping methods of annodation labels, marker genes, clustering, or manual assignments. A column name in \code{colData(sce.dimred)}, where one label defines a cell group.}

\item{tar.cell}{Applicable when co-visualizing bulk and single-cell data with cell-to-bulk mapping. A vector of cell group labels in \code{cell.group} which are mapped to tissues through \code{lis.rematch}. Cells corresponding to these labels will be colored in the embedding plot while other cells will be grey, and tissues corresponding to these labels will be colored in the SHM while other tissues will be transparent.}

\item{tar.bulk}{A vector of tissues of interest, which are mapped to single cells through cell group labels with \code{lis.rematch}. These tissues will be colored in SHMs while other tissues will be transparent, and cells corresponding to these tissues will be colored embedding plots while other cells will be grey.}

\item{size.pt, alpha.pt}{The size and alpha value of points in the embedding plot respectively.}

\item{shape}{A named numeric vector of custom shapes for points in the embedding plot, where the names are the cluster labels and values are from \code{c(0, 2:25, 32:127)}.}

\item{col.idp}{Logical, if \code{TRUE}, each cell in the embedding plot and spatial feature in the SHM are colored independently according the expression values of chosen biomolecules.}

\item{decon}{Logical, if \code{TRUE}, the cell data will be considered from bulk deconvolution results.}

\item{profile}{Logical, applicable when co-visualizing bulk and single-cell data. If \code{TRUE}, one or multiple biomolecule (e.g. gene) identifiers need to be assigned to \code{ID}, and their abundance proifles will be used for coloring in the co-visualization plots. If \code{FALSE}, constant colors will be used in the co-visualization plot.}

\item{charcoal}{Logical, if \code{TRUE} the raster image will be turned black and white.}

\item{alpha.overlay}{The opacity of the raster image under the SHM when superimposing raster images with SHMs. The default is 1.}

\item{lay.shm}{One of `gene`, `con`, or `none`. If `gene`, SHMs are organized horizontally by each biomolecule (gene, protein, or metabolite, \emph{etc.}) and variables are sorted under each biomolecule. If `con`, SHMs are organized horizontally by each experiment vairable and biomolecules are sorted under each variable. If `none`, SHMs are organized by the biomolecule order in \code{ID} and variables follow the order they appear in \code{data}.}

\item{ncol}{The number of columns to display SHMs, which does not include the legend plot.}

\item{h}{The height (0-1) of color key and SHM/co-visualization plots in the middle, not including legend plots.}

\item{size.r}{The scaling ratio (0-1) of tissue section when visualizing the spatially resolved single-cell data.}

\item{col.com}{A vector of color components used to build the color scale. The default is `c('yellow', 'orange', 'red')`.}

\item{col.bar}{One of `selected` or `all`, the former uses expression values of \code{ID} to build the color scale while the latter uses all expression values from the data. The default is `selected`.}

\item{thr}{A two-numeric vector of expression value thresholds (the range of the color bar). The first and the second element will be the minmun and maximum threshold in the color bar respectively. Values above the max or below min will be assigned the same color as the max or min respectively. The default is \code{c(NA, NA)} and the min and max values in the data will be used. If one needs to change only max or min, the other should be \code{NA}.}

\item{cores}{The number of CPU cores for parallelization. The default is `NA`, and the number of used cores is 1 or 2 depending on the availability.}

\item{bar.width}{The width of color bar that ranges from 0 to 1. The default is 0.08.}

\item{bar.title, bar.title.size}{The title and title size of the color key.}

\item{scale}{One of \code{no} (default), \code{selected}, \code{all}, or \code{row}, corresponding to no scaling, scaling selected rows as a whole, scaling all rows as a whole, or scaling each row independently.}

\item{ft.trans}{A character vector of spatial features that will be set transparent. When features of interest are covered by overlapping features on the top layers and the latter can be set transparent.}

\item{tis.trans}{This argument is deprecated and replaced by \code{ft.trans}.}

\item{legend.r}{A numeric (-1 to 1) to adjust the legend plot size.}

\item{lgd.plots.size}{A vector of 2 or 3 numeric values that sum up between 0 and 1 (e.g., `c(0.5, 0.4)`), corresponding to the sizes of legend plots in the co-visualization plot. If there are 2 values, the first and second values correspond to the sizes of the SHM and embedding plots, respectively. If there are 3 values, the first, second, and third values correspond to the sizes of the SHM, single-cell SHM, and embedding plots, respectively.}

\item{sub.title.size}{A numeric of the subtitle font size of each individual spatial heatmap. The default is 11.}

\item{sub.title.vjust}{A numeric of vertical adjustment for subtitle. The default is \code{2}.}

\item{legend.plot}{A vector of suffix(es) of aSVG file name(s) such as \code{c('shm1', 'shm2')}. Only aSVG(s) whose suffix(es) are assigned to this arugment will have a legend plot on the right. The default is \code{all} and each aSVG will have a legend plot. If NULL, no legend plot is shown.}

\item{ft.legend}{One of "identical", "all", or a character vector of tissue/spatial feature identifiers from the aSVG file. The default is "identical" and all the identical/matching tissues/spatial features between the data and aSVG file are colored in the legend plot. If "all", all tissues/spatial features in the aSVG are shown. If a vector, only the tissues/spatial features in the vector are shown.}

\item{bar.value.size}{A numeric of value size in the y-axis of the color bar. The default is 10.}

\item{legend.plot.title}{The title of the legend plot. The default is 'Legend'.}

\item{legend.plot.title.size}{The title size of the legend plot. The default is 11.}

\item{legend.ncol}{An integer of the total columns of keys in the legend plot. The default is NULL. If both \code{legend.ncol} and \code{legend.nrow} are used, the product of the two arguments should be equal or larger than the total number of shown spatial features.}

\item{legend.nrow}{An integer of the total rows of keys in the legend plot. The default is NULL. It is only applicable to the legend plot. If both \code{legend.ncol} and \code{legend.nrow} are used, the product of the two arguments should be equal or larger than the total number of matching spatial features.}

\item{legend.position}{the default position of legends ("none", "left",
"right", "bottom", "top", "inside")}

\item{legend.direction}{layout of items in legends ("horizontal" or
"vertical")}

\item{legend.key.size}{A numeric of the legend key size ("npc"), applicable to the legend plot. The default is 0.02.}

\item{legend.text.size}{A numeric of the legend label size, applicable to the legend plot. The default is 12.}

\item{angle.text.key}{Key text angle in legend plots. The default is NULL, equivalent to 0.}

\item{position.text.key}{The position of key text in legend plots, one of `top`, `right`, `bottom`, `left`. Default is NULL, equivalent to `right`.}

\item{legend.2nd}{Logical. If `TRUE`, the secondary legend is added to each SHM, which are the numeric values of each colored spatial features. The default its `FALSE`. Only applies to the static image.}

\item{position.2nd}{The position of the secondary legend in SHMs, one of `top`, `right`, `bottom`, `left`, or a two-component numeric vector. The default is `bottom`. Applies to images and videos.}

\item{legend.nrow.2nd}{An integer of rows of the secondary legend keys in SHMs. Applies to static images and videos.}

\item{legend.ncol.2nd}{An integer of columns of the secondary legend keys in SHMs. Applies to static images and videos.}

\item{legend.key.size.2nd}{A numeric of legend key size in SHMs. The default is 0.03. Applies to static images and videos.}

\item{legend.text.size.2nd}{A numeric of the secondary legend text size in SHMs. The default is 10. Applies to static images and videos.}

\item{angle.text.key.2nd}{Angle of the key text in the secondary legend in SHMs. Default is 0. Applies to static images and videos.}

\item{position.text.key.2nd}{The position of key text in the secondary legend in SHMs, one of `top`, `right`, `bottom`, `left`. Default is `right`. Applies to static images and videos.}

\item{dim.lgd.pos}{The position of legends in the embedding plot. One of \code{top}, \code{right}, \code{bottom}, and \code{left}.}

\item{dim.lgd.nrow}{The number of rows in the embedding plot legends.}

\item{dim.lgd.key.size, dim.lgd.text.size}{The key and font size of the embedding plot legends respectively.}

\item{dim.axis.font.size}{The size of axis font of the embedding plot.}

\item{dim.capt.size}{The size of caption text in the dimension reduction plot in co-clustering (see \code{\link{cocluster}}). The default is \code{13}.}

\item{size.lab.pt}{The size of point labels, applicable when \code{decon=TRUE}.}

\item{hjust.lab.pt, vjust.lab.pt}{Numeric values to adjust the horizontal and vertical positions of point labels respectively, applicable when \code{decon=TRUE}.}

\item{add.feature.2nd}{Logical. If `TRUE`, feature identifiers are added to the secondary legend. The default is FALSE. Applies to static images of SHMs.}

\item{label}{Logical. If `TRUE`, the same spatial features between numeric data and aSVG are labeled by their identifiers. The default is `FALSE`. It is useful when spatial features are labeled by similar colors.}

\item{label.size}{The size of spatial feature labels in legend plots. The default is 4.}

\item{label.angle}{The angle of spatial feature labels in legend plots. Default is 0.}

\item{hjust, vjust}{The value to horizontally or vertically adjust positions of spatial feature labels in legend plots respectively. Default of both is 0.}

\item{opacity}{The transparency of colored spatial features in legend plots. Default is 1. If 0, features are totally transparent.}

\item{key}{Logical. If `TRUE` (default), keys are added in legend plots. If \code{label} is TRUE, the keys could be removed.}

\item{line.width}{The thickness of each shape outline in the aSVG is maintained in spatial heatmaps, \emph{i.e.} the stroke widths in Inkscape. This argument is the extra thickness added to all outlines. Default is 0.2 in case stroke widths in the aSVG are 0.}

\item{line.color}{A character of the shape outline color. Default is "grey70".}

\item{relative.scale}{A numeric to adjust the relative sizes between multiple aSVGs. Applicable only if multiple aSVGs are provided. Default is \code{NULL} and all aSVGs have the same size.}

\item{out.dir}{The directory to save SHMs as interactive HTML files and videos. Default is `NULL`, and the HTML files and videos are not saved.}

\item{animation.scale}{A numeric to scale the SHM size in the HTML files. The default is 1, and the height is 550px and the width is calculated according to the original aspect ratio in the aSVG file.}

\item{selfcontained}{Whether to save the HTML as a single self-contained file
(with external resources base64 encoded) or a file with external resources
placed in an adjacent directory.}

\item{aspr}{The aspect ratio (width to height) in the interative HTML files.}

\item{video.dim}{A single character of the dimension of video frame in form of 'widthxheight', such as '1920x1080', '1280x800', '320x568', '1280x1024', '1280x720', '320x480', '480x360', '600x600', '800x600', '640x480' (default). The aspect ratio of SHMs are decided by \code{width} and \code{height}.}

\item{res}{Resolution of the video in dpi.}

\item{interval}{The time interval (seconds) between SHM frames in the video. Default is 1.}

\item{framerate}{An integer of video framerate in frames per seconds. Default is 1. Larger values make the video smoother.}

\item{bar.width.vdo}{The color bar width (0-1) in videos.}

\item{legend.value.vdo}{Logical. If `TRUE`, numeric values of colored spatial features are added to the video legend. The default is NULL.}

\item{verbose}{Logical. If `TRUE` (default), intermediate messages will be printed.}

\item{...}{additional element specifications not part of base ggplot2. In general,
these should also be defined in the \verb{element tree} argument. \link[rlang:splice]{Splicing} a list is also supported.}
}
\value{
A `SPHM` class.
}
\description{
This is a meta function for plotting spatial heatmaps or co-visualizing bulk and single cell data that takes as input file paths of assay data and aSVG files.
}
\examples{

# Path of mouse brain aSVG.
svg.mus.brain.pa <- system.file("extdata/shinyApp/data", "mus_musculus.brain.svg", package="spatialHeatmap")
# Bulk data path.
blk.mus.pa <- system.file("extdata/shinyApp/data", "bulk_mouse_cocluster.rds", package="spatialHeatmap") 
# Plotting spatial heatmaps.
plot_meta(svg.path=svg.mus.brain.pa, bulk=blk.mus.pa, sam.factor='tissue', aggr='mean', ID=c('AI593442', 'Adora1'), ncol=1, bar.width=0.1, legend.nrow=5, h=0.6)

}
\author{
Jianhai Zhang \email{jzhan067@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@ucr.edu}
}
