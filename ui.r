library(shinydashboard);
library(dqshiny);

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Open Data Cologne - First Names"),
  
  # fluidRow(
  div(paste("Sarah, Mia, Alexander or Sophia - which was the most popular first name parents gave their baby during the last years in Cologne? Find out with this interactive tool!",
            "Select one or multiple first names by typing into the name text box and adding your name to the selection with add.", 
            "Choose the baby's sex - this applies to all the first names chosen. Please be aware that sometimes a first name",
            "is given to boys and girls alike. Lastly define the analysis time frame, i.e. select one or multiple years. When done hit submit.",
            collapse = "\n")
  ),
  
  br(),
  
  div(paste("Please be aware that the data set is directly based of Cologne Open Data and as such may contain data quality problems.",
            "Clearly, we aim to rectify some of the inherent quality issues, but data is messy sometimes...", 
            collapse = "\n")
  ),
  br(),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(

      autocomplete_input(id = "aiFirstName", label = "First Name:", 
                         max_options = 100, options = NULL),
      actionButton(inputId = "abAdd", "Add"),
      br(),
      selectInput(inputId = "siFirstName", label = "Selected First Names", 
                  choices = c(), selected = NULL, multiple = T),
      
      selectInput(inputId = "siSex", label = "Sex",
                  choices = c("male" = "m", "female" = "w"), selected = "w", multiple = F),
      
      selectInput(inputId = "siBirthYear", label = "Year of Birth", 
                  choices = c("2010" = 2010,
                              "2011" = 2011,
                              "2012" = 2012,
                              "2013" = 2013,
                              "2014" = 2014,
                              "2015" = 2015,
                              "2016" = 2016,
                              "2017" = 2017), selected = 2010, multiple = T),

      actionButton(inputId = "abSubmit", label = "Submit")
    ),
  
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput(outputId = "poFirstName"),
      tableOutput(outputId = "toFirstName")
    )
  )
)
