# Postwork Sesión 3

#### Objetivo

#- Realizar un análisis descriptivo de las variables de un dataframe

#### Requisitos

#1. R, RStudio
#2. Haber realizado el prework y seguir el curso de los ejemplos de la sesión
#3. Curiosidad por investigar nuevos tópicos y funciones de R

#### Desarrollo
library(DescTools)
"Utilizando el dataframe `boxp.csv` realiza el siguiente análisis descriptivo.
No olvides excluir los missing values y transformar las variables a su
tipo y escala correspondiente."
# Carga de datos
df <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-03/Data/boxp.csv")
# Decripción de df
str(df)
# Dimensiones
dim(df)
# Visualizar df 
View(df)
# Excluir missing values
complete.cases(df)
var<-df[complete.cases(df),]
var
str(var)
names(var)
# 
# La variable Categoria es una variable ordinal, con niveles "C1", "C2" y "C3", 
# entonces usamos la funcion factor() para asignarles un nivel "numérico" a cada dato,
# dependiendo del label que tengan asignado.
#
var$Categoria<-factor(var$Categoria,levels = c("C1","C2","C3")) 
#
# La variable Grupo es una variable nominal, usamos la función factor() para asignarle
# un label a cada categoria
#
var$Grupo<-factor(var$Grupo,labels = c("Grupo0","Grupo1"))
View(var)
"
1) Calcula e interpreta las medidas de tendencia central de la variable `Mediciones`
"
# cálculo de la media: mean(), mediana: median() y moda: Mode()[1]
mean(var$Mediciones);median(var$Mediciones);Mode(var$Mediciones)[1]
#
# Resultados:
#
#Media = 62.88494
#Mediana = 49.3
#Moda = 23.3
#
# Conclusión
#
# La media, mediana y moda no coinciden.
"
2) Con base en tu resultado anterior, ¿qué se puede concluir respecto al sesgo de `Mediciones`?
"
# Moda < Mediana < Media. Esto implica que hay un sesgo a la derecha
"
3) Calcula e interpreta la desviación estándar y los cuartiles de la distribución de `Mediciones`
"
# Desviacion estandar
sd(var$Mediciones) 
#53.76972
# La desviación estandar es grande en comparación a las medidas de tendencia central, 
# esto implica que los datos están muy dispersos. Hay una dispersión del 53.76 respecto a la media
#
#Cuartiles
#
quantile(var$Mediciones,probs=c(0.25,0.5,0.75))
#q1=23.45 -> 25% de las mediciones son menores a 23.45
#q2=49.30 -> 50% de las mediciones son  menores a 49.30
#q3=82.85 -> 75% de las mediciones son menores a 82.85
"
4) Con ggplot, realiza un histograma separando la distribución de `Mediciones` por `Categoría`
¿Consideras que sólo una categoría está generando el sesgo?
"
#Numero de clases usando regla de raiz, redondeando hacia arriba
k1 <- ceiling(sqrt(length(var$Mediciones))) 
#Numero de clases usando Sturges
k2 <- ceiling(1+3.3*log10(length(var$Mediciones)))
k1;k2
k <- k2 # Elegimos k2=11 sobre k1=25
#
# Histogramas de mediciones por categoria
#
ggplot(var, aes(x=Mediciones)) +
#   geom_histogram(aes(color=Categoria),fill="white",bins =11,alpha=0.4 ) + 
  geom_histogram(aes(color=Categoria,fill=Categoria),bins =11,alpha=0.4 ) + 
  labs(title = "Histograma", 
       x = "Mediciones",
       y = "Frequency") + 
#    scale_color_manual(values = c("#00AFBB", "#E7B800","#FB4485")) +
#    scale_fill_manual(values = c("#00AFBB", "#E7B800","#FB4485"))
  theme_classic()
#
# De acuerdo con los histogramas, parece ser que el sesgo es intrinseco a las tres categorias
#
"5) Con ggplot, realiza un boxplot separando la distribución de `Mediciones` por `Categoría` 
y por `Grupo` dentro de cada categoría. ¿Consideras que hay diferencias entre categorías? 
¿Los grupos al interior de cada categoría 
podrían estar generando el sesgo?"
# Boxplot separando datos por categoria y grupo
ggplot(var, aes(x=Mediciones, y=Categoria, fill=Grupo)) + 
  geom_boxplot()
#
# No parece haber diferencias notables entre cada categoria. Ambos grupos interiores están generando sesgos
#