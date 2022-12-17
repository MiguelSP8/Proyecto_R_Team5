# Código fuente en R para obtener los resultados 🛠️
* [Código fuente en R Postwork 8](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/Postwork_8.R)

# Autores ✒️

## Equipo 5 BEDU
* **Miguel** - *Desarrollo y Análisis* - [Miguel](https://github.com/)
* **Jose** - *Desarrollo y Análisis* - [José](https://github.com/)
* **Oswaldo** - *Desarrollo y Análisis* - [Oswaldo](https://github.com/)


# Análisis de resultados obtenidos en el desarrollo del Postwork asociado a la sesión 8

En este documento se describen las principales conclusiones asociadas con el análisis de patrones de gasto en alimentos saludables y no saludables, como función de observables estadísticos de interés como el *nivel socioeconómico*, la percepción  de *ingresos extra* y el riesgo de padecer *insuficiencia alimentaria*. Así mismo, se presentan las principales conclusiones extraídas del análisis de un modelo de regresión logístico utilizado para encontrar los parámetros socioeconómicos determinantes para padecer o no insuficiencia alimentaria. 

Como punto de partida, se realizó una limpieza de datos, seguida de un análisis exploratorio, en busca de entender la muestra de datos con la que se está trabajando. En la figura 1 se muestran los resultados obtenidos a partír de esté análisis exploratorio.

![**Figura 1:** Resultados del análisis exploratorio de datos.](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/analisis1.png "Figura 1: Resultados del análisis exploratorio de datos")
**Figura 1:** Resultados del análisis exploratorio de datos. 

## Patrones de gasto como función de nivel socioeconómico, ingresos extra e insuficiencia alimentaria

### Nivel socieconómico
Texto 

![**Figura 1:** DateFrame NSE](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/DF_NSE.png "Figura 1: DataFrame del análisis como función del nivel socioeconómico")

1. En terminos absolutos, los hogares que más gastan en alimentos no saludables son los de nivel socio económico alto, sin ingresos extra y que no padecen insuficiencia alimentaria. 

2. Los hogares que menos gastan en alimentos no saludables son los hogares de nivel socioeconómico bajo, sin ingresos extra y que además padecen insuficiencia alimentaria.

3. En general, para las 20 diferentes combinaciones de categorias asociadas a insuficiencia alimentaria (IA), Nivel socioeconómico (NSE5F) y percepción de ingresos extra (REFIN), las medidades de tendencia central coinciden, lo cual nos habla de una posible distribución normal.

4. Considerando que hablar del gasto en términos ABSOLUTOS no es del todo concluyente, ya que el hecho de percibir más ingresos implica la posibilidad de ejercer gastos mayores tanto en alimentos saudables como no saludables, se calculó la razón entre el gasto en alimentos no saludables y saludables, la cual nos proporciona información sobre de la toma de decisión en cuanto al uso de los recursos disponibles en cada hogar. La principal conclusión de este análisis es que, en general, se puede ver que, **contrario a la opinión pública**, los hogares con mejor nivel socioeconómico destinan más dinero al consumo de alimentos NO saludables en comparación con el dinero usado para el consumo de alimentos saludables.

5. También se encontró que para todos los niveles socioeconómicos, los hogares con ingresos extra y que padecen insuficiencia alimentaria son quienes **priorizan más** el consumo de alimentos **saludables** sobre los **no saludables**.



## Análisis de probabilidades

En concordancia con el análisis anterior, podemos obtener la probabilidad y gráficos de densidad que nos permitan visualizar el comportamiento de las variables en términos estadisticos, los cuales se describen a continuación:

1. ¿Cuál es la probabilidad de que los hogares que NO reciben ingresos extra, destinen relativamente más recursos al consumo de ALNS, que el promedio de
los hogares que SI perciben ingresos extra?

![**Figura XX:** Gráfica de densidad de probabilidad NIE vs SIE](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/grafica_E1.png "Figura XX: Gráfica de densidad de probabilidad NIE vs SIE")

Como se puede apreciar en la gráfica XX, obtenemos una probabilidad del 0.525 de que un hogar que NO percibe ingresos extra, gaste más en ALNS, que el promedio
del gasto de un hogar, que SI percibe ingresos extra.

2. ¿Cuál es la probabilidad de que los hogares que padecen IA relativamente, destinen más recursos al consumo de ALNS, que el promedio de los hogares que NO
padecen IA?

![**Figura XXX:** Gráfica de densidad de probabilidad si IA vs no IA](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/grafica_E2.png "Figura XXX: Gráfica de densidad de probabilidad si IA vs no IA")

Existe una probabilidad del 0.423 de que un hogar que padece IA, gaste relativamente más en ALNS, que el promedio del gasto relativo de un hogar que no padece IA.

3. ¿Cuál es la probabilidad de que los hogares que pertenecen a un NSE Bajo, destinen más recursos al consumo de ALNS, que el promedio de los hogares que 
pertenecen a un NSE Alto?

![**Figura IV:** Gráfica de densidad de probabilidad NSE Bajo vs NSE Alto](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/grafica_E3.png "Figura IV: Gráfica de densidad de probabilidad NSE Bajo vs NSE Alto")

Como podemos observar, hay una probabilidad del 0.368 de que un hogar que pertenece al NSE Bajo, gaste relativamente más en ALNS, que el promedio del gasto relativo
de un hogar que pertenece a un NSE Alto.


# Planteamiento de  hipótesis estadísticas para entender el problema en México.

En este apartado se analizará la veracidad de las conclusiones que hemos encontrado en nuestro analisis estadístico previo, con base en la información de la muestra, en relación a la población.

Nos interesa analizar los patrones de gasto en alimentos saludables y no saludables en los hogares mexicanos con base a:
```
* Su nivel socioeconómico, 
* Si el hogar tiene recursos financieros extras al ingreso 
* Si presenta o no inseguridad alimentaria.
```
Recordando:
* si muestra>=30 o conocemos varianza de población => Normal
* si muestra<30 Y no conocemos varianza de población => t-student

_En nuestro caso, desconocemos el dato preciso de las medidas de tendencia central y dispersión estadística de la población, usaremos la prueba **t.test()** para verificar si la media muestral para cada una de las 20 combinaciones posibles de las variables **IA, refin y nse5f** son representativas de la población._

## Nuestros planteamientos son: 🚀

### ⌨️ 1) Existe evidencia estadística para asumir que los hogares mexicanos que pertenecen a un nivel socioeconómico (NSE) alto, en promedio, gastan más en alimentos NO saludables que los hogares que pertenecen a un nivel socioeconómico (NSE) menor a Alto.

**Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot**

![**Figura 4.1:** BoxPlot NSE Alto vs NSE < Alto](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_1_boxplot.PNG "Figura 4.1: BoxPlot NSE Alto vs NSE < Alto")

#### Planteamiento de hipótesis:📋

* **Hipótesis nula, Ho: mu(ln_alns)_nse5f('alto') <=  mu(ln_alns)_nse5f('< que alto')**
* **Hipótesis alternativa, Ha: mu(ln_alns)_NSE('alto') >  mu(ln_alns)_NSE('< que alto')**

_Se están comparando dos grupos, por lo tanto se analizará la varianza de las dos muestras._

#### Conclusiones ⚙️

#### Una vez realizado el análisis de las varianzas por medio de la función **t.test()** y posteriormente analizando los 2 variables con la misma función se concluye lo siguiente:

#### **Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que los hogares mexicanos que pertenecen a un NSE alto, en promedio, gastan más en alimentos NO saludables que los hogares que pertenecen a un NSE bajo, contrario a la opinión pública.**



### ⌨️ 2) Existe evidencia estadística para asumir que la razón entre el gasto destinado a ALNS y el gasto destinado a ALS en los hogares mexicanos que pertenecen a un NSE alto, en promedio, es mayor que los hogares que pertenecen a un NSE bajo

**Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot**

![**Figura 4.2:** BoxPlot NSE Alto vs NSE < Alto, con base a la razón de ALNS/ALS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_2_boxplot.PNG "Figura 4.1: BoxPlot NSE Alto vs NSE < Alto, con base a la razón de ALNS/ALS ")

#### Planteamiento de hipótesis:📋

* **Hipótesis nula, Ho: mu(rateNS)_NSE('alto') <=  mu(rateNS)_NSE('< que alto')**
* **Hipótesis alternativa, Ha: mu(rateNS)_NSE('alto') >  mu(rateNS)_NSE('< que alto')**

_Se están comparando dos grupos, por lo tanto se analizará la varianza de las dos muestras._

#### Conclusiones ⚙️

#### Una vez realizado el análisis de las varianzas por medio de la función **t.test()** y posteriormente analizando los 2 variables con la misma función se concluye lo siguiente:

#### **Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que la razón entre el gasto destinado a ALNS y el gasto destinado a ALS en los hogares mexicanos que pertenecen a un NSE alto, en promedio, es mayor que los hogares que pertenecen a un NSE bajo, contrario a la opinión pública.**


### ⌨️ 3) En promedio, los hogares que perciben ingresos extra gastan menos, en terminos relativos, en ALNS que los hogares que no perciben ingresos extra.

**Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot**

![**Figura 4.3:** BoxPlot Ingreso Extra en hogares con base a la razón de ALNS/ALS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_3_boxplot.PNG "Figura 4.3: BoxPlot Ingreso Extra en hogares con base a la razón de ALNS/ALS ")

#### Planteamiento de hipótesis: 📋

* **Hipótesis nula, Ho: mu(rateNS)_refin('Si') >=  mu(rateNS)_refin('No')**
* **Hipótesis alternativa, Ha: mu(rateNS)_refin('Si') <  mu(rateNS)_refin('No')**

_Se están comparando dos grupos, por lo tanto se analizará la varianza de las dos muestras._

#### Conclusiones ⚙️

#### Una vez realizado el análisis de las varianzas por medio de la función **t.test()** y posteriormente analizando los 2 variables con la misma función se concluye lo siguiente:

#### **Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que en promedio los hogares que perciben ingresos extra gastan menos, en terminos relativos, en ALNS que los hogares que no perciben ingresos extra, contrario a la opinión pública.**


### ⌨️ 4) En promedio, los hogares que padecen insuficiencia alimentaria gastan menos, en terminos relativos, en ALNS que los hogares que no padecen insuficiencia alimentaria.

**Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot**

![**Figura 4.4:** BoxPlot Hogares con Insuficiencia Alimentaria de acuerdo a la razón de ALNS/ALS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_3_boxplot.PNG "Figura 4.4: BoxPlot Hogares con Insuficiencia Alimentaria de acuerdo a la razón de ALNS/ALS ")

#### Planteamiento de hipótesis: 📋

* **Hipótesis nula, Ho: mu(rateNS)_IA('Si') >=  mu(rateNS)_IA('No')**
* **Hipótesis alternativa, Ha: mu(rateNS)_IA('Si') <  mu(rateNS)_IA('No')**

_Se están comparando dos grupos, por lo tanto se analizará la varianza de las dos muestras._

#### Conclusiones ⚙️

#### Una vez realizado el análisis de las varianzas por medio de la función **t.test()** y posteriormente analizando los 2 variables con la misma función se concluye lo siguiente:

#### **Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que en promedio los hogares que padecen IA gastan menos, en terminos relativos, en ALNS que los hogares que no padecen IA, contrario a la opinión pública.**

### ⌨️ 5) Existe evidencia estadística para concluir que, en promedio, el nivel socioeconómico tiene efectos sobre la razón del gasto en razón ALNS respecto al gasto en ALS.

**Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot**

![**Figura 4.5:** BoxPlot Nivel socioeconómico en Hogares de acuerdo a la razón de ALNS/ALS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_5_boxplot.PNG "Figura 4.5: BoxPlot Nivel socioeconómico en Hogares de acuerdo a la razón de ALNS/ALS")

#### Planteamiento de hipótesis: 📋

* **Ho: avg_rateNS_nse(alto) = avg_rateNS_nse(medio alto) = avg_rateNS_nse(medio) = avg_rateNS_nse(medio bajo) = avg_rateNS_nse(bajo)**
* **Ha: Al menos uno es diferente.**


#### Conclusiones ⚙️

#### Una vez realizado el análisis por medio de la función **anova()**, por cuestiones de categorízación de la variables NSE, se concluye lo siguiente:

#### **Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que al menos uno de los promedios es diferente, esto implica que el nivel socioeconómico si tiene efecto sobre la razón entre el gasto en ALNS y ALS.**


# Modelo de regresión logística

Se quiere estimar la probabilidad de que un hogar presente inseguridad alimentaria o no

**_Al hablar de probabilidad significa que necesitamos hacer un modelo de regresión logística_**

## Análisis: 📋

### Análisis de correlaciones entre variables numericas

**_A partir de la matriz de correlación como del análisis visual, No hay evidencia de correlación entre las variables numéricas que describen el problema_**

### Se genera el modelo de regresión logística, usando todas las variables disponibles.

#### Planteamiento de hipótesis: 📋

* **H_0: Bi = 0**
* **H_a : Bi != 0**

## Información obtenida: 📋
### Tabla de resultados
FALTA

## Conclusiones ⚙️

1. La probabilidad de padecer insuficiencia alimentaria es menor conforme aumenta el nivel socioeconómico del hogar, en comparación con la probabilidad de padecer insuficiencia alimentaria para un hogar con un nivel socioeconómico bajo.

2. La probabilidad de padecer insuficiencia alimentaria para un hogar en una zona rural es menor que para un hogar en una zona urbana.

3. El incremento del número de personas en un hogar aumenta la probabilidd de padecer insuficiencia alimentaria.

4. La probabilidad de padecer insuficiencia alimentaria en un hogar con jefe de familia mujer es ligeramente mayor que para un hogar con jefe de familia hombre.

5. Los años de educación del jefe del hogar disminuyen la probabilidad de padecer insuficiencia alimentaria.

6. El aumento en el gasto par ala adquisición de alimnetos, tanto saludables como no saludables, disminuye el riesgo de padecer insuficiencia alimentaria.

