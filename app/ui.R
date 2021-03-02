
# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("IBD tracker"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # textInput(inputId = "Date",
      #           label = "Date",
      #           value = Sys.Date()),
      # textInput(inputId = "Time",
      #           label = "Time",
      #           value = format(Sys.time(),"%H:%M:%S")),
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
      actionButton("submit","Add record")
    ),

    # Show the table of results and the history graph
    mainPanel(
      # tableOutput("formD"),
      h3("Last 24 hours"),
      DT::dataTableOutput("last24"), tags$hr(),
      h3("History"),
      plotOutput("day_totals")
    )
  )
)
