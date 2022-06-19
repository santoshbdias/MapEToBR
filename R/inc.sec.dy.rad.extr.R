#'Função para acrescentar raster radiação extraterrestre do dia
#'
#'Esta função serve criar raster de radiação extraterrestre
#'
#'@param stackday um stack raster
#'@param shapflbr um arquivo shapfile load rgdal
#'@param datfram um Data Frame gerado com a função ETo_BR do pacote com os as coordenadas x e y escritas Lat e Long especificamente, além da data!
#'
#'@example
#'rad.extr(datfram,stackday,shapflbr)
#'
#'@export
#'@return Returns a stack raster day modeling
#'@author Santos Henrique Brant Dias
#'
#'


if(!require("pacman")) install.packages("pacman");pacman::p_load(
  raster, rgdal, terra, MapEToBR)

stackday <- raster::stack('D:/OneDrive/Doutorado/Tese/Base_Dados_BR/bspredDay.grd')

datfram <- ETo_BR(date=Sys.Date()-1)

shapflbr <- readOGR(dsn = 'D:/OneDrive/Doutorado/Tese/Base_Dados_BR/Shape_Brasil/Shape_Brasil.shp')


inc.sec.dy.rad.extr <- function(datfram,stackday,shapflbr) {

  date <- as.Date(datfram$Data[10])

  dj <- as.POSIXlt(date, format = "%d%b%y")$yday


  if(!require("pacman")) install.packages("pacman");pacman::p_load(
    raster, rgdal, terra)

  lamb=23.45*sin((360/365*(dj-80))*pi/180)#Declinação solar
  dD2=1+0.033*cos((360/365)*dj*pi/180)#Constante solar - dist?ncia terra sol


  lat <- init(stackday$meday0101, 'y')
  names(lat)<-'Latitude'


  Hn=acos((-tan(lamb*pi/180)*tan(lat*pi/180)))*180/pi#Angulo zenital
  Qo=37.6*dD2*(pi/180*Hn*sin(lamb*pi/180)*sin(lat*pi/180)+cos(lamb*pi/180)*cos(lat*pi/180)*sin(Hn*pi/180))

  qo_br<-mask(crop(Qo, shapflbr),shapflbr)

  names(qo_br)<-'Latitude'

  #N=2*Hn/15#N? de Horas efetivo de brilho solar com latitude

  #Nascer do Sol = 12 ? N/2
  #P?r do Sol = 12 + N/2

  diad <- format(date,"%m%d")
  bspredD <- raster::subset(stackday, grep(diad, names(stackday), value = T))

  bsprdy <- raster::stack(bspredD,qo_br)

  rm(bspredD,Hn,lat,Qo,stackday,date,dD2,diad,dj,lamb,qo_br)

  return(bsprdy)
}


