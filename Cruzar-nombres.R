setwd("A:/GL_Admision/Procesos_Masivos/gl_repo")
options(scipen=999)
library(data.table)
library(stringr)
library(tidyverse)
library(openxlsx)

load("A:/GL_Admision/Procesos_Masivos/gl_repo/insumosR/insumos_Rda/nombres_empresas.Rda")
nombres <- nombres_empresas[,c("RIF","NOMBRE_RIF")]
names(nombres) <- c("CEDULA","NOMBRE")
rm(nombres_empresas)

Data_Jornada <- read.xlsx("D:/Documents and Settings/NM37043/Desktop/REGISTRO PLAYEROS - OPERADORES TURISTICOS 2023.xlsx", startRow = 1)
Data_Jornada <- Data_Jornada[,c("CEDULA","NOMBRE")]
Data_Jornada$CEDULA <- str_remove_all(Data_Jornada$CEDULA, pattern = "\\.")
Data_Jornada$CEDULA <- str_remove_all(Data_Jornada$CEDULA, pattern = "-")
Data_Jornada$CEDULA <- str_replace(Data_Jornada$CEDULA," ", "")
Data_Jornada$CEDULA <- ifelse(is.na(Data_Jornada$CEDULA), 0, Data_Jornada$CEDULA)
Juridico <- Data_Jornada[toupper(substr(Data_Jornada$CEDULA,0,1)) %in% c("J", "M"),]
Data_Jornada <- Data_Jornada[!(toupper(substr(Data_Jornada$CEDULA,0,1)) == "J"),]
Data_Jornada$CEDULA <- str_replace_all(Data_Jornada$CEDULA,"[^0-9.-]", "")
Data_Jornada$CEDULA <- as.numeric(Data_Jornada$CEDULA)
Data_Jornada$CEDULA <- ifelse(is.na(Data_Jornada$CEDULA), 0, Data_Jornada$CEDULA)
Data_Jornada$NAC <-  ifelse(Data_Jornada$CEDULA >= 80000000,"E","V")
Data_Jornada$CEDULA <- str_pad(Data_Jornada$CEDULA, 8, pad = "0")
#Data_Jornada$CEDULA <- sprintf("%08d", Data_Jornada$CEDULA)
Data_Jornada$CEDULA <- paste0(Data_Jornada$NAC,Data_Jornada$CEDULA)
Data_Jornada$NOMBRE <- toupper(Data_Jornada$NOMBRE)
Data_Jornada$NOMBRE <- ifelse(is.na(Data_Jornada$NOMBRE), "SN", Data_Jornada$NOMBRE)
Data_Jornada <- Data_Jornada[,c("CEDULA","NOMBRE")]

comparacion <- merge(Data_Jornada,nombres, by="CEDULA", all.x = TRUE)

rm(nombres, Data_Jornada, BD)

comparacion$dif <- ifelse(comparacion$NOMBRE.x != comparacion$NOMBRE.y, "Verdadero", "Falso")
comparacion$lenght.x <- nchar(comparacion$NOMBRE.x)
comparacion$lenght.y <- nchar(comparacion$NOMBRE.y)
comparacion %>% count(dif)
prueba <- comparacion
prueba <- prueba %>% separate(NOMBRE.x,c("Apellido","Segundo Apellido","Nombre","Segundo Nombre")," ")