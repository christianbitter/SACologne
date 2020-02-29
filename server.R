library(ggplot2);
library(dplyr);

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  data_fp      <- "data/firstnames_cologne_2010_to_2018.csv";
  plot_title   <- "Cologne First Names";
  plot_caption <- "(c) Christian Bitter 2020";
  do_plot      <- F;
  context      <- NULL;

  
  context <- reactiveValues(
    names_df = read.csv(file = data_fp, sep = ";", header = T, stringsAsFactors = F),
    "first_names"  = NULL,
    "sex"          = NULL,
    "year"         = NULL
  )
  
  observeEvent(eventExpr = input$siSex, handlerExpr = {
    do_plot <- F;
  })
  
  observeEvent(eventExpr = input$siBirthYear, handlerExpr = {
    do_plot <- F;
  })
  
  observeEvent(eventExpr = input$abAdd, handlerExpr = {
    if (!is.null(input$aiFirstName)) {
      do_plot <- F;
      # get existing first names and add the newly created
      first_names <- unique(c(input$siFirstName, input$aiFirstName));
      updateSelectInput(session, inputId = "siFirstName", 
                        choices = first_names, selected = first_names);
    }
  })
  
  observe({
    if (!is.null(context)) {
      data_df <- context$names_df;
      if (nrow(data_df) > 0) {
        update_autocomplete_input(session = session, id = "aiFirstName",
                                  label = "First Name",
                                  placeholder = "Start Typing ...",
                                  options = unique(data_df$firstname));
      }
    }
  })
  
  update_plot   <- eventReactive(input$abSubmit, {
    context$first_names <- input$siFirstName;
    context$sex         <- input$siSex;
    context$year        <- as.numeric(input$siBirthYear);
    
    T & !is.null(context$first_names);
  })
  
  output$toFirstName <- renderTable({
    if (update_plot()) {
      data_df <- context$names_df;
      first_names <- context$first_names;
      sel_year    <- context$year;
      sel_sex     <- context$sex;
      
      data_df <- 
        data_df %>%
        dplyr::filter(year %in% sel_year, 
                      sex %in% sel_sex, 
                      firstname %in% first_names);
     
      return(data_df);
    }
  })
  
  output$poFirstName <- renderPlot({
    if (update_plot()) {
      data_df <- context$names_df;
      first_names <- context$first_names;
      sel_year    <- context$year;
      sel_sex     <- context$sex;
      
      strFirstName <- ifelse(length(first_names) > 3, 
                             sprintf("%s, %s, ...", first_names[1], first_names[2]),
                             paste(first_names, collapse = ",", sep = ""));
      
      data_df %>%
        dplyr::filter(firstname %in% first_names, 
                      year %in% sel_year, 
                      sex %in% sel_sex) %>%
        ggplot(aes(x = year, y = count, group = firstname, colour = firstname)) +
        geom_point() +
        geom_hline(aes(yintercept = med)) +
        geom_ribbon(aes(ymin = count - spread, ymax = count + spread),
                    alpha = .5, fill = "lightblue") +
        geom_smooth(se = F, method = "loess") +
        labs(x = "Year", y = "# No Babys",
             title = plot_title, caption = plot_caption,
             subtitle = paste(sprintf("Yearly, median (gray) and IQR (shaded region) occurrence of %s in Cologne.", strFirstName), 
                              "Loess trend line shown for individual names where possible.",
                              sep = "\n")) +
        theme_light()
    }
  })
}
