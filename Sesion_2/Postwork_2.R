"
1) Inspecciona el DataSet iris_meaniris` disponible directamente en R. 
Identifica las variables que contiene y su tipo, asegúrate de que no hayan datos
faltantes y que los datos se encuentren listos para usarse.
"

df<-iris
# Ver headers
names(df)
# Ver descripción 
str(df)
# revisar primeras lineas
head(df)
# Dimensión del df
dim(df)
# Revisar si hay faltantes
faltantes<-sum(complete.cases(df))
continuar<-faltantes==dim(df)[1]
# Si no hay casos faltantes entonces sum(complete.cases(df))==dim[1]
if(continuar){print("No hay datos faltantes")}else{"Hay datos faltantes"}
"
2) Crea una gráfica de puntos que contenga Sepal.Lenght en el eje horizontal, 
Sepal.Width en el eje vertical, que identifique Species por color y que el tamaño 
de la figura está representado por Petal.Width. 
Asegúrate de que la geometría contenga shape = 10 y alpha = 0.5
"
library(ggplot2)
g<-ggplot(df,aes(x=Sepal.Length,y=Sepal.Width,color=Species,size=Petal.Width))+geom_point(shape=10,alpha=0.5)
g
"
3) Crea una tabla llamada iris_mean que contenga el promedio de todas las variables agrupadas por Species
"
library(dplyr)
# Usamos el par de funciones group_by y summarise para agrupar por especie y generar nuevas columnas con los promedios
# asociados a cada variable
iris_mean<-df%>%group_by(Species)%>%summarise(Sepal.Length=mean(Sepal.Length),
                                              Sepal.Width=mean(Sepal.Width),
                                              Petal.Length=mean(Petal.Length),
                                              Petal.Width=mean(Petal.Width))
class(iris_mean)
# Transformamos el tbl en un df
iris_mean<-data.frame(iris_mean)
head(iris_mean)
'
4. Con esta tabla, agrega a tu gráfica anterior otra geometría de puntos para 
agregar los promedios en la visualización. Asegúrate que el primer argumento de
la geometría sea el nombre de tu tabla y que los parámetros sean shape = 23,
size = 4, fill = "black" y stroke = 2. También agrega etiquetas, temas y los 
cambios necesarios para mejorar tu visualización.
'
g<-g+geom_point(data=iris_mean,shape=23,size=4,fill="black",stroke=2) + 
  labs(title = "Iris mean",x = "Sepal length", y = "Sepal width") + 
  theme_classic()
g
