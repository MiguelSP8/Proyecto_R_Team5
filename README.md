# Autores ✒️

**Equipo 5 BEDU**

* [Miguel Angel Sandoval Puentes](https://github.com/MiguelSP8) (ma.sandovalpuentes@ugto.mx)  - *Desarrollo y Análisis* 
* [José Carlos Cuevas](https://github.com/CUOC907A) (jcarlos_cuevas_olayo@hotmail.es) - *Desarrollo y Análisis*
* [Oswaldo Helí Ramírez González](https://github.com/waldohr1)) (oswaldo.ramirez@unicach.mx) - *Desarrollo y Análisis*
* Marisol Juarez (14872@uagro.mx)
* Enrique Soto Avila (enrique.soto.avila@outlook.com)
* Ephrain Toledo (nextelfops@gmail.com)
* Alejandro (jkbojorquez@outlook.com)

# Análisis de resultados obtenidos en el desarrollo del Postwork asociado a la sesión 8
* [Código fuente en R Postwork 8](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/Postwork_8.R)

En este documento se describen las principales conclusiones asociadas con el análisis de patrones de gasto en alimentos saludables y no saludables de los hogares mexicanos, como función de observables estadísticos de interés como el *nivel socioeconómico*, la percepción  de *ingresos extra* y el riesgo de padecer *insuficiencia alimentaria*. Así mismo, se presentan las principales conclusiones extraídas del análisis de un modelo de regresión logístico, utilizado para encontrar los parámetros socioeconómicos determinantes para que un hogar padezca o no insuficiencia alimentaria. 

Tenemos información de un extracto de la Encuesta Nacional de Salud y Nutrición (2012) levantada por el Instituto Nacional de Salud Pública en México. En dicha base de datos se presenta información sonre el nivel socioeconómico (nse5f), el área geográfica (area), el número de personas en el hogar (numpeho), la disponibilidad de ingresos extra (refin), la edad (edadjef) y el sexo (sexojef) del jefe de familia así como sus años de educación (añosedu). También hay información sobre si el hogar presenta insuficiencia alimentaria (IA) y sobre el logaritmo natural del gasto de cada hogar en alimentos saludables (ln_als) y no saludables (ln_alns). Como punto de partida, se realizó una limpieza de datos, seguida de un análisis exploratorio, en busca de entender la muestra de datos con la que se está trabajando. En la figura 1 se muestran los resultados obtenidos a partír de esté análisis exploratorio.

![**Figura 1:** Resultados del análisis exploratorio de datos.](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/analisis1.png "Figura 1: Resultados del análisis exploratorio de datos")
**Figura 1:** Resultados del análisis exploratorio de datos. Distribución de hogares por A) Nivel socioeconómico, B) zona geográfica, C) percepción de ingresos extra, D) sexo del jefe del hogar, E) insuficiencia alimentaria, F) número de personas que conforman el hogar, G) Edad y H) años de educación del jefe de familia.

#### Observaciones

- La distribución de hogares conforme al nivel socioeconómico es aproximadamente uniforme, aumenando ligeramente hacia los niveles socioeconómicos altos. 
- Hay aproximadamente una razon de 2:1 de hogares en zona urbana respecto a los hogares en zona rural. 
- Aproximadamente 3 de cada 4 hogares no percibe ingresos extra. 
- De la misma forma, cerca de 3 de cada 4 hogares tiene jefe de hogar hombre. 
- Existe una proporción mayor al 2:1 en los hogares que precentan insuficiencia alimentaria respecto a los que no. 
- La distribución del número de habitantes en el hogar es cercana a una normal, con un sesgo a la derecha (distribución tipo gamma). Algo similar se observa en la distribución de edad del jefe de familia. 
- La distribución de los años de estudio es algo más complicada de entender, los picos coinciden con la culminación de algún grado, siendo los maás frecuentes los asociados a la secundaria y preparatoria.

En función del análisis anterior, se concluyó que hablar del gasto en términos absolutos no es del todo concluyente ya que el hecho de percibir más ingresos implica la posibilidad de ejercer gastos mayores tanto en alimentos saudables como no saludables. Tomando en cuenta lo anterior, se definió la variable **rateNS=ln_alns/ln_als**, como la razón entre el gasto en alimentos no saludables y saludables. Esta nueva observable nos habla más de la toma de decisión en cuanto al uso de los recursos disponibles en cada hogar que de la magnitud de sus gastos.

## 1) Patrones de gasto como función de nivel socioeconómico, ingresos extra e insuficiencia alimentaria

Una vez que se ha presentado un análisis sobre la composición de la muestra, es momento de hablar sobre los patrones de gasto en alimentos saludables y no saludables, como función de algunos determinantes socioeconómicos de intrés. Con este fin, centramos nuestro estudio en el análisis de las variables **ln_als** y **ln_alns**, así como en la nueva variable **rateNS**. Nuestras observaciones están basados en el estudio de las medidas de tendencia central, dispersión estadística y otros observables de interés:

- media: avg_als, avg_alns, avg_rate
- mediana: med_als, med_alns
- dispersión estándar: sd_als, sd_alns, sd_rate
- sesgo en la distribución: ses_als, ses_alns
- curtósis: cur_als, cur_alns
- conteo de frecuencia: n


### Nivel socieconómico

En el siguiente data frame se presentan los resultados obtenidos respecto el análisis de los patrones de gasto en alimentos saludables y no saludables como función del nivel socioeconómico (NSE) al que pertenece cada hogar.

![DateFrame NSE](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/DF_NSE.png "Figura 1: DataFrame del análisis como función del nivel socioeconómico")

Con base en los resultados ariba presentados, podemos realizar las siguientes observaciones:

- El promedio del ln del gasto, tanto en alimentos saludables (ALS) como en los no saludables (ALNS) y en la razon entre ellos, aumenta conforme mejora el nivel socioeconómico.
- Las medidas de tendencia central coinciden, en lo general, tanto para ln del gasto en ALS como para el ln del gasto en ALNS, lo que nos habla de distribuciones cercanas a una gaussiana.
- Para todos los niveles socioeconómicos, se presenta sesgo a la izquierda (s<0) en la distribución del ln(ALS) y una curtosis mayor a 3 (leptocúrtica). Esto nos habla de una cierta homogeneidad en el patrón de gasto en ALS de los hogares que pertenecen al mismo NSE. Esto se puede apreciar en la gráfica que se presenta en la figura 1.1 (A).
- Para todos los NSE, se presenta sesgo a la derecha (s>0) en la distribución del ln(ALNS) y una curtosis menor y aproximadamente 3 (mesocúrtica). Esto nos dice que el patrón de gasto en ALNS de los hogares que pertenecen al mismo NSE es menos uniforme en comparación con el patrón de gasto en ALS. Esto se puede apreciar en la gráfica que se presenta en la figura 1.1 (B).

![**Figura 1.1:** Distribución de gastos como función del nivel socioeconómico](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/NSE.png "Figura 2: Distribución del logaritmo natural del gasto en alimentos saludables y no saludables como función del nivel socioeconómico")
**Figura 1.1:** Distribución del logaritmo natural del gasto en alimentos saludables y no saludables como función del nivel socioeconómico.

#### Conclusiones (nivel socioeconómico):

- Contrario a la opinión publica, en promedio, los hogares de NSE altos gastan más en ALNS que los hogares pertenecientes a los NSE bajos, no solo en términos absolutos, sino también en términos relativos con relación a su gasto en ALS (Prueba de hipótesis pendiente).
- Los patrones de gasto en ALS son más homogéneos que los patrónes de gasto en ALNS.

### Disponibilidad de ingresos extra

En el siguiente data frame se presentan los resultados obtenidos respecto el análisis de los patrones de gasto en alimentos saludables y no saludables como función de la disponibilidad de ingresos extra en cada hogar.

![DateFrame Ingresos extra](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/DF_refin.png "Figura 1: DataFrame del análisis como función de la disponibilidad de ingresos extra")

Con base en los resultados ariba presentados, podemos realizar las siguientes observaciones:

- En promedio, los hogares que perciben ingresos extra gastan más dinero en ALS que los hogares sin ingresos extra.
- Por el contrario, en promedio, los hogares que perciben ingresos extra gastan menos, en terminos absolutos y relativos, en ALNS que los hogares sin ingresos extra.
- La distribución del gasto, ln_als y ln_alns, sigue los mismos patrones descritos respecto al NSE, como puede apreciarse en los paneles A y B de la figura 1.2.

![**Figura 1.2:** Distribución de gastos como función de la percepción de ingresos extra](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/refin.png "Figura 2: Distribución del logaritmo natural del gasto en alimentos saludables y no saludables como función de la percepción de ingresos extra")
**Figura 1.2:** Distribución del logaritmo natural del gasto en alimentos saludables y no saludables como función de la percepción de ingresos extra.

#### Conclusiones (ingresos extra):

- Los hogares que perciben ingresos extra gastan más dinero en ALS y menos dinero en ALNS que los hogares que no perciben ingresos extra (Prueba de hipótesis pendiente).
- Los patrones de gasto en ALS son más homogéneos que los patrónes de gasto en ALNS.

### Insuficiencia alimentaria

En el siguiente data frame se presentan los resultados obtenidos respecto el análisis de los patrones de gasto en alimentos saludables y no saludables en relación a si el hogar presenta o no insuficiencia alimentaria (IA).

![DateFrame Insuficiencia Alimentaria](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/DF_IA.png "Figura 1: DataFrame del análisis como función de si el hogar padece insuficiencia alimentaria")

Con base en los resultados ariba presentados, podemos realizar las siguientes observaciones:

- En promedio, los hogares que no padecen de IA gastan más, absoluta y relativamente, en ALNS que los hogares que padecen IA.
-  La distribución del ln_ALS y ln_ALNS sigue los mismos patrones descritos respecto al NSE y la disponibilidad de ingresos extra.

![**Figura 1.3:** Distribución de gastos en relación a la insuficiencia alimentaria](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/IA.png "Figura 2: Distribución del logaritmo natural del gasto en alimentos saludables y no saludables en relación a la insuficiencia alimentaria")
**Figura 1.3:** Distribución del logaritmo natural del gasto en alimentos saludables y no saludables en relación a la insuficiencia alimentaria.

#### Conclusiones (insuficiencia alimentaria):

- Los hogares que no padecen insuficiencia alimentaria destinan más recursos al consumo de ALNS que los hogares que padecen IA (Prueba de hipótesis pendiente).
- Los patrones de gasto en ALS son más homogéneos que los patrónes de gasto en ALNS.

### Análisis conjunto: nivel socioeconómico, insuficiencia laimentaria y disponibilidad de ingresos extra

Una vez analizados los patrones de gasto en ALS y ALNS como función de cada una de las tres variables de interés, de manera individual, ahora se presentan los resultados de un análisis comparativo de los patrones de consumo para cada una de las 20 combinaciones que resultan de considerar en conjunto dichas tres variables de interés:
```
IA (2 opciones) x refin (2 opciones) x NSE5F (5 opciones)
```
En las figuras 1.4 y 1.5, se presenta la distribución del gasto en alimentos saludables y no saludables, respectivamente, para las 20 diferentes combinaciones, agrupando las distribuciones de acuerdo al nivel socioeconómico. Mediante el analisis de las medidas de tendencia central, dispersión estándar (dataframe no presentado) y el resto de observables analizados, así como a través de las gráficas antes mencionadas, se puede notar que las distribuciones de datos ordenados mediante estos 20 diferentes grupos, tiene las mismas características que las descritas en el análisis descriptivo conforme a cada variable individual (ver información en subsecciones anteriores).

<p align="center" width="100%">
    <img width="66%" src="https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/als.png">
</p>

**Figura 1.4:** Distribución del logaritmo natural del gasto en alimentos saludables como función de la IA, NSE y la disponibilidad de ingresos extra.

<p align="center" width="100%">
    <img width="66%" src="https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/alns.png">
</p>

**Figura 1.5:** Distribución del logaritmo natural del gasto en alimentos NO saludables como función de la IA, NSE y la disponibilidad de ingresos extra.

En consideración de lo anterior, el siguiente data frame solo se presentan los resultados asociados con la media de las variables de interés (ln_als, ln_alns y rateNS) para la descripción de los patrones de gasto, agrupados en forma descendiente respecto al gasto relativo entre ALNS y ALS.

<p align="center" width="100%">
    <img width="66%" src="https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/DF_ord.png">
</p>

Con base en los resultados arriba presentados, podemos realizar las siguientes observaciones:

- Los hogares que pertenecen a la categoria refin=No, IA=No y NSEF5=Alto son los que más gastan en alimentos no saludables en comparación al gasto en alimentos saludables. Mientras que los hogares que pertenecen a la categoria refin=Si, IA=Si, NSEF5=Bajo son quienes destinan menos dinero al consumo de alimentos no saludables en relación al consumo de alimentos saludables.
- En general se puede ver que, contrario a la opinión publica, los hogares con mejor nivel socioeconómico destinan más dinero al consumo de alimentos NO saludables en comparación al usado para el consumo de alimentos saludables, absuluta y relativamente.
- Para todos los NSE, se encuentra que los hogares que padecen IA priorizan el gasto en ALS sobre los ALNS en comparación con los hogares que no la padecen, así mimso, los que reciben ingresos extra priorizan dicho gasta un poco más que los que no.

## 2) Análisis de probabilidades

Dado las observaciones que se realizaron en los análisis exploratorio y descriptivo previos, se presentan los siguientes análisis de probabilidad en busca de entender el problema en México. 


1. ¿Cuál es la probabilidad de que los hogares que NO reciben ingresos extra, destinen relativamente más recursos al consumo de ALNS, que el promedio de los hogares que SI perciben ingresos extra?

![**Figura 2.1:** Gráfica de densidad de probabilidad NIE vs SIE](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/grafica_E1.png "Figura 2.1: Gráfica de densidad de probabilidad NIE vs SIE")

**Figura 2.1:** Gráfica de densidad de probabilidad de rateNS para los hogares que no perciben ingresos extra. En esta gráfica observamos una distribución de probabilidad de tipo LEPTOCURTICA. El promedio de rateNS en los hogares que no perciben ingresos extra es mu = 0.6714. El quantil q = 0.6604, hace referencia al promedio de rateNS en los hogares que sí perciben ingresos extra. Usamos este ultimo como quantil para estimar la probabilidad deseada, usando la opción cola superior para ello.


#### Conclusiones:

Como se puede apreciar en la gráfica 2.1, obtenemos una probabilidad del **0.525** de que un hogar que NO percibe ingresos extra, gaste más relativamente en ALNS, que el promedio del gasto relativo de un hogar, que SI percibe ingresos extra.



2. ¿Cuál es la probabilidad de que los hogares que padecen IA relativamente, destinen más recursos al consumo de ALNS, que el promedio de los hogares que NO padecen IA?

![**Figura 2.2:** Gráfica de densidad de probabilidad si IA vs no IA](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/grafica_E2.png "Figura 2.2: Gráfica de densidad de probabilidad si IA vs no IA")

**Figura 2.2:** Gráfica de densidad de probabilidad de rateNS para los hogares padecen insuficiencia alimentaria. En esta gráfica observamos una distribución de probabilidad de tipo LEPTOCURTICA. El promedio de rateNS en los hogares que padecen insuficiencia alimentaria es mu = 0.6596. El quantil q = 0.6933, hace referencia al promedio de rateNS en los hogares que no padecen IA. Usamos este ultimo como quantil para estimar la probabilidad deseada, usando la opción cola superior para ello.


#### Conclusiones:

Existe una probabilidad del **0.423** de que un hogar que padece IA, gaste relativamente más en ALNS, que el promedio del gasto relativo de un hogar que no padece IA.



3. ¿Cuál es la probabilidad de que los hogares que pertenecen a un NSE Bajo, destinen más recursos al consumo de ALNS, que el promedio de los hogares que pertenecen a un NSE Alto?

![**Figura 2.3:** Gráfica de densidad de probabilidad NSE Bajo vs NSE Alto](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/main/Sesion_8/img/grafica_E3.png "Figura 2.3: Gráfica de densidad de probabilidad NSE Bajo vs NSE Alto")

**Figura 2.3:** Gráfica de densidad de probabilidad de rateNS para los hogares que pertenecen al NSE bajo. En esta gráfica observamos una distribución de probabilidad de tipo LEPTOCURTICA. El promedio de rateNS en los hogares que pertenecen al NSe bajo es es mu = 0.6447. El quantil q = 0.7089, hace referencia al promedio de rateNS en los hogares que pertenecen al nivel socioeconómico alto. Usamos este ultimo como quantil para estimar la probabilidad deseada, usando la opción cola superior para ello.


#### Conclusiones:

Como podemos observar, hay una probabilidad del **0.368** de que un hogar que pertenece al NSE Bajo, gaste relativamente más en ALNS, que el promedio del gasto relativo de un hogar que pertenece a un NSE Alto.


## 3) Planteamiento de  hipótesis estadísticas para entender el problema en México.

En este apartado se analizará la veracidad de las conclusiones que hemos encontrado en nuestro analisis estadístico previo, con base en la información de la muestra, en relación a la población. Considerando los siguientes puntos:

1. Nos interesa generar hipótesis sobre los patrones de gasto en alimentos saludables y no saludables en los hogares mexicanos con base a:

* Su nivel socioeconómico.
* Si el hogar tiene recursos financieros extras al ingreso.
* Si presenta o no inseguridad alimentaria.

2. Por último se verificará la hipótesis sobre si el nivel socioeconómico tiene efectos sobre la razón del gasto en razón ALNS respecto al gasto en ALS

Recordando:

_Para la comprobación de las hipotesis usaremos la prueba **t.test()** para verificar si la media muestral para cada una de las variables **IA, refin y nse5f** son representativas de la población. La distribución **t de Student** tiene características similares a la distribución normal estándar, salvo que tiene un único parámetro (grados de libertad) y es utilizada preferentemente en lugar de la distribución Z, ya que a medida que el tamaño de la muestra es más grande, su densidad se acerca a la de la distribución normal estándar._

_Adicionalmente para comprobar que los observaciones categorícas de la variables NSE (**nse5f**) impacta en el promedio de gasto de alimentos no saludables utilizaremos la función **aov(anova)** la cuál nos permite comparar la media de una variable considerando dos o más niveles/grupos de factor. Entre muchas otras aplicaciones de la **ANOVA**, esta técnica puede emplearse como una extensión de la prueba t de Student_

### Nuestros planteamientos son: 🚀

#### 1. Existe evidencia estadística para asumir que los hogares mexicanos que pertenecen a un nivel socioeconómico (NSE) alto, en promedio, gastan más en alimentos NO saludables que los hogares que pertenecen a un nivel socioeconómico (NSE) menor a Alto.

Previo a la demostración, visualizamos las 2 variables de estudio por medio de boxplot.

![**Figura 3.1:** Boxplot Nivel Socioeconómico (NSE)  Alto y NSE (< Alto) comparados con el gasto en ALNS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_1_boxplot.PNG "Figura 3.1: Boxplot Nivel Socioeconómico (NSE)  Alto y NSE (< Alto) comparados con el gasto en ALNS")

**Figura 3.1:** Boxplot Nivel Socioeconómico (NSE)  Alto y NSE (< Alto) comparados con el gasto en ALNS.

**Planteamiento de hipótesis:📋**

* Hipótesis nula, Ho: mu(ln_alns)_nse5f('alto') <=  mu(ln_alns)_nse5f('< que alto')
* Hipótesis alternativa, Ha: mu(ln_alns)_NSE('alto') >  mu(ln_alns)_NSE('< que alto')

_Se están comparando dos grupos, por lo tanto se analizará la varianza de las dos muestras._

**Conclusiones ⚙️**

Una vez realizado el análisis de las varianzas por medio de la función **t.test()** y posteriormente analizando los 2 variables con la misma función se concluye lo siguiente:

Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que, los hogares mexicanos que pertenecen a un NSE alto, en promedio, gastan más en alimentos NO saludables que los hogares que pertenecen a un NSE bajo, contrario a la opinión pública.



#### 2. Existe evidencia estadística para asumir que la razón entre el gasto destinado a ALNS y el gasto destinado a ALS en los hogares mexicanos que pertenecen a un NSE alto, en promedio, es mayor que los hogares que pertenecen a un NSE bajo

Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot

![**Figura 3.2:** Boxplot Nivel Socioeconómico (NSE)  Alto y NSE (< Alto) comparados con la razón de ALNS/ALS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_2_boxplot.PNG "Figura 3.2: Boxplot Nivel Socioeconómico (NSE)  Alto y NSE (< Alto) comparados con la razón de ALNS/ALS")

**Figura 3.2:** Boxplot Nivel Socioeconómico (NSE)  Alto y NSE (< Alto) comparados con la razón de ALNS/ALS.

**Planteamiento de hipótesis:📋**

* Hipótesis nula, Ho: mu(rateNS)_NSE('alto') <=  mu(rateNS)_NSE('< que alto')
* Hipótesis alternativa, Ha: mu(rateNS)_NSE('alto') >  mu(rateNS)_NSE('< que alto')

_Se están comparando dos grupos, por lo tanto se analizará la varianza de las dos muestras._

**Conclusiones ⚙️**

Una vez realizado el análisis de las varianzas por medio de la función **t.test()** y posteriormente analizando los 2 variables con la misma función se concluye lo siguiente:

Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que la razón entre el gasto destinado a ALNS y el gasto destinado a ALS en los hogares mexicanos que pertenecen a un NSE alto, en promedio, es mayor que los hogares que pertenecen a un NSE bajo, contrario a la opinión pública.


#### 3. En promedio, los hogares que perciben ingresos extra gastan menos, en terminos relativos, en ALNS que los hogares que no perciben ingresos extra.

Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot

![**Figura 3.3:** Boxplot Ingreso Extra en Hogares (Si/No) comparados con la razón de ALNS/ALS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_3_boxplot.PNG "Figura 3.3: Boxplot Ingreso Extra en Hogares (Si/No) comparados con la razón de ALNS/ALS")

**Figura 3.3:** Boxplot Ingreso Extra en Hogares (Si/No) comparados con la razón de ALNS/ALS.

**Planteamiento de hipótesis:📋**

* Hipótesis nula, Ho: mu(rateNS)_refin('Si') >=  mu(rateNS)_refin('No')
* Hipótesis alternativa, Ha: mu(rateNS)_refin('Si') <  mu(rateNS)_refin('No')

_Se están comparando dos grupos, por lo tanto se analizará la varianza de las dos muestras._

**Conclusiones ⚙️**

Una vez realizado el análisis de las varianzas por medio de la función **t.test()** y posteriormente analizando los 2 variables con la misma función se concluye lo siguiente:

Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que en promedio los hogares que perciben ingresos extra gastan menos, en terminos relativos, en ALNS que los hogares que no perciben ingresos extra, contrario a la opinión pública.


#### 4. En promedio, los hogares que padecen insuficiencia alimentaria gastan menos, en terminos relativos, en ALNS que los hogares que no padecen insuficiencia alimentaria.

Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot

![**Figura 3.4:** BoxPlot Boxplot Hogares con Insuficiencia Alimentaria (Si/No) comparados con la razón de ALNS/ALS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_3_boxplot.PNG "Figura 3.4: Boxplot Hogares con Insuficiencia Alimentaria (Si/No) comparados con la razón de ALNS/ALS ")

**Figura 3.4:** Boxplot Hogares con Insuficiencia Alimentaria (Si/No) comparados con la razón de ALNS/ALS.

**Planteamiento de hipótesis:📋**

* Hipótesis nula, Ho: mu(rateNS)_IA('Si') >=  mu(rateNS)_IA('No')
* Hipótesis alternativa, Ha: mu(rateNS)_IA('Si') <  mu(rateNS)_IA('No')

_Se están comparando dos grupos, por lo tanto se analizará la varianza de las dos muestras._

**Conclusiones ⚙️**

Una vez realizado el análisis de las varianzas por medio de la función **t.test()** y posteriormente analizando los 2 variables con la misma función se concluye lo siguiente:

Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que en promedio los hogares que padecen IA gastan menos, en terminos relativos, en ALNS que los hogares que no padecen IA, contrario a la opinión pública.

#### 5.Existe evidencia estadística para concluir que, en promedio, el nivel socioeconómico tiene efectos sobre la razón del gasto en razón ALNS respecto al gasto en ALS.

Previo a la demostración visualizamos las 2 variables de estudio por medio de boxplot

![**Figura 3.5:** Boxplot hogares clasificados por nivel socioeconómico y comparados con la razón de ALNS/ALS](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/4_5_boxplot.PNG "Figura 3.5: Boxplot hogares clasificados por nivel socioeconómico y comparados con la razón de ALNS/ALS")

**Figura 3.5:** Boxplot hogares clasificados por nivel socioeconómico y comparados con la razón de ALNS/ALS.

**Planteamiento de hipótesis:📋**
* Ho: avg_rateNS_nse(alto) = avg_rateNS_nse(medio alto) = avg_rateNS_nse(medio) = avg_rateNS_nse(medio bajo) = avg_rateNS_nse(bajo)
* Ha: Al menos uno es diferente.


**Conclusiones ⚙️**

Una vez realizado el análisis por medio de la función **aov(anova)**, por cuestiones de categorízación de la variables NSE, se concluye lo siguiente:

Con niveles de confianza de 90%,95% y 99%, existe evidencia estadística para rechazar Ho, por lo tanto podemos asumir que al menos uno de los promedios es diferente, esto implica que el nivel socioeconómico si tiene efecto sobre la razón entre el gasto en ALNS y ALS.


## 4) Modelo de regresión logística

En este punto se requiere encontrar los factores determinates para que un hogar mexicano presente o no insuficiencia alimentaria. Así mismo, se desea estimar la razon de probabilidades de que un hogar presente o no dicho problema, asociada a cada variable. Al hablar de probabilidades, esto
implica que necesitamos hacer un modelo de regresión logística.

Recordando:

_La regresión logística es un tipo de análisis de regresión utilizado para predecir el resultado de una variable categórica en función de las variables independientes o predictoras. Es útil para modelar la probabilidad de un evento ocurriendo en función de otros factores._

**Análisis: 📋**

Comenzamos nuesto análisis con el estudio de las correlaciones entre variables numericas, se determinó que no hay evidencia de correlación entre dichas variables.

![**Figura 4.1:** Análisis de correlaciones entre variables numericas.](https://github.com/MiguelSP8/Proyecto_R_Team5/blob/mdoswaldo/Sesion_8/img/5_1_boxplot.PNG "Figura 4.1: Análisis de correlaciones entre variables numericas.")

**Figura 4.1:** Análisis de correlaciones entre variables numericas.

Posteriormente, construimos un modelo de regresión logística, utilizando todas las variables disponibles, en busca de determinar cuales son los estadísticos relevantes para el modelo. Para ello se plantearon las siguientes hipótesis: 

    *Planteamiento de hipótesis:*
        * H_0: Bi = 0
        * H_a : Bi != 0
Haciendo uso del criterio del pvalue:

* pvalue < significancia, se rechaza H_0 en favor de H_a
* pvalue > significancia, no se rechaza H_0

Las observaciones asociadas a dicho análisis se pueden ver en la tabla siguiente.

**Observaciones: 📋**

| Variables | p-value | Estadístico relevante |
| --- | --- | --- |
| intercepto | < 2x10^-16 | Si | 
| nse5fMedio bajo | 1.97x10^-6 | Si |
| nse5fMedio | < 2e-16 | Si |
|nse5fMedio alto | < 2e-16 | Si |
| nse5fAlto | < 2e-16 | Si |
| areaRural  | 0.030585 | Si |
| numpeho | < 2e-16 | Si |
| refinSi | < 2e-16 | Si |
| edadjef | 0.35 | No |
| sexojef | 0.000299 | Si |
| añosedu | < 2e-16 | Si |
| ln_als | 0.001389 | Si |
| ln_alns | 8.39e-09 | Si |
    
De la tabla de datos anterior, se puede ver que la variable **edadjef** no es un estadístico adecuado para el sistema. Considerando esto, se creó un nuevo modelo excluyendo dicha variable. Los datos asociados con el segundo modelo se muestran en la siguiente tabla.

| Variables | p-value | Estadístico relevante | odds-momios |
| --- | --- | --- | --- |
| intercepto | < 2x10^-16 | Si | 11.7895649 | 
| nse5fMedio bajo | 2.28x10^-16 ° Si | 0.7372021 |
| nse5fMedio | < 2e-16 | Si | 0.5893272 |
|nse5fMedio alto | < 2e-16 | Si | 0.4087232 |
| nse5fAlto | < 2e-16 | Si | 0.2269539 |
| areaRural  | 0.032171 | Si | 0.9156154 |
| numpeho | < 2e-16 | Si | 1.1914034 |
| refinSi | < 2e-16 | Si | 1.4830742 |
| sexojef | 0.000256 | Si | 1.1630108  |
| añosedu | < 2e-16 | Si | 0.9485316 |
| ln_als | 0.001296 | Si | 0.9120567 |
| ln_alns | 5.20e-09 | Si | 0.9061236 |

Interpretación de los momios: exp(log odds)

* La probabilidad de padecer IA para un hogar con NSE5F "Medio bajo" es 0.7372 la probabilidad de padecer IA para un hogar con NSE5F "bajo" 
* La probabilidad de padecer IA para un hogar con NSE5F "Medio" es 0.5893 la probabilidad de padecer IA para un hogar con NSE5F "bajo" 
* La probabilidad de padecer IA para un hogar con NSE5F "Medio alto" es 0.4087 la probabilidad de padecer IA para un hogar con NSE5F "bajo" 
* La probabilidad de padecer IA para un hogar con NSE5F "Alto" es 0.2269 la probabilidad de padecer IA para un hogar con NSE5F "bajo" 
* La probabilidad de padecer IA en una zona rural es 0.9156 la probabilidad de padecer IA en una zona urbana
* La probabilidad de padecer IA para un hogar con NSE5F "Medio bajo" es 0.7372 la probabilidad de padecer IA para un hogar con NSE5F "bajo" 
* Con el incremento unitario en el número de personas que habitan el hogar, "numpeho", la probabilidad de padecer IA es 1.0326 veces la probabilidad sin dicho aumento
* La probabilidad de padecer IA para un hogar con ingresos extra (refin=Si) es 1.1914 la probabilidad de padecer IA para un hogar sin ingresos extra (refin=No) 
* La probabilidad de padecer IA para un hogar con jefe de familia mujer es 1.483 la probabilidad de padecer IA para un hogar con jefe de familia hombre
* Con el incremento unitario en el número de años de educación, "años edu", la probabilidad de padecer IA es 0.9485 veces la probabilidad sin el aumento
* Con el incremento unitario en el "ln_als", la probabilidad de padecer IA es 0.912 veces la probabilidad sin el aumento
* Con el incremento unitario en el "ln_als", la probabilidad de padecer IA es 0.906 veces la probabilidad sin el aumento

**Conclusiones**


1. La probabilidad de padecer insuficiencia alimentaria es menor conforme aumenta el nivel socioeconómico del hogar, en comparación con la probabilidad de padecer insuficiencia alimentaria para un hogar con un nivel socioeconómico bajo.

2. La probabilidad de padecer insuficiencia alimentaria para un hogar en una zona rural es menor que para un hogar en una zona urbana.

3. El incremento del número de personas en un hogar aumenta la probabilidd de padecer insuficiencia alimentaria.

4. La probabilidad de padecer insuficiencia alimentaria en un hogar con jefe de familia mujer es ligeramente mayor que para un hogar con jefe de familia hombre.

5. Los años de educación del jefe del hogar disminuyen la probabilidad de padecer insuficiencia alimentaria.

6. El aumento en el gasto para la adquisición de alimentos, tanto saludables como no saludables, disminuye el riesgo de padecer insuficiencia alimentaria.


