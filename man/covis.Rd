% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/covis.R
\name{covis}
\alias{covis}
\alias{covis,SPHM-method}
\title{Co-visualizing spatial heatmaps with single-cell embedding plots}
\usage{
\S4method{covis}{SPHM}(
  data,
  assay.na = NULL,
  sam.factor = NULL,
  con.factor = NULL,
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
\item{data}{An `SHM` class that containing the numeric data and aSVG instances for plotting SHMs or co-visualization plots. See \code{\link{SPHM}}.}

\item{assay.na}{The name of target assay to use when \code{data} is \code{SummarizedExperiment}.}

\item{sam.factor}{The column name corresponding to spatial features in \code{colData} of \code{SummarizedExperiment}. If the column names in the \code{assay} slot already follows the scheme "spatialFeature__variable", then the \code{colData} slot is not required and accordingly this argument could be NULL.}

\item{con.factor}{The column name corresponding to experimental variables in \code{colData} of \code{SummarizedExperiment}. It can be NULL if column names of in the \code{assay} slot already follows the scheme "spatialFeature__variable", or no variable is associated with the data.}

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
This function is an extension of \code{\link{shm}}. It is designed to co-visualize bulk and single-cell data in form of a spatial heatmap (SHM) and embedding plot (PCA, UMAP, TSNE) respectively.
}
\section{Details}{

See the package vignette (\code{browseVignettes('spatialHeatmap')}).
}

\examples{

# To always obtain the same results, a fixed seed is set.
set.seed(10); library(SummarizedExperiment); library(ggplot2)
# Read example single cell data of mouse brain (Marques et al. (2016)).
sce.pa <- system.file("extdata/shinyApp/data", "cell_mouse_brain.rds", 
package="spatialHeatmap")
# Cell group lables are stored in the "label" column in "colData".
sce <- readRDS(sce.pa); colData(sce)[1:3, 1:3]
# Read example bulk data of mouse brain (Vacher et al. 2021). 
blk.mus.pa <- system.file("extdata/shinyApp/data", "bulk_mouse_cocluster.rds", 
package="spatialHeatmap"); blk.mus <- readRDS(blk.mus.pa)
assay(blk.mus)[1:3, 1:5]

# Jointly normalize bulk and single cell data.
cache.pa <- '~/.cache/shm' # Cache path.
mus.ann.nor <- read_cache(cache.pa, 'mus.ann.nor') 
if (is.null(mus.ann.nor)) {
  mus.lis.nor <- norm_cell(sce=sce, bulk=blk.mus, quick.clus=list(min.size = 100, d=15), 
  com=FALSE); save_cache(dir=cache.pa, overwrite=TRUE, mus.ann.nor)
}
# Separate normalized bulk and single cell data.
blk.mus.nor <- mus.lis.nor$bulk
cell.mus.nor <- mus.lis.nor$cell; colData(cell.mus.nor) <- colData(sce)
# Reduce dimensions (PCA, UMAP, TSNE) for single cell data.
cell.dim <- reduce_dim(cell.mus.nor, min.dim=5)

# Aggregate tissue replicates in bulk data by mean.
blk.mus.aggr <- aggr_rep(blk.mus.nor, sam.factor='sample', aggr='mean')
assay(blk.mus.aggr)[1:2, ]

# Read the aSVG image into an "SVG" object.
svg.mus.brain.pa <- system.file("extdata/shinyApp/data", "mus_musculus.brain.svg", 
package="spatialHeatmap")
svg.mus.brain <- read_svg(svg.mus.brain.pa)
tail(attribute(svg.mus.brain)[[1]])[, 1:4]
# Map tissues to cell groups through a "list", where tissue labels are in name slots and
# the corresponding elements are cell group labels.
lis.match.blk <- list(cerebral.cortex=c('cortex.S1'), hypothalamus=c('corpus.callosum',
'hypothalamus')) 
# Store bulk and single-cell data, aSVG, and match list in an "SHM" class.
dat.ann.tocell <- SPHM(svg=svg.mus.brain, bulk=blk.mus.aggr, cell=cell.dim, 
match=lis.match.blk)
# Co-visualization is created on expression values of gene "Eif5b". The target cell
# groups are "hypothalamus" and "cortex.S1".
covis(data=dat.ann.tocell, ID=c('Cacnb4'), col.idp=TRUE, dimred='TSNE', 
cell.group='label', tar.bulk=names(lis.match.blk), bar.width=0.09, dim.lgd.nrow=2, 
dim.lgd.text.size=10, h=0.6, legend.r=0.1, legend.key.size=0.01, legend.text.size=10,
legend.nrow=2)

# Save plots to HTML files and videos in the folder "test". 
# covis(data=dat.ann.tocell, ID=c('Cacnb4', 'Apod'), col.idp=TRUE, dimred='UMAP', 
# cell.group='label', tar.bulk=names(lis.match.blk), bar.width=0.12, bar.value.size=4, 
# dim.lgd.nrow=3, dim.lgd.text.size=7, h=0.5, legend.r=1, animation.scale=0.8, aspr=1.1,
# legend.key.size=0.01, legend.text.size=7, legend.nrow=3, legend.nrow.2nd=3, 
# out.dir='test', dim.lgd.key.size=2)
# More examples of co-visualization are provided in the package vignette: https://www.bioconductor.org/packages/release/bioc/vignettes/spatialHeatmap/inst/doc/covisualize.html


}
\references{
https://www.gimp.org/tutorials/
https://inkscape.org/en/doc/tutorials/advanced/tutorial-advanced.en.html
http://www.microugly.com/inkscape-quickguide/
Martin Morgan, Valerie Obenchain, Jim Hester and Hervé Pagès (2018). SummarizedExperiment: SummarizedExperiment container. R package version 1.10.1
H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.
Jeroen Ooms (2018). rsvg: Render SVG Images into PDF, PNG, PostScript, or Bitmap Arrays. R package version 1.3. https://CRAN.R-project.org/package=rsvg
R. Gentleman, V. Carey, W. Huber and F. Hahne (2017). genefilter: genefilter: methods for filtering genes from high-throughput experiments. R package version 1.58.1
Paul Murrell (2009). Importing Vector Graphics: The grImport Package for R. Journal of Statistical Software, 30(4), 1-37. URL http://www.jstatsoft.org/v30/i04/ 
Baptiste Auguie (2017). gridExtra: Miscellaneous Functions for "Grid" Graphics. R package version 2.3. https://CRAN.R-project.org/package=gridExtra
R Core Team (2018). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. RL https://www.R-project.org/
https://github.com/ebi-gene-expression-group/anatomogram/tree/master/src/svg 
Yu, G., 2020. ggplotify:  Convert Plot to ’grob’ or ’ggplot’ Object. R package version 0.0.5.URLhttps://CRAN.R-project.org/package=ggplotify30
Keays, Maria. 2019. ExpressionAtlas: Download Datasets from EMBL-EBI Expression Atlas
Love, Michael I., Wolfgang Huber, and Simon Anders. 2014. "Moderated Estimation of Fold Change and Dispersion for RNA-Seq Data with DESeq2." Genome Biology 15 (12): 550. doi:10.1186/s13059-014-0550-8
Guangchuang Yu (2020). ggplotify: Convert Plot to 'grob' or 'ggplot' Object. R package version 0.0.5. https://CRAN.R-project.org/package=ggplotify
Cardoso-Moreira, Margarida, Jean Halbert, Delphine Valloton, Britta Velten, Chunyan Chen, Yi Shao, Angélica Liechti, et al. 2019. “Gene Expression Across Mammalian Organ Development.” Nature 571 (7766): 505–9
Marques A et al. (2016). Oligodendrocyte heterogeneity in the mouse juvenile and adult central nervous system. Science 352(6291), 1326-1329.
Amezquita R, Lun A, Becht E, Carey V, Carpp L, Geistlinger L, Marini F, Rue-Albrecht K, Risso D, Soneson C, Waldron L, Pages H, Smith M, Huber W, Morgan M, Gottardo R, Hicks S (2020). “Orchestrating single-cell analysis with Bioconductor.” Nature Methods, 17, 137–145. https://www.nature.com/articles/s41592-019-0654-x.
Vacher, Claire-Marie, Helene Lacaille, Jiaqi J O’Reilly, Jacquelyn Salzbank, Dana Bakalar, Sonia Sebaoui, Philippe Liere, et al. 2021. “Placental Endocrine Function Shapes Cerebellar Development and Social Behavior.” Nat. Neurosci. 24 (10). Nature Publishing Group: 1392–1401
}
\author{
Jianhai Zhang \email{jzhan067@ucr.edu} \cr Dr. Thomas Girke \email{thomas.girke@ucr.edu}
}
