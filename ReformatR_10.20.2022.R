# Updated 10.20.2022 by Andrew Perl

library(shiny)

# Layout of user interface
ui <- fluidPage(
  
  titlePanel("Reformat 'Video Freeze' fear conditioning output files"), 
  
  sidebarLayout(
    position="left", 
    sidebarPanel(fileInput("file", 
                           "'Video Freeze' .csv file for input: ", 
                           accept=".csv"
                           ), 
                 radioButtons("radio", 
                              "Type of experiment: ", 
                              choices=list("Acquisition/Tone Test"=1, 
                                           "Context Test"=2), 
                              selected=1
                              ), 
                 numericInput("NoM", 
                              "Number of animals included in selected file: ", 
                              1, 
                              min=0, 
                              max=1000
                              ), 
                 actionButton("pressme", 
                              "Generate reformatted table"
                              ), 
                 h1(" "
                    ), 
                 h1("==========", 
                    align="center"
                    ), 
                 h1(" "
                    ), 
                 textInput("outputname", 
                           "Name for output file: ", 
                           value=""), 
                 downloadButton("pressme2", 
                              "Save reformatted file")
                 ), 
    mainPanel(tableOutput("SecDF")
              )
  )
)

# Server portion w/ reformatting instructions
server <- function(input, output) {
  
  # Blanket instructions
  observeEvent(input$pressme, {
    output$SecDF <- renderTable({
      file1 <- input$file
      FirDF <- read.csv(file1$datapath, header=FALSE, col.names=c(1:13))
      SecDF <- data.frame()
      SecDF[1,1:4] <- c("number", "animal", "group", "box")
      
      # Reformatting instructions for acquisition/tone tests
      if (input$radio == 1) {
        SecDF[1,5:17] <- FirDF[21:33,6]
        n <- input$NoM
        for (i in seq(from=1, to=n)) {
          SecDF[(i+1),1] <- i
          SecDF[(i+1),2] <- FirDF[(21+(13*(i-1))),4]
          SecDF[(i+1),3] <- FirDF[(21+(13*(i-1))),5]
          SecDF[(i+1),4] <- FirDF[(21+(13*(i-1))),3]
          SecDF[(i+1),5:17] <- FirDF[(21:33+(13*(i-1))),10]
          SecDF[(i+1),7] <- FirDF[(23+(13*(i-1))),11]
          SecDF[(i+1),10] <- FirDF[(26+(13*(i-1))),11]
          SecDF[(i+1),13] <- FirDF[(29+(13*(i-1))),11]
        }
      }
      
      # Reformatting instructions for context test
      else {
          SecDF[1,5:14] <- FirDF[18:27,6]
          SecDF[1,15] <- "AVG"
          n <- input$NoM
          for (i in seq(from=1, to=n)) {
            SecDF[(i+1),1] <- i
            SecDF[(i+1),2] <- FirDF[(18+(10*(i-1))),4]
            SecDF[(i+1),3] <- FirDF[(18+(10*(i-1))),5]
            SecDF[(i+1),4] <- FirDF[(18+(10*(i-1))),3]
            SecDF[(i+1),5:14] <- FirDF[(18:27+(10*(i-1))),10]
            mean <- as.numeric(FirDF[(18:27+(10*(i-1))),10])
            SecDF[(i+1),15] <- mean(mean)
          }
        }
      
      SecDF <<- SecDF
    })
  })
  
  # Save the currently displayed table
  output$pressme2 <- downloadHandler(
    filename = function() {
      paste0(input$outputname, ".csv")
    }, 
    content = function(file2) {
      write.csv(SecDF, file=file2, row.names=FALSE)
    }
  )
  
}

shinyApp(ui=ui, server=server)