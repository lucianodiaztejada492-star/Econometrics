
cd "C:\\Stata"
use "C:\Stata\input\Work_Information2" 


cap drop year_at_14
gen year_at_14 = datyear-age+14
cap drop legislacion
gen legislacion = 1 
replace legislacion = 0 if year_at_14<=47
cap drop age_increase
rename legislacion age_increase

reg agelfted age_increase sex date_of_birth
eststo model1
outreg2 using documento.doc, replace
estimates store mco2
reg earn age_increase sex date_of_birth
eststo model2
outreg2 using documento.doc, append
estimates store iv2
ivregress 2sls earn (agelfted=age_increase) sex date_of_birth
eststo model4
outreg2 using documento.doc, append
hausman mco2 iv2

reg agelfted age_increase sex 
eststo model1
outreg2 using documento2.doc, replace
estimates store mco2
reg earn age_increase sex 
eststo model2
outreg2 using documento2.doc, append
estimates store iv2
ivregress 2sls earn (agelfted=age_increase) sex 
eststo model4
outreg2 using documento2.doc, append
hausman mco2 iv2






reg earn age_increase sex date_of_birth
eststo model5
outreg2 using documento3.doc, replace
estimates store mco1
ivregress 2sls earn (agelfted=age_increase) sex 
eststo model6
outreg2 using documento3.doc, append
estimates store iv1
hausman iv1 mco1



