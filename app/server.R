

# Define server logic required to draw a histogram
server <- function(input, output, session) {


  # Whenever a field is filled, aggregate all form data
  formData <- reactive({
    data <- sapply(fields,function(x) input[[x]])
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
    input$submit
    loadData()
  })

  output$formD <- renderTable({
    input$submit
    formData() %>%
      as.list() %>%
      data.frame()
  })

  ## format the data
  ## go back 24 hours, time is counted in seconds * min * hours
  output$last24 <- DT::renderDataTable({

      input$submit

    fullData() %>%
      filter(Datetime >= Sys.time()-60*60*24) %>%
      mutate(Datetime = format(Datetime, "%Y-%m-%d %H:%M")) %>%
      # select(-c(Date,Time)) %>%
      datatable(
        options = list(
          order = list(1,'desc')
        )
      )

  })

  ## print a graph of the last 24 ours
  output$day_totals <- renderPlot({

      input$submit

      p <- fullData() %>%
        mutate(Date = as.Date(Datetime)) %>%
        group_by(Date,Colour,Bristol_Score) %>%
        ggplot(aes(x=Date,
                   fill = Colour),
               color = "white") +
        geom_bar(stat="count") +
        geom_text(aes(label = Bristol_Score,
                      y = 1),
                  color = "white",
                  position = position_stack(vjust = 0.5)) +
        scale_y_continuous(breaks = scales::pretty_breaks()) +
        scale_x_date(breaks = "days",
                     date_labels = "%d %b") +
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
