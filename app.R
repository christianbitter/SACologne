#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# version 1:
# using the uniquely defined fields ... create a small app
# where the user can select any of the individual uniques
# name can be multi-select
# the output is a visualization of the yearly stats of the names

# version 2:
# pre-grouping by first letter

# version 3:
# incorporating birth statistics

# version 4:
# incorporating knowledge about names

# version 5:
# some modeling

library(shiny);

source("ui.r");
source("server.r");

# Run the application 
shinyApp(ui = ui, server = server)
