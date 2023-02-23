library(DBI)
library(lubridate)
library(dplyr)

#Query BD
bd <- dbConnect(RSQLite::SQLite(), "A:/Consumo/Simuladores/CREDITO_DB.db")
consumo <- dbGetQuery(bd,"SELECT * FROM ARCHIVO_CREDISOCIAL")
dbDisconnect(bd)

#Lee fecha de inicio para consulta
fechaInicio <- read.delim("D:/Documents and Settings/NM37043/Desktop/Proyectos/R/InformeJornada/fechaInicio.txt", header = F, col.names = "Fecha")
fechaInicio$Fecha <- parse_date_time(fechaInicio$Fecha, c("%d/%m/%Y"))

consumo$FECHA_HORA <- parse_date_time(consumo$FECHA_HORA, c("%d/%m/%Y %H:%M:%S","%d/%m/%Y %H:%M"))
#Mantiene casos desde la fecha de inicio
consumo <- consumo[consumo$FECHA_HORA >= fechaInicio$Fecha,]

consumo$MONTO_APROBADO <- substr(consumo$MONTO_APROBADO,5,nchar(consumo$MONTO_APROBADO))
consumo$MONTO_APROBADO <- gsub("\\.", "", consumo$MONTO_APROBADO)
consumo$MONTO_APROBADO <- gsub(",", ".", consumo$MONTO_APROBADO)
consumo$MONTO_APROBADO <- as.numeric(consumo$MONTO_APROBADO)
str(consumo$MONTO_APROBADO)


## names(resumen) <- c("DESCRIPCION", "TOTAL")
resumen <- consumo %>% group_by(CALIFICA_ARCHIVO) %>% summarise(total = sum(MONTO_APROBADO), casos = n())


summary(consumo)
