
# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("IBD flare tracker"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(

    sidebarPanel(width = 2,

      ## first set of data collection
      h4("Motions"),
      textInput(inputId = "Datetime",
                label = "Datetime",
                value = Sys.time()),
      selectInput(inputId = "Colour",
                  label = "Colour",
                  choices = c("LightBrown",
                              "Brown",
                              "Orange",
                              "BrownRed",
                              "Red"),
                  selected = "Brown"),
      selectInput(inputId = "Bristol_Score",
                  label = "Bristol Score",
                  choices = c(1:7),
                  selected = 5),
      fluidRow(
        column(6,
        checkboxInput(inputId = "Blood",
                      label = "Blood",
                      value = TRUE)
        ),
        column(6,
        checkboxInput(inputId = "Sample",
                      label = "Sample",
                      value = FALSE)
        )
      ),
      textInput(inputId = "Notes",
                label = "Notes",
                value = ""),
      actionButton("submit","Add bowel motion"),
      actionButton("reset","Reset fields")
    ),

    # Show the table of results and the history graph
    mainPanel(width = 10,
              h4("left_side_input"),
      DT::dataTableOutput("print"),
      h4("responses"),
          DT::dataTableOutput("responses"), tags$hr(),
        h4("History"),
          plotOutput("day_totals")
        )
      )
    )
