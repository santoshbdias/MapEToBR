# MapEToBR
MapEToBR é um pacote de R que faz a modelagem da ETo para todo o Brasil de forma fácil e rápida. MapEToBR é um pacote pratico para determinação da ETo para todo brasil em qualquer data dos últimos seis meses.

# Instalação
Para instalar a última versão do pacote MapEToBR siga estes passos:

1 - Instalar os pacotes necesários para iniciar as instalações:
```
install.packages(devtools)
```

2 - Instalar via github pacote MapEToBR
```
devtools::install_github("santoshbdias/MapEToBR")
```

# Exemplo

Para refazer os passos do trabalho, faça o download dos rasters base pelo link: https://drive.google.com/drive/folders/1LGWMg4lvgPEQuVwWdr96gaYavRlOXVt3?usp=sharing

```
#Limpar todas as variáveis e memória ocupada pelo R
rm(list = ls()); gc(); removeTmpFiles(h=0)

#Instalar/carregar todos os pacotes necessários
if(!require("pacman")) install.packages("pacman");pacman::p_load(
  raster, rgdal, terra, MapEToBR) 

#Base stacks rasters criado pelo códiog Create_Base_Raster.R

#Rasters de Latitude, Longitude, Elevação WorldClim e Bioclimaticas WorldClim
stacktotal <-  raster::stack(dir(path ='D:/OneDrive/Doutorado/Tese/Base_Dados_BR/bspredTotal',
                                 pattern = ".tif", full.names = TRUE, recursive = T))

#Rasters de dados mensais do WorldClim: temperatura mínima, temperatura máxima, temperatura média, precipitação, radiação solar, velocidade do vento, pressão de vapor de água.
stackmonth <-  raster::stack(dir(path ='D:/OneDrive/Doutorado/Tese/Base_Dados_BR/bspredMes',
                                 pattern = ".tif", full.names = TRUE, recursive = T))

#Rasters diários, como média e desvio padrão da ETo e radiação extraterrestre
stackday <-  raster::stack(dir(path ='D:/OneDrive/Doutorado/Tese/Base_Dados_BR/bspredDay',
                                 pattern = ".tif", full.names = TRUE, recursive = T))

#Usar o formato de data = "2022-06-14"
#Dados da ETo do Brasil para a data de ontem
datfram <- ETo_BR(date=Sys.Date()-1)

#Carregar shapefile Brasil
shapflbr <- readOGR(dsn = 'D:/OneDrive/Doutorado/Tese/Base_Dados_BR/Shape_Brasil/Shape_Brasil.shp')

#Selecionar rasters do dia selecionado e criar raster da radiação extraterrestre para o determinado dia
stackday <- inc.sec.dy.rad.extr(datfram,stackday,shapflbr)

#Conferir rasters selecionados.
plot(stackday)

#Extração dos valores dos rasters para as estações com dados neste dia. Arquivo para fazer treino dos modelos de AI
dftv <- ExtrValRast(datfram,stackday,stackmonth,stacktotal)
```
