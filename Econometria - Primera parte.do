*ssc install outreg2
*ssc install estout

clear all
set type double
cd "C:\\Stata"
use "C:\Stata\input\Work_Information1" 

*Para corroborar la ausencia de missing values y limpiar la base.

codebook dpto - formal

ttest formal_pre, by(tratamiento)
ttest local_agua, by(tratamiento)
ttest local_desague, by(tratamiento)
ttest local_luz, by(tratamiento)
ttest local_internet, by(tratamiento)
ttest ganancias_anuales_pre, by(tratamiento)
ttest mujer, by(tratamiento)
 
reg ganancias_anuales tratamiento, nocons 
eststo model1

reg ganancias_anuales tratamiento 
eststo model2

reg ganancias_anuales tratamiento mujer
eststo model3

reg ganancias_anuales tratamiento mujer formal
eststo model4

esttab, not nonumber se r2
 
cap drop lima
gen lima = 1 if dpto == 15
replace lima = 0 if lima == .

cap drop lima_trat
gen lima_trat = lima*tratamiento

reg ganancias_anuales tratamiento lima lima_trat
eststo model5 

esttab model5, not nonumber se r2 ar2


reg ganancias_anuales tratamiento lima lima_trat formal mujer local_agua local_desague local_luz local_internet
eststo model6

esttab model6, not nonumber se r2 ar2

reg ganancias_anuales tratamiento lima lima_trat formal
eststo model7

reg ganancias_anuales tratamiento lima lima_trat formal local_internet
eststo model8


esttab model5 model7 model8 model6, not nonumber se r2 ar2
 
cap drop cambioventas
gen cambioventas = (ventas_anuales/ventas_anuales_pre)-1
replace cambioventas = 0 if cambioventas == .
reg cambioventas tratamiento 
ttest cambioventas = 0.2 if tratamiento == 1

