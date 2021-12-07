library(shiny)
library(dplyr)
library(ggplot2)
library(openxlsx)
library(DT)
root_dir = "summary"

SraRunTable <- openxlsx::read.xlsx("../dbGaP_SraRunTable_summary_lu.xlsx")
dat_cat =unique(SraRunTable$Data.category)
input_dir  = file.path(unique(SraRunTable$folder))


phenotype_file =  list()
for (i in seq_along(input_dir)){
  setwd(root_dir)
  setwd(file.path("../",input_dir[i],"Phenotype/combined/"))
  recode_file= list.files(pattern = "phenotype_info_combined_recode.txt$")
  if(length(recode_file) ==0)
  {
    phenotype_file[[i]] = list.files(pattern = "phenotype_info_combined.txt$")
  }else{
    phenotype_file[[i]] = list.files(pattern = recode_file)
  } 
  phenotype_file[[i]] = file.path(getwd(),phenotype_file[[i]])

  print(phenotype_file[[i]])
  
  setwd(root_dir)
}
#------------------------------------------------------------------------

# Define UI for dataset viewer app 
ui <- fluidPage(
  # App title ----
  titlePanel("Cancer phenotype summary dashboard"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
        # Sidebar with a dropbox input
   sidebarPanel(
      # Input: Text for providing a caption ----
      # Note: Changes made to the caption in the textInput control
      # are updated in the output area immediately as you type

      textInput(inputId = "cancer",
                label = "Date",
                value = Sys.Date()),
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "dataset",
                  label = "Choose a phenotype file",
                  choices = unlist(phenotype_file)),
      

      
      # Input: Selector for variable to group_by ----
      uiOutput("groups"),
      uiOutput("xvar"),
      uiOutput("yvar"),
      uiOutput("colvar"),
      uiOutput("apply")
    ),
      
    # Main panel for displaying outputs ----
  mainPanel(
    h3(textOutput("name", container = span)),
    h5(textOutput("obs")),
         DT::dataTableOutput('table'),
         plotOutput("plot")
  )
 )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output, session) {
  # read-in phenotype file
  dataset <- reactive({
    infile <- req(input$dataset)
    df <- read.delim(infile)
    df
  })
  
  # add group variable
  output$groups <- renderUI({
    df <- dataset()
    selectInput(inputId = "grouper", label = "Group variable", 
                choices = names(df), multiple = TRUE)
  })
  
  output$name <- renderText({
    infile <- req(input$dataset)
    name <- stringr::str_split(infile,"/",simplify = T)[,2]
    name
  })
  
  #use dplyr group_by to generate count table
  sum_tab <- reactive({
    req(input$grouper)
    dataset() %>% 
      group_by(!!! rlang::syms(input$grouper))%>%
      summarise(n=n())
    
  })
  
  #output summary tables 
  output$table <- renderDataTable({
    DT::datatable(sum_tab())
  })
  
  
  output$obs <- renderText({
    paste0("Number of observations is: ", nrow(dataset()))
    
  })
  
  
  #add simple plots
  output$xvar <- renderUI({
    df <- dataset()
    req(df)
    selectInput(inputId = "xvar", label = "Selece a X variable to plot", 
                choices = names(df))
  })

  
  output$yvar <- renderUI({
    df <- dataset()
    req(df)
    selectInput(inputId = "yvar", label = "Selece a Y variable to plot", 
                choices = names(df))
  })
  
  output$colvar <- renderUI({
    df <- dataset()
    req(df)
    selectInput(inputId = "colvar", label = "Selece a color variable to plot", 
                choices = names(df))
  })
  
  output$apply <- renderUI({
    df <- dataset()
    req(df)
    actionButton("apply", "Plot", icon = icon("Plot"))
  })
  
  
  
  # Render the plot
  observeEvent(input$apply, {
    
    output$plot <-  renderPlot({
      df <- dataset()
      req(df)
      # Plot the data with x/y vars indicated by the caller.
      
      p <- ggplot(df, aes_string(input$xvar, input$yvar,color=input$colvar)) + 
        geom_violin()+
        theme_minimal()
      p
    })
  })
    
    
    
}


shinyApp(ui, server)
