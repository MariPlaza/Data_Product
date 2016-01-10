library(slidify)
library(slidifyLibraries)
library(knitr)
directory<- '/Users/Marines/Documents/6.-R/Cursera/Data_Product/ShinyFinalProject'

setwd(directory)
author("Fruit Comparison - Nutrition")
slidify('index.Rmd')
browseURL('index.html')

publish_github(mariplaza,repo)
