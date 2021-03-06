#!/usr/bin/env Rscript

#' User Interface for the main analysis tab of the infercnv shiny app.
#' 
#' @title mainAnalysisTabUI()
#' 
#' @param id, character string used to specify a namespace, \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements for the main infercnv output
#' 

mainAnalysisTabUI <- function(id) {
    # set the name space
    ns <- NS(id)
    
    tags$head(includeCSS("www/infercnv.style.css"))
    # create teh tag list 
    tagList(
        
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ##########################       Main output Analysis tab      ##########################
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        tags$div( class = "analysisTabTitles",
                  fluidRow(
                      
                      # __________________    Header tite and text description     __________________
                      tags$h2("Infercnv Figure Output", 
                              align = "center",
                              style = "font-weight:bold"),
                  ),
                  
                  fluidRow(
                      column(width = 10, offset = 1,
                             tags$p("Heatmaps generated by infercnv analysis. All of these plots can be found in the output folder." )
                      )
                  ),
                  
                  br(), hr()
        ),
        
        # __________________    Infercnv Final Output     __________________
        fluidRow(
            column(width = 3, offset = 1,
                   tags$h4( textOutput(ns("infercnv_png_title")) ),
                   tags$p( textOutput(ns("infercnv_png_text")) )
            ),
            column(8, imageOutput(outputId = ns('infercnv_png'),
                                  width    = "100%",
                                  height   = "100%" ) )
        ),
        
        br(),br(),hr(),
        
        # __________________    Infercnv Output Preliminary    __________________
        fluidRow(
            column(width = 3, offset = 1,
                   tags$h4( textOutput(ns("infercnv_preliminary_title"))),
                   tags$p( textOutput(ns("infercnv_preliminary_text")))
            ),
            column(8, imageOutput(outputId = ns('infercnv_preliminary_png'),
                                  width    = "100%",
                                  height   = "100%") )
        ),
    ) # taglist
}



#' Server portion of the Main output portion of the infercnv Shiny app
#' 
#' 
#' @title analysisPage()
#' 
#' 
#' @param input, output, session standard \code{shiny} boilerplate
#' @param infercnv_inputs, the list of UI inputs given by the function runInfercnvInputs().
#' @param infercnv_obj, infercnv object created using createObject().
#'
#' @return Returns the main output figures for running infercnv

mainAnalysis <- function(input, output, session,
                         infercnv_inputs,
                         infercnv_obj 
                         ){
    
    
    # Set the  constants
    ## output directory
    output_path <- infercnv_inputs$dir()
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ********************************      Main Analysis Images      *********************************
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    # Get the png files in the output directory 
    output_file_list <- list.files(path       = output_path, 
                                   pattern    = "*.png", 
                                   all.files  = FALSE, 
                                   full.names = TRUE)
    # list of files 
    output$fileList <- renderText({
        paste0(output_file_list, collapse = "\n")
    })
    
    #_________________     infercnv.preliminary.png    _____________________
    
    check <- grepl(pattern = "*infercnv.preliminary.png", 
                   x = output_file_list)
    if ( any(check) ){
        
        # create image output 
        ## get the file path 
        infercnv_preliminary_png_path <- output_file_list[check]
        ## render image 
        output$infercnv_preliminary_png <- renderImage({
            # create the list for image rendering
            list(src = infercnv_preliminary_png_path,
                 contentType = 'image/png',
                 width = "100%",
                 alt = "This is alternate text")
        },
        deleteFile = FALSE)
        
        # Create the text output 
        output$infercnv_preliminary_title <- renderText({ "Preliminary InferCNV View:" })
        output$infercnv_preliminary_text <- renderText({ "The following figure is a view prior to denoising or HMM prediction." })
    }
    
    
    #_________________     infercnv.png    _________________
    
    
    check <- grepl(pattern = "infercnv.png", 
                   x = output_file_list)
    if ( any(check) ){
        # create image output 
        ## get the file path 
        infercnv_png_path <- output_file_list[check]
        ## render image 
        output$infercnv_png <- renderImage({
            # create the list for image rendering
            list(src = infercnv_png_path,
                 contentType = 'image/png',
                 width = "100%",
                 alt = "This is alternate text")
        },
        deleteFile = FALSE)
        
        # Create the text output 
        output$infercnv_png_title <- renderText({ "Final InferCNV View:" })
        output$infercnv_png_text <- renderText({ "The following figure is the final heatmap generated by inferCNV with denoising methods applied." })
    }
    
    
    
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ***************************     Remaining Plots    ***************************
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    # ________    denoised     ________    
    check <- grepl(pattern = "*_denoised.png", 
                   x       = output_file_list)
    if ( any(check) ){
        denoise <- output_file_list[check]
        
        output$denoise_png <- renderImage({
            # create the list for image rendering
            list(src = denoise,
                 contentType = 'image/png',
                 width = "100%",
                 alt = "This is alternate text")
        },
        deleteFile = FALSE)
    }
}
