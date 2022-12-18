"
Utilizando el siguiente vector numérico, realiza lo que se indica:
"
url = "https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-07/Data/global.txt"
Global <- scan(url, sep="")
head(Global)
tail(Global)
class(Global)
"
1) Crea un objeto de serie de tiempo con los datos de Global. La serie debe ser mensual comenzando en Enero de 1856
"
# Hacemos uso de la función ts() para la creación de la serie de tiempo, 
# usando start=c(1856,1), ya que la serie inica en enero (1) del año de 1856 con variaciones mensuales (frequency=12)
Global.ts <- ts(Global,start=c(1856,1),frequency = 12)
Global.ts
"
2) Realiza una gráfica de la serie de tiempo anterior
"
plot(Global.ts, 
     main = "Serie de tiempo sobre variación de la Temperatura Global", 
     xlab = "Tiempo",
     ylab = "Temperatura [°C]",
     sub = "Enero de 1856 - 2005")

"
3) Ahora realiza una gráfica de la serie de tiempo anterior, transformando a la primera diferencia
"
# Para transformar a la primera diferencia, hacemos uso de la función diff()
plot(diff(Global.ts), type = "l", main = "Serie de tiempo de diferencia de primer orden", 
     xlab = "Tiempo", ylab = "diff(Temperatura)[° C]",
     sub = "Enero de 1856 - 2005")
"
4) ¿Consideras que la serie es estacionaria en niveles o en primera diferencia?
"
# La serie de tiempo no es estacionaria, dado que presenta un tendencia a crecer. 
#
# En primera diferencia, la serie de tiempo oscila en torno a la media.
# Salvo algunas variaciones mayores en los primeros datos, podría decirse que con varianza constante
# Tampoco hay evidencia de ciclos.
# Entonces, podría decirse que la serie SI es estacionaria en primera diferencia
"
5) Con base en tu respuesta anterior, obtén las funciones de autocorrelación y autocorrelación parcial?
"
# Función de auto-correlación: acf(), mide correlación ente variables temporales 
# separadas por K-periodos de rezago
# Se usa para identificar el proceso de media movil (MA(p)) en los modelos ARIMA
acf(Global.ts)
# Muchos intervalos significativos => serie Global.ts no estacionaria
acf(diff(Global.ts))
# En este caso podemos ver que a partir del intervalo 4, la correlación es inexistente.
# Es decir, el parametro para un proceso de media movil es p<=4
#
# Al diferenciar una vez, la serie se vuelve estacionaria, por tanto, es un proceso estacionario I(d=1)
#
# Función de auto-correlación parcial: pacf(), mide correlación ente variables temporales 
# separadas por K-periodos de rezago, sin tomar en cuenta la dependencia creada por los retardos intermedios.
# Se usa para identificar valores autorregresivos (AR(q)) en los modelos ARIMA
pacf(diff(Global.ts))
# En este caso, podmeos ver que el intervalo 1 es el más pronunciado. AR(q=1)
"
6) De acuerdo con lo observado en las gráficas anteriores, se sugiere un modelo ARIMA
con AR(1), I(1) y MA desde 1 a 4 rezagos Estima los diferentes modelos ARIMA propuestos:
"
arima(Global.ts,order=c(1,1,1)) #AIC=-2278.26
arima(Global.ts,order=c(1,1,2)) #AIC=-2306.96
arima(Global.ts,order=c(1,1,3)) #AIC=-2307.88
arima(Global.ts,order=c(1,1,4)) #AIC=-2310.39
#
# Observación:
#AIC: arima(1,1,4) < arima(1,1,3) < arima(1,1,2) < arima(1,1,1)
"
7) Con base en el criterio de Akaike, estima el mejor modelo ARIMA y realiza una 
predicción de 12 periodos (meses)
"
# Buscamos el modelo con menor AIC
# De la comparación anterior, se tiene que el menor AIC es arima(1,1,4)
# Para realizar la predicción, primero usamos la función arima(), con order=c(1,1,4)
# para simular la serie de tiempo
#
fit <- arima(Global.ts,order=c(1,1,4))
# Luego extraemos la predicción usando la función predict(), usando la serie de tiempo simulada, 
# con frecuancia 12 correspondiente a la serie de tiempo
pr <- predict(fit,12)$pred
#
ts.plot(cbind(window(Global.ts, start = 2000), exp(pr)), col = c("blue", "red"), xlab = "")
title(main = "Predicción para la Temperatura Global",
      xlab = "Tiempo",
      ylab = "Temperatura [°C]")
