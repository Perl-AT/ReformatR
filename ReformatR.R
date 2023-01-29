# Updated XX.XX.2023 by Andrew Perl

library(shiny)

# Layout of user interface
ui <- fluidPage(navbarPage(title="ReformatR 1.0", 
  
  # GUI layout
  tabPanel("GUI", 
    titlePanel("Reformat 'Video Freeze' fear conditioning output files."), 
    sidebarLayout(
      position="left", 
      sidebarPanel(fileInput("file", 
                             "'Video Freeze' .csv file for input: ", 
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
  
  # Embedded README tab
  tabPanel("README", 
           h1("README"), 
           hr(), 
           h3(a(href="https://github.com/Perl-AT/ReformatR", "ReformatR 1.0")), 
           p("This ", a(href="https://www.rdocumentation.org/packages/shiny/versions/1.7.2", "shiny"), "app takes, as input, .csv reports from Med Associates ", a(href="https://med-associates.com/product/videofreeze-video-fear-conditioning-software/", "Video Freeze"), a(href="https://med-associates.com/wp-content/uploads/2022/09/DOC-321-R1.1-SOF-843-USB-Video-Freeze.pdf", "(manual)"), "and makes, as output, new .csv files containing only key data from the input file, reformatted so as to be readily handleable in R and SPSS."), 
           hr(), 
           h3("Usage"), 
           tags$ol(
             tags$li("Open ReformatR.R in R or RStudio and run the code,"), 
             tags$li("upload intended input file,"), 
             tags$li("select type of experiment,"), 
             tags$li("type the number of tests run in the selected experiment's file (overestimation will not compromise integrity of output),"), 
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
           h3("Roadmap"), 
           p("Accommodation for new experiment types can be added into the existing framework ", tags$i("ad libitum", .noWS="after"), "."), 
           hr(), 
           h3("Contributing"), 
           p("Submit issues or pull requests in ", a(href="https://github.com/Perl-AT/ReformatR", "GitHub"), "or reach out to maintainer."), 
           hr(), 
           h3("Changelog"), 
           h5("Version 1.0 | 01.25.2023 (Andrew Perl)"), 
           tags$ul(
             tags$li("Updated to handle reformatting for three additional experiment types."), 
             tags$li("Embedded most README content into the UI itself."), 
             tags$li("Output files now contain informative footers."), 
             tags$li("Fixed the ", code("actionButton"), "(🙌) and other minor quirks.")
           ), 
           h5("Version 0.2 | 10.20.2022 (Andrew Perl)"), 
           tags$ul(
             tags$li("Updated to accommodate corrected .cmp component file for 5 min/30 sec Context Test reports."), 
             tags$li("Addition of 'average' column to 5 min/30 sec Context Test output tables.")
           ), 
           h5("Version 0.1 | 09.23.2022 (Andrew Perl)"), 
           tags$ul(
             tags$li("Reformating for Acquisition/Tone and 5 min/30 sec Context Tests facilitated.")
           ), 
           hr(), 
           h3("Dependency (", tags$i("etc.", .noWS="after"), ") Management"), 
           p(tags$b("ReformatR 1.0"), "has been constructed and tested to reformat reports from ", tags$b("Video Freeze"), tags$u("v2.7.3.0"), "using ", tags$b("R"), "(for Mac) ", tags$u("v4.2.1"), "in ", tags$b("RStudio"), "(for Mac) ", tags$u("v2022.07.0+548,"), "and using the ", tags$b("shiny"), "package ", tags$u("v1.7.2", .noWS="after"), ". It is recommended that users first test ReformatR with different versions of R, RStudio and shiny before sanctioning data produced under their auspices."), 
           hr(), 
           h5("Author and maintainer: Andrew Perl (perlat@nih.gov; atperl123@gmail.com; ", a(href="https://github.com/Perl-AT", "Perl-AT", .noWS="after"), ")")
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
    SecDF[1,1:4] <- c("test number", "animal", "group", "box")
    OP <- 0
      
    # Reformatting instructions for Acquisition/Tone Test
    if (input$radio == 1) {
      SecDF[1,5:17] <- FirDF[21:33,6]
      SecDF[1,18:20] <- c("Tone_AVG", "Shock_AVG", "Trace_AVG")
      n <- input$NoM
      width <- 20
      OP <- 1
      type <- "Acquisition/Tone Test"
      pro <- "Protocol file: '3 Tone Acquisition 75 Sheryl protocol.pro'"
      cmp <- "Component file: '3 TS DelayToneAquandTest Sheryl.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(21+(13*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(21+(13*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(21+(13*(i-1))),3]
        SecDF[(i+1),5:17] <- FirDF[(21:33+(13*(i-1))),10]
        SecDF[(i+1),7] <- FirDF[(23+(13*(i-1))),11]
        SecDF[(i+1),10] <- FirDF[(26+(13*(i-1))),11]
        SecDF[(i+1),13] <- FirDF[(29+(13*(i-1))),11]
        SecDF[(i+1),18] <- mean(as.numeric(SecDF[(i+1),c(6,9,12)]))
        SecDF[(i+1),19] <- mean(as.numeric(SecDF[(i+1),c(7,10,13)]))
        SecDF[(i+1),20] <- mean(as.numeric(SecDF[(i+1),c(15,16,17)]))
      }
    }
      
    # Reformatting instructions for 5 min/30 sec Context Test
    if (input$radio == 2) {
      SecDF[1,5:14] <- FirDF[18:27,6]
      SecDF[1,15] <- "AVG"
      n <- input$NoM
      width <- 15
      type <- "5 min/30 sec Context Test"
      pro <- "Protocol file: 'Context Test 5 min.pro'"
      cmp <- "Component file: '5minContext30secbinsFIXED.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(18+(10*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(18+(10*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(18+(10*(i-1))),3]
        SecDF[(i+1),5:14] <- FirDF[(18:27+(10*(i-1))),10]
        SecDF[(i+1),15] <- mean(as.numeric(FirDF[(18:27+(10*(i-1))),10]))
        }
      }
    
    # Reformatting instructions for 5 min/1 min Context Test
    # Note: during tests ReformatR did not handle empty rows in the input .csv the way it has for other inputs (i.e. it did not ignore empty rows) -- this was for both tested input files. Keep an eye on this test... 
    if (input$radio == 3) {
      SecDF[1,5:10] <- FirDF[18:23,6]
      n <- input$NoM
      width <- 10
      type <- "5 min/1 min Context Test"
      pro <- "Protocol file: '5 min context test Days 4 and 5.pro'"
      cmp <- "Component file: '5Minute context test.cmp'"
      for (i in seq(from=1, to=n)) {
        SecDF[(i+1),1] <- i
        SecDF[(i+1),2] <- FirDF[(18+(7*(i-1))),4]
        SecDF[(i+1),3] <- FirDF[(18+(7*(i-1))),5]
        SecDF[(i+1),4] <- FirDF[(18+(7*(i-1))),3]
        SecDF[(i+1),5:10] <- FirDF[(18:23+(7*(i-1))),10]
      }
    }
    
    # Reformatting instructions for 10 min Pre-Exposure
    if (input$radio == 4) {
      SecDF[1,5:15] <- paste0("Freezing_", FirDF[19:29,6])
      SecDF[1,16:26] <- paste0("Motion_", FirDF[19:29,6])
      n <- input$NoM
      width <- 26
      OP <- 2
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
      OP <- 2
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
    SecDF2[(n+3),1] <- "ReformatR version: 1.0"
    SecDF2[(n+4),1] <- paste0("Date/time: ", as.character(Sys.time()))
    SecDF2[(n+6:8),1] <- c(type, pro, cmp)
    if (OP == 0) {
      SecDF2[(n+9),1] <- "Output values for all components are 'Pct Component Time Freezing.'"
    }
    if (OP == 1) {
      SecDF2[(n+9),1] <- "Output values for all three shocks are 'Avg Motion Index,' and output values for all other components are 'Pct Component Time Freezing.'"
    }
    if (OP == 2) {
      SecDF2[(n+9),1] <- "Output values in 'Freezing_' columns are 'Pct Component Time Freezing,' while values in 'Motion_' columns are 'Avg Motion Index.'"
    }
    
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
