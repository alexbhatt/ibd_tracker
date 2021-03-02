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
googlesheets4::sheets_auth()
# see your token file in the cache, if you like
list.files(".secrets/")
# sheets reauth with specified token and email address
sheets_auth(
  cache = ".secrets",
  email = "alex.bhatt@gmail.com"
)

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

## taken from googleURL
gsheet_id <- "1bslpAy0ZeheM6cHdpouB7LL75bUbdfnY1iNjjcR8R6Y"
gsheet_id_stub <- "motions"

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

loadData <- function() {
  # Read the data
  googlesheets4::read_sheet(
    gsheet_id,
    col_names = TRUE,
    col_types = "Tcdddc"
    ) %>%
    arrange(desc(Datetime))
}
