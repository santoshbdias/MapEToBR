#'Função para calcular ETo FAO 56 das estações automaticas do Brasil
#'
#'Está função serve para calcular a ETo FAO 56 no Brasil
#'
#'@param date uma data
#'
#'@example
#'ETo_BR()
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias

ETo_BR <- function(date) {

  date <- as.Date(date)

  if(!require("pacman")) install.packages("pacman");pacman::p_load(
    httr,jsonlite,dplyr)

  df<-GET(paste0('https://apitempo.inmet.gov.br/estacao/dados/',date))
  df<-fromJSON(rawToChar(df$content), flatten = TRUE)

  df <- df %>% dplyr::select(c("DT_MEDICAO","DC_NOME","PRE_INS","VL_LATITUDE","UMD_MAX",
                               "UF","TEM_MAX","RAD_GLO","CD_ESTACAO","TEM_MIN","VL_LONGITUDE",
                               "UMD_MIN","VEN_VEL",'TEM_INS','CHUVA'))
  df <- mutate_at(df, vars(PRE_INS,VL_LATITUDE,UMD_MAX,TEM_MAX,RAD_GLO,TEM_MIN,
                           VL_LONGITUDE,UMD_MIN,VEN_VEL,TEM_INS,CHUVA), as.numeric)

  df<-df %>%
    group_by(DC_NOME, DT_MEDICAO,CD_ESTACAO,VL_LATITUDE)%>%
    summarise(tmin = min(TEM_MIN), tmax = max(TEM_MAX),tmean = mean(TEM_INS),
              Rs = sum(RAD_GLO)/1000,u2 = mean(VEN_VEL),Patm = mean(PRE_INS),
              RH_max = max(UMD_MAX),RH_min = min(UMD_MIN), Chuva = sum(CHUVA)) %>%
    na.omit()

  names(df)<-c("Cid","Data","Cod_Estacao","Lat","tmin","tmax","tmean","Rs","u2",
               "Patm","RH_max","RH_min",'Chuva')

  estaut<-GET('https://apitempo.inmet.gov.br/estacoes/T')
  estaut <- fromJSON(rawToChar(estaut$content), flatten = TRUE)

  estaut <- estaut %>% dplyr::select(c("DC_NOME","CD_SITUACAO","TP_ESTACAO","VL_LATITUDE",
                                       "VL_LONGITUDE","VL_ALTITUDE","SG_ESTADO","CD_ESTACAO"))%>%
    na.omit()
  names(estaut)<-c('Cidade','Situacao','Tipo_Estacao','Latitude','Long','Altitude','Estado','Cod_Estacao')


  df<-left_join(df,estaut,by="Cod_Estacao")
  rm(estaut)

  df <- df %>% dplyr::select(c('Cod_Estacao','Cidade','Estado','Lat','Long','tmin','tmax','tmean',
                               'Rs','u2','Patm','RH_max','RH_min','Altitude','Data','Situacao','Chuva')) %>%
    na.omit()

  df <- df[,-1]

  df<-as.data.frame(df)
  df <- mutate_at(df, vars(Altitude,Long), as.numeric)
  df <- mutate_at(df, vars(Data), as.Date)

  daily_eto_FAO56 <- function (lat, tmin, tmax, tmean, Rs, u2, Patm, RH_max, RH_min,
                               z, date)
  {
    delta <- (4098 * (0.6108 * exp(17.27 * tmean/(tmean + 237.3))))/(tmean +
                                                                       237.3)^2
    Patm <- Patm/10
    psy_constant <- 0.000665 * Patm
    DT = (delta/(delta + psy_constant * (1 + 0.34 * u2)))
    PT <- (psy_constant)/(delta + psy_constant * (1 + 0.34 *
                                                    u2))
    TT <- (900/(tmean + 273)) * u2
    e_t <- 0.6108 * exp(17.27 * tmean/(tmean + 237.3))
    e_tmax <- 0.6108 * exp(17.27 * tmax/(tmax + 237.3))
    e_tmin <- 0.6108 * exp(17.27 * tmin/(tmin + 237.3))
    es <- (e_tmax + e_tmin)/2
    ea <- (e_tmin * (RH_max/100) + e_tmax * (RH_min/100))/2
    j <- as.numeric(format(date, "%j"))
    dr <- 1 + 0.033 * cos(2 * pi * j/365)
    solar_decli <- 0.409 * sin((2 * pi * j/365) - 1.39)
    lat_rad <- (pi/180) * lat
    ws <- acos(-tan(lat_rad) * tan(solar_decli))
    Gsc <- 0.082
    ra <- (24 * (60)/pi) * Gsc * dr * ((ws * sin(lat_rad) * sin(solar_decli)) +
                                         (cos(lat_rad) * cos(solar_decli) * sin(ws)))
    rso <- (0.75 + (2 * 10^-5) * z) * ra
    Rns <- (1 - 0.23) * Rs
    sigma <- 4.903 * 10^-9
    Rnl <- sigma * ((((tmax + 273.16)^4) + ((tmin + 273.16)^4))/2) *
      (0.34 - 0.14 * sqrt(ea)) * (1.35 * (Rs/rso) - 0.35)
    Rn <- Rns - Rnl
    Rng <- 0.408 * Rn
    ETrad <- DT * Rng
    ETwind <- PT * TT * (es - ea)
    ETo <- ETwind + ETrad
  }

  det <- df%>%
    mutate(ETo = daily_eto_FAO56(lat=df$Lat, tmin=df$tmin, tmax=df$tmax, tmean=df$tmean,
                                 Rs=df$Rs, u2=df$u2,Patm=df$Patm, RH_max=df$RH_max,
                                 RH_min=df$RH_min, z=df$Altitude, date=df$Data)) %>%
    dplyr::select(c('Cod_Estacao','Cidade','Estado','Lat','Long','Altitude','Data','Situacao',
                    'ETo','Chuva'))

  rm(df,daily_eto_FAO56)
  return(det)
}
