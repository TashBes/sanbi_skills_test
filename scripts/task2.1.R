#####################################################################################
##
## Script name: task_2.1
##
## Purpose of script:To get the temperature at point locations for species
##
## Author: Natasha Besseling
##
## Date Created: 2024-03-08
##
##
## Notes:Task 2.1: Explain/demonstrate the steps of how you would select
##the 10 most commonly encountered genera from the first file and
##add the average bottom water temperature values from the second
##file to the selected survey records. The expected outcome would
##be a spreadsheet (.csv).
##
##
#####################################################################################
### packages & functions

 require(tidyverse)
 require(sf)
 require(terra)


#####################################################################################
##load data

mean_temp <- rast("data/mean_bottom_temperature_EPSG-9221.tif")

trwl_ctch <- read.csv("data/trawl_survey_catches.csv")


#####################################################################################
### select only the top ten species in the trawl catches

top_10 <- trwl_ctch %>%
  filter(!is.na(genus)) %>% #remove na's
  count(genus)%>%
  order(n) %>%
  slice_head(n = 10)


#####################################################################################
### unload packages

# detach("package:xxx", unload=TRUE)
