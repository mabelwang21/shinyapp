##############################################################

#ShinyApp for data EDA
#input a dataframe
#output a scatterplot with option to select color,
#size, shape, and smooth method

#when click 'Facet' button, right panel will show scatterplot
#stratified by 'group variable'

#can use brush function, after drag and select, click 'DONE' button
#will return the subset data output in DT::datatable at bottom left
#and subset data will output another scatterplot on the right panel
#bottom right is the linear model summary (lm())
#click 'Download' button, subset data will be saved into a CSV file
#default to your 'Download folder', right click 'Download' can select path

#reference: http://shiny.rstudio.com/gallery/file-upload.html
#http://shiny.rstudio.com/articles/gadgets.html
#http://deanattali.com/2015/06/28/introducing-shinyjs-colourinput/

# ~* *Lu, 05.31.16* *~

##############################################################


library(shiny)
library(shinyjs)
library(dplyr)
library(plotly)
library(ggplot2)
library(DT)
library(ggExtra)

ui <- fluidPage(
  titlePanel("EDA"),
  
  fluidRow(
    column(3,
           
           wellPanel(    
             fileInput('file1', 'Choose CSV File',
                       accept=c('text/csv', 
                                'text/comma-separated-values,text/plain', 
                                '.csv')),
             tags$hr(),
             checkboxInput('header', 'Header', TRUE),
             
             uiOutput("xvar"),
             uiOutput("grpvar"),
             uiOutput("yvar"),
             uiOutput("apply")
             
           ),
           
           wellPanel(
             colourInput("col", "Select colour", "#EB6A36",
                         allowTransparent = FALSE),
             numericInput("shape", "Select shape", value = 19, min=1, max=25),
             numericInput("size", "Select size", value = 3, min=1, max=20),
             selectInput("md", "Select smooth method", c("lm", "loess")),
             uiOutput("facet")
           )),
    
    # Create a Scatter plot (with selected color, size, shape)
    #The brush="brush" argument means we can listen for
    # brush events on the plot using input$brush.
    
    column(4, 
           
           plotOutput("plot", height = "700px",brush = "plot_brush"),
           uiOutput("done")),
           
           
    column(4,
           
           plotOutput("brushplot", height = "700px") )),
    
    fluidRow(
    
    column(7, 
           dataTableOutput('mytable'),
           uiOutput("save")),
    
    column(4, offset = 0.5, 
            verbatimTextOutput('model'))
          )
)



server <- function(input, output, session) {
  
  
  filedata <- reactive({
    infile <- input$file1
    #if (is.null(infile)) return(NULL)      
    #use req() to replace code above
    req(infile)
    read.csv(infile$datapath)
  })
  
  output$xvar <- renderUI({
    df <- filedata()
    req(df)
    items=names(df)
    names(items)=items
    selectInput("xvar","Select X variable",items,items[2])
  })
  

  
  output$grpvar <- renderUI({
    df <- filedata()
    req(df)
    items=names(df)
    names(items)=items
    selectInput("grpvar","Select group variables",items,items[3])
  })
  
  
  output$yvar <- renderUI({
    df <- filedata()
    req(df)
    items=names(df)
    names(items)=items
    selectInput("yvar","Select Y variables",items,items[4])
  })
  
  output$apply <- renderUI({
    req(input$file1)
    actionButton("apply", "Apply", icon = icon("play"))
  })
  
  
  
  # Render the plot
    observeEvent(input$apply, {
      
      output$plot <-  renderPlot({
        
    # Plot the data with x/y vars indicated by the caller.
       
        p <- ggplot(filedata(), aes_string(input$xvar, input$yvar)) + 
          geom_point(col=input$col,size=input$size, shape=input$shape)+
          geom_smooth(method=input$md,  col="grey", se=TRUE)+
          theme(axis.text=element_text(size=14),axis.title=element_text(size=18,face="bold"))
        p
   })
      
      #show facet button
      output$facet <- renderUI({
        actionButton("facet", "Facet")
      })
      
      #show done button
      output$done <- renderUI({
        actionButton("done", "Done")
        
      })
   })
    
    #if click 'Facet' button, show facet_wrap plot
    observeEvent(input$facet, {
      output$brushplot <- renderPlot({
        p1 <- ggplot(filedata(), aes_string(input$xvar, input$yvar)) + 
          geom_point(col=input$col,size=input$size, shape=input$shape)+
          geom_smooth(method=input$md,  col="grey", se=FALSE)+
          theme(axis.text=element_text(size=14),axis.title=element_text(size=18,face="bold"))+
          facet_grid(paste('.~', input$grpvar))
        p1
        
      })
    })
    
    # Handle the Done button being pressed.Generate a subset data based on brushed points
      select <-  eventReactive(input$done, {
                 brushedPoints(filedata(), input$plot_brush, 
                              xvar = input$xvar, yvar =input$yvar)
      })
      
      #output a datatable using DT package datatable()
      output$mytable <- renderDataTable(datatable({
        select()
      }))
      
    
      #generate linear model using brushed points
      model <- reactive(lm(paste(input$yvar, "~", paste(input$xvar, input$grpvar, sep=' + ')), select()))
      
      #generate another scatter plot using brushed points
      observeEvent(input$done, {
         output$brushplot <-  renderPlot({
          
          p2 <- ggplot(select(), aes_string(input$xvar, input$yvar)) + 
            geom_point(col=input$col,size=input$size, shape=input$shape)+
            geom_smooth(method=input$md,  col="grey", se=TRUE)+
            theme(axis.text=element_text(size=14),axis.title=element_text(size=18,face="bold"))
          #add marginal plot for x and y variable
          p2 <-ggMarginal(p2, type="histogram", margins="both")
          p2
          
        })
        
         output$model <- renderPrint({
            summary(model())
          })   
         
         #show download button
         output$save <- renderUI({
           downloadButton("download", "Download")
         })
    })
      
       #save brushed points to a CSV file called
       #"selected.data.csv" in the current directory.
     
        output$download <- downloadHandler(
            filename =function() { paste('selected.data.', Sys.Date(), '.csv', sep='') },
            content= function(file){
                     write.csv(select(), file)
             }
            )
    
        
}
    
   




shinyApp(ui = ui, server = server)
