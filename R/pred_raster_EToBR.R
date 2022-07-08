#'Função gera o raster da modelagem de ETo para todo o Brasil
#'
#'Esta função serve para gerar o raster de ETo para o Brasil
#'
#'@param stackday um stack raster
#'@param shapflbr um arquivo shapfile load rgdal
#'@param datfram um Data Frame gerado com a função ETo_BR do pacote com os as coordenadas x e y escritas Lat e Long especificamente, além da data!
#'
#'@example
#'inc.sec.dy.rad.extr(datfram,stackday,shapflbr)
#'
#'@export
#'@return Returns a stack raster day modeling
#'@author Santos Henrique Brant Dias
#'
#'
#'

if(!require("pacman")) install.packages("pacman");pacman::p_load(
  MapEToBR)

stacktotal <-  raster::stack(dir(path ='D:/OneDrive/Doutorado/Tese/Base_Dados_BR/bspredTotal',
                                 pattern = ".tif", full.names = TRUE, recursive = T))
stackmonth <-  raster::stack(dir(path ='D:/OneDrive/Doutorado/Tese/Base_Dados_BR/bspredMes',
                                 pattern = ".tif", full.names = TRUE, recursive = T))
stackday <- raster::stack(dir(path ='D:/OneDrive/Doutorado/Tese/Base_Dados_BR/bspredDay',
                              pattern = ".tif", full.names = TRUE, recursive = T))

shapflbr <- readOGR(dsn = 'D:/OneDrive/Doutorado/Tese/Base_Dados_BR/Shape_Brasil/Shape_Brasil.shp')

date <- Sys.Date()-1

inc.sec.dy.rad.extr <- function(date,stacktotal,stackmonth,stackday,shapflbr) {

  datfram <- ETo_BR(date)
  stackdaii <- inc.sec.dy.rad.extr(datfram,stackday,shapflbr)
  dftv <- ExtrValRast(datfram,stackdaii,stackmonth,stacktotal)

  dftv <- dftv %>% na.omit()

  df <- dftv[,-c(1,2,3,4,5,6,7,8,10)]

  rm(datfram,dftv,stackdaii)


  return(bsprdy)
}




modelo_all <- run_models(treino, models= c("lm","rf","cubist",'gbm','gaussprRadial','bagEarth',
                                           'svmPoly','icr','pls'),
                         formula = NULL,preprocess = NULL, nfolds = 10, repeats = NA,
                         tune_length =5, cpu_cores = 10, metric = "Rsquared",verbose = T)














for (i in seq(from = 201, to = 400, by = 4)) {

  set.seed(i)
  print(i)

  modelo_all <- run_models(dados, models= c("lm","rf","cubist",'gbm'), formula = NULL, preprocess = NULL,
                           nfolds = 10, repeats = NA, tune_length =5, cpu_cores = 8,
                           metric = "Rsquared",verbose = T)

  raster::predict(
    object = predicao, model = modelo_all$lm, na.rm = TRUE,
    progress = "text",
    filename=paste0('D:/OneDrive/Doutorado/Tese/C_Erosividade_Chuvas_BR/Mapas/eros_lm_',i,'.tif'), overwrite = TRUE)

  raster::predict(
    object = predicao, model = modelo_all$rf, na.rm = TRUE,
    progress = "text",
    filename =paste0('D:/OneDrive/Doutorado/Tese/C_Erosividade_Chuvas_BR/Mapas/eros_rf_',i,'.tif'), overwrite = TRUE)

  raster::predict(
    object = predicao, model = modelo_all$cubist, na.rm = TRUE,
    progress = "text",
    filename =paste0('D:/OneDrive/Doutorado/Tese/C_Erosividade_Chuvas_BR/Mapas/eros_cubist_',i,'.tif'), overwrite = TRUE)

  raster::predict(
    object = predicao, model = modelo_all$gbm, na.rm = TRUE,
    progress = "text",
    filename =paste0('D:/OneDrive/Doutorado/Tese/C_Erosividade_Chuvas_BR/Mapas/eros_gbm_',i,'.tif'), overwrite = TRUE)

}
