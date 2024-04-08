#####################################################################################
##
## Script name: Task_1.1
##
## Purpose of script: To answer question 1.1
##
## Author: Natasha Besseling
## Date Created: 2024-03-08
##
##
## Notes: Task 1.1: Using the Ecosystem Type (EcosystemTypes.shp) and Protected Area layers (ProtectedAreas.shp), calculate the protection level category for each ecosystem type.
##The protected area layer includes areas that have been degazetted. (These are areas that have previously been declared as a protected area but no longer contribute to the conservation estate.) Degazetted Protected Areas are flagged in the NBA_PA_Not column.)
##The name of each ecosystem type is displayed in the Name_18 field. The biodiversity target (expressed as a percentage) for each ecosystem type is displayed in the CNSRV_TRGT field.
##Please clearly document your workflow. You may either save your workflow as a GIS model, or otherwise document each step taken in a script or a text file. Save your outputs of.csv file.
##
##
#####################################################################################
### packages & functions
##load all packages that will be used in the script

require(sf) ## used to work with spatial data
require(tidyverse)  ##used to work with data

#####################################################################################
## load the vector files
protected_areas <- st_read("data/ProtectedAreas.shp")
eco_type <- st_read("data/EcosystemTypes.shp")

## now remove the multi-surface variable to create an appropriate analyses.
protected_areas <- st_zm(protected_areas, drop=TRUE, what = "ZM") ## Use this layer instead of the original


#####################################################################################
### check to see if the spatial files have the same CRS, if not make sure that it has an identical CRS for comparison and analyses

## check and transform CRS if needed
if (st_crs(protected_areas) != st_crs(eco_type)) {
  protected_areas <- st_transform(protected_areas, st_crs(eco_type)) # transform MPA layer to match the CRS of eco data frame
}

## Check if the CRS for the spatial files are identical
st_crs(eco_type) == st_crs(protected_areas)
#[1] TRUE

#####################################################################################
### select columns of interest and remove irrelevant data

## select relevant columns of the ecosystem types: Ecosystem name, polygon area, convervation target
eco_type <- eco_type %>%
  dplyr::select(Name_18, Shape_Area, CNSRV_TRGT)

##select relevant columns of the ecosystem types: protected area name, polygon area, protected area status
##remove Degazetted Protected Areas
protected_areas <- protected_areas %>%
  dplyr::select(CUR_NME, Shape_Area, NBA_PA_Not) %>%
  filter(NBA_PA_Not != "Degazetted")

#####################################################################################
### do an intersection between polygons of the ecosystem and protected area map

## determine the overlaps (intersections) of the ecomap and protected_areas layers and calculate the areas of the new polygons
eco_pa <- st_intersection(eco_type, st_geometry(protected_areas)) %>%
  mutate(area_under_mpa = st_area(.))

head(eco_mpa)

## create a table summarizing ecosystem type and it's extent
eco_mpa_df <- eco_mpa %>%
  dplyr::select(-geom) %>% # remove the geometry column
  as_tibble() %>%
  group_by(P_EcosysType) %>%
  summarise(extent = sum(extent), ## sum the areas
            area_under_mpa = sum(area_under_mpa))

dim(eco_mpa_df)
head(eco_mpa_df)


#####################################################################################
### unload packages

# detach("package:xxx", unload=TRUE)
