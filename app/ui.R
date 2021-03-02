
# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("IBD tracker"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      dateInput(inputId = "date",
                label = "Date",
                value = Sys.Date()),
      textInput(inputId = "time",
                label = "Time",
                value = format(Sys.time(),"%H:%M:%S")),
      selectInput(inputId = "colour",
                  label = "Colour",
                  choices = c("Yellow","Orange","Brown","BrownRed","Red"),
                  selected = "Brown"),
      selectInput(inputId = "bristol",
                  label = "Bristol Score",
                  choices = c(1:7),
                  selected = 4),
      checkboxInput(inputId = "blood",
                    label = "Blood",
                    value = 0),
      checkboxInput(inputId = "sample",
                    label = "Sample",
                    value = 0),
      textInput(inputId = "note",
                label = "Notes",
                value = ""),
      actionButton(inputId = "submit",
                   label = "Submit")
    ),

    # Show the table of results
    mainPanel(
      DT::dataTableOutput("responses", width = 300), tags$hr(),
    )
  )
)
