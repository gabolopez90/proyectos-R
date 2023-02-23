library(lubridate)
library(RSQLite)
library(sqldf)
library(dplyr)
library(openxlsx)


BD <- dbConnect(RSQLite::SQLite(),dbname = "A:/Consumo/Simuladores/CREDITO_DB.db")
dbListTables(BD)

MODULO_CONSUMO <- dbGetQuery(BD, "SELECT NM, CEDULA, NOMBRE, FECHA_HORA,
                                  CAST(MONTO_APROBADO AS TEXT) AS MONTO_APROBADO,
                                  OBSERVACION, CARGAS_BDV, OTRAS_CARGAS, 
                                  CAST(INGRESOS_BDV AS TEXT),
                                  OTROS_INGRESOS, INGRESOS_USD, CALIFICA_ARCHIVO, 
                                  TIPO_CLIENTE, CANAL, ESTADO, PROYECTOS, AREA, 
                                  CAPITAL_TRABAJO, ADQUISICION, OTROS, PRODUCTO, 
                                  ACTIVIDAD_ECONOMICA, GRUPO_ECONOMICO
                                  FROM ARCHIVO_CREDISOCIAL")
rm(BD)

TOTAL <- table(MODULO_CONSUMO$FECHA_HORA)

TOTAL <- MODULO_CONSUMO %>% count(FECHA_HORA)

PRUEBA <- MODULO_CONSUMO[,c("CEDULA","FECHA_HORA")]
PRUEBA$nueva_fecha <- parse_date_time(PRUEBA$FECHA_HORA, c("%d/%m/%Y %H:%M:%S","%d/%m/%Y %H:%M"))
PRUEBA$nueva_fecha <- parse_date_time(PRUEBA$FECHA_HORA, c("%d/%m/%Y %H:%M:%S","%d/%m/%Y %H:%M"))

MODULO_CONSUMO$FECHA_HORA <- parse_date_time(MODULO_CONSUMO$FECHA_HORA, c("%d/%m/%Y %H:%M:%S","%d/%m/%Y %H:%M"))
str(MODULO_CONSUMO)
