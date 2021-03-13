## global setup for app

library(shiny)
library(DT)
library(googlesheets4)
library(dplyr)
library(ggplot2)


if(nrow(gs4_find("public_ibd_tracker_data"))==0){
  googlesheets4::gs4_create(
    name = "public_ibd_tracker_data",
    sheets = as.data.frame(list(
      "Datetime" = format(Sys.time(),"%Y-%m-%d %H:%M:%S"),
      "Colour" = "Brown",
      "Blood" = FALSE,
      "Bristol_Score" = 4,
      "Sample" = FALSE,
      "Notes" = "Example data"
    )),
  )
}

# Define the fields we want to save from the form
# the names must match the inputID in the UI
fields <- c(
  # "Date",
  # "Time",
  "Datetime",
  "Colour",
  "Blood",
  "Bristol_Score",
  "Sample",
  "Notes"
)

## taken from googleURL
gsheet_id <- gs4_find("public_ibd_tracker_data")$id[1]


saveData <- function(data) {
  # The data must be a dataframe rather than a named vector
  data <- data %>% as.list() %>% data.frame()
  # Add the data as a new row
  googlesheets4::sheet_append(
    ss = gsheet_id,
    data = data
    )
}

loadData <- function() {
  # Read the data
  googlesheets4::read_sheet(
    ss = gsheet_id,
    col_names = TRUE,
    col_types = "ccdddc"
    ) %>%
    arrange(desc(Datetime)) %>%
    mutate(Datetime = as.POSIXct(Datetime))
}
