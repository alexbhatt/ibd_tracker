

# Define server logic required to draw a histogram
server <- function(input, output, session) {


  # Whenever a field is filled, aggregate all form data
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })

  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    saveData(formData())
  })

  # Show the previous responses
  # (update with current response when Submit is clicked)
  output$responses <- DT::renderDataTable({
    input$submit
    loadData()
  })

  fullData <- reactive({
    loadData()
  })

  ## format the data

  # data <-

  ## print a graph of the last 24 ours
  output$last24 <-
    renderPlot({

      p <- fullData() %>%
        mutate(Date=as.Date(Datetime)) %>%
        group_by(Date,Colour,Bristol_Score) %>%
        # filter(Datetime >= Sys.time()-60*60*24*2) %>%
        ggplot(aes(x=Date,
                   fill = Colour),
               color = "white") +
        geom_bar(stat="count") +
        geom_text(aes(label = Bristol_Score,
                      y = 1),
                  color = "white",
                  position = position_stack(vjust = 0.5)) +
        scale_y_continuous(breaks = scales::pretty_breaks()) +
        scale_fill_manual(values = c(
          "Brown" = "#A0522D",
          "BrownRed" = "#8B0000",
          "LightBrown" = "#B8860B",
          "Orange" = "#f74b26",
          "Red" = "#FF0000"
        )) +
        theme_bw()

    p

    })
}
