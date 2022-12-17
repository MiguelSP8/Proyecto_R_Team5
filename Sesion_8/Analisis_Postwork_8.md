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

## Modelo de regresión logística

1. La probabilidad de padecer insuficiencia alimentaria es menor conforme aumenta el nivel socioeconómico del hogar, en comparación con la probabilidad de padecer insuficiencia alimenaria para un hogar con un nivel socioeconómico bajo.

2. La probabilidad de padecer insuficiencia alimentaria para un hogar en una zona rural es menor que para un hogar en una zona urbana.

3. El incremento del número de personas en un hogar aumenta la probabilidd de padecer insuficiencia alimentaria.

4. La probabilidad de padecer insuficiencia alimentaria en un hogar con jefe de familia mujer es ligeramente mayor que para un hogar con jefe de familia hombre.

5. Los años de educación del jefe del hogar disminuyen la probabilidad de padecer insuficiencia alimentaria.

6. El aumento en el gasto par ala adquisición de alimnetos, tanto saludables como no saludables, disminuye el riesgo de padecer insuficiencia alimentaria.

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
