#'Função para extrair valores dos rasters para modelagem usando data frame com coordenadas e data
#'
#'Esta função serve para extrair valores de rasters stacks
#'
#'@param stackday um stack raster
#'@param stackmonth um stack raster
#'@param stacktotal um stack raster
#'@param datfram um Data Frame gerado com a função ETo_BR do pacote com os as coordenadas x e y escritas Lat e Long especificamente, além da data!
#'
#'@example
#'ExtrValRast('2022-06-17',det,stackday,stackmonth,stacktotal)
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias
#'
#'

ExtrValRast <- function(datfram,stackday,stackmonth,stacktotal) {

  date <- as.Date(datfram$Data[10])

  if(!require("pacman")) install.packages("pacman");pacman::p_load(
    raster, rgdal, terra)

  dg <- datfram %>% mutate(y=Lat, x=Long)

  coordinates(dg)<-~x+y #Adicionar coordenadas X e Y ao arquivo

  proj4string(dg) <- CRS("+init=epsg:4326") # Colocar proje??o WGS84 coordenadas geogr?ficas

  mess <- format(date,"%m")
  bspredM <- raster::subset(stackmonth, grep(mess, names(stackmonth), value = T))

  diad <- format(date,"%m%d")
  bspredD <- raster::subset(stackday, grep(diad, names(stackday), value = T))

  vto <- terra::extract(stacktotal, dg)
  vmes <- terra::extract(bspredM, dg)
  vday <- terra::extract(bspredD, dg)
  
  dfmodel<-cbind(datfram,vto,vmes,vday)

  rm(date,diad,mess,dg,bspredM,bspredD,vto,vmes,vday)

  return(dfmodel)
}





