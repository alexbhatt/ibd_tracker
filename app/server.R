

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  observeEvent(input$reset, {
    updateTextInput(session,"Datetime",value = format(Sys.time(),
                                                      "%Y-%m-%d %H:%M:%S"))
    updateTextInput(session,"Notes",value = "")
    updateTextInput(session,"Event",value = "")
    updateTextInput(session,"Note",value = "")
    updateTextInput(session,"Start_Date",value = Sys.Date())
  })

  # Whenever a field is filled, aggregate all form data
  formData <- reactive({
    data <- sapply(fields,function(x) input[[x]])
  })

  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    saveData(formData())
  })

  # When the Submit button is clicked, save the form data
  observeEvent(input$event, {
    saveEvent(eventData())
  })

  output$print <- DT::renderDataTable({
    formData() %>% as.list() %>% as.data.frame()
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

      p <- fullData() %>%
        mutate(Date = as.Date(Datetime),
               blocks = 1:n(),
               Type = "Bowel motions") %>%
        mutate(Type=factor(Type)) %>%
        mutate(Colour = factor(Colour,
                               levels = c(
                                 "LightBrown",
                                 "Brown",
                                 "Orange",
                                 "BrownRed",
                                 "Red"
                               )
        )) %>%
        ggplot(aes(x=Date,
                   fill = Colour,
                   color = as.factor(Blood),
                   na.rm=T)) +
        geom_bar(aes(group=blocks), stat="count", na.rm=T) +
        geom_text(aes(label = Bristol_Score,
                      y = 1),
                  color = "white",
                  position = position_stack(vjust = 0.5),
                  na.rm=T) +
        scale_y_continuous("",breaks = scales::pretty_breaks()) +
        scale_x_date(breaks = "days",
                     date_labels = "%d %b") +
        scale_color_manual("Blood",
                           values = c("1" = "red","0" = "white"),
                           labels = c("No blood","Blood"),
                           na.translate = F,
                           guide = guide_legend(nrow=1)) +
        scale_fill_manual(values = c(
          "LightBrown" = "#B8860B",
          "Brown" = "#A0522D",
          "Orange" = "#fa4224",
          "BrownRed" = "#6e0202",
          "Red" = "#ac0404"
        ),
        na.translate = F,
        guide=guide_legend(nrow=1)) +
        labs(caption = "Numbers within the box represent Bristol Stool scores") +
        coord_flip(clip = "off") +
        theme_bw() +
        theme(panel.grid = element_blank(),
              panel.border = element_blank(),
              plot.margin = margin(0,3,0,0,unit="cm"),
              legend.position = "bottom",
              plot.caption = element_text(hjust=0.5))

    p

    })
}
