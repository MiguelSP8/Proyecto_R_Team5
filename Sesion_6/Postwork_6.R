"Supongamos que nuestro trabajo consiste en aconsejar a un cliente sobre como mejorar 
las ventas de un producto particular, y el conjunto de datos con el que disponemos son
datos de publicidad que consisten en las ventas de aquel producto en 200 diferentes mercados, 
junto con presupuestos de publicidad para el producto en cada uno de aquellos mercados para
tres medios de comunicación diferentes: TV, radio, y periódico. No es posible para nuestro 
cliente incrementar directamente las ventas del producto. Por otro lado, ellos pueden controlar
el gasto en publicidad para cada uno de los tres medios de comunicación. Por lo tanto, 
si determinamos que hay una asociación entre publicidad y ventas, entonces podemos instruir 
a nuestro cliente para que ajuste los presupuestos de publicidad, y así indirectamente 
incrementar las ventas.

En otras palabras, nuestro objetivo es desarrollar un modelo preciso que pueda ser usado para 
predecir las ventas sobre la base de los tres presupuestos de medios de comunicación. Ajuste 
modelos de regresión lineal múltiple a los datos advertisement.csv y elija el modelo más adecuado
siguiendo los procedimientos vistos

Considera:
  
  Y: Sales (Ventas de un producto)
X1: TV (Presupuesto de publicidad en TV para el producto)
X2: Radio (Presupuesto de publicidad en Radio para el producto)
X3: Newspaper (Presupuesto de publicidad en Periódico para el producto)
"
# Adquisición de datos
adv <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-06/data/advertising.csv")
head(adv)
# separación de variables
attach(adv)
# Necesitamos un modelo para predecir ventas, el modelo más adecuado es una regresión lineal
#
# Cálculo de la matriz de correlación
#
round(cor(adv),4)  
# podemos ver que la correlación entre ventas y Tv es alta: 0.9012
#
# Visualización de correlaciones:
#
pairs(~ Sales + TV + Radio + Newspaper, 
      data = df, gap = 0.4, cex.labels = 1.5)
# Igualmente podemos observar la correlación entre Sales y Tv
#
# Necesitamos desarrollar un modelo de regresión lineal múltiple que pueda ser usado para 
# predecir las ventas con relación a los tres presupuestos de medios de comunicación
#
m1 <- lm(Sales~TV+Radio+Newspaper)

summary(m1)
#
# Modelo lineal múltiple
#   y=B0+B1X1+B2X2+B3X3
# Declaración y prueba de hipótesis
# Ho: Bi=0
# Ha: Bi != 0
#
# A niveles de confienza del 95 %, la significancia, alpha=0.05.
#
# Para B0, pvalue<2e-16 < alpha=0.05, Se rechaza Ho en favor de la hipótesis alternativa, es decir, B0 != 0
#
# Para B1, pvalue<2e-16 < alpha=0.05, Se rechaza Ho en favor de la hipótesis alternativa, es decir,
# B1 != 0. Por tanto, TV es un buen estadístico para el modelo.
#
# Para B2, pvalue<2e-16 < alpha=0.05, Se rechaza Ho en favor de la hipótesis alternativa, es decir,
# B2 != 0. Por tanto, Radio es un buen estadístico para el modelo.
#
# Para B3, pvalue=0.954 > alpha=0.05, No se rechaza Ho, por tanto, B3 = 0. 
# Newspaper NO es un buen estadístico para el modelo
#
# El Multiple-R^2=0.9026, el modelo describe el 90.26% de la variación en los datos
# El Ajustado-R^2= 0.9011
#
# Considerando los resultados del análisis de las pruebas de hipótesis, eliminamos Newspaper del modelo
m2 <- update(m1, ~.-Newspaper)
summary(m2)
#
# Conclusión:
# Todos los estadísticos rechazan la Ho en favor de Ha: Bi != 0.
# El Ajustado-R^2= 0.9016, aumenta
# Por consiguiente, es un mejor modelo
#
# Interpretación de los coeficientes:
#
# A partir de B1=0.054449, se concluye que cada incremento unitario en la inversion 
# en publicidad asociada a TV aumenta las ventas en 0.0544 unidades.
#
# A partir de B2= 0.107175, se concluye que cada incremento unitario en la inversion 
# en publicidad asociada a Radio aumenta las ventas en 0.1 unidades
#
# Ahora, es momento de analizar los supuestos sobre el modelo de regresión lineal:
#
# 1) No correlación entre errores y variables
# 2) errores siguen distribución normal
#
StanRes2 <- rstandard(m2)

par(mfrow = c(2, 2))

plot(m2$fitted.values,Sales, ylab = "valores ajustados")
# La correlación entre los valores medidos, Sales, y los valores ajustados, m2$fitted.values, es buena
#
plot(TV, StanRes2, ylab = "Residuales Estandarizados")
# No hay evidencia de tendencia en los residuals
#
plot(Radio, StanRes2, ylab = "Residuales Estandarizados")
# No hay evidencia de tendencia en los residuals 
#
# Conclusión:
# NO hay correlación netre los errores y las variables
#
qqnorm(StanRes2)
qqline(StanRes2)
# Distribución de errores  coincide con distribución normal hasta +-2 sigma
#
dev.off()
#
# prueba de normalidad 
#
shapiro.test(StanRes2)
# Ho: Es normal
# H1: No es normal
# pvalue=0.0013 < alpha=0.1,0.05,0.01, Se rechaza la hipótesis nula en favor de la alternativa. 
# Al 90%, 95% y 99% de nivel de confianza, se rechaza la hipótesis nula en favor de la alternativa. 
# La distribución de errores no sigue una distribución normal
#
#
#
# Conclusión:
# Errores siguen una distribución normal
#
# Por tanto, se cumplen los supuestos sobre el modelo de regresión lineal. El modelo propuesto es adecuado.
#