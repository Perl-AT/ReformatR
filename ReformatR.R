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
           hr(), 
           p("This ", a(href="https://www.rdocumentation.org/packages/shiny", "shiny"), "app takes, as input, .csv reports from Med Associates ", a(href="https://med-associates.com/product/videofreeze-video-fear-conditioning-software/", "Video Freeze"), a(href="https://med-associates.com/wp-content/uploads/2022/09/DOC-321-R1.1-SOF-843-USB-Video-Freeze.pdf", "(manual)"), "and makes, as output, new .csv files containing only key data from the input file, reformatted so as to be readily handleable in R and SPSS."), 
           hr(), 
           h3("Usage"), 
           tags$ol(
             tags$li("Upload intended input file,"), 
             tags$li("select type of experiment (see below),"), 
             tags$li("type the number of tests run in the selected experiment's file (overestimation will not compromise the integrity of the output),"), 
             tags$li("hit the 'Generate reformatted table' button,"), 
             tags$li("double-check the table displayed in the main panel for obvious errors,"), 
             tags$li("type the intended name for the output file, and"), 
             tags$li("hit the 'Save reformatted file' button, and select a destination for the output file.")
           ), 
           hr(), 
           h3("Experiment Types"), 
           p("Note: If an uploaded report was not extracted using the component file indicated under the selected experiment type, and/or does not represent an experiment performed using the indicated protocol, the integrity of the tabular output cannot be guaranteed and is likely compromised."), 
           h5("Acquisition/Tone Test"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("3 Tone Acquisition 75 Sheryl protocol.pro")), 
             tags$li(strong("Component File:"), code("3 TS DelayToneAquandTest Sheryl.cmp"))
           ), 
           h5("5 min/30 sec Context Test"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("Context Test 5 min.pro")), 
             tags$li(strong("Component File:"), code("5minContext30secbinsFIXED.cmp"))
           ), 
           h5("5 min/1 min Context Test"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("5 min context test Days 4 and 5.pro")), 
             tags$li(strong("Component File:"), code("5Minute context test.cmp"))
           ), 
           h5("10 min Pre-Exposure"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("10 min pre-exposure Days 1 and 2.pro")), 
             tags$li(strong("Component File:"), code("10 min preexposure.cmp"))
           ), 
           h5("Immediate Shock"), 
           tags$ul(
             tags$li(strong("Protocol:"), code("Immediate Shock 10sec PSI Day 3.pro")), 
             tags$li(strong("Component File:"), code("immediate shock 10s PSI.cmp"))
           ), 
           br(), 
           p("Output values in columns beginning with 'FREEZING_' are the 'Pct Component Time Freezing' values associated with the indicated component, while values in the corresponding 'MOTION_' columns are 'Avg Motion Index.' It is recommended that 'Shock' components and all components of the 10 min Pre-Exposure test be analyzed according to their MOTION_ data, while all other components have their FREEZING_ data analyzed."), 
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
    SecDF[1,1:6] <- c("test number", "animal", "group", "experiment", "trial", "box")
      
    # Reformatting instructions for Acquisition/Tone Test
    if (input$radio == 1) {
      SecDF[1,7:19] <- paste0("FREEZING_", FirDF[21:33,6])
      SecDF[1,20:22] <- paste0("FREEZING_", c("Tone_AVG", "Shock_AVG", "Trace_AVG"))
      SecDF[1,23:35] <- paste0("MOTION_", FirDF[21:33,6])
      SecDF[1,36:38] <- paste0("MOTION_", c("Tone_AVG", "Shock_AVG", "Trace_AVG"))
      n <- input$NoM
      width <- 38
      type <- "Acquisition/Tone Test"
      pro <- "Protocol file: '3 Tone Acquisition 75 Sheryl protocol.pro'"
      cmp <- "Component file: '3 TS DelayToneAquandTest Sheryl.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(21+(13*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(21+(13*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(21+(13*(i-1))),1]
        SecDF[(i+1),5] <- FirDF[(21+(13*(i-1))),2]
        SecDF[(i+1),6] <- FirDF[(21+(13*(i-1))),3]
        # freezing data
        SecDF[(i+1),7:19] <- FirDF[(21:33+(13*(i-1))),10]
        SecDF[(i+1),20] <- mean(as.numeric(SecDF[(i+1),c(8,11,14)]))
        SecDF[(i+1),21] <- mean(as.numeric(SecDF[(i+1),c(9,12,15)]))
        SecDF[(i+1),22] <- mean(as.numeric(SecDF[(i+1),c(17,18,19)]))
        # motion data
        SecDF[(i+1),23:35] <- FirDF[(21:33+(13*(i-1))),11]
        SecDF[(i+1),36] <- mean(as.numeric(SecDF[(i+1),c(24,27,30)]))
        SecDF[(i+1),37] <- mean(as.numeric(SecDF[(i+1),c(25,28,31)]))
        SecDF[(i+1),38] <- mean(as.numeric(SecDF[(i+1),c(33,34,35)]))
      }
    }
      
    # Reformatting instructions for 5 min/30 sec Context Test
    if (input$radio == 2) {
      SecDF[1,7:16] <- paste0("FREEZING_", FirDF[18:27,6])
      SecDF[1,17] <- "FREEZING_AVG"
      SecDF[1,18:27] <- paste0("MOTION_", FirDF[18:27,6])
      SecDF[1,28] <- "MOTION_AVG"
      n <- input$NoM
      width <- 28
      type <- "5 min/30 sec Context Test"
      pro <- "Protocol file: 'Context Test 5 min.pro'"
      cmp <- "Component file: '5minContext30secbinsFIXED.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(18+(10*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(18+(10*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(18+(10*(i-1))),1]
        SecDF[(i+1),5] <- FirDF[(18+(10*(i-1))),2]        
        SecDF[(i+1),6] <- FirDF[(18+(10*(i-1))),3]
        # freezing data
        SecDF[(i+1),7:16] <- FirDF[(18:27+(10*(i-1))),10]
        SecDF[(i+1),17] <- mean(as.numeric(FirDF[(18:27+(10*(i-1))),10]))
        # motion data
        SecDF[(i+1),18:27] <- FirDF[(18:27+(10*(i-1))),11]
        SecDF[(i+1),28] <- mean(as.numeric(FirDF[(18:27+(10*(i-1))),11]))
        }
      }
    
    # Reformatting instructions for 5 min/1 min Context Test
    # Note: during tests ReformatR did not handle empty rows in the input .csv the way it has for other inputs (i.e. it did not ignore empty rows) -- this was for both tested input files. Keep an eye on this test... 
    if (input$radio == 3) {
      SecDF[1,7:12] <- paste0("FREEZING_", FirDF[18:23,6])
      SecDF[1,13:18] <- paste0("MOTION_", FirDF[18:23,6])
      n <- input$NoM
      width <- 18
      type <- "5 min/1 min Context Test"
      pro <- "Protocol file: '5 min context test Days 4 and 5.pro'"
      cmp <- "Component file: '5Minute context test.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(18+(7*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(18+(7*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(18+(7*(i-1))),1]
        SecDF[(i+1),5] <- FirDF[(18+(7*(i-1))),2]
        SecDF[(i+1),6] <- FirDF[(18+(7*(i-1))),3]
        # freezing data
        SecDF[(i+1),7:12] <- FirDF[(18:23+(7*(i-1))),10]
        # motion data
        SecDF[(i+1),13:18] <- FirDF[(18:23+(7*(i-1))),11]
      }
    }
    
    # Reformatting instructions for 10 min Pre-Exposure
    if (input$radio == 4) {
      SecDF[1,7:17] <- paste0("FREEZING_", FirDF[19:29,6])
      SecDF[1,18:28] <- paste0("MOTION_", FirDF[19:29,6])
      n <- input$NoM
      width <- 28
      type <- "10 min Pre-Exposure"
      pro <- "Protocol file: '10 min pre-exposure Days 1 and 2.pro'"
      cmp <- "Component file: '10 min preexposure.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(19+(11*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(19+(11*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(19+(11*(i-1))),1]
        SecDF[(i+1),5] <- FirDF[(19+(11*(i-1))),2]
        SecDF[(i+1),6] <- FirDF[(19+(11*(i-1))),3]
        # freezing data
        SecDF[(i+1),7:17] <- FirDF[(19:29+(11*(i-1))),10]
        # motion data
        SecDF[(i+1),18:28] <- FirDF[(19:29+(11*(i-1))),11]
      }
    }
    
    # Reformatting instructions for Immediate Shock
    if (input$radio == 5) {
      SecDF[1,7:9] <- paste0("FREEZING_", FirDF[11:13,6])
      SecDF[1,10:12] <- paste0("MOTION_", FirDF[11:13,6])
      n <- input$NoM
      width <- 12
      type <- "Immediate Shock"
      pro <- "Protocol file: 'Immediate Shock 10sec PSI Day 3.pro'"
      cmp <- "Component file: 'immediate shock 10s PSI.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(11+(3*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(11+(3*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(11+(3*(i-1))),1]
        SecDF[(i+1),5] <- FirDF[(11+(3*(i-1))),2]
        SecDF[(i+1),6] <- FirDF[(11+(3*(i-1))),3]
        # freezing data
        SecDF[(i+1),7:9] <- FirDF[(11:13+(3*(i-1))),10]
        # motion data
        SecDF[(i+1),10:12] <- FirDF[(11:13+(3*(i-1))),11]
      }
    }
    
    # Footer information
    SecDF2 <- SecDF
    SecDF2[(n+2:13),1:width] <- ""
    
    SecDF2[(n+3:5),1] <- c(type, pro, cmp)
    SecDF2[(n+6),1] <- "Output values in columns beginning with 'FREEZING_' are the 'Pct Component Time Freezing' values associated with the indicated component, while values in the corresponding 'MOTION_' columns are 'Avg Motion Index.'"
    
    SecDF2[(n+8),1] <- paste("Time of experiment:", as.character(FirDF[1,2]))
    SecDF2[(n+9),1] <- paste("Time of reformatting:", as.character(paste(Sys.time(), "|", Sys.timezone())))
    
    SecDF2[(n+11),1] <- R.version$version.string
    SecDF2[(n+12),1] <- paste("shiny version", packageVersion("shiny"))
    SecDF2[(n+13),1] <- "ReformatR version 1.2"
    
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
