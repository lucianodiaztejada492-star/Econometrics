#install.packages("dplyr")
#install.packages("tidyverse")
#install.packages("haven")
#install.packages("readr")
#install.packages("readxl")
#install.packages("tidyr")
#install.packages("stringr")
#install.packages("cowplot")
#install.packages("ggplot2")
#install.packages("writexl")
#install.packages("lubridate")


library(dplyr)
library(tidyverse)
library(haven)
library(readr)
library(readxl)
library(tidyr)
library(cowplot)
library(ggplot2)
library(lubridate)
library(writexl)
rm(list=ls())
setwd("C:\\Esta Aplicada-R")


datos <- readxl::read_xlsx("input\\BBDD0324.xlsx")
datos <- select(datos, "Certificado/Unidad Riesgo", "Moneda P?liza", "Cobertura","Estado Cobertura","Fecha Ocurrencia",
       "Fecha Aviso", "Tipo de movimiento", "Fecha Movimiento", "Monto")

colnames(datos)=c("NumCertificado", "Moneda","Cobertura","EstadoCob","FechaOcurr",
                  "FechaAviso","TipoMov","FechaMov","Monto")
write_xlsx(datos, "input\\BBDD0324_IBNR.xlsx")


summary(datos$Moneda)
#Hay 15 825 observaciones que no tienen asignado valor en Moneda.

datos$FechaOcurr <- as.Date(datos$FechaOcurr,format="%d/%m/%Y")
datos$FechaAviso <- as.Date(datos$FechaAviso,format="%d/%m/%Y")
datos$FechaMov <- as.Date(datos$FechaMov,format="%d/%m/%Y")


datos$Moneda[datos$Moneda==1] <-"SOL" 
datos$Moneda[is.na(datos$Moneda)] <- "SOL"
datos$Moneda[datos$Moneda=="2"] <- "DOL"

datos <- mutate(datos, MontoSol=case_when(
  Moneda=="SOL"~Monto,
  Moneda=="DOL"~round(Monto*3.718,2)
))


datos <- datos %>%                                                              
  mutate(PerDesAnual=FechaMov-FechaOcurr,
         PerOcurAnual=year(FechaOcurr)-2016)
write_xlsx(datos, "output\\BBDD0324_IBNR_Anual.xlsx")

#Bloque 2


rm(list=ls())
setwd("C://Estadística Aplicada R//input")
data1 = readxl::read_xlsx("BBDD0324_IBNR_Anual.xlsx")
data2 = data1[data1$TipoMov == "P",] %>%
  group_by(PerDesAnual,PerOcurAnual) %>% 
  summarise(Montos = sum(MontoSol)) %>% 
  arrange(PerDesAnual,PerOcurAnual) %>% 
  ungroup()

data2 = tidyr::spread(data2, key = PerDesAnual, value =Montos)
data2[is.na(data2)]=0
#Pregunta 3:
matriz1=as.matrix(data2)
matriz2=matrix(0,nrow=9,ncol=9)
colnames(matriz2)=0:8
rownames(matriz2)=0:8

matriz2[,1]=matriz1[,2]
matriz2[,2]=matriz1[,3]+matriz1[,2]
matriz2[9,2]=0

matriz2[,3]=matriz2[,2]+matriz1[,4]
matriz2[8,3]=0

matriz2[,4]=matriz2[,3]+matriz1[,5]
matriz2[7,4]=0

matriz2[,5]=matriz2[,4]+matriz1[,6]
matriz2[6,5]=0

matriz2[,6]=matriz2[,5]+matriz1[,7]
matriz2[5,6]=0

matriz2[,7]=matriz2[,6]+matriz1[,8]
matriz2[4,7]=0

matriz2[,8]=matriz2[,7]+matriz1[,9]
matriz2[3,8]=0

matriz2[,9]=matriz2[,8]+matriz1[,10]
matriz2[2,9]=0

rpta=as.data.frame(matriz2)

rm(matriz1, matriz2)

write_xlsx(rpta,"Triángulo_Pagos_Acum.xlsx")

objeto1 = sum(rpta[,1])
objeto2 = sum(rpta[,2])
objeto3 = sum(rpta[,3])
objeto4 = sum(rpta[,4])
objeto5 = sum(rpta[,5])
objeto6 = sum(rpta[,6])
objeto7 = sum(rpta[,7])
objeto8 = sum(rpta[,8])
objeto9 = sum(rpta[,9])

matriz1 = matrix(0,1,9)
rpta = mutate(rpta, fd= objeto2/objeto1)
rpta[2,10]=objeto3/objeto2
rpta[3,10]=objeto4/objeto3
rpta[4,10]=objeto5/objeto4
rpta[5,10]=objeto6/objeto5
rpta[6,10]=objeto7/objeto6
rpta[7,10]=objeto8/objeto7
rpta[8,10]=objeto9/objeto8
rpta[9,10]=1

matriz1[1,1]=rpta[1,10]
matriz1[1,2]=rpta[2,10]
matriz1[1,3]=rpta[3,10]
matriz1[1,4]=rpta[4,10]
matriz1[1,5]=rpta[5,10]
matriz1[1,6]=rpta[6,10]
matriz1[1,7]=rpta[7,10]
matriz1[1,8]=rpta[8,10]
matriz1[1,9]=rpta[9,10]
matriz1  = as.data.frame(matriz1)                                              

objeto11 = matriz1[1,1]*matriz1[1,2]
objeto12 = matriz1[1,1]*matriz1[1,2]*matriz1[1,3]
objeto13 = matriz1[1,1]*matriz1[1,2]*matriz1[1,3]*matriz1[1,4]
objeto14 = matriz1[1,1]*matriz1[1,2]*matriz1[1,3]*matriz1[1,4]*matriz1[1,5]
objeto15 = matriz1[1,1]*matriz1[1,2]*matriz1[1,3]*matriz1[1,4]*matriz1[1,5]*matriz1[1,6]
objeto16 = matriz1[1,1]*matriz1[1,2]*matriz1[1,3]*matriz1[1,4]*matriz1[1,5]*matriz1[1,6]*matriz1[1,7]
objeto17 = matriz1[1,1]*matriz1[1,2]*matriz1[1,3]*matriz1[1,4]*matriz1[1,5]*matriz1[1,6]*matriz1[1,7]*matriz1[1,8]
objeto18 = matriz1[1,1]*matriz1[1,2]*matriz1[1,3]*matriz1[1,4]*matriz1[1,5]*matriz1[1,6]*matriz1[1,7]*matriz1[1,8]*matriz1[1,9]

matriz2[1,1]=objeto11
matriz2[1,2]=objeto12
matriz2[1,3]=objeto13
matriz2[1,4]=objeto14
matriz2[1,5]=objeto15
matriz2[1,6]=objeto16
matriz2[1,7]=objeto17
matriz2[1,8]=objeto18
matriz2[1,9]=1                                                                  

respuesta = diag(apply(rpta,c(1,2),rev))* matriz2                               
#Se busca la diagonal de la matriz inversa




#bloque 3
rm(list=ls())
data1  = readxl::read_xlsx("input//Triangulo_Pagos_Acum.xlsx")
data2 = pivot_longer(data1,2:10,names_to="Variable",values_to="Valor")
data2=filter(data2,data2$Valor!=0)
data2$Valor=data2$Valor/1000

rm(list=ls())
data <- readxl::read_xlsx("input\\Base_Triangulo_Long.xlsx")                    
ggplot(data,aes(y=Valor,x=as.numeric(Variable),color=PerOcurAnual))+
  geom_line(aes(color=PerOcurAnual))+
  xlab("Tiempo")+ylab("Valor")+
  ggtitle("Gráfico de Lineas por Filas")                                         #Creo que es un buen trabajo.

