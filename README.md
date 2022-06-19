# MapEToBR
MapEToBR é um pacote de R que faz a modelagem da ETo para todo o Brasil de forma fácil e rápida. MapEToBR é um pacote pratico para determinação da ETo para todo brasil em qualquer data dos últimos seis meses.

# Instalação
Para instalar a última versão do pacote MapEToBR siga estes passos:

1 - Instalar os pacotes necesários para iniciar as instalações:
if(!require("pacman")) install.packages("pacman");pacman::p_load(
  devtools)

2 - Instalar via github pacote MapEToBR devtools::install_github("santoshbdias/MapEToBR")

# Exemplo

1 - 

2 - det <- ETo_BR(date=Sys.Date()-1) 


rm(list = ls()); gc(); removeTmpFiles(h=0)

if(!require("pacman")) install.packages("pacman");pacman::p_load(
  raster, rgdal, terra, MapEToBR)

#Base stacks rasters criado pelo códiog Create_Base_Raster.R
stacktotal <- raster::stack('D:/OneDrive/Doutorado/Tese/C_04_ETo_Diario/bspredTotal.grd')
stackmonth <- raster::stack('D:/OneDrive/Doutorado/Tese/C_04_ETo_Diario/bspredMes.grd')
stackday <- raster::stack('D:/OneDrive/Doutorado/Tese/C_04_ETo_Diario/bspredDay.grd')

#Usar o formato de data = "2022-06-14"
datfram <- ETo_BR(date=Sys.Date()-1)#Para fazer com a data de ontem

dftv <- ExtrValRast(datfram,stackday,stackmonth,stacktotal)

