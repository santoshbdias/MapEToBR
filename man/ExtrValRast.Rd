% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ExtrValRast.R
\name{ExtrValRast}
\alias{ExtrValRast}
\title{Função para extrair valores dos rasters para modelagem usando data frame com coordenadas e data}
\usage{
ExtrValRast(datfram, stackday, stackmonth, stacktotal)
}
\arguments{
\item{datfram}{um Data Frame gerado com a função ETo_BR do pacote com os as coordenadas x e y escritas Lat e Long especificamente, além da data!}

\item{stackday}{um stack raster}

\item{stackmonth}{um stack raster}

\item{stacktotal}{um stack raster}
}
\value{
Returns a data.frame with the AWS data requested
}
\description{
Esta função serve para extrair valores de rasters stacks
}
\author{
Santos Henrique Brant Dias
}
