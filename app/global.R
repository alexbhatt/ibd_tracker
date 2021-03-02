## global setup for app

library(shiny)
library(googlesheets4)


# Define the fields we want to save from the form
fields <- c("Date",
            "Time",
            "Colour",
            "Blood",
            "Bristol_Score",
            "Sample",
            "Notes"
            )
