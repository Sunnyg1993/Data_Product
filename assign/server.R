#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input,output,session) {

  # let df1 be the readin csv file
  df1 <- reactive({
    getd <- function(x){
      if (is.null(x))
        return(NULL)
      read.csv(x$datapath)
    }
    df1 <- getd(input$file1)
  })
  
  # show the dataframe
  output$dynamic <- renderDataTable(df1(), options = list(pageLength = 5))
  
  # show the dataframe summary
  output$summary <- renderPrint(str(df1()))
  
  # before plot, let's update our selections for plot
  observe({
    x=df1()
    z <- sapply(x,mode)
    z_num <- names(z[z=="numeric"])
    z_chr <- names(z[z=="character"])
    
    # plot_x and plot_y will take only the numeric variables 
    updateSelectInput(session, "plot_x",
                      label = "plot x",
                      choices = z_num)
    updateSelectInput(session, "plot_y",
                      label = "plot y",
                      choices = z_num)
    
    # plot_color will take only the chatacter variables 
    updateSelectInput(session, "plot_color",
                      label = "colorcode",
                      choices = z_chr)
  })
  
  # plot x ~ y
  doplot <- eventReactive(input$plot,{
    dp <- function(x,y,d){
      library(ggplot2)
      # if any plot_x or plot_y has no input, it will not plot
      if (is.null(x)|is.null(y)){
        return()
      } else {
        # update x & y input
        # first get the index of the plot_x and plot_y
        colNames <- colnames(d)
        px <- grep(x, colNames)
        py <- grep(y, colNames)
        
        # use ggplot do the plot
        g <- ggplot(d,aes(d[,px], d[,py]))
        g <- g + geom_point()
        g <- g + labs(x=x, y=y)
        g
      }
    }
    dp(input$plot_x,input$plot_y,df1())
  })
  output$plot <- renderPlot({doplot()})
  
  # plot x ~ y with a colorcode
  doplot_1 <- eventReactive(input$add_color,{
    dp <- function(x,y,z,d){
      library(ggplot2)
      # if any plot_x, plot_y, or plot_color has no input, it will not plot
      if (is.null(x)|is.null(y)|is.null(z)){
        return()
      } else {
        # update x, y, z input
        # first get the index of the plot_x, plot_y, and plot_color
        colNames <- colnames(d)
        px <- grep(x, colNames)
        py <- grep(y, colNames)
        pz <- grep(z, colNames)
        
        g <- ggplot(d,aes(d[,px], d[,py]))
        g <- g + geom_point(aes(color=d[,pz]))
        g <- g + labs(x=x, y=y)
        g <- g + labs(color=z)
        g
      }
    }
    dp(input$plot_x,input$plot_y, input$plot_color,df1())
  })
  output$plot1 <- renderPlot({doplot_1()})

})
