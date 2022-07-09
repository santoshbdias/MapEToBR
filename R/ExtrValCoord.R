#'Função para extrair valores dos rasters utilizando coordenadas individuais ou em dataframe
#'
#'Esta função serve para extrair valores de raster
#'
#'@param rasterE um stack raster
#'@param Latitude um conjunto de coordenadas ou coluna dataframe de Latitude
#'@param Longitude um conjunto de coordenadas ou coluna dataframe de Longitude
#'
#'@example
#'ExtrValCoord(rasterE, Latitude, Longitude)
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias
#'

ExtrValCoord <- function(rasterE, Latitude, Longitude) {

  if(!require("pacman")) install.packages("pacman");pacman::p_load(
    raster, rgdal, terra)

  y = Latitude
  x = Longitude

  dg <- data.frame(x = c(x),
                    y = c(y))

  coordinates(dg)<-~x+y #Adicionar coordenadas X e Y ao arquivo

  proj4string(dg) <- crs(rasterE)

  EToLoc <- as.data.frame(terra::extract(rasterE, dg))

  dfmodel <- cbind(data.frame(x = c(x),y = c(y)),EToLoc)
  dfmodel <- as.data.frame(dfmodel)

  names(dfmodel) <- c('Longitude','Latitude','ETo')

  rm(dg,EToLoc,x,y)

  return(dfmodel)
}

