"El data frame iris contiene información recolectada por Anderson sobre 50 flores 
de 3 especies distintas (setosa, versicolor y virginca), incluyendo medidas en 
centímetros del largo y ancho del sépalo así como de los pétalos.

Estudios recientes sobre las mismas especies muestran que:"
#
# Adquisición de datos
#
df<-iris
# Visualización
names(df)
View(df)
#
"1) En promedio, el largo del sépalo de la especie setosa (Sepal.Length) es igual a 5.7 cm"
#
#Nos habla de mu = 5.7, por tanto se trata de una hipótesis nula

# Declaración de hipótesis
#
# Hipótesis nula
# Ho: mu = 5.7
# Hipótesis alternativa
# Ha: mu != 5.7
#
t.test(x=df[df$Species=="setosa","Sepal.Length"],alternative="two.side",mu=5.7)
#
# Nos pregunta si EEE para aceptar Ho
# A niveles de confianza del 99% -> significancia alpha=0.01
# Para rechazar Ho se requiere pvalue<alpha
#
# En este caso
# pvalue= 2.2x10^-16 
# Por tanto, pvalue < alpha 
# Esto es: A niveles de confianza del 99% rechazamos la hipótesis nula -> El promedio es diferente a 5.7
#
# Conclusión:
# A niveles de confianza del 99%, existe evidencia estadística para rechazar Ho, es decir,
# El promedio es diferente de 5.7
#
"
2) En promedio, el ancho del pétalo de la especie virginica (Petal.Width) es menor a 2.1 cm
"
#Nos habla de mu < 2.1, por tanto se trata de una hipótesis alternativa
#
# Declaración de hipótesis
# Hipótesis nula
# Ho: mu>=2.1
# Hipótesis alternativa
# Ha: mu < 2.1
t.test(x=df[df$Species=="virginica","Petal.Width"],alternative="less",mu=2.1)
#
# El problema nos pregunta si existe evidencia estadística para aceptar Ho
# A niveles de confianza del 99% -> significancia alpha=0.01
# Para rechazar Ho se requiere: pvalue<alpha
#
# En este caso
# pvalue= 0.01323 
# Por tanto, pvalue > alpha
# No rechazamos hipotesis nula -> El promedio no es menor a 2.1
#
# Conclusión:
# A niveles de confianza del 99%, no existe evidencia estadistica para rechazar Ho, es decir,
# El promedio no es menor de 2.1
#
"
3) En promedio, el largo del pétalo de la especie virgínica es 1.1 cm 
más grande que el promedio del largo del pétalo de la especie versicolor
"
# Primero verificamos que pasa con las varianzas
# H0: var1/var2=ratio=1
# Ha: ratio != 1
var.test(df[df$Species=="virginica","Petal.Length"],
         df[df$Species=="versicolor","Petal.Length"],
         ratio=1,alternative = "two.sided")
# pvalue=0.26, pvalue > alpha, entonces no se rechaza Ho
# entonces las varianzas NO son diferentes, o equivalentemente, las varianzas son iguales
#
#
# El problema nos habla de mu_vir = mu_ver + 1.1, por tanto nos está hablando de una hipótesis nula
#
# Declaración de hipótesis:
# Ho: mu_virginica = mu_versicolor+1.1cm
# Ha: mu_virginica != mu_versicolor+1.1cm
t.test(df[df$Species=="virginica","Petal.Length"],
       df[df$Species=="versicolor","Petal.Length"],
       alternative="two.sided", mu=1.1, var.equal=TRUE)
# ya vimos que los varianzas NO son distintas con la prueba anterior, por eso var.equal=TRUE
#
# El problema nos pregunta si existe evidencia estadística para aceptar Ho
#
# A niveles de confianza del 99% -> significancia alpha=0.01
# Para rechazar Ho a 99% se requiere que pvalue<alpha
# En este caso
# pvalue= 0.06405
# Entonces, pvalue > alpha
# No rechazamos hipotesis nula -> mu_virginica = mu_versicolor+1.1cm
#
# Conclusión:
# A niveles de confianza del 99%, no existe evidencia estadistica para rechazar Ho, es decir,
# el promedio del largo del petalo de virginica es 1.1cm mayor que el promedio del largo del petalo de versicolor
#

"4) En promedio, no existe diferencia en el ancho del sépalo entre las 3 especies."
# Es un problema de análisis de varianza de varias poblaciones. Nis plantea que no existe diferencia entre los promedios 
# del ancho de los sépalos entre tres especies, es decir, nos plantea una hipótesis nula.
#
# Declaración de hipótesis
#
# Ho: mu_sepal.width_virginica = mu_sepal.width_versicolor = mu_sepal.width_setosa
# Ha: al menos uno es diferente
# Boxplot para vizualización de datos
boxplot(Sepal.Width ~ Species,data=df, xlab="Especies",ylab="Ancho de sépalo")
anova <- aov(Sepal.Width ~ Species, data=df)
summary(anova)
#
# El problema nos pregunta si existe evidencia estadística para aceptar Ho
#
# A niveles de confianza del 99% -> significancia alpha=0.01
# Para rechazar Ho a 99% se requiere que pvalue<alpha
# En este caso
# pvalue < 2e-16
# Entonces, pvalue < alpha
# Rechazamos hipotesis nula en favor de la hipótesis alternativa 
# => En promedio, si existe diferencia entre los anchos del sépalo de alguna de las especies.
#
# Conclusión:
# A niveles de confianza del 99%, existe evidencia estadistica para rechazar Ho, es decir,
# el promedio del ancho del sétalo de al menos una de las especies es diferente al de las otras.
#

"Utilizando pruebas de inferencia estadística, concluye si existe evidencia suficiente
para concluir que los datos recolectados por Anderson están en línea con los nuevos estudios.

Utiliza 99% de confianza para toda las pruebas,
en cada caso realiza el planteamiento de hipótesis adecuado y concluye."