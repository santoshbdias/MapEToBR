#'Função gera o raster da modelagem de ETo para todo o Brasil
#'
#'Esta função serve para gerar o raster de ETo para o Brasil
#'
#'@param date um data para modelagem
#'@param stacktotal um stack raster
#'@param stackmonth um stack raster
#'@param stackday um stack raster
#'@param shapflbr um arquivo shapfile load rgdal
#'@param model um modelo para realização da modelagem e criaçõ do mapa raster, caracter baseado no pacote caret
#'
#'@example
#'pred.raster.EToBR(date,stacktotal,stackmonth,stackday,shapflbr,model)
#'
#'@export
#'@return Returns a stack raster day modeling
#'@author Santos Henrique Brant Dias
#'
#'
#'

pred.raster.EToBR <- function(date,stacktotal,stackmonth,stackday,shapflbr,model) {

  datfram <- ETo_BR(date)
  stackdaii <- inc.sec.dy.rad.extr(datfram,stackday,shapflbr)
  dftv <- ExtrValRast(datfram,stackdaii,stackmonth,stacktotal)

  dftv <- dftv %>% na.omit()

  df <- dftv[,-c(1,2,3,4,5,6,7,8,10)]

  rm(datfram,dftv)

  modelo_all <- run_models(df, models= model, formula = NULL,preprocess = NULL,
                           nfolds = 10, repeats = NA, tune_length =5, cpu_cores = 8,
                           metric = "Rsquared",verbose = T)


  mess <- format(date,"%m")
  bspredM <- terra::subset(stackmonth, grep(mess, names(stackmonth), value = T))

  predicao <- stack(stacktotal,bspredM,stackdaii)

  rm(bspredM,stackdaii,df)

  RasterETo <- terra::predict(object = predicao, model = modelo_all, na.rm = TRUE,
    progress = "text")

  rm(modelo_all,predicao,mess)

  plot(RasterETo)

  return(RasterETo)
}

