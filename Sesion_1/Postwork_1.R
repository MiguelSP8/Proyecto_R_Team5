# Postwork Sesión 1.

#### Objetivo

"El Postwork tiene como objetivo que practiques los comandos básicos aprendidos 
durante la sesión, de tal modo que sirvan para reafirmar el conocimiento. Recuerda 
que la programación es como un deporte en el que se debe practicar, habrá caídas, 
pero lo importante es levantarse y seguir adelante. Éxito"
"El siguiente postwork, te servirá para ir desarrollando habilidades como si se 
tratara de un proyecto que evidencie el progreso del aprendizaje durante el módulo, 
sesión a sesión se irá desarrollando.
A continuación aparecen una serie de objetivos que deberás cumplir, es un ejemplo 
real de aplicación y tiene que ver con datos referentes a equipos de la liga española 
de fútbol (recuerda que los datos provienen siempre de diversas naturalezas), en 
este caso se cuenta con muchos datos que se pueden aprovechar, explotarlos y generar 
análisis interesantes que se pueden aplicar a otras áreas. Siendo así damos paso a las instrucciones:" 

"
1) Del siguiente enlace, descarga los datos de soccer de la temporada 2019/2020 de la primera división
de la liga española:  https://www.football-data.co.uk/spainm.php
"

"
2) Importa los datos a R como un Dataframe. NOTA: No olvides cambiar tu dirección 
de trabajo a la ruta donde descargaste tu archivo
"
sp1 <- read.csv("SP1.csv")
"
3) Del dataframe que resulta de importar los datos a `R`, extrae las columnas que 
contienen los números de goles anotados por los equipos que jugaron en casa (FTHG) 
y los goles anotados por los equipos que jugaron como visitante (FTAG); guárdalos en vectores separados
"
class(sp1)
#Investigar sobre las DB
dim(sp1)
names(sp1) #headers de columnas
# Goles del local
ngol.casa<- sp1$FTHG
ngol.casa
#Goles del visitante
ngol.vis<- sp1$FTAG
ngol.vis
'
4) Consulta cómo funciona la función `table` en `R`. 
Para ello, puedes ingresar los comandos `help("table")` o `?table` para leer la documentación.
'
"
La función table permite crear tablas de frecuencia relativa. Es como una mezcla entre el DISTINCT + GROUP BY de SQL
"
"
5. Responde a las siguientes preguntas:
"
"
a) ¿Cuántos goles tuvo el partido con mayor empate?
"
#Primero generamos un vector con numero de anotaciones en cada empate
ngol.empate<-ngol.casa[ngol.casa==ngol.vis]
ngol.empate
# Calculamos el número de empates
length(ngol.empate)
# Calculamos el máximo numero de goles para los partidos que terminaron en empate
max.emp.marc<-max(ngol.empate)
paste("El resultado del partido que culminó en empate con mayor numero de goles es un empate a",max.emp.marc,"goles")
"
b) ¿En cuántos partidos ambos equipos empataron 0 a 0?
"
# Usando la función table(a) calculamos la frecuencia de cada empate
gol.frec<-table(ngol.empate)
gol.frec
class(gol.frec)
# Necesitamos el número de partidos con empate a cero, es decir:
#De todos los empates, nos interesa solo la frecuencia de los empates a cero, por ello usamos el header "0"
frec.emp.cero<-gol.frec["0"]
paste("En",frec.emp.cero,"partidos hubo empate a 0")
"
c) ¿En cuántos partidos el equipo local (HG) tuvo la mayor goleada sin dejar que el equipo visitante (AG) metiera un solo gol?
"
#Creamos vector con número de goles del local, solo para los partidos en que el vistante se quedó en 0
ngol.win.loc<-ngol.casa[ngol.vis==0L & sp1$FTHG>0L]
ngol.win.loc
#Calculamos el máximo número de goles anotados, tal que se cumple con la condición previa
max.gol<-max(ngol.win.loc)
max.gol
paste("La mayor goleada dejando al visitante en 0 tuvo un marcador de ",max.gol,'a 0')
#Usando la funcion table(a), calculamos la frecuencia de cada partido, tal que se cumple con la condicion de dejar al visitante en cero
gol.frec.max<-table(ngol.win.loc)
gol.frec.max
#Nos interesa solo la frecuenca de los partidos con resultado #-0, con #=max.gol,usamos el header "max.gol"
frec.max.gol.cero<-gol.frec.max[as.character(max.gol)]
paste("En",frec.max.gol.cero,"partidos se dió la mayor goleada dejando al visitante en cero")
#
#  __Notas para los datos de soccer:__ https://www.football-data.co.uk/notes.txt