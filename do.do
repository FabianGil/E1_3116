                      ***** TRABAJO COMPUTACIÓN ESTADÍSTICA*****

*I]COMBINACIÓN DE BASES DE DATOS*****

*1)Importar y guardar base de excel:
clear 
import excel "Base1(4) (1).xls", sheet("base1") firstrow
save "Base excel importada.dta", replace

*2) Importar y guardar base de datos delimitados:
clear
import delimited "Base2 (1).csv" 
save "Base delimitada importada.dta", replace
 
*3) Append las dos bases:
use "Base excel importada.dta"
append using "Base delimitada importada.dta"
save "Base 1 y 2 unidas.dta", replace

*4) Merge base 3:
merge m:1 var1 using "Base3 (1).dta"
save "Base final trabajo 1.dta", replace
** Acopló 303 observaciones **

*II] Organizar base de datos:

*1) Modificar formato de fechas de manera similar:
*1.1] Fecha de nacimiento
generate fechan = date(var7,"MDY")   
*;(9 missing generados)
format %tdDD/NN/CCYY fechan
drop var7
*1.2] Fecha de angiografía:
generate fechangio = date(var9,"DMY")
*(5 missing generados)
format %tdDD/NN/CCYY fechangio 
drop var9

*2) Modificar variables leidas erroneamente como categoricas:
*2.1] Presion arterial sistólica y 2.2] Colesterol:
destring var4 var5, replace force
*Var 4 (PAS) generó 5 missings.
* Var 5(colesterol) generó 7 missings. 

*III] Nombrar y etiquetar variables y valores:
*1) Nombrar variables y etiquetar:  
label variable var1 "Patient´s identification. "
rename var1 id
label variable var2 "patient´s sex"
rename var2 sex
label variable var3 "Chest pain type"
rename var3 dolortipo
label variable var4 "Systolic blood pressure"
rename var4 pas
label variable var5 "Serum cholestoral"
rename var5 colesterol
label variable var6 "Resting electrocardiographic results"
rename var6 ekg
label variable var8 "Diagnosis of heart disease"
rename var8 dx
label variable fechan "Date of birth"
label variable fechangio "Coronary angiography date"

*2) Rotular valores:
label define sex 0 "female" 1 "male"
label values sex sex
label define angina 1 "typical angina" 2 "atypical angina" 3 "non-anginal pain" 4 "asymptomatic"
label values dolortipo angina
label variable colesterol "Serum cholestoral mg/dl"
label variable pas "Systolic blood pressure mmHg"
order _merge, last
label define Electroocardiograma 0 "normal" 1 "having ST-T wave abnormality" 2 "showing probable or definite left ventricular hypertrophy"
label values ekg Electroocardiograma
label define comrpomise 0 "< 50% diameter narrowing" 1 "> 50% diameter narrowing"
label values dx comrpomise

*3) Hipertensión arterial:
*Primero, organización :
generate HTA=.
replace HTA=1 if pas<90
replace HTA=2 if pas>=90 & pas<=129
replace HTA=3 if pas>=130 & pas<=139
replace HTA=4 if pas>=140 & pas<=159
replace HTA=5 if pas>=160 & pas<=179
replace HTA=6 if pas>=180

*Segundo, etiquetado:
label define Hipertension 1 "Hipotensión" 2 "Deseada/Normall" 3 "Prehipertensión" 4 "Hpertensión grado 1" 5 "Hpertensión grado2" 6 "crisis hipertensiva"
label values HTA Hipertension


*V] Generar edad al momento de la angiografía:
generate edadexamen= fechangio - fechan
*(14 missing values generated)
gen edadex=edadexamen/365.25
*(14 missing values generated)

*VI] Describir pacientes por edad y sexo.

*1) Genero edad de los pacientes:
generate HOY= ("13/08/2017","DMY")
generate hoy2 = date(HOY, "DMY")
generate edadpcte = hoy2 - fechan
generate edady=edadpcte/365.25
drop HOY hoy2 edadpcte

*2) Grafico pie chart para describir proporcion segun sexo
graph pie, over(sex)
*En este gráfico se puede observar que el 68% de los individuos pertenecientes a la base de datos son de género masculinos. Se debe tener en cuenta que tres registros no contaban con la observación de la variable sexo. 

*3) box plot para comparar:
graph box edady, by(sex)
*Y en esta segunda figura se evidencia una mediana similar en cuanto a la edad de los pacientes pertenecientes tanto al género masculino cómo al femenino. Esta mediana se ubica entre los 50 y 60 años. En el caso de las mujeres se evidencia que el percentil 25 contiene individuos hasta los 51 años y que el percentil 75 es mayor a los 63. Este grafico evidencia una menor variabilidad dad que es de menor tamaño y no cuenta con valores por fuera de los denominados bigotes de la caja. En el caso de los hombres si existe este valor de un individuo de 30 año, el corte para el percentil 25 es de 48 años y de edad y el del percentil 75 es de 61 años edad. Cabe aclarar que esto se pude deber a que el mayor número de individuos era masculino. 

*VII] Comparar diagnóstico de 
tab dolortipo dx
*En esta tabla se evidencia en primera instancia que la mayoría de pacientes evaluados tenían menos del 50% del compromiso al momento del examen. Y entre estos la mayor parte presentó un dolor no anginoso seguido del atípico, ser asintomático y por último el dolor anginoso. En el caso de los que tenían más del 50% del compromiso la mayor parte fue asintomática seguido del dolor no anginoso, el atípico y nuevamente en último lugar en cuanto a frecuencia fue el dolor anginoso típico. Si se habla del total en cuanto a las presentaciones el orden no se modifica de manera importante. El evento más frecuente fue el asintomático seguido del dolor no anginoso, el atípico y por último el dolor anginoso típico. En la siguiente tabla se evidencian los porcentajes especificados. 
tab dolortipo dx, column 
* Key frequency column percentages

