## global setup for app

library(shiny)
library(DT)
library(googlesheets4)
library(googledrive)
library(dplyr)
library(ggplot2)


# designate project-specific cache
options(gargle_oauth_cache = ".secrets")
# check the value of the option, if you like
gargle::gargle_oauth_cache()
# trigger auth on purpose to store a token in the specified cache
# a broswer will be opened

googlesheets4::gs4_auth(
  email = "alex.bhatt@gmail.com"
)

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

## events are seperate
events <- c(
  "Start_Date",
  "Type",
  "Event",
  "Note"
)

## taken from googleURL
gsheet_id <- "1bslpAy0ZeheM6cHdpouB7LL75bUbdfnY1iNjjcR8R6Y"
gsheet_id_stub <- "motions"
gsheet_id_stub2 <- "events"

saveData <- function(data) {
  # The data must be a dataframe rather than a named vector
  data <- data %>% as.list() %>% data.frame()
  # Add the data as a new row
  googlesheets4::sheet_append(
    ss = gsheet_id,
    data = data,
    sheet = gsheet_id_stub
    )
}

saveEvent <- function(data) {
  # The data must be a dataframe rather than a named vector
  data <- data %>% as.list() %>% data.frame()
  # Add the data as a new row
  googlesheets4::sheet_append(
    ss = gsheet_id,
    data = data,
    sheet = gsheet_id_stub2
  )
}

loadData <- function() {
  # Read the data
  googlesheets4::read_sheet(
    ss = gsheet_id,
    sheet = gsheet_id_stub,
    col_names = TRUE,
    col_types = "Tcdddc"
    ) %>%
    arrange(desc(Datetime))
}
