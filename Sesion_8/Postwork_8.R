'
ESTE ES UN CAMBIO DE OSWALDO

Un centro de salud nutricional está interesado en analizar estadísticamente y probabilísticamente 
los patrones de gasto en alimentos saludables y no saludables en los hogares mexicanos con base en
su nivel socioeconómico, en si el hogar tiene recursos financieros extras al ingreso y en si presenta 
o no inseguridad alimentaria. Además, está interesado en un modelo que le permita identificar los 
determinantes socioeconómicos de la inseguridad alimentaria.

La base de datos es un extracto de la Encuesta Nacional de Salud y Nutrición (2012) levantada por el 
Instituto Nacional de Salud Pública en México. La mayoría de las personas afirman que los hogares con 
menor nivel socioeconómico tienden a gastar más en productos no saludables que las personas con mayores
niveles socioeconómicos y que esto, entre otros determinantes, lleva a que un hogar presente cierta 
inseguridad alimentaria.

La base de datos contiene las siguientes variables:
  
  nse5f (Nivel socioeconómico del hogar): 1 "Bajo", 2 "Medio bajo", 3 "Medio", 4 "Medio alto", 5 "Alto"
area (Zona geográfica): 0 "Zona urbana", 1 "Zona rural"
numpeho (Número de persona en el hogar)
refin (Recursos financieros distintos al ingreso laboral): 0 "no", 1 "sí"
edadjef (Edad del jefe/a de familia)
sexoje (Sexo del jefe/a de familia): 0 "Hombre", 1 "Mujer"
añosedu (Años de educación del jefe de familia)
ln_als (Logaritmo natural del gasto en alimentos saludables)
ln_alns (Logaritmo natural del gasto en alimentos no saludables)
IA (Inseguridad alimentaria en el hogar): 0 "No presenta IA", 1 "Presenta IA"
'
# Adquisición de datos
df<-read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-08/Postwork/inseguridad_alimentaria_bedu.csv")
head(df)
# Limpiar data frame
df.clean <- df[complete.cases(df),]
head(df.clean)
# Renombrar df.clean para fácil uso
df<-df.clean
head(df)
#
# Asociar labels a categorias usando la función factor() + labels=c()
#
df$nse5f <- factor(df$nse5f,labels=c("Bajo","Medio bajo","Medio","Medio alto","Alto"))
df$area <- factor(df$area,labels=c("Urbana","Rural"))
df$refin <- factor(df$refin,labels = c("No","Si"))
df$sexojef <- factor(df$sexojef,labels = c("H","M"))
df$IA <- factor(df$IA,labels = c("No","Si"))
View(df)
"
1) Plantea el problema del caso
"
#
# Por un lado, se desea analizar los patrones de gasto como función del nivel socioeconómico, 
# la existencia de ingresos extra y si el hogar presenta insuficiencia alimentaria.
#
# También se quiere estimar la probabilidad de que un hogar presente inseguridad alimentaria, 
# como función de ciertos factores como los patrones de gastos, ingresos extra, conformación del hogar, etc.

"
2) Realiza un análisis descriptivo de la información
"
library(dplyr)
library(DescTools)
# Necesitamos analizar los patrones de gasto, relacionados con las variables ln_als,ln_alns, 
# como función de refin, IA y nse5f
#
# Para ello, vamos a obtener el promedio, mediana, moda y sd para el gasto en alimentos 
# saludables y no saludables, para los hogares pertenecientes a cada categoria.
#
# Con este objetivo necesitamos agrupar los datos de los hogares en cada una de las 20 combinaciones posibles
# que derivan de este análisis: 2 (opciones de IA) x 2 (opciones de ingresos extra) x 5 (niveles socioeconómicos).
# Con ese objetivo en mente, usaremos la función group_by() juno con la función summarise, para obtener 
# las medidas de tendencia central antes mencionadas para cada una de las 20 categorias.
#
# Ordenamos los datos de forma descendiente en función del mean(ln_alns), para fines de análisis
df%>%select(nse5f,refin,IA,ln_als,ln_alns)%>%group_by(refin,IA,nse5f)%>%summarize(avg_als=mean(ln_als),med_als=median(ln_als),moda_als=Mode(ln_als)[1],sd_als=sd(ln_als),avg_alns=mean(ln_alns),med_alns=median(ln_alns),moda_alns=Mode(ln_alns)[1],sd_alns=sd(ln_alns))%>%arrange(desc(avg_alns))
# Conclusiones: 
# 1) En terminos absolutos, los hogares que más gastan en alimentos no saludables son los de nivel socio económico alto 
# sin ingresos extra y que no padecen IA. Los que menos gastan en alimentos no saludables son los hogares de NSE5F bajo,
# sin ingresos extra y que presentan IA.
#
# 2) En general, para las 20 diferentes combinaciones de categorias asociadas a IA, NSE5F y REFIN, las medidades 
# de tendencia central coinciden, lo que nos habla de una posible distribución normal. 
# 
# Podríamos usar la función filter() para quedarnos unicamente con los datos de cada una de las 20 combinaciones, 
# si fuera de interes verificar su distribución. Por ejemplo:
# Para los hogares con NSE5F 'Alto', sin ingresos extra y que no padecen IA:
#
df.est<-df%>%filter(refin=="No",IA=="No",nse5f=="Alto")%>%select(ln_alns)
class(df.est)
my_hist <- hist(df.est$ln_alns,main="refin=No, IA=No, nsef5=Alto",xlab="Ln(Gasto en alimentos no saludables)")
#
# Se comprueba que los datos siguen una distribución normal para esta combinación. No es pertinente hacerlo para todas.
#
#
# Sin embargo, hablar del gasto en términos ABSOLUTOS no es del todo concluyente, ya que el hecho de 
# percibir más ingresos implica la posibilidad de ejercer gastos mayores tanto en alimentos saudables
# como no saludables
#
# Considerando lo anterior, una variable adecuada  para caracterizar los patrones de gasto sería la razón
# entre el gasto en alimentos no saludables vs saludables, la cual nos habla más de la toma de decisión
# en cuanto al uso de los recursos disponibles en cada hogar.
#
# Ordenamos los datos de forma descendiente respecto a la razón rateNS=mean(ln_alns)/mean(ln_als) 
# para fines de simplificar el análisis.
#
df%>%select(nse5f,refin,IA,ln_als,ln_alns)%>%group_by(refin,IA,nse5f)%>%summarize(avg_als=mean(ln_als),avg_alns=mean(ln_alns),rateNS=mean(ln_alns)/mean(ln_als))%>%arrange(desc(rateNS))
#
# Conclusiones:
#
# 1) De lo anterior, se encuentra que los hogares que pertenecen a la categoria refin=No, IA=No y NSEF5=Alto
# son los que más gastan en alimentos NO saludables en comparación al gasto en alimentos saludables. 
# Mientras que los hogares que pertenecen a la categoria refin=Si, IA=Si, NSEF5=Bajo son quienes destinan 
# menos dinero al consumo de alimentos no saludables en relación al destinado para el consumo 
# de alimentos saludables.
#
# 2) En general se puede ver que, CONTRARIO A LA OPINIÓN PÚBLICA, los hogares con mejor nivel socioeconómico
# destinan más dinero al consumo de alimentos NO saludables en comparación al usado para alimentos saludables.
#
# Ahora analizaremos, para de cada NSEF5, que hogares priorizan más sus gastos en alimentos saludables.
# Con este fin, ordenaremos los datos por NSE5F de forma descendiente y de forma ascendente en rateNS. 
#
df%>%select(nse5f,refin,IA,ln_als,ln_alns)%>%group_by(refin,IA,nse5f)%>%summarize(avg_als=mean(ln_als),avg_alns=mean(ln_alns),rateNS=mean(ln_alns)/mean(ln_als))%>%arrange(desc(nse5f),rateNS)
#
# Conclusión: 
# Para todo los niveles socioeconómicos, los hogares con ingresos extra y que padecen IA son quienes
# PRIORIZAN MÁS el consumo de alimentos SALUDABLES sobre los NO saludables.
"
3) Calcula probabilidades que nos permitan entender el problema en México
"

"
4) Plantea hipótesis estadísticas y concluye sobre ellas para entender el problema en México
"
# Nos interesa analizar los patrones de gasto en alimentos saludables y no 
# saludables en los hogares mexicanos con base en su nivel socioeconómico, 
# en si el hogar tiene recursos financieros extras al ingreso y en si presenta 
# o no inseguridad alimentaria.
# 
# Tenemos información de un extracto de la Encuesta Nacional de Salud y Nutrición (2012)
# levantada por el Instituto Nacional de Salud Pública en México. Dicho lo anterior, 
# nuestro trabajo es analizar la verasidad de las conclusiones que hemos encontrado
# en nuestro analisis estadístico previo, con base en la información de esta muestra, en relación 
# a la población.
#
# Recordando:
# si n>=30 o conocemos varianza de población => Normal
# si n<30 Y no conocemos varianza de población => t-student
#
# En nuestro caso, desconocemos el dato preciso de las medidas de tendencia
# central y dispersión estadística de la población, usaremos la prueba t.test()
# para verificar si la media muestral para cada una de las 20 combinaciones
# posibles de las variables IA, refin y nse5f son representativas de la población.
#
# Nuestros planteamientos serían:
#
"
1) Existe evidencia estadística para asumir que los hogares mexicanos que 
pertenecen a un nivel socioeconómico (NSE) alto, en promedio, gastan más en alimentos NO saludables 
que los hogares que pertenecen a un nivel socioeconómico (NSE) diferente?
  "
#Graficamente como se presentan las variables a analizar en la hipótesis
library(ggplot2)
#Creación de una variable más para identificar el nivel socioeconómico menor a Alto
df <- data.frame(df %>% mutate(nse5f_analisis = ifelse(nse5f == "Alto", "Alto", "< que Alto")))
ggplot(data = df) +
  geom_boxplot(aes(x = nse5f_analisis, y = ln_alns, colour = nse5f_analisis)) +
  labs(title = "Nivel socioeconómico en hogares con gasto en elimentos NO saludables",
       x = "Nivel socioeconómico",
       y = "Frecuencia") +
  theme_classic()

# Planteamiento de hipótesis:
#
# Hipótesis nula, Ho: mu(ln_alns)_nse5f('alto') <=  mu(ln_alns)_nse5f('< que alto')
# Hipótesis alternativa, Ha: mu(ln_alns)_NSE('alto') >  mu(ln_alns)_NSE('< que alto')
#
# Se están comparando dos grupos, por lo tanto necesitamos analizar la varianza de las
# dos muestras (inferencia sobre la media de dos poblaciones)
#
# Planteamiento de hipótesis intermedias
#

# Hipótesis nula, Ho: ratio=var1/var2=1 sean iguales
# Hipótesis alternativa, Ha: ratio != 1 sean difentes
res <- var.test(df[df$nse5f == "Alto", "ln_alns"],
          df[df$nse5f != "Alto", "ln_alns"],
          ratio = 1, alternative = "two.sided")
pv <- res$p.value[1] #3.636145e-07
# Comprobando pv contra la significancia 
# NC del 90%
if(pv < 0.1) {
  paste("Con un pvalue=",pv," a niveles de confianza del 90% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 90% no EEE para rechazar Ho")
}
# NC 95%
if(pv < 0.05) {
  paste("Con un pvalue=",pv," a niveles de confianza del 95% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 95% no EEE para rechazar Ho")
}
# NC 99 %
if(pv < 0.01) {
  paste("Con un pvalue=",pv," a niveles de confianza del 99% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 99% no EEE para rechazar Ho")
}
# A niveles de confianza estándar, existe evidencia estadística para rechazar Ho en favor de Ha
# Es decir:
# A niveles de confianza estándar, EEE para para rechazar que ratio=1, esto implica
# que ratio != 1. Por consiguiente, var.equal = FALSE
#
# Ahora es momento de poner a prueba las hipótesis iniciales
#
res <- t.test(x = df[df$nse5f == "Alto", "ln_alns"], y = df[df$nse5f != "Alto", "ln_alns"],
       alternative = "greater",
       mu = 0, var.equal = FALSE)
pv <- res$p.value[1]  # 1.381818e-244
# Comprobando pv contra la significancia.
# NC del 90%
if(pv < 0.1) {
  paste("Con un pvalue=",pv," a niveles de confianza del 90% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 90% no EEE para rechazar Ho")
}
# NC 95%
if(pv < 0.05) {
  paste("Con un pvalue=",pv," a niveles de confianza del 95% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 95% no EEE para rechazar Ho")
}
# NC 99 %
if(pv < 0.01) {
  paste("Con un pvalue=",pv," a niveles de confianza del 99% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 99% no EEE para rechazar Ho")
}
# A niveles de confianza estándar, EEE para rechazar Ho en favor de Ha, esto es:
# A niveles de confianza estándar, EEE para asumir que los hogares mexicanos que 
# pertenecen a un NSE alto, en promedio, gastan más en alimentos NO saludables 
# que los hogares que pertenecen a un NSE bajo, contrario a opinión pública


"
2) Existe evidencia estadística para asumir que la razón entre el gasto destinado a
ALNS y el gasto destinado a ALS en los hogares mexicanos que pertenecen a un NSE alto, 
en promedio, es mayor que los hogares que pertenecen a un NSE bajo?
"
#Graficamente como se presentan las variables a analizar en la hipótesis
ggplot(data = df) +
  geom_boxplot(aes(x = nse5f_analisis, y = rateNS, colour = nse5f_analisis)) +
  labs(title = "Nivel socioeconómico en hogares con base a la razón de ALNS/ALS",
       x = "Nivel socioeconómico",
       y = "Frecuencia") +
  theme_classic()

# Planteamiento de hipótesis:
#
# Hipótesis nula, Ho: mu(rateNS)_NSE('alto') <=  mu(rateNS)_NSE('< que alto')
# Hipótesis alternativa, Ha: mu(rateNS)_NSE('alto') >  mu(rateNS)_NSE('< que alto')
#
# Se están comparando dos grupos, primero necesitamos analizar la varianza de las
# dos muestras (inferencia sobre la media de dos poblaciones)
#
# Planteamiento de hipótesis intermedias
#
# Hipótesis nula, Ho: ratio=var1/var2=1
# Hipótesis alternativa, Ha: ratio != 1
res <- var.test(df[df$nse5f_analisis == "Alto", "rateNS"],
                df[df$nse5f_analisis != "Bajo", "rateNS"],
                ratio = 1, alternative = "two.sided")
pv <- res$p.value[1] # 0.005339243
# NC del 90%
if(pv < 0.1) {
  paste("Con un pvalue=",pv," a niveles de confianza del 90% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 90% no EEE para rechazar Ho")
}
# NC 95%
if(pv < 0.05) {
  paste("Con un pvalue=",pv," a niveles de confianza del 95% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 95% no EEE para rechazar Ho")
}
# NC 99 %
if(pv < 0.01) {
  paste("Con un pvalue=",pv," a niveles de confianza del 99% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 99% no EEE para rechazar Ho")
}
# A niveles de confianza estándar, existe evidencia estadística para rechazar Ho en favor de Ha
# Es decir:
# A niveles de confianza estándar, EEE para para rechazar que ratio=1, esto implica
# que ratio != 1. Por consiguiente, var.equal = FALSE
#
# Ahora es momento de poner a prueba las hipótesis iniciales
#
res <- t.test(x = df[df$nse5f == "Alto", "rateNS"], y = df[df$nse5f != "Bajo", "rateNS"],
              alternative = "greater",
              mu = 0, var.equal = FALSE)
pv <- res$p.value[1] #1.070836e-31
# NC del 90%
if(pv < 0.1) {
  paste("Con un pvalue=",pv," a niveles de confianza del 90% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 90% no EEE para rechazar Ho")
}
# NC 95%
if(pv < 0.05) {
  paste("Con un pvalue=",pv," a niveles de confianza del 95% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 95% no EEE para rechazar Ho")
}
# NC 99 %
if(pv < 0.01) {
  paste("Con un pvalue=",pv," a niveles de confianza del 99% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 99% no EEE para rechazar Ho")
}
# A niveles de confianza estándar, EEE para rechazar Ho en favor de Ha, esto es:
# A niveles de confianza estándar, EEE para asumir que la razón entre el gasto destinado a
# ALNS y el gasto destinado a ALS en los hogares mexicanos que pertenecen a un NSE alto, 
# en promedio, es mayor que los hogares que pertenecen a un NSE bajo
"
3) En promedio, los hogares que perciben ingresos extra gastan menos,
en terminos relativos, en ALNS que los hogares que no perciben
ingresos extra.
"
#Graficamente como se presentan las variables a analizar en la hipótesis
ggplot(data = df) +
  geom_boxplot(aes(x = refin, y = rateNS, colour = refin)) +
  labs(title = "Ingreso Extra en hogares con base a la razón de ALNS/ALS",
       x = "Ingreso Extra",
       y = "Frecuencia") +
  theme_classic()
# Planteamiento de hipótesis:
#
# Hipótesis nula, Ho: mu(rateNS)_refin('Si') >=  mu(rateNS)_refin('No')
# Hipótesis alternativa, Ha: mu(rateNS)_refin('Si') <  mu(rateNS)_refin('No')
#
# Se están comparando dos grupos, primero necesitamos analizar la varianza de las
# dos muestras (inferencia sobre la media de dos poblaciones)
#
# Planteamiento de hipótesis intermedias
#
# Hipótesis nula, Ho: ratio=var1/var2=1
# Hipótesis alternativa, Ha: ratio != 1
res <- var.test(df[df$refin == "Si", "rateNS"],
                df[df$refin == "No", "rateNS"],
                ratio = 1, alternative = "two.sided")
pv <- res$p.value[1] # 0.0001289455
# NC del 90%
if(pv < 0.1) {
  paste("Con un pvalue=",pv," a niveles de confianza del 90% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 90% no EEE para rechazar Ho")
}
# NC 95%
if(pv < 0.05) {
  paste("Con un pvalue=",pv," a niveles de confianza del 95% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 95% no EEE para rechazar Ho")
}
# NC 99 %
if(pv < 0.01) {
  paste("Con un pvalue=",pv," a niveles de confianza del 99% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 99% no EEE para rechazar Ho")
}
# A niveles de confianza estándar, existe evidencia estadística para rechazar Ho en favor de Ha
# Es decir:
# A niveles de confianza estándar, EEE para para rechazar que ratio=1, esto implica
# que ratio != 1. Por consiguiente, var.equal = FALSE
#
# Ahora es momento de poner a prueba las hipótesis iniciales
#
res <- t.test(x = df[df$refin == "Si", "rateNS"], y = df[df$refin == "No", "rateNS"],
              alternative = "less",
              mu = 0, var.equal = FALSE)
pv <- res$p.value[1]  #0.000162292
# NC del 90%
if(pv < 0.1) {
  paste("Con un pvalue=",pv," a niveles de confianza del 90% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 90% no EEE para rechazar Ho")
}
# NC 95%
if(pv < 0.05) {
  paste("Con un pvalue=",pv," a niveles de confianza del 95% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 95% no EEE para rechazar Ho")
}
# NC 99 %
if(pv < 0.01) {
  paste("Con un pvalue=",pv," a niveles de confianza del 99% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 99% no EEE para rechazar Ho")
}
# A niveles de confianza estándar, EEE para rechazar Ho en favor de Ha, esto es:
# A niveles de confianza estándar, EEE para asumir que en promedio los hogares 
# que perciben ingresos extra gastan menos, en terminos relativos, en ALNS que 
# los hogares que no perciben ingresos extra

"
4) En promedio, los hogares que padecen insuficiencia alimentaria gastan menos,
en terminos relativos, en ALNS que los hogares que no padecen insuficiencia
alimentaria
"

#Graficamente como se presentan las variables a analizar en la hipótesis
ggplot(data = df) +
  geom_boxplot(aes(x = IA, y = rateNS, colour = IA)) +
  labs(title = "Hogares con Insuficiencia Alimentaria de acuerdo a la razón de ALNS/ALS",
       x = "Insuficiencia Alimentaria",
       y = "Frecuencia") +
  theme_classic()

# Planteamiento de hipótesis:
#
# Hipótesis nula, Ho: mu(rateNS)_IA('Si') >=  mu(rateNS)_IA('No')
# Hipótesis alternativa, Ha: mu(rateNS)_IA('Si') <  mu(rateNS)_IA('No')
#
# Se están comparando dos grupos, primero necesitamos analizar la varianza de las
# dos muestras (inferencia sobre la media de dos poblaciones)
#
# Planteamiento de hipótesis intermedias
#
# Hipótesis nula, Ho: ratio=var1/var2=1
# Hipótesis alternativa, Ha: ratio != 1
res <- var.test(df[df$IA == "Si", "rateNS"],
                df[df$IA == "No", "rateNS"],
                ratio = 1, alternative = "two.sided")
pv <- res$p.value[1] # 1.496197e-11
# NC del 90% # 
if(pv < 0.1) {
  paste("Con un pvalue=",pv," a niveles de confianza del 90% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 90% no EEE para rechazar Ho")
}
# NC 95%
if(pv < 0.05) {
  paste("Con un pvalue=",pv," a niveles de confianza del 95% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 95% no EEE para rechazar Ho")
}
# NC 99 %
if(pv < 0.01) {
  paste("Con un pvalue=",pv," a niveles de confianza del 99% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 99% no EEE para rechazar Ho")
}
# A niveles de confianza estándar, existe evidencia estadística para rechazar Ho en favor de Ha
# Es decir:
# A niveles de confianza estándar, EEE para para rechazar que ratio=1, esto implica
# que ratio != 1. Por consiguiente, var.equal = FALSE
#
# Ahora es momento de poner a prueba las hipótesis iniciales
#
res <- t.test(x = df[df$IA == "Si", "rateNS"], y = df[df$IA == "No", "rateNS"],
              alternative = "less",
              mu = 0, var.equal = FALSE)
pv <- res$p.value[1] # 6.045403e-33
# NC del 90%
if(pv < 0.1) {
  paste("Con un pvalue=",pv," a niveles de confianza del 90% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 90% no EEE para rechazar Ho")
}
# NC 95%
if(pv < 0.05) {
  paste("Con un pvalue=",pv," a niveles de confianza del 95% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 95% no EEE para rechazar Ho")
}
# NC 99 %
if(pv < 0.01) {
  paste("Con un pvalue=",pv," a niveles de confianza del 99% EEE para rechazar Ho en favor de Ha")
} else {
  paste("Con un pvalue=",pv," a  niveles de confianza del 99% no EEE para rechazar Ho")
}
# A niveles de confianza estándar, EEE para rechazar Ho en favor de Ha, esto es:
# A niveles de confianza estándar, EEE para asumir que en promedio los hogares 
# que padecen IA gastan menos, en terminos relativos, en ALNS que 
# los hogares que no padecen IA

"
5) ¿Existe evidencia estadística para concluir que, en promedio, el nivel
socioeconómico tiene efectos sobre el la razón del ln del gasto en ALNS respecto
al gasto en ALS?
"
#Graficamente como se presentan las variables a analizar en la hipótesis
ggplot(data = df) +
  geom_boxplot(aes(x = nse5f, y = rateNS, colour = nse5f)) +
  labs(title = "Nivel socioeconómico en Hogares de acuerdo a la razón de ALNS/ALS",
       x = "Nivel socioeconómico",
       y = "Frecuencia") +
  theme_classic()

# Planteamiento de hipótesis:
# Ho: avg_rateNS_nse(alto) = avg_rateNS_nse(medio alto) = avg_rateNS_nse(medio) = avg_rateNS_nse(medio bajo) = avg_rateNS_nse(bajo)
# Ha: Al menos uno es diferente.

anova <- aov(rateNS ~ nse5f,
             data = df)

summary(anova)  # <2e-16 ***
#
# pvalue < 2e-16
# A niveles de confianza del 90%, 95% y 99 %, la significancia alpha=0.1,0.05,0.01
# se cumple que pvalue < alpha
# Por tanto, a niveles de confianza estándar EEE para rechazar Ho en favor de la Ha
# Es decir, a niveles de confianza estándar EEE de que al menos uno de los 
# promedios es diferente. Esto implica que el nivel socioeconómico si tiene efecto
# sobre la razón entre el gasto en ALNS y ALS.


"
5) Estima un modelo de regresión, lineal o logístico, para identificar los determinantes de la inseguridad alimentaria en México
"

#
# Se quiere estimar la probabilidad de que un hogar presente inseguridad alimentaria o no... 
# Al hablar de probabilidad significa que necesitamos hacer un modelo de regresión logística.
#
# Separamos variables para fácil manejo de las mismas
#
attach(df)
#
# Análisis de correlaciones entre variables numericas
#
df.select <- select(df, numpeho,edadjef,añosedu,ln_als,ln_alns)
round(cor(df.select),4)  
pairs(~ numpeho+edadjef+añosedu+ln_als+ln_alns, 
      data = df, gap = 0.4, cex.labels = 1.5)
#
# Tanto a partir de la matriz de correlación como del análisis visual,
# No hay evidencia de correlación entre las variables numéricas que describen el problema
#
# Ahora es momento de generar el modelo de regesión logística. 
# Primero, usaremos todas las variables disponibles.
#
logistic.1 <- glm(IA ~ nse5f+area+numpeho+refin+edadjef+sexojef+añosedu+ln_als+ln_alns, family = binomial) 
summary(logistic.1)
pseudo_r2.1 <- (logistic.1$null.deviance - logistic.1$deviance)/logistic.1$null.deviance
pseudo_r2.1
# Pseudo R^2=0.0925
#
# ln (p/1-p)=B0 + B1x1 + B2x2 + ...
#
#Declaración de hipótesis
# H_0: Bi = 0
# H_a : Bi != 0
#
# Para el intercepto B0, pvalue < 2x10^-16< alpha=0.05 => a niveles de confianza del 95% se rechaza la hipotesis nula, es decir, B0 != 0
#
# Para B1, pvalue=1.97x10^-6, para B2,B3 y B4, pvalue < 2x10^-16, para todos se cumple que pvalue < alpha=0.05 
#  => A niveles de confianza del 95% se rechaza la hipotesis nula, es decir B1,B2,B3 y B4 != 0. "nse5f"  es un buen estadístico para el modelo
#
# Para B5, pvalue = 0.030585 < alpha=0.05 =>  A niveles de confianza del 95% se rechaza la hipotesis nula
# es decir, B5 != 0 => "area" es un buen estadístico para el modelo
#
# Para B6, pvalue < 2e-16 < alpha=0.05 => A niveles de confianza del 95% se rechaza la hipotesis nula
# es decir, B6 != 0, "numpeho" es un buen estadístico para el modelo
#
# Para B7, pvalue < 2e-16 < alpha=0.05 => A niveles de confianza del 95% se rechaza la hipotesis nula
# es decir, B7 != 0, "refin" es un buen estadístico para el modelo
#
# Para B8, pvalue = 0.35 > alpha=0.05 =>  A niveles de confianza del 95% no se rechaza la hipotesis nula
# es decir, B8 = 0 => "edadjef" NO es un buen estadístico para el modelo
#
# Para B9, pvalue = 0.000299 < alpha=0.05 => A niveles de confianza del 95% se rechaza la hipotesis nula
# es decir, B9 != 0, "sexojef" es un buen estadístico para el modelo
#
# Para B10, pvalue < 2x10^-16< alpha=0.05 => A niveles de confianza del 95% se rechaza la hipotesis nula
# es decir, B9 != 0 => "añosedu" es un buen estadístico para el modelo
#
# Para B11, pvalue = 0.001389 < alpha=0.05 => A niveles de confianza del 95% se rechaza la hipotesis nula
# es decir, B11 != 0, "ln_als" es un buen estadístico para el modelo
#
# Para B12, pvalue = 8.39e-09 < alpha=0.05 => A niveles de confianza del 95% se rechaza la hipotesis nula
# es decir, B12 != 0, "ln_alns" es un buen estadístico para el modelo
#
# Quitamos "edadjef" y creamos un nuevo modelo
#
logistic.2 <- update(logistic.1, ~.-edadjef) 
summary(logistic.2)
pseudo_r2.2 <- (logistic.2$null.deviance - logistic.2$deviance)/logistic.2$null.deviance
pseudo_r2.2
#
# Pseudo R^2=0.09249, mejora el modelo.
#
# Vamos por la interpretación de los coefficientes "odds"
#
exp(coef(logistic.2))# quitamos logaritmo
#
# La probabilidad de padecer IA para un hogar con NSE5F "Medio bajo" es 0.7372 la 
# probabilidad de padecer IA para un hogar con NSE5F "bajo" 
#
# La probabilidad de padecer IA para un hogar con NSE5F "Medio" es 0.5893 la probabilidad 
# de padecer IA para un hogar con NSE5F "bajo" 
#
# La probabilidad de padecer IA para un hogar con NSE5F "Medio alto" es 0.4087 la 
# probabilidad de padecer IA para un hogar con NSE5F "bajo" 
#
# La probabilidad de padecer IA para un hogar con NSE5F "Alto" es 0.2269 la probabilidad
# de padecer IA para un hogar con NSE5F "bajo" 
#
# La probabilidad de padecer IA en una zona rural es 0.9156 la probabilidad de 
# padecer IA en una zona urbana
#
# Con el incremento unitario en el número de personas que habitan el hogar, "numpeho",
# la probabilidad de padecer IA es 1.1914  veces la probabilidad sin dicho aumento
#
# La probabilidad de padecer IA para un hogar con ingresos extra (refin=Si) es 1.483
# la probabilidad de padecer IA para un hogar sin ingresos extra (refin=No) 
#
# La probabilidad de padecer IA para un hogar con jefe de familia mujer es 1.1630 la 
# probabilidad de padecer IA para un hogar con jefe de familia hombre
#
# Con el incremento unitario en el número de años de educación, "años edu", 
# la probabilidad de padecer IA es 0.9485 veces la probabilidad sin el aumento
#
# Con el incremento unitario en el "ln_als", la probabilidad de padecer IA es 0.912 veces
# la probabilidad sin el aumento
#
# Con el incremento unitario en el "ln_als", la probabilidad de padecer IA es 0.906 veces
# la probabilidad sin el aumento
#
"
6) Escribe tu análisis en un archivo README.MD y tu código en un script de R y publica ambos en un repositorio de Github.
"
# Ver directorio Sesion_9 en reositorio: https://github.com/MiguelSP8/Proyecto_R_Team5.git