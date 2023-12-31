# Module for plotting SHMs.
shm_ui <- function(id, data.ui, search.ui) {
  ns <- NS(id)
  tabPanel("Spatial Heatmap", value='shmPanelAll', icon=NULL,
    # list(
    # width = ifelse(input$lgdTog %% 2 == 0, 9, 12), 
      # boxPad(color = NULL, title = NULL, solidHeader = FALSE, 
    # Append matrix heatmap, network with SHMs.    
    do.call(tabsetPanel, append(list(type="pills", id=ns('shmMhNet'), selected="shm1",
    # tabsetPanel(type = "pills", id=NULL, selected="shm1", 
      tabPanel(title="Static Image", value='shm1',
      column(12, id=ns('searshm'), search.ui, style='z-index:5'),  
      navbarPage('Settings:', id=ns('shmPar'),
      tabPanel("Basic", value='basic', 
      fluidRow(splitLayout(cellWidths=c('10px', '90px', '1px', '90px', '1px', '92px', '1px', '100px', '1px', '120px', '1px', '90px', '1px', '90px', '1px', '135px'), '',  
      actionButton(ns("fs"), "Full screen", onclick = "fullsn(document.getElementById('barSHM'))"), '',
      dropdownButton(inputId=ns('colDrop'), label='Columns', circle=FALSE, icon=NULL, status='primary', inline=FALSE, width='100%',
        sliderInput(ns("col.n"), "", min=1, max=50, step=1, value=2, width='100%')
      ), '',
      dropdownButton(inputId=ns('disDrop'), label='Layout by', circle=FALSE, icon=NULL, status='primary', inline=FALSE,
        radioButtons(inputId=ns('genCon'), label='', choices=c("Gene"="gene", "Condition"="con"), selected='', inline=FALSE)
      ), '',
      dropdownButton(inputId=ns('scaleDrop'), label='Scale plots', circle=FALSE, icon=NULL, status='primary', inline=FALSE, width=250,
        sliderInput(ns("scale.shm"), "", min=0.1, max=10, step=0.1, value=1, width='100%')
      ), '',
      dropdownButton(inputId=ns('scroDrop'), label='Overall height', circle=FALSE, icon=NULL, status='primary', inline=FALSE, width=250,
        sliderInput(ns("scrollH"), "", min=50, max=10000, step=50, value=450, width='100%')
      ), '',
      dropdownButton(inputId=ns('titDrop'), label='Title size', circle=FALSE, icon=NULL, status='primary', inline=FALSE, width=250,
        sliderInput(ns("title.size"), "", min=0, max=100, step=0.5, value=12, width='100%')
      ), '',
      dropdownButton(inputId=ns('dropdown'), label='Color key', circle=FALSE, icon=NULL, status='primary', inline=FALSE, width=250,
      div(style='margin-left:-8px;margin-bottom:-15px;',
        selectInput(ns('colorOp'), label='Color scheme', choices=c('yellow,orange,red', 'green,yellow,orange', 'custom')) 
      ),
      fluidRow(id=ns('colCus'), splitLayout(cellWidths=c('1%', '60%', '35%'), '', textInput(ns("color"), label="Color scheme", value='', width=200),
      actionButton(ns("col.but"), "Confirm", icon=NULL, style = "margin-top: 24px;"))), 
      radioButtons(inputId=ns('ckeyV'), label='Color key based on', choices=c("Selected rows", "All rows"), selected='', inline=TRUE)
      ), '', 
      dropdownButton(inputId=ns('togDrop'), label='Horizontal width', circle=FALSE, icon=NULL, status='primary', inline=FALSE, width=250,
        sliderInput(ns("togSld"), "Adjust horizontal layout", min=0, max=1, step=0.05, value=0.67, width='100%')
      )
      )), # fluidRow
      bsTooltip(id=ns('colDrop'), title="Number of columns for organizing plots", placement="top", trigger = "hover"),
      bsTooltip(id=ns('disDrop'), title="Horizontal layout by gene or treatment.", placement="top", trigger = "hover"),
      bsTooltip(id=ns('scroDrop'), title="Adjust overall height for all plots.", placement="top", trigger = "hover"),
      bsTooltip(id=ns('colCus'), title="Use comma as separators, e.g.: yellow,orange,red. ", placement="top", trigger = "hover"),
      bsTooltip(id=ns('ckeyV'), title="Color keys created on selected or all rows in the numeric assay data.", placement="top", trigger = "hover"),
      bsTooltip(id=ns('togDrop'), title="Adjust widths between spatial heatmaps and the legend plot.", placement="top", trigger = "hover"),
      # bsPopover(id=ns('genCon'), title="Data column: by the column order in data matrix.", placement = "top", trigger = "hover"),
      div(style='margin-top:10px') 
      ), # tabPanel
      tabPanel("Transparency",
        fluidRow(splitLayout(cellWidths=c('1%', '5%', '3%', '90%'), '',
        actionButton(ns("transBut"), "Update", icon=icon("sync"), style=run.col), '', 
        selectizeInput(ns('tis'), label='Transparent features', choices='', multiple = TRUE, options=list(placeholder = 'Selected spatial features will be transparent.'))
      ))),
      tabPanel("Value legend",
      fluidRow(id=ns('valLgd'), splitLayout(cellWidths=c('1%', '10%', '1%', '10%', '1%', '10%', '1%', '10%', '1%', '10%'), '', 
      numericInput(inputId=ns('val.lgd.row'), label='Rows', value='', min=1, max=Inf, step=1, width=150), '',
      numericInput(inputId=ns('val.lgd.key'), label='Legend key size', value='', min=0.0001, max=1, step=0.01, width=150), '',
      numericInput(inputId=ns('val.lgd.text'), label='Legend text size', value='', min=0.0001, max=Inf, step=1, width=140), '',
      radioButtons(inputId=ns('val.lgd.feat'), label='Include features', choices=c('No', 'Yes'), selected='', inline=TRUE), '',
      actionButton(ns("val.lgd"), "Add/Remove", icon=icon("sync"), style = "margin-top: 24px;") 
      )),
      bsTooltip(ns('valLgd'), title="Add/remove the secondary legends that comprise of heat colors, numeric values, and spatial features.", placement="top", trigger = "hover")
      ), # tabPanel
      tabPanel("Shape outline",
      splitLayout(cellWidths=c('1%', '15%', '1%', '13%'), '', 
      selectInput(ns('line.color'), label='Line color', choices=c('grey70', 'black', 'red', 'green', 'blue'), selected=''), '', 
      numericInput(inputId=ns('line.size'), label='Line size', value='', min=0.05, max=Inf, step=0.05) 
      )), # tabPanel
     tabPanel("Download",
      # tags$div(title="Download the spatial heatmaps and legend plot.",
      # h1(strong("Download paramters:"), style = "font-size:20px;"),
      fluidRow(splitLayout(cellWidths=c('0.7%', '15%', '1%', '10%', '1%', '12%', '1%', '12%', '1%', '8%', '1%', '8%'), '',
      radioButtons(inputId=ns('ext'), label='File type', choices=c("jpg", "png", "pdf"), selected='jpg', inline=TRUE), '', 
      numericInput(inputId=ns('res'), label='Resolution (dpi)', value='', min=10, max=Inf, step=10, width=150), '',
      radioButtons(inputId=ns('lgd.incld'), label='Include legend plot', choices=c('Yes', 'No'), selected='', inline=TRUE), '', 
      numericInput(inputId=ns('lgd.size'), label='Legend plot size', value='', min=-1, max=Inf, step=0.1, width=140), '',
      actionButton(ns("dld.but"), "Confirm", icon=icon("sync"), style = "margin-top: 24px;"), '',
      # downloadButton(ns("dld.shm"), "Download", style = "margin-top: 24px;")
      uiOutput(ns('dldBut'))
      )), # fluidRow
      bsTooltip(id=ns('ext'), title="Select a file type to download.", placement = "bottom", trigger = "hover")

      #fluidRow(splitLayout(cellWidths=c('18%', '1%', '25%', '1%', '18%') 
      # tags$div(title="Alegend plot.",
      # ), '', 
      #)) # fluidRow 
      ), # tabPanel 
     
     # navbarMenu("More", # Create dropdown menu.
     tabPanel("Relative size", value='relasize',
       tags$div(title="Only applicable in multiple aSVGs.",
       numericInput(inputId=ns('relaSize'), label='Relative sizes', value='', min=0.01, max=Inf, step=0.1, width=140))
      ), # tabPanel

      tabPanel(title="Re-match features", value='rematch',
        # column(12, fluidRow(splitLayout(cellWidths=c('1%', "40%", '10%', "30%"), '',
        #  uiOutput(ns('svg'), style = 'margin-left:-5px'), '', 
        #  actionButton(ns("match"), "Confirm re-matching", icon=icon("sync"))
        #))), verbatimTextOutput(ns('msg.match')),
        #column(12, uiOutput(ns('ft.match')))
        match_ui(ns('rematch'))
      ),
      tabPanel("Raster image", value='raster',
         splitLayout(id=ns('superimp'), cellWidths=c('1%', '10%', '1%', '10%', '1%', '10%'), '', 
           selectInput(ns('raster'), label='Superimposing', choices=c('Yes', 'No'), selected='Yes'), '',
           selectInput(ns('coal'), label='Black-white', choices=c('Yes', 'No'), selected='No'), '',
           div(style='margin-top:25px',
           dropdownButton(inputId=ns('dpwAlpOver'), label='Alpha', circle=FALSE, icon=NULL, status='primary', inline=FALSE, width=300,
           fluidRow(splitLayout(cellWidths=c('1%', '60%', '35%'), '',
           sliderInput(ns('alpOver'), "", min=0, max=1, step=0.05, value=1, width='100%'),
           actionButton(ns("alpOverBut"), "Confirm", icon=icon("sync"), style='margin-top:31px')))
           ))
         ), bsTooltip(ns('superimp'), title="Superimposing raster images with spatial heatmaps.", placement = "top", trigger = "hover")
      ), # tabPanel
      tabPanel(title='Co-visualization', value='scellTab', 
        fluidRow(splitLayout(cellWidths=c('12px', '130px', '1px', '140px', '1px', '110px', '1px', '220px'), '',  
        div(id=ns('tpprof'), selectInput(ns('profile'), label='Coloring options', choices=c('Cell-by-value'='idp', 'Cell-by-group'='cellgrp', 'Feature-by-group'='ftgrp', 'Fixed-by-group'='fixed'), selected='idp')), '', 
        uiOutput(ns('tarCellBlk')), '',
        selectInput(ns('dims'), label='Embedding plot', choices=c('PCA', 'UMAP', 'TSNE'), selected='PCA'), '', 
        numericInput(ns('dimLgdRows'), label='Legend rows in embedding plot', value=2, min=1, max=Inf, step=1)
        )), bsTooltip(ns('tpprof'), title="Cell-by-value: cells and tissues are colored independently according to expression values of a chosen gene in single-cell (SC) and bulk data respectively. <br/> Cell-by-group: expression values of a chosen gene in SC data are averaged by cell groups. Cells of the same group and matching tissues are colored by the same heat color derived from the averaged value. <br/> Feature-by-group: similar with \\'Cell-by-group\\' except that expression values are from bulk data. <br/>Fixed-by-group: cells of the same group and matching tissue features are assigned the same constant colors.", placement = "right", trigger = "hover"),
        bsTooltip(ns('tarCellBlk'), title="Show all or a certain group of cells.", placement = "top", trigger = "hover")
      ),
      tabPanel(title=span('Help', style=hp), value='help', htmlOutput(ns('helpStatic')))
      # bsTooltip(id='scellTab', title='This panel is active for co-visualization.', placement = "top", trigger = "hover")
      #) # navbarMenu
      ), # navbarPage  
    uiOutput(ns('shm.ui')), data.ui
    ), # tabPanel 
      tabPanel(title='Interactive Image', value='interTab',
      navbarPage('', id=ns('interNav'),
      tabPanel('Plot', value='interPlot',
        fluidRow(splitLayout(cellWidths=c("10px", "85px", '1px', "400px"), '',
        actionButton(ns("glyBut"), "Run", icon=icon("sync"), style=run.col), '',
        uiOutput(ns('sld.fm'))
        )),
        # The input ids should be unique, so no legend plot parameters are added here.
        fluidRow(splitLayout(cellWidths=c("1%", "90%", "1%"), "", htmlOutput(ns("ggly"))))
      ),
      tabPanel('Settings',
        fluidRow(splitLayout(cellWidths=c('10px', '80px', '1px', '86px', '1px', '120px', '1px', '110px'), '',
          numericInput(ns('aspr'), label='Aspect ratio', value=0.8, min=0.1, max=Inf, step=0.1, width=170), '',
          numericInput(ns('scale.ly'), label='Scaling plots', value=1, min=0.1, max=Inf, step=0.1, width=170), '',
          numericInput(ns('t'), label='Transition time (s)', value=3, min=0.1, max=Inf, step=NA, width=270), '',
          downloadButton(ns("dld.anm"), "Download", style = "margin-top: 24px;") 
         )), bsTooltip(ns('t'), title="Multiple plots can be displayed sequentially automatically.", placement = "top", trigger = "hover")
      ),
      tabPanel(title=span('Help', style=hp), value='help', htmlOutput(ns('helpInter')))
      ) # navbarPage
      ),
      tabPanel(title='Video', value='vdoTab',
      navbarPage('', id=ns('vdoNav'),
      tabPanel('Video', value='video',
      actionButton(ns("vdo.but"), "Run", icon=icon("sync"), style=run.col),
      fluidRow(splitLayout(cellWidths=c("1%", "98%", "1%"), "", uiOutput(ns('video')), ""))
      ),
      tabPanel("Settings",
      div(id=ns('shmVdo'),
      h5(strong('Spatial heatmap')),
      fluidRow(splitLayout(cellWidths=c('10px', '60px', '1px', '75px', '1px', '65px', '1px', '115px', '1px', '90px', '1px', '70px'), '',
      numericInput(inputId=ns('vdo.key.row'), label='Key rows', value=2, min=1, max=Inf, step=1), '',
      numericInput(inputId=ns('vdo.key.size'), label='Key size', value=0.04, min=0.01, max=Inf, step=0.1), '',
      selectInput(inputId=ns("vdo.val.lgd"), label="Key value", choices=c("Yes", "No"), selected='No'), '', 
      numericInput(inputId=ns('vdoText2'), label='Legend text size', value=7, min=1, max=Inf, step=1), '',
      selectInput(inputId=ns("vdo.label"), label="Feature label", choices=c("Yes", "No"), selected='No'), '',
      numericInput(inputId=ns('vdo.lab.size'), label='Label size', value=2, min=0, max=Inf, step=0.5)
      )) # fluidRow
      ),
      bsTooltip(ns('shmVdo'), title="Key: Legend keys in spatial heatmaps. <br/> Feature label: label spatial features with text.", placement = "top", trigger = "hover"),
      div(id=ns('lgdVdo'),
      h5(strong('Legend plot: embedding plot')),
      fluidRow(id=ns('lgdDim'), style='width:300px', splitLayout(cellWidths=c('10px', '60px', '1px', '60px', '1px', '75px'), '',
      numericInput(inputId=ns('vdoLgdDimText'), label='Text size', value=4, min=1, max=Inf, step=1), '',
      numericInput(inputId=ns('vdoLgdDimRow'), label='Key rows', value=2, min=1, max=Inf, step=1), '',
      numericInput(inputId=ns('vdoLgdDimkey'), label='Key size', value=1, min=0.01, max=Inf, step=0.5)
      )), # fluidRow
      bsTooltip(ns('lgdDim'), title="Adjust legend keys and text in the embedding legend plot.", placement = "top", trigger = "hover"),
      h5(strong('Legend plot: spatial heatmap')),
      fluidRow(id=ns('lgdSHM'), style='width:250px', splitLayout(cellWidths=c('10px', '60px', '1px', '60px', '1px', '75px'), '',
      numericInput(inputId=ns('vdoLgdText'), label='Text size', value=4, min=1, max=Inf, step=1), '',
      numericInput(inputId=ns('vdoLgdKeyRow'), label='Key rows', value=3, min=1, max=Inf, step=1), '',
      numericInput(inputId=ns('vdoLgdkey'), label='Key size', value=0.01, min=0.01, max=Inf, step=0.1)
      )), # fluidRow
      bsTooltip(ns('lgdSHM'), title="Adjust legend keys and text in the spatial heatmap legend plot.", placement = "top", trigger = "hover")
      ),
      h5(strong('Video')),
      fluidRow(id=ns('vdoTp'), style='width:700px', splitLayout(cellWidths=c('10px', '75px', '1px', '105px', '1px', '145px', '1px', '110px', '1px', '100px', '1px', '110px'), '',
      numericInput(inputId=ns('vdoH'), label='Height', value=0.6, min=0.01, max=1, step=0.05), '',
      numericInput(inputId=ns('vdo.bar.width'), label='Color key width', value=0.08, min=0.01, max=0.9, step=0.03, width=270), '',
      numericInput(inputId=ns('lgdR'), label='Scaling legend plots', value=0.7, min=0.01, max=Inf, step=0.05), '',
      selectInput(ns("vdo.dim"), label="Dimension", choices=c('1920x1080', '1280x800', '320x568', '1280x1024', '1280x720', '320x480', '480x360', '600x600', '800x600', '640x480'), selected='640x480'), '',
      numericInput(inputId=ns('vdo.itvl'), label='Transition time', value=1, min=0.1, max=Inf, step=1), '',
      numericInput(inputId=ns('vdo.res'), label='Resolution (dpi)', value=400, min=1, max=1000, step=5, width=270)
      )), # fluidRow
      bsTooltip(ns('vdoTp'), title="Transition time: speed for playing videos.", placement = "top", trigger = "hover"),
      textOutput(ns('tran.vdo')) 
      ),
      tabPanel(title=span('Help', style=hp), value='help', htmlOutput(ns('helpVdo')))
      ) # navbarPage
      ) # tabPanel
      ), list()
      )) # append, do.call

    #  ) # list

  )
}
