# header ------------------------------------------------------------------

# This script accesses the tables stored as Google Sheets which contain
# the course data. Each table is read and stored locally as a CSV.

# library -------------------------------------------------------------------

library(googlesheets4)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)

# script ------------------------------------------------------------------

# course-schedule

gs4_auth()

googlesheets4::read_sheet("1WfhCs-EWzD9oB5tjpP-cqszeqzG0ZorXjTEmfee-EHo") |>
  mutate(title = case_when(
    is.na(page_link) == FALSE ~  paste0("[", title, "](", page_link, "/)"),
    TRUE ~ title
  )) |>
  mutate(start_time = as.character(start_time)) |>
  mutate(start_time = str_extract(start_time, "\\b\\d{2}:\\d{2}\\b")) |>
  mutate(end_time = as.character(end_time)) |>
  mutate(end_time = str_extract(end_time, "\\b\\d{2}:\\d{2}\\b")) |>
  mutate(time = paste(start_time, end_time, sep = " - ")) |>
  write_csv(here::here("data/tbl-01-ost-hs-23-course-schedule.csv"))
