"Utilizando la variable total_intl_charge de la base de datos
telecom_service.csv de la sesión 3, realiza un análisis probabilístico. Para ello,
debes determinar la función de distribución de probabilidad que más se
acerque el comportamiento de los datos. 
Hint: Puedes apoyarte de medidas descriptivas o técnicas de visualización.
Una vez que hayas seleccionado el modelo, realiza lo siguiente:
"
library(DescTools)
# Adquisición y análisis de datos
df <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-03/Data/telecom_service.csv")
summary(df)
names(df)
#
# Medidas descriptivas
# cálculo de la media: mean(), mediana: median(), moda: Mode()[1] y desviación estándar: sd()
#
mean(df$total_intl_charge)# 2.764581
Mode(df$total_intl_charge)[1]# 2.7
median(df$total_intl_charge)# 2.78
sd(df$total_intl_charge)# 0.7537726
#
# Dado que media ~ moda ~ mediana y sd >> variaciones entre medidas de tendencia central
#                => podría ser una distribución normal
#
# Histograma:
#
hist(df$total_intl_charge, main = "Distribución", ylab = "f(x)", xlab = "X",freq=FALSE)
#
# Se comprueba que los datos siguen una distribución normal
#
"
1) Grafica la distribución teórica de la variable aleatoria total_intl_charge
"
# Por comodidad, asignamos la media y desviación estandar a las variables mean y sd
mean<-mean(df$total_intl_charge)
sd<-sd(df$total_intl_charge)
# Generamos arreglo x con elementos que van desde -4*sd a 4*sd con respecto a la media
x <- seq(-4, 4, 0.01)*sd + mean
# Agregamos ráfica de distribución normal teórica asociada a la distribución de datos, sobre el histograma previo
curve(dnorm(x, mean = mean, sd = sd), from = min(x), to = max(x), 
      col='blue', main = "Densidad Normal",
      ylab = "f(x)", xlab = "X",add=TRUE)
#
# Conclusión: 
# Los datos siguen una distribución normal
#
"
2) ¿Cuál es la probabilidad de que el total de cargos internacionales sea
menor a 1.85 usd?
"
# Para eso, hacemos uso de la función pnorm con q=1.85 y lower.tail=TRUE
q=1.85
res <- pnorm(q=q, mean = mean, sd = sd,lower.tail = TRUE, log.p = FALSE)
res
#0.1125002
paste("La probabilidad de que el total de cargos internacionales sea menor a 1.85 usd es",round(res,4))
#
"
3) ¿Cuál es la probabilidad de que el total de cargos internacionales sea
mayor a 3 usd?
"
# Similar al caso anterior pero con q=3 y lower.tail=FALSE. O en su caso, 1-pnorm con lower.tail=TRUE
q=3
res <- pnorm(q=q, mean = mean, sd = sd,lower.tail = FALSE, log.p = FALSE)
#0.3773985
paste("La probabilidad de que el total de cargos internacionales sea mayor a 3 usd es",round(res,4))
#
"
4) ¿Cuál es la probabilidad de que el total de cargos internacionales esté
entre 2.35usd y 4.85 usd?
"
# Usamos una combinación de los dos casos anteriores
q1=2.35
q2=4.85
res <- pnorm(q=q2, mean = mean, sd = sd,lower.tail = TRUE, log.p = FALSE)-pnorm(q=q1, mean = mean, sd = sd,lower.tail = TRUE, log.p = FALSE)
#0.7060114
paste("La probabilidad de que el total de cargos internacionales esté entre 2.35 usd y a 4.85 usd es",round(res,4))
#
"
5) Con una probabilidad de 0.48, ¿cuál es el total de cargos internacionales
más alto que podría esperar?
"
# Ahora necesitamos estimar el cuartil p=0.48, para ello usamos la función qnorm()
p=0.48
b<-qnorm(p=p,mean=mean,sd=sd,lower.tail = TRUE, log.p = FALSE)
b
#2.726777
paste("el total de cargos internacionales
más alto que podría esperar con una probabilidad acumulado de 0.48 es:",round(b,4))
#
"
6) ¿Cuáles son los valores del total de cargos internacionales que dejan
exactamente al centro el 80% de probabilidad?
"
# Para encontrar los valores tales que el 80% de los cargos se encuentren al centro de la distribución de probabiidad
# hay que encontrar los cuartiles para p=0.1 con lower.tail=True y False
p=0.1
b<-qnorm(p=p,mean=mean,sd=sd,lower.tail = TRUE, log.p = FALSE)
b
#1.798583
b2<-qnorm(p=p,mean=mean,sd=sd,lower.tail = FALSE, log.p = FALSE)
b2
#3.73058
#comprobación
pnorm(q=b2, mean = mean, sd = sd,lower.tail = TRUE, log.p = FALSE)-pnorm(q=b, mean = mean, sd = sd,lower.tail = TRUE, log.p = FALSE)
