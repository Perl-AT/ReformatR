# Updated 02.15.2023 by Andrew Perl

library(shiny)

# Layout of user interface
ui <- fluidPage(navbarPage(title="ReformatR 1.2", 
  
  # GUI layout
  tabPanel("GUI", 
    titlePanel("Reformat Video Freeze reports from fear conditioning experiments."), 
    sidebarLayout(
      position="left", 
      sidebarPanel(fileInput("file", 
                             "Video Freeze report (.csv) for input: ", 
                             accept=".csv"
                             ), 
                   radioButtons("radio", 
                                "Type of experiment: ", 
                                choices=list("Acquisition/Tone Test"=1, 
                                             "Context Test (5 min/30 sec bins)"=2, 
                                             "Context Test (5 min/1 min bins)"=3, 
                                             "10 min Pre-Exposure"=4, 
                                             "Immediate Shock"=5
                                             ), 
                                selected=1
                                ), 
                   numericInput("NoM", 
                                "Number of tests run in selected file: ", 
                                1, 
                                min=0, 
                                max=1000
                                ), 
                   actionButton("pressme", 
                                "Generate reformatted table"
                                ), 
                   hr(), 
                   textInput("outputname", 
                             "Name for output .csv file: ", 
                             value=""), 
                   downloadButton("pressme2", 
                                  "Save reformatted file")
                   ), 
      mainPanel(tableOutput("SecDF")
                )
      )
    ), 
  
  # Usage tab layout
  tabPanel("Usage", 
           h1(a(href="https://github.com/Perl-AT/ReformatR", "ReformatR 1.2")), 
           p("This ", a(href="https://www.rdocumentation.org/packages/shiny", "shiny"), "app takes, as input, .csv reports from Med Associates ", a(href="https://med-associates.com/product/videofreeze-video-fear-conditioning-software/", "Video Freeze"), a(href="https://med-associates.com/wp-content/uploads/2022/09/DOC-321-R1.1-SOF-843-USB-Video-Freeze.pdf", "(manual)"), "and makes, as output, new .csv files containing only key data from the input file, reformatted so as to be readily handleable in R and SPSS."), 
           hr(), 
           h3("Usage"), 
           tags$ol(
             tags$li("Upload intended input file,"), 
             tags$li("select type of experiment,"), 
             tags$li("type the number of tests run in the selected experiment's file (overestimation will not compromise the integrity of the output),"), 
             tags$li("hit the 'Generate reformatted table' button,"), 
             tags$li("double-check the table displayed in the main panel for obvious errors,"), 
             tags$li("type the intended name for the output file, and"), 
             tags$li("hit the 'Save reformatted file' button, and select a destination for the file.")
           ), 
           hr(), 
           h3("Experiment Types"), 
           p("Note: If an uploaded report was not extracted using the component file indicated under the selected experiment type, and/or does not represent an experiment performed using the indicated protocol, the integrity of the tabular output cannot be guaranteed and is likely compromised."), 
           h5("Acquisition/Tone Test"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("3 Tone Acquisition 75 Sheryl protocol.pro")), 
             tags$li(strong("Component File:"), code("3 TS DelayToneAquandTest Sheryl.cmp")), 
             tags$li(strong("ReformatR Output:"), "Output values for all three shocks are 'Avg Motion Index,' and output values for all other components are 'Pct Component Time Freezing.'")
           ), 
           h5("5 min/30 sec Context Test"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("Context Test 5 min.pro")), 
             tags$li(strong("Component File:"), code("5minContext30secbinsFIXED.cmp")), 
             tags$li(strong("ReformatR Output:"), "Output values for all components are 'Pct Component Time Freezing.'")
           ), 
           h5("5 min/1 min Context Test"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("5 min context test Days 4 and 5.pro")), 
             tags$li(strong("Component File:"), code("5Minute context test.cmp")), 
             tags$li(strong("ReformatR Output:"), "Output values for all components are 'Pct Component Time Freezing.'")
           ), 
           h5("10 min Pre-Exposure"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("10 min pre-exposure Days 1 and 2.pro")), 
             tags$li(strong("Component File:"), code("10 min preexposure.cmp")), 
             tags$li(strong("ReformatR Output:"), "Output values in 'Freezing_' columns are 'Pct Component Time Freezing,' while values in 'Motion_' columns are 'Avg Motion Index.'")
           ), 
           h5("Immediate Shock"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("Immediate Shock 10sec PSI Day 3.pro")), 
             tags$li(strong("Component File:"), code("immediate shock 10s PSI.cmp")), 
             tags$li(strong("ReformatR Output:"), "Output values in 'Freezing_' columns are 'Pct Component Time Freezing,' while values in 'Motion_' columns are 'Avg Motion Index.'")
           ), 
           hr(), 
           h3("Getting Help"), 
           p("Reach out to the maintainer for help or to make suggestions, or submit issues or pull requests on ", a(href= "https://github.com/Perl-AT/ReformatR", "GitHub", .noWS="after"), ". Accommodation for new experiment types can be added into the existing framework ", tags$i("ad libitum", .noWS="after"), "."), 
           hr(), 
           h5("Author/Maintainer: Andrew Perl (perlat@nih.gov | atperl123@gmail.com | ", a(href="https://github.com/Perl-AT", "Perl-AT", .noWS="after"), ")")
           )
  
  )
)

# Server portion w/ reformatting instructions
server <- function(input, output) {
  
  # Blanket instructions
  re <- eventReactive(input$pressme, {
    file1 <- input$file
    FirDF <- read.csv(file1$datapath, header=FALSE, col.names=c(1:30))
    SecDF <- data.frame()
    SecDF[1,1:6] <- c("test number", "animal", "group", "box")
      
    # Reformatting instructions for Acquisition/Tone Test
    if (input$radio == 1) {
      SecDF[1,5:17] <- paste0("Freezing_", FirDF[21:33,6])
      SecDF[1,18:20] <- paste0("Freezing_", c("Tone_AVG", "Shock_AVG", "Trace_AVG"))
      SecDF[1,21:33] <- paste0("Motion_", FirDF[21:33,6])
      SecDF[1,34:36] <- paste0("Motion_", c("Tone_AVG", "Shock_AVG", "Trace_AVG"))
      n <- input$NoM
      width <- 36
      type <- "Acquisition/Tone Test"
      pro <- "Protocol file: '3 Tone Acquisition 75 Sheryl protocol.pro'"
      cmp <- "Component file: '3 TS DelayToneAquandTest Sheryl.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(21+(13*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(21+(13*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(21+(13*(i-1))),3]
        # freezing data
        SecDF[(i+1),5:17] <- FirDF[(21:33+(13*(i-1))),10]
        SecDF[(i+1),18] <- mean(as.numeric(SecDF[(i+1),c(6,9,12)]))
        SecDF[(i+1),19] <- mean(as.numeric(SecDF[(i+1),c(7,10,13)]))
        SecDF[(i+1),20] <- mean(as.numeric(SecDF[(i+1),c(15,16,17)]))
        # motion data
        SecDF[(i+1),21:33] <- FirDF[(21:33+(13*(i-1))),11]
        SecDF[(i+1),34] <- mean(as.numeric(SecDF[(i+1),c(22,25,28)]))
        SecDF[(i+1),35] <- mean(as.numeric(SecDF[(i+1),c(23,26,29)]))
        SecDF[(i+1),36] <- mean(as.numeric(SecDF[(i+1),c(31,32,33)]))
      }
    }
      
    # Reformatting instructions for 5 min/30 sec Context Test
    if (input$radio == 2) {
      SecDF[1,5:14] <- paste0("Freezing_", FirDF[18:27,6])
      SecDF[1,15] <- "Freezing_AVG"
      SecDF[1,16:25] <- paste0("Motion_", FirDF[18:27,6])
      SecDF[1,26] <- "Motion_AVG"
      n <- input$NoM
      width <- 26
      type <- "5 min/30 sec Context Test"
      pro <- "Protocol file: 'Context Test 5 min.pro'"
      cmp <- "Component file: '5minContext30secbinsFIXED.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(18+(10*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(18+(10*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(18+(10*(i-1))),3]
        # freezing data
        SecDF[(i+1),5:14] <- FirDF[(18:27+(10*(i-1))),10]
        SecDF[(i+1),15] <- mean(as.numeric(FirDF[(18:27+(10*(i-1))),10]))
        # motion data
        SecDF[(i+1),16:25] <- FirDF[(18:27+(10*(i-1))),11]
        SecDF[(i+1),26] <- mean(as.numeric(FirDF[(18:27+(10*(i-1))),11]))
        }
      }
    
    # Reformatting instructions for 5 min/1 min Context Test
    # Note: during tests ReformatR did not handle empty rows in the input .csv the way it has for other inputs (i.e. it did not ignore empty rows) -- this was for both tested input files. Keep an eye on this test... 
    if (input$radio == 3) {
      SecDF[1,5:10] <- paste0("Freezing_", FirDF[18:23,6])
      SecDF[1,11:16] <- paste0("Motion_", FirDF[18:23,6])
      n <- input$NoM
      width <- 16
      type <- "5 min/1 min Context Test"
      pro <- "Protocol file: '5 min context test Days 4 and 5.pro'"
      cmp <- "Component file: '5Minute context test.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(18+(7*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(18+(7*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(18+(7*(i-1))),3]
        # freezing data
        SecDF[(i+1),5:10] <- FirDF[(18:23+(7*(i-1))),10]
        # motion data
        SecDF[(i+1),11:16] <- FirDF[(18:23+(7*(i-1))),11]
      }
    }
    
    # Reformatting instructions for 10 min Pre-Exposure
    if (input$radio == 4) {
      SecDF[1,5:15] <- paste0("Freezing_", FirDF[19:29,6])
      SecDF[1,16:26] <- paste0("Motion_", FirDF[19:29,6])
      n <- input$NoM
      width <- 26
      type <- "10 min Pre-Exposure"
      pro <- "Protocol file: '10 min pre-exposure Days 1 and 2.pro'"
      cmp <- "Component file: '10 min preexposure.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(19+(11*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(19+(11*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(19+(11*(i-1))),3]
        # freezing data
        SecDF[(i+1),5:15] <- FirDF[(19:29+(11*(i-1))),10]
        # motion data
        SecDF[(i+1),16:26] <- FirDF[(19:29+(11*(i-1))),11]
      }
    }
    
    # Reformatting instructions for Immediate Shock
    if (input$radio == 5) {
      SecDF[1,5:7] <- paste0("Freezing_", FirDF[11:13,6])
      SecDF[1,8:10] <- paste0("Motion_", FirDF[11:13,6])
      n <- input$NoM
      width <- 10
      type <- "Immediate Shock"
      pro <- "Protocol file: 'Immediate Shock 10sec PSI Day 3.pro'"
      cmp <- "Component file: 'immediate shock 10s PSI.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(11+(3*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(11+(3*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(11+(3*(i-1))),3]
        # freezing data
        SecDF[(i+1),5:7] <- FirDF[(11:13+(3*(i-1))),10]
        # motion data
        SecDF[(i+1),8:10] <- FirDF[(11:13+(3*(i-1))),11]
      }
    }
    
    # Footer information
    SecDF2 <- SecDF
    SecDF2[(n+2:9),1:width] <- ""
    SecDF2[(n+3),1] <- "ReformatR version: 1.2"
    SecDF2[(n+4),1] <- paste("Reformatting date/time:", as.character(Sys.time()))
    SecDF2[(n+6:8),1] <- c(type, pro, cmp)
    SecDF2[(n+9),1] <- "Output values in 'Freezing_' columns are 'Pct Component Time Freezing,' while values in 'Motion_' columns are 'Avg Motion Index.'"
    
    SecDF2 <<- SecDF2
    SecDF <<- SecDF
    
    })
  
  output$SecDF <- renderTable({re()})
  
  # Save the currently displayed table
  output$pressme2 <- downloadHandler(
    filename = function() {
      paste0(input$outputname, ".csv")
    }, 
    content = function(file2) {
      write.csv(SecDF2, file=file2, row.names=FALSE)
    }
  )
  
}

shinyApp(ui=ui, server=server)
