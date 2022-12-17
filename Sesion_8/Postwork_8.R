'
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
#
# Consideración:
#
# Hablar del gasto en términos absolutos no es del todo concluyente, 
# ya que el hecho de percibir más ingresos implica la posibilidad de ejercer 
# gastos mayores tanto en alimentos saudables como no saludables.
#
# Tomando en cuenta lo anterior, una variable adecuada para analizar los patrones
# de gasto sería la razón entre el ln del gasto en alimentos no saludables vs saludables,
# lo cual nos habla más de la toma de decisión en cuanto al uso de los recursos 
# disponibles en cada hogar rateNS=ln_alns/ln_als
#
# Agregamos columna rateNS
df <- data.frame(df%>%mutate(rateNS=ln_alns/ln_als))
View(df)
"
1) Plantea el problema del caso
"
#
# Por un lado, se desea analizar los patrones de gasto como función de algunos deterninantes socioeconómicos:
# 1) El nivel socioeconómico 
# 2) La existencia de ingresos extra
# 3) Si el hogar presenta insuficiencia alimentaria
#
# También se quiere estimar la probabilidad de que un hogar presente inseguridad alimentaria, 
# como función de ciertos factores como la edad, el sexo y la educación del jefe del hogar, la zona geográfica
# en donse se encuentra el hogar, los patrones de gastos, ingresos extra, conformación del hogar, etc. 
# Así como determinar cuáles de esos factores son determinantes para que un hogar padezca o no 
# insuficiencia alimentaria.

"
2) Realiza un análisis descriptivo de la información
"
# Carga de paqueterias de interés para el proyecto
library(dplyr)
library(DescTools)
library(moments)
library(ggpubr)
#
# Se está trabajando con un extracto de la Encuesta Nacional de Salud y Nutrición (2012)
# levantada por el Instituto Nacional de Salud Pública en México. En busca de llevar a cabo 
# el análisis descriptivo de la información, comenzaremos por estudiar cómo está constituida
# la base de datos con la que se está trabajando.
#
#
# Visualización descriptiva de datos por variable
#
# nse5f
#
p1 <-ggplot(df, aes(x=nse5f)) + 
  geom_bar(fill="darkblue",width = 0.9, alpha = c(0.3,0.45,0.5,0.65,0.8)) +
  scale_y_continuous(limits = c(0, 4500),
                     breaks = seq(0,4500, 500)) + 
  labs(x = "Nivel socioeconómico",
       y = "Frecuencia") + 
  theme_classic()
p1 <- p1+  geom_text(aes(label = ..count..), stat = "count", vjust = 1.5, colour = "red",  size=5)+ 
  theme(text = element_text(size = 20),axis.text = element_text(size = 12))
p1
#
# Zona
#
p2 <-ggplot(df, aes(x=area)) + 
  geom_bar(fill="darkblue",width = 0.9, alpha = c(0.45,0.8)) +
#  scale_y_continuous(limits = c(0, 4500),
#                     breaks = seq(0,4500, 500)) + 
  labs(x = "Zona geográfica",
       y = "Frecuencia") +
  scale_y_continuous(limits = c(0, 15000),
                     breaks = seq(0,15000, 3000)) + 
  theme_classic() 
p2 <- p2+  geom_text(aes(label = ..count..), stat = "count", vjust = 1.5, colour = "red",  size=6)+ 
  theme(text = element_text(size = 20))

p2
#
# refin
#
p3 <-ggplot(df, aes(x=refin)) + 
  geom_bar(fill="darkblue",width = 0.9, alpha = c(0.45,0.8)) +
  #  scale_y_continuous(limits = c(0, 4500),
  #                     breaks = seq(0,4500, 500)) + 
  labs(x = "Ingresos extra",
       y = "Frecuencia") +
  scale_y_continuous(limits = c(0, 18000),
                     breaks = seq(0,18000, 2000)) + 
  theme_classic()
p3 <- p3+  geom_text(aes(label = ..count..), stat = "count", vjust = 1.5, colour = "red",  size=6)+ 
  theme(text = element_text(size = 20))

p3
#
# Sexo
#
p4 <-ggplot(df, aes(x=sexojef)) + 
  geom_bar(fill="darkblue",width = 0.9, alpha = c(0.45,0.8)) +
  #  scale_y_continuous(limits = c(0, 4500),
  #                     breaks = seq(0,4500, 500)) + 
  labs(x = "Sexo jefe del hogar",
       y = "Frecuencia") +
  scale_y_continuous(limits = c(0, 16000),
                     breaks = seq(0,16000, 2000)) +
  theme_classic()
p4 <- p4+  geom_text(aes(label = ..count..), stat = "count", vjust = 1.5, colour = "red",  size=6)+ 
  theme(text = element_text(size = 20))

p4
#
# IA
#
p5 <-ggplot(df, aes(x=IA)) + 
  geom_bar(fill="darkblue",width = 0.9, alpha = c(0.45,0.8)) +
  #  scale_y_continuous(limits = c(0, 4500),
  #                     breaks = seq(0,4500, 500)) + 
  labs(x = "Insuficiencia alimentaria",
       y = "Frecuencia") +
  scale_y_continuous(limits = c(0, 15000),
                     breaks = seq(0,15000, 3000)) + 
  theme_classic()
p5 <- p5 +  geom_text(aes(label = ..count..), stat = "count", vjust = 1.5, colour = "red",  size=6)+ 
  theme(text = element_text(size = 20))

p5
#
# numpeho
#
p6 <- ggplot(df, aes(x=numpeho)) +
  geom_histogram(color="darkblue",fill="darkblue",bins =20,alpha=0.4 ) + 
  labs(x = "no. Personas en hogar",
       y = "Frecuencia") + 
  theme_classic()
p6 <- p6 + theme(text = element_text(size = 20))

p6
#
# edad jefe
#
p7 <- ggplot(df, aes(x=edadjef)) +
  geom_histogram(color="darkblue",fill="darkblue",bins =15,alpha=0.4 ) + 
  labs(x = "Edad de jefe",
       y = "Frecuencia") + 
  theme_classic()
p7 <- p7+ theme(text = element_text(size = 20))

p7
#
# años edu
#
p8 <- ggplot(df, aes(x=añosedu)) +
  geom_histogram(color="darkblue",fill="darkblue",bins =12,alpha=0.4 ) + 
  labs(x = "Años de educación jefe",
       y = "Frecuencia") + 
  theme_classic()
p8 <- p8+ theme(text = element_text(size = 20))

p8
#
# En busca de optimizar la presentación de datos, vamos a incluir las gráficas anteriores
# como paneles en un solo gráfico. Con este fin, usaremos la función ggarrange().
#
figure <- ggarrange(p1, p2, p3, p4, p5, p6, p7, p8, 
                    labels = c("A","B", "C","D","E","F","G","H"),
                    ncol = 4, nrow = 2)
annotate_figure(figure)#,
#                top = text_grob("Distribución del ln_als \n", color = "black", face = "bold", size = 16))
dev.off()
#
# Conclusiones:
#
# La información en las gráficas nos ayuda a entender de mejor manera como está 
# constituída la muestra que estamos analizando. En allas, es posible ver que la
# distribución de hogares como función del nivel socioeconómico es aproximadamente
# uniforme, aumenando ligeramente hacia los niveles socioeconómicos más altos. 
# Hay aproximadamente una razon de 2:1 hogares en zona urbana respecto a los hogares
# en zona rural. Así mismo, aproximadamente 3 de cada 4 hogares no percibe ingresos
# extra. También se puede ver que existe una proporción mayor al 2:1 en cuanto a los 
# hogares que precentan insuficiencia alimentaria respecto alos que no. En cuanto a 
# la constitución del hogar, cerca de 3 de cada 4 hogares tiene jefe de hogar hombre.
# La distribución del número de habitantes en el hogar es cercana a una normal, 
# con un sesgo a la derecha (distribución tipo gamma). Algo similar se observa 
# en la distribución de edad del jefe de familia. La distribución de los años de
# estudio es algo más complicada de entender, los picos coinciden con la culminación
# de algún grado, siendo los maás frecuentes los asociados a la secundaria y preparatoria.
#
#
# Ahora que ya conocemos nuestra muestra, es momento de analizar los patrones de 
# gasto en alimentos saludables (ALS) y no slaudables (ALNS), mediante las variables ln_als, 
# ln_alns y la definida por nosotros, rateNS,  como función de los factores de 
# interés refin, IA y nse5f. Como una primera aproximación, nos centraremos en 
# el análisis de los patrones de gasto en relación a cada una de estás variables, 
# de forma individual.
#
#
# Para este fin, usaremos el siguiente procedimento:
# 
# Seleccionamos datos de interes usando select(), agrupamos conforme a las variables 
# refin, IA y nse5f, según sea el cas, a través de la función group_by(). Luego calculamos
# los observables de interés mediante la función summarise(). Para el este primer anáisis
# nos enfocaremos en la media: mean(), mediana: median(), desviación estándar: sd()
# sesgo: skewness(), curtosis: kurtosis() y el conteo de eventos : n().
#
# nse5f : nivel socioeconómico
#
df.vis<-df%>%group_by(nse5f)%>%summarise(avg_als=mean(ln_als),
                                         med_als=median(ln_als),
                                         sd_als=sd(ln_als),
                                         ses_als=skewness(ln_als),
                                         cur_als=kurtosis(ln_als),
                                         avg_alns=mean(ln_alns),
                                         med_alns=median(ln_alns),
                                         sd_alns=sd(ln_alns),
                                         ses_alns=skewness(ln_alns),
                                         cur_alns=kurtosis(ln_alns),
                                         avg_rate=mean(rateNS),
                                         sd_rate=sd(rateNS),
                                         n=n())%>%arrange(nse5f)
df.vis.nse<- data.frame(df.vis)
df.vis.nse
View(df.vis.nse)
# Visualización de distribuciones de datos ln_als y la_alns
p1 <- ggplot(df, aes(x=ln_als)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  #  geom_histogram(aes(y=after_stat(count / sum(count)),color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "Saludables", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
p1
p2 <- ggplot(df, aes(x=ln_alns)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  #  geom_histogram(aes(y=after_stat(count / sum(count)),color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "No Saludables", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
p2
# Creamos gráfica de dos paneles
figure <- ggarrange(p1, p2, 
                    labels = c("A","B"),
                    ncol = 2, nrow = 1)
annotate_figure(figure)#,
#                top = text_grob("Distribución del ln_als \n", color = "black", face = "bold", size = 16))
dev.off()
#
# Observaciones:
# 1) El promedio del ln del gasto, tanto en ALS como en los ALNS y en la razon rateNS, 
# aumenta conforme mejora el nivel socioeconómico. Contrario a la opinión publica,
# en promedio, los hogares de NSE altos gastan más en ALNS que los hogares 
# pertenecientes a los NSE bajos, no solo en términos absolutos, sino también
# en términos relativos con respecto al gasto en ALS. PRUEBA DE HIPÓTESIS PENDIENTE
#
# 2) Las medidas de tendencia central (media y mediana) coinciden, en lo general, 
# tanto para los ALS como para los ALNS, lo que nos habla de distribuciones cercanas
# a una gaussiana.
#
# 3) Para todos los NSE, se presenta sesgo a la izquierda (s<0) en la distribución 
# del ln(ALS) y una curtosis mayor a 3 (leptocúrtica). Esto nos habla de una cierta
# homogeneidad en el patrón de gasto en ALS de los hogaresque pertenecen al mismo NSE.
# Lo anterior se puede corroborar en la gráfica p1, ariba generada.
#
# 4) Para todos los NSE, se presenta sesgo a la derecha (s>0) en la distribución 
# del ln(ALNS) y una curtosis menor que y aproximadamente igual a 3 (mesocúrtica). 
# Esto nos dice que el patrón de gasto en ALNS de los hogares que pertenecen al 
# mismo NSE es menos uniforme en comparación con el patron de gasto en ALS. Esto
# también se puede corroborar visualmente, mediante la gráfica p2 arriba generada.
#
# refin : ingresos extra
#
df.vis<-df%>%group_by(refin)%>%summarise(avg_als=mean(ln_als),
                                         med_als=median(ln_als),
                                         sd_als=sd(ln_als),
                                         ses_als=skewness(ln_als),
                                         cur_als=kurtosis(ln_als),
                                         avg_alns=mean(ln_alns),
                                         med_alns=median(ln_alns),
                                         sd_alns=sd(ln_alns),
                                         ses_alns=skewness(ln_alns),
                                         cur_alns=kurtosis(ln_alns),
                                         avg_rate=mean(rateNS),
                                         sd_rate=sd(rateNS),
                                         n=n())
df.vis.ref<- data.frame(df.vis)
df.vis.ref
# Visualización de distribuciones de datos ln_als y la_alns
p1 <- ggplot(df, aes(x=ln_als)) +
  geom_histogram(aes(color=refin,fill=refin),bins =k+1,alpha=0.4 ) + 
  #  geom_histogram(aes(y=after_stat(count / sum(count)),color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "Saludables", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
p1
p2 <- ggplot(df, aes(x=ln_alns)) +
  geom_histogram(aes(color=refin,fill=refin),bins =k+1,alpha=0.4 ) + 
  #  geom_histogram(aes(y=after_stat(count / sum(count)),color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "No Saludables", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
p2
# Gráfica de dos paneles
figure <- ggarrange(p1, p2, 
                    labels = c("A","B"),
                    ncol = 2, nrow = 1)
annotate_figure(figure)#,
#                top = text_grob("Distribución del ln_als \n", color = "black", face = "bold", size = 16))
dev.off()
#
# Observaciones:
#
# 1) En promedio, los hogares que perciben ingresos extra gastan más dinero en ALS
# que los hogares sin ingresos extra. PRUEBA DE HIPÓTESIS PENDIENTE
#
# 2) Por el contrario, en promedio, los hogares que perciben ingresos extra gastan menos
# en terminos absolutos y relativos, en ALNS que los hogares sin ingresos extra.
# PRUEBA DE HIPÓTESIS PENDIENTE.
#
# 3) La distribución del ln_ALS y ln_ALNS sigue los mismos patrones descritos 
# respecto al NSE, como puede apreciarse en las figuras p1 y p2 arriba generadas.
#
#
# IA : Insuficiencia alimentaria
#
df.vis<-df%>%group_by(IA)%>%summarise(avg_als=mean(ln_als),
                                      med_als=median(ln_als),
                                      sd_als=sd(ln_als),
                                      ses_als=skewness(ln_als),
                                      cur_als=kurtosis(ln_als),
                                      avg_alns=mean(ln_alns),
                                      med_alns=median(ln_alns),
                                      sd_alns=sd(ln_alns),
                                      ses_alns=skewness(ln_alns),
                                      cur_alns=kurtosis(ln_alns),
                                      avg_rate=mean(rateNS),
                                      sd_rate=sd(rateNS),
                                      n=n())
df.vis.ia<- data.frame(df.vis)
df.vis.ia
# Visualización de distribuciones de datos ln_als y la_alns
p1 <- ggplot(df, aes(x=ln_als)) +
  geom_histogram(aes(color=IA,fill=IA),bins =k+1,alpha=0.4 ) + 
  #  geom_histogram(aes(y=after_stat(count / sum(count)),color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "Saludables", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
p1
p2 <- ggplot(df, aes(x=ln_alns)) +
  geom_histogram(aes(color=IA,fill=IA),bins =k+1,alpha=0.4 ) + 
  #  geom_histogram(aes(y=after_stat(count / sum(count)),color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "No Saludables", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
p2
# Gráfica de dos paneles
figure <- ggarrange(p1, p2, 
                    labels = c("A","B"),
                    ncol = 2, nrow = 1)
annotate_figure(figure)#,
#                top = text_grob("Distribución del ln_als \n", color = "black", face = "bold", size = 16))
dev.off()
#
# Observaciones
#
# 1)  En promedio, los hogares que no padecen de IA gastan más, absoluta y 
# relativamente, en ALNS que los hogares que padecen IA. PRUEBA
# DE HIPÓTESIS PENDIENTE
#
# 2) La distribución del ln_ALS y ln_ALNS sigue los mismos patrones descritos 
# respecto al NSE y refin.
#
#
# Una vez analizados los patrones de gasto en ALS y ALNS como función de cada una
# de las tres variables de interés, de manera individual, ahora realizaremos un 
# análisis comparativo de los patrones de consumo para cada una de las 20 combinaciones
# que resultan de considerar en conjunto dichas tres variables de interés:
#
# IA (2 opciones) x refin (2 opciones) x NSE5F (5 opciones)= 20 combinaciones
#
# Con este objetivo necesitamos agrupar los datos de los hogares en cada una 
# de las combinaciones. Para ello,seleccionamos los datos de interes usando select(),
# luego agrupamos conforme a las variables refin, IA y nse5f,  usando la función
# group_by() y calculamos los observables deseados mediante la función summarise(). 
# Por último, ordenaremos los datos en función del nse5f para fines de análisis.
#
#
df.est<-df%>%select(nse5f,refin,IA,ln_als,ln_alns)%>%group_by(refin,IA,nse5f)%>%summarize(avg_als=mean(ln_als),
                                                                                          med_als=median(ln_als),
                                                                                          sd_als=sd(ln_als),
                                                                                          ses_als=skewness(ln_als),
                                                                                          cur_als=kurtosis(ln_als),
                                                                                          avg_alns=mean(ln_alns),
                                                                                          med_alns=median(ln_alns),
                                                                                          sd_alns=sd(ln_alns),
                                                                                          ses_alns=skewness(ln_alns),
                                                                                          cur_alns=kurtosis(ln_alns))%>%arrange(nse5f)
df.est<-data.frame(df.est)
df.est
View(df.est)
#
# Conclusiones:
#
# 1) En general, para las 20 diferentes combinaciones de categorias asociadas a 
# IA,NSEF5,REFIN, las medidades de tendencia central coinciden y presentan baja 
# dispersión. Lo anterior nos habla de una posible distribución normal.
#
# 2) En el caso de la distribución del ln de los gastos en alimentos saludables,
#
df.est%>%filter(ses_als>0) # No hay distribuciones con sesgo s>0
df.est%>%filter(cur_als<3) # No hay distribuciones con curtosis k<3
# Todas las distribuciones presentan un sesgo a la izquierda (s<0) y curtosis 
# mayor a 3 (leptocúrticas). Esto nos habla de que los patrones de gasto en 
# alimentos saludables son bastante homogéneos entre los diferentes hogares 
# pertenecientes a la misma categoría.
#
#
# 3) En el caso de la distribución del ln de los gastos en alimentos NO saludables,
#
df.est%>%filter(ses_alns>0) # Hay 16 distribuciones con sesgo s>0
df.est%>%filter(cur_alns<3) # Hay 18 distribuciones con curtosis k<3
# La mayoria de las distribuciones presentan un sesgo a la derecha (s>0) y curtosis 
# menor a 3 (platocúrticas), aunque bastante cercanas al umbral k=3 (mesocúrticas).
# Esto nos habla de que los patrones de gasto en alimentos saludables son menos 
# homogéneos entre los diferentes hogares pertenecientes a la misma categoría en
# comparación con el patrón de gasto en alimentos saludables.
#
#
# Para analizar una a una podríamos seguir el siguiente procedimiento:
#
# Ejemplo: Distribución de gasto en alimentos saludables para refin=No IA=NO nse5f=Alto 
#
# 1) Extraer datos usando la función filter(), aplicada sobre las variables 
# refin, IA y nse5f,
df.est1<-df%>%filter(refin=="No",IA=="No",nse5f=="Alto")%>%select(ln_alns)
# 2) Calcular el número de categorias e intervalos para las mismas
#
#Numero de clases usando regla de raiz, redondeando hacia arriba
k1 = ceiling(sqrt(length(df.est1$ln_alns))) 
#Numero de clases usando Sturges, redondeando hacia arriba
k2 = ceiling(1+3.3*log10(length(df.est1$ln_alns))) 
k1;k2
# Elegimos Sturges
k<-k2
#calcular ancho de bin/clase
ac = (max(df.est1$ln_alns)-min(df.est1$ln_alns))/k
bins <- seq(min(df.est1$ln_alns),max(df.est1$ln_alns),by=ac)
#
# Creación de histograma
hist(df.est1$ln_alns,breaks=bins,
     main="Distribución del ln del gasto en ALNS",
     sub="refin = No, IA = No, nse5f = Alto",
     xlab="x",ylab="f(x)",freq=FALSE)
# Comparación con distribución normal asociada a las medidadas de 
# tendencia central de la muestra
mean=mean(df.est1$ln_alns)
sd=sd(df.est1$ln_alns)
x <- seq(-4, 4, 0.01)*sd + mean
curve(dnorm(x, mean = mean, sd = sd), from = mean-4*sd, to = mean+4*sd, 
      col='blue', main = "Densidad de Probabilidad Normal",
      ylab = "f(x)", xlab = "X",add=TRUE)
#
# Conclusión:
# Se comprueba que los datos siguen una distribución normal para esta combinación. 
#
# Sin embargo hacerlo una a una podría resultar algo cansado. 
#
# Para el resto de distribuciones, podemos usar igualmente filter(), pero en esta 
# ocasión solo sobre las variables refin y IA. Dejando la variable nse5f como 
# argumento para establecer el esquema de color en una gráfica comparativa de las 
# distribuciones de gastos como funcion de los diferentes niveles socioeconomicos
# usando la libreria ggplt2. Así mismo, usamos la librería ggpubr para agrupar 
# varios paneles en una sola gráfica
#
# Caso ALS
#
#
# refin=No IA=NO
#

df.est2<-df%>%filter(refin=="No",IA=="No")%>%select(ln_als,nse5f)
p1 <- ggplot(df.est2, aes(x=ln_als)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
#  geom_histogram(aes(y=after_stat(count / sum(count)),color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "refin = No, IA = No", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
#
# refin=No IA=Si
#
df.est2<-df%>%filter(refin=="No",IA=="Si")%>%select(ln_als,nse5f)
p2 <- ggplot(df.est2, aes(x=ln_als)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "refin = No, IA = Si ", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
#
# refin=Si IA=No
#
df.est2<-df%>%filter(refin=="Si",IA=="No")%>%select(ln_als,nse5f)
p3 <- ggplot(df.est2, aes(x=ln_als)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title = "refin = Si, IA = No", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()

#
# refin=Si IA=Si
#
df.est2<-df%>%filter(refin=="Si",IA=="Si")%>%select(ln_als,nse5f)
p4 <- ggplot(df.est2, aes(x=ln_als)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "refin = Si, IA = Si", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
#
figure <- ggarrange(p1, p2, p3,p4, 
                    labels = c("A", "B", "C","D"),
                    ncol = 2, nrow = 2)
annotate_figure(figure,
                top = text_grob("Distribución del ln_als \n", color = "black", face = "bold", size = 16))
dev.off()
#
# Caso ALNS
#
#
# refin=No IA=NO
#

df.est2<-df%>%filter(refin=="No",IA=="No")%>%select(ln_alns,nse5f)
p1 <- ggplot(df.est2, aes(x=ln_alns)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "refin = No, IA = No", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
#
# refin=No IA=Si
#
df.est2<-df%>%filter(refin=="No",IA=="Si")%>%select(ln_alns,nse5f)
p2 <- ggplot(df.est2, aes(x=ln_alns)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "refin = No, IA = Si ", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
#
# refin=Si IA=No
#
df.est2<-df%>%filter(refin=="Si",IA=="No")%>%select(ln_alns,nse5f)
p3 <- ggplot(df.est2, aes(x=ln_alns)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title = "refin = Si, IA = No", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()

#
# refin=Si IA=Si
#
df.est2<-df%>%filter(refin=="Si",IA=="Si")%>%select(ln_alns,nse5f)
p4 <- ggplot(df.est2, aes(x=ln_alns)) +
  geom_histogram(aes(color=nse5f,fill=nse5f),bins =k+1,alpha=0.4 ) + 
  labs(title =  "refin = Si, IA = Si", 
       x = "ln(gasto)",
       y = "Frecuencia") + 
  theme_classic()
#
figure <- ggarrange(p1, p2, p3,p4, 
                    labels = c("A", "B", "C","D"),
                    ncol = 2, nrow = 2)
annotate_figure(figure,
                top = text_grob("Distribución del ln_alns \n",
                color = "black", face = "bold", size = 16))
dev.off()
#
# Conclusión:
#
# En general, la distribución de gastos en las 20 diferentes combinaciones de 
# categorias parece seguir una distribución normal. En general, se observan 
# las mismas tendencias que las obsrvadas en el análisis variable por variable.
#
# Una vez analizada la distibución de gasto de cada grupo de interés, vamos a 
# continuar con el análisis descriptivo de los patrones de gasto. Para ello nos
# enfocaremos en la tendencia (promedio del ln del gasto) del gasto en ALS, ALNS 
# y el gasto relativo rateNS. Con este fin, seleccionamos datos de interes mediante
# la función select(), agrupamos conforme a las variables refin, IA y nse5f, usando
# la función group_by() y calculamos los observables de interés mediante la función 
# summarise(). Por último, ordenaremos los datos mediante la función arrange()
# en función del promedio de gastos en alimentos no saludables avg_alns, de forma
# descendiente para fines de análisis.
#
df.est<-df%>%select(nse5f,refin,IA,ln_als,ln_alns,rateNS)%>%group_by(refin,IA,nse5f)%>%summarize(avg_als=mean(ln_als),
                                                                                                 avg_alns=mean(ln_alns),
                                                                                                 avg_rate=mean(rateNS))%>%arrange(desc(avg_alns))
df.est<-data.frame(df.est)
df.est
View(df.est)
# Conclusión:
df.est%>%filter(avg_alns==max(avg_alns)) # categoria que más gasta
df.est%>%filter(avg_alns==min(avg_alns)) # categoria que menos gasta
# En terminos absolutos, los hogares que más gastan en alimentos no saludables
# son los de nivel socio económico alto sin ingresos extra y que no padecen IA. 
# Los que menos gastan en alimentos no saludables son los hogares de NSEf5 bajo,
# sin ingresos extra y que presentan IA.
#
#
# Conclusiones:
#
# 1) De lo anterior, se encuentra que los hogares que pertenecen a la categoria 
# refin=No, IA=No y NSEF5=Alto son los que más gastan en alimentos no saludables 
# en comparación al gasto en alimentos saludables. Mientras que los hogares que 
# pertenecen a la categoria refin=Si, IA=Si, NSEF5=Bajo son quienes destinan menos dinero
# al consumo de alimentos no saludables en relación al consumo de alimentos saludables.
#
# 2) En general se puede ver que, contrario a la opinión publica, los hogares con 
# mejor nivel socioeconómico destinan más dinero al consumo de alimentos NO 
# saludables en comparación al usado para el consumo de alimentos saludables, 
# absuluta y relativamente
#
# Ahora analizaremos, dentro de cada NSEF5, que hogares priorizan más sus gastos 
# en alimentos saludables.
#
# Para ello, reordenaremos el dataframe anterior, usando arrange(), primero de 
# forma descendiente en nse5f y luego ascendente en rateNS.
df.estf%>%arrange(desc(nse5f),rateNS)
#
# Conclusión: 
# Para todos los NSE, se encuentra que los hogares que padecen IA priorizan el 
# gasto en ALS sobre los ALNS, los que reciben ingresos extra un poco más que 
# los que no.
"
3) Calcula probabilidades que nos permitan entender el problema en México

"
# Para el cálculo de las probabilidades, vamos a trabajar con la razón entre el gasto en ALNS y ALS

# 1) ¿Cuál es la probabilidad de que los hogares que no reciben ingresos extra 
# destinen relativamente más recursos al consumo de ALNS, que el promedio de 
#los hogares que sí perciben ingresos extra?

mean.si <- df.vis.ref%>%filter(refin=="Si")%>%select(avg_rate)
mean.si
mean.no <- df.vis.ref%>%filter(refin=="No")%>%select(avg_rate)
mean.no
sd.no <- df.vis.ref%>%filter(refin=="No")%>%select(sd_rate)
sd.no
q<-as.double(mean.si)
mean <- as.double(mean.no)
sd <- as.double(sd.no)
res <-  pnorm(q=q, mean = mean, sd = sd,lower.tail = FALSE, log.p = FALSE)
print(paste("Hay una probabilidad del",round(res,3)," de que un hogar que no percibe ingresos extra gaste más en ALNS que el promedio del gasto de un hogar que sí percibe ingresos extra"))

# Gráficamente
x <- seq(-4, 4, 0.01)*sd + mean
y <- dnorm(x, mean = mean, sd = sd) 
b <- q
b2 <- mean+5*sd
curve(dnorm(x, mean = mean, sd = sd), from = mean-5*sd, to = mean+5*sd, 
      col='blue', main = "Densidad de Probabilidad Normal: rateNS",
      ylab = "f(x)", xlab = "X",sub="P(rateNS no ingresos extra > avg rateNS ingresos extra)")
polygon(c(b, x[x>=b & x<=b2], b2), c(0, y[x>=b & x<=b2], 0), col="green")
text(0.25*q, 2.0,paste("q=",round(q,4)),col=2)
text(0.25*q, 1.8,paste("mu=",round(mean,4)),col=2)
text(1.2, 2.0,paste("P(x>q)=",round(res,3)),col=3)

# 2) ¿Cuál es la probabilidad de que los hogares que padecen IA relativamente,
# destinen más recursos al consumo de ALNS, que el promedio de los hogares que no
# padecen IA?

mean.si <- df.vis.ia%>%filter(IA=="Si")%>%select(avg_rate)
mean.si
sd.si <- df.vis.ia%>%filter(IA=="Si")%>%select(sd_rate)
sd.si
mean.no <- df.vis.ia%>%filter(IA=="No")%>%select(avg_rate)
mean.no

q<-as.double(mean.no)
mean <- as.double(mean.si)
sd <- as.double(sd.si)
res <-  pnorm(q=q, mean = mean, sd = sd,lower.tail = FALSE, log.p = FALSE)
print(paste("Hay una probabilidad del",round(res,3)," de que un hogar que padece IA gaste relativamente más en ALNS que el promedio del gasto relativo de un hogar que no padece IA"))

# Gráficamente
x <- seq(-4, 4, 0.01)*sd + mean
y <- dnorm(x, mean = mean, sd = sd) 
b <- q
b2 <- mean+5*sd
curve(dnorm(x, mean = mean, sd = sd), from = mean-5*sd, to = mean+5*sd, 
      col='blue', main = "Densidad de Probabilidad Normal: rateNS",
      ylab = "f(x)", xlab = "X",sub="P(rateNS si IA > avg rateNS no IA)")
polygon(c(b, x[x>=b & x<=b2], b2), c(0, y[x>=b & x<=b2], 0), col="green")
text(0.25*q, 1.8,paste("q=",round(q,4)))
text(0.25*q, 2.0,paste("mu=",round(mean,4)))
text(1.2, 2.0,paste("P(x>q)=",round(res,3)),col=3)

# 3) ¿Cuál es la probabilidad de que los hogares que pertenecen a un NSE Bajo
# destinen más recursos al consumo de ALNS, que el promedio de los hogares que
# pertenecen a un NSE Alto?

mean.bajo <- df.vis.nse%>%filter(nse5f=="Bajo")%>%select(avg_rate)
mean.bajo
sd.bajo <- df.vis.nse%>%filter(nse5f=="Bajo")%>%select(sd_rate)
sd.bajo
mean.alto <- df.vis.nse%>%filter(nse5f=="Alto")%>%select(avg_rate)
mean.alto

q<-as.double(mean.alto)
mean <- as.double(mean.bajo)
sd <- as.double(sd.bajo)
res <-  pnorm(q=q, mean = mean, sd = sd,lower.tail = FALSE, log.p = FALSE)
print(paste("Hay una probabilidad del",round(res,3)," de que un hogar que pertenece al NSE Bajo gaste relativamente más en ALNS que el promedio del gasto relativo de un hogar que pertenence a un NSE Alto"))

# Gráficamente
x <- seq(-4, 4, 0.01)*sd + mean
y <- dnorm(x, mean = mean, sd = sd) 
b <- q
b2 <- mean+5*sd
curve(dnorm(x, mean = mean, sd = sd), from = mean-5*sd, to = mean+5*sd, 
      col='blue', main = "Densidad de Probabilidad Normal: rateNS",
      ylab = "f(x)", xlab = "X",sub="P(rateNS NSE Bajo > avg rateNS NSE Alto)")
polygon(c(b, x[x>=b & x<=b2], b2), c(0, y[x>=b & x<=b2], 0), col="green")
text(0.25*q, 1.8,paste("q=",round(q,4)))
text(0.25*q, 2.0,paste("mu=",round(mean,4)))
text(1.2, 2.0,paste("P(x>q)=",round(res,3)),col=3)

"
4) Plantea hipótesis estadísticas y concluye sobre ellas para entender el problema en México

"

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
# Ver directorio Sesion_8 en reositorio: https://github.com/MiguelSP8/Proyecto_R_Team5.git
