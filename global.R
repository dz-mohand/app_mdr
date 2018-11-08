library(mongolite)
library(shiny)
library(dplyr)
library(shinydashboard)
library(timevis)

options(mongodb = list(
     "host" = "127.0.0.1",
      "port" = "27017",
     "username" = "mohand",
     "password" = "mohand"
   ))
databaseName <- "test"
#collectionName <- "mdr"
 
 saveData <- function(collectionName,data1) {
   # Connect to the database
   db <- mongo(collection = collectionName,
               url = sprintf(
                 "mongodb://%s:%s@%s/%s",
                 options()$mongodb$username,
                 options()$mongodb$password,
                 options()$mongodb$host,
                 databaseName))
   
   # Insert the data into the mongo collection as a data.frame
   data1 <- as.data.frame(data1)
   db$insert(data1)
 }
 
 loadData <- function(collectionName) {
   # Connect to the database
   db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb://%s:%s@%s/%s",
                options()$mongodb$username,
                options()$mongodb$password,
                options()$mongodb$host,
                databaseName))
   
   # Read all the entries
   data <- db$find()
   data
 }
 spectacle_nbr_res <- aggregate(spectacle$nombre_reservation, by=list(Category=spectacle$nom_spectacle), FUN=sum)
 spectacle_count <- count(spectacle, nom_spectacle)
 spectacle_count_site_res <- count(spectacle, nom_spectacle,site_reservation)
 