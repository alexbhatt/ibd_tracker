

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

  # Whenever a field is filled, aggregate all form data
  eventData <- reactive({
    data <- sapply(events,function(x) input[[x]])
  })

  # When the Submit button is clicked, save the form data
  observeEvent(input$event, {
    saveEvent(eventData())
  })

  # Show the previous responses
  # (update with current response when Submit is clicked)
  output$responses <- DT::renderDataTable({
    input$submit
    loadData() %>%
      mutate(Datetime = format(Datetime, "%Y-%m-%d %H:%M")) %>%
      datatable(
        options =  list(
          pageLength = 20
        )
      )
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

    # e <- googlesheets4::read_sheet(
    #   ss = gsheet_id,
    #   sheet = gsheet_id_stub2,
    #   col_names = T,
    #   col_types = "Dccc"
    # )

      p <- fullData() %>%
        mutate(Date = as.Date(Datetime)) %>%
        ggplot(aes(x=Date,
                   fill = Colour,
                   color = as.factor(Blood))) +
        geom_bar(stat="count") +
        geom_text(aes(label = Bristol_Score,
                      y = 1),
                  color = "white",
                  position = position_stack(vjust = 0.5)) +
        scale_y_continuous("Bowel motions",
                           breaks = scales::pretty_breaks()) +
        scale_x_date(breaks = "days",
                     date_labels = "%d %b") +
        scale_color_manual("Blood",
                           values = c(
                             "1" = "red",
                             "0" = "white")
                           ) +
        scale_fill_manual(values = c(
          "Brown" = "#A0522D",
          "BrownRed" = "#6e0202",
          "LightBrown" = "#B8860B",
          "Orange" = "#fa4224",
          "Red" = "#ac0404"
        )) +
        theme_bw() +
        theme(panel.grid = element_blank()) +
        coord_flip()

    p

    })
}
