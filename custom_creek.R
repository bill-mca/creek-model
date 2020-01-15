source('./creek_model.R')

###    Creek Model is a program for basic hydraulic modelling of waterways
###    Copyright (C) 2020 William McAlister

# here choose between read.qgis.csv or read.global.mapper.csv
DEFAULT_CSV_READER <- read.qgis.csv

# catchment name for example: Sandhills - Reedy Creek
CATCHMENT_NAME <- 'Landtasia - Mulloon'

#survey data reference. For example:
# Derived from Spatial Services (NSW) 2016 Braidwood LiDAR survey 1m DEM
SURVEY_DATA_REF <- 'Derived from Spatial Services (NSW) 2016 Braidwood LiDAR survey 1m DEM'

shr <- read.csv('input_site_table.csv')
fnames <- paste('input_csvs/', shr$site.code, '.csv', sep='')
coord.list <- lapply(fnames, read.qgis.csv)

thalwegs <- sapply(coord.list, get.thalweg)

transects <- creek.model(read.csv('input_site_table.csv'), read.func=read.qgis.csv)

model.output <- model.from.transects(transects, NULL, '', '')

hydrau <- model.calculation(cbind(model.output, 
                                  shr[ , c('gradient', 
                                           'pi.gradient', 
                                           'roughness')]))

hydraulics.output(hydrau)
