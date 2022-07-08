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
  MapEToBR,raster)

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


  return(bsprdy)
}



df <- dftv[,-c(1,2,3,4,5,6,7,8,10)]
dd <- dftv[,c(9,1,2,3,4,5,6,7,8,10)]
rm(dftv,stackdaii)

import = recursive_feature_elimination(df, sizes = c(1:33),method_rfe = 'regression',cpu_cores=10,
                                       metric='Rsquared',verbose=T)
vat<-import$results
vat2 <- cbind(as.data.frame(vat),data.frame(seed=rep(Sys.Date()-i, nrow(vat))),
              data.frame(seed=rep(nrow(datfram), nrow(vat))), data.frame(seed=rep(i, nrow(vat))))
names(vat2)

names(vat2) <- c("Variables","RMSE","Rsquared","MAE","RMSESD","RsquaredSD","MAESD",
                 "Data","N","i")

if(exists('vatt')==T){vatt<-rbind(vatt, vat2)}else{vatt<-vat2}

rm(vat,vat2)

ipt<-import$variables

iptg1 <- ipt %>%
  group_by(var,Variables) %>%
  count(var)

iptg2 <- ipt %>%
  group_by(var,Variables) %>%
  summarise(over = mean(Overall))

iptg <- full_join(iptg1,iptg2,by=c('var','Variables'))

rm(import,ipt,iptg1,iptg2)

iptg2 <- cbind(as.data.frame(iptg),data.frame(seed=rep(Sys.Date()-i, nrow(iptg))),
               data.frame(seed=rep(nrow(datfram), nrow(iptg))),data.frame(seed=rep(i, nrow(iptg))))

names(iptg2)
names(iptg2) <- c("var","Variables","n","over","Data","N","i")

if(exists('iptgt')==T){iptgt<-rbind(iptgt, iptg2)}else{iptgt<-iptg2}

rm(iptg,iptg2,datfram)

intrain = createDataPartition(df$ETo, p = 0.9, list = FALSE)

treino = df[intrain,]
valida = df[-intrain,]

ddv <- dd[-intrain,]
rm(dd)

treino<-as.data.frame(treino)

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
