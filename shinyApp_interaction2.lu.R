

library(shiny)
library(shinyjs)
library(ggplot2)
library(DT)


ui <- fluidPage(
  titlePanel("Interaction"),
  
  fluidRow(
    column(4, 
           wellPanel(    
             fileInput('file1', 'Choose CSV File',
                       accept=c('text/csv', 
                                'text/comma-separated-values,text/plain', 
                                '.csv')),
             tags$hr(),
             checkboxInput('header', 'Header', TRUE),
             
             uiOutput("xvar"),
             uiOutput("moderator"),
             uiOutput("yvar")
           ),
           
           wellPanel(
             colourInput("col", "Select colour", "#00D4F0",
                         allowTransparent = FALSE),
             sliderInput("shape", "Select shape",  min=1, max=25, value = 19),
             sliderInput("size", "Select size", min=1, max=20, value = 3),
             uiOutput("slider"),
             uiOutput("apply")
           )),
    
    # Create a Scatter plot (with selected color, size, shape)
    #The brush="brush" argument means we can listen for
    # brush events on the plot using input$brush.
    
    column(7, offset = 1,
           plotOutput("plot", height = "900px"))),
    
    fluidRow(
      column(5, offset = 0.5, 
             verbatimTextOutput('model')),
      column(7, h3('prediction'),
             dataTableOutput('mytable'))
      
      
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
  
  output$moderator <- renderUI({
    df <- filedata()
    req(df)
    items=names(df)
    names(items)=items
    selectInput("moderator","Select moderator",items,items[3])
  })
  
  output$yvar <- renderUI({
    df <- filedata()
    req(df)
    items=names(df)
    names(items)=items
    selectInput("yvar","Select Y variables",items,items[4])
  })
  
  # define the range for moderator input in slider
  slidermin <- reactive(range(filedata()[input$moderator])[1])
  slidermax <- reactive(range(filedata()[input$moderator])[2])
  output$slider <- renderUI({
    sliderInput("modvalue","Moderator value", min=slidermin(), 
                max = slidermax(),  value =slidermin())
  })
  
  output$apply <- renderUI({
    req(input$file1)
    actionButton("apply", "Apply", icon = icon("play"))
  })
  
  
  # Render the plot
  observeEvent(input$apply, {
    
       model <- reactive(lm(paste(input$yvar, "~", 
                               paste(input$xvar, input$moderator, sep='*')), filedata()))
    
    output$model <- renderPrint({
      summary(model())
    }) 
    
    mynewdata <- reactive ({
      df <- filedata()[c(input$xvar, input$moderator,input$yvar)]
      df[input$moderator] <- rep(input$modvalue,times= nrow(filedata()))
      df[input$yvar] <- predict(model(), newdata = df)
      
      return(df)
    })
    
    #output a datatable using DT package datatable()
    output$mytable <- renderDataTable(datatable({
      mynewdata()
    }))
    
    output$plot <- renderPlot({
      
      p <- ggplot(filedata(), aes_string(input$xvar, input$yvar)) + 
        geom_point(col=input$col,size=input$size, shape=input$shape) +
        theme(axis.text=element_text(size=14),axis.title=element_text(size=18,face="bold"))
      p <- p+ geom_line(data=mynewdata(),aes_string(input$xvar, input$yvar), col="grey50", size =2)
      
      p
    })
  })
}


shinyApp(ui = ui, server = server)






