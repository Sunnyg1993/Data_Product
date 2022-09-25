#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Let's check the data"),

    # Sidebar 
    sidebarLayout(
      sidebarPanel(
        # load csv file
        fileInput('file1', 'Choose CSV File',
                  accept=c('text/csv', 'text/comma-separated-values,text/plain')),
        tags$hr(),
        
        # choose x and y to plot
        tags$h5(strong("Choose x and y to plot:")),
        
        # textInput("plot_x","plot x"),
        # make this as a select type, it is blank now and will update the choices once the csv file uploaded
        selectInput(inputId = "plot_x",
                    label = "plot x",
                    choices = c("")),
        # textInput("plot_y","plot y"),
        selectInput(inputId = "plot_y",
                    label = "plot y",
                    choices = c("")),
        # the plot will do when this button clicked
        actionButton('plot', 'Plot x ~ y'),
        
        # give the plot a colorcode
        tags$hr(),
        tags$h5(strong("Add a colorcode?")),
        # textInput("plot_color","colorcode"),
        selectInput(inputId = "plot_color",
                    label = "colorcode",
                    choices = c("")),
        actionButton('add_color', 'Add colorcode')
      ),

        # Show four tabs: data table, data summary, x~y plot, and x~y plot with colorcode (category)
      mainPanel(
        tabsetPanel(
          type = "tabs",
          tabPanel("Table",dataTableOutput("dynamic")),
          tabPanel("Summary", verbatimTextOutput("summary")),
          tabPanel("Plot",plotOutput("plot")),
          tabPanel("Plot+colorcode",plotOutput("plot1")))
        
      )
    )
))
