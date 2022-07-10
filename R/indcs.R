#'Função para calculo dos indices de avaliação do desepenho de modelos
#'
#'Esta função serve para calcular os indices de desempenho de modelos
#'
#'@param obs : numeric 'data.frame', 'matrix' or 'vector' with observed values
#'@param prd : numeric 'data.frame', 'matrix' or 'vector' with simulated values
#'
#'@example
#'indcs(prd, obs)
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias

indcs <- function(prd, obs){
  if ( length(obs) != length(prd) )
    stop("Invalid argument: 'prd' & 'obs' doesn't have the same length !")


d <- function(prd, obs){#
  # Mean of the observed values
  Om <- mean(obs)
  denominator <- sum( ( abs(prd - Om) + abs(obs - Om)  )^2 )
  if (denominator != 0) {
    d <- 1 - ( sum( (obs - prd)^2 ) / denominator )
  } else {    d <- NA
    warning("'sum((abs(prd-Om)+abs(obs-Om))^2)=0', it is not possible to compute 'IoA'")
  }
  return(d)}

mae <- function (prd, obs){#Mean Absolute Error
  mae <- mean( abs(prd - obs), na.rm = TRUE)
  return(mae)
  }

mape <- function (prd, obs){#Mean Absolute Percentage Error
  mape <- mean( abs((obs - prd)/obs), na.rm = TRUE)
  return(mape)
  }

me <- function (prd, obs){#Mean Error
  me <- mean( prd - obs, na.rm = TRUE)
  return(me)
  }

mpe <- function (prd, obs){#Mean Percentage Error
  mpe <- mean(((obs - prd)/obs), na.rm = TRUE)
  return(mpe)
  }

rmse <- function (prd, obs) {#Root Mean Square Error
  rmse <- sqrt( mean( (obs - prd)^2) )
  return(rmse)
  }

nrmse <- function (prd, obs) {#Normalized Root Mean Square Error
  cte <- sd(obs)
  nrmse <- (sqrt(mean((obs - prd)^2))/cte)*100
  return(nrmse)
  }

NSE <- function (prd, obs){#Nash-sutcliffe Efficiency
  denominator <- sum( (obs - mean(obs))^2 )
  if (denominator != 0) {
    NSE <- 1 - ( sum( (obs - prd)^2 ) / denominator )
  } else { NSE <- NA
    warning("'sum((obs - mean(obs))^2)=0' => it is not possible to compute 'NSE'")
  } # ELSE end
  return(NSE)
  }

mbe <- function (prd, obs){# Mean bias error
  mbe <- mean((prd - obs), na.rm = TRUE)
  return(mbe)
  }

d <- d(prd, obs)
mae <- mae(prd, obs)
mape <- mape(prd, obs)
me <- me(prd, obs)
mpe <- mpe(prd, obs)
rmse <- rmse(prd, obs)
nrmse <- nrmse(prd, obs)
NSE <- NSE(prd, obs)
mbe <- mbe(prd, obs)

indcs <-as.data.frame(cbind(d,mae,mape,me,mpe,rmse,nrmse,NSE,mbe))

return(indcs)
}






