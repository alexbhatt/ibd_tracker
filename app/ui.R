
# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("IBD tracker"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(

    sidebarPanel(

      ## first set of data collection
      h3("Motions"),
      textInput(inputId = "Datetime",
                label = "Datetime",
                value = Sys.time()),
      selectInput(inputId = "Colour",
                  label = "Colour",
                  choices = c("Yellow","Orange","Brown","BrownRed","Red"),
                  selected = "BrownRed"),
      selectInput(inputId = "Bristol_Score",
                  label = "Bristol Score",
                  choices = c(1:7),
                  selected = 5),
      checkboxInput(inputId = "Blood",
                    label = "Blood",
                    value = TRUE),
      checkboxInput(inputId = "Sample",
                    label = "Sample",
                    value = FALSE),
      textInput(inputId = "Notes",
                label = "Notes",
                value = ""),
      actionButton("submit","Add bowel motion"),

      ## annotative dataset
      h3("Events"),
      textInput(inputId = "Start_Date",
                label = "Date",
                value = Sys.Date()),
      selectInput(inputId = "Type",
                  label = "Type",
                  choices = c("Treatment","Admission","Consult","Diagnoistic"),
                  selected = "Treatment"),
      textInput(inputId = "Event",
                label = "Event",
                value = ""),
      textInput(inputId = "Note",
                label = "Note",
                value = ""),
      actionButton("event","Add event")
    ),

    # Show the table of results and the history graph
    mainPanel(


      # tableOutput("formD"),
      h3("Last 24 hours"),
      DT::dataTableOutput("last24"), tags$hr(),
      h3("History"),
      plotOutput("day_totals")



    ) # mainClose
  ) # sidebarClose
)
