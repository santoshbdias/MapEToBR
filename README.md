# MapEToBR
MapEToBR é um pacote de R que faz a modelagem da ETo para todo o Brasil de forma fácil e rápida. MapEToBR é um pacote pratico para determinação da ETo para todo brasil em qualquer data dos últimos seis meses.

# Instalação
Para instalar a última versão do pacote MapEToBR siga estes passos:

1 - Instalar os pacotes necesários para iniciar as instalações:
if(!require("pacman")) install.packages("pacman");pacman::p_load(
  devtools)

2 - Instalar via github pacote MapEToBR devtools::install_github("santoshbdias/MapEToBR")

# Exemplo

#Usar o formato de data = "2022-06-14"
det<-ETo_BR(date=Sys.Date()-1) #Para fazer com a data de ontem
