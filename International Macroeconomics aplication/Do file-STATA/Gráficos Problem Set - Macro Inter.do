clear all
import excel using "C:\Users\Lucia\Downloads\Datos NIIP.xlsx", firstrow clear
tsset Año

tsline NIIP, ylabel(0 "0%" -0.05 "-5%" -0.1 "-10%" -0.15 "-15%" -0.2 "-20%" -0.25 "-25%" -0.3 "-30%" -0.35 "-35%" -0.4 "-40%" -0.45 "-45%" -0.5 "-50%") ytitle("Porcentaje del PBI") xtitle("Año") xlabel(2012(2)2024) legend(label(1 "NIIP como porcentaje de PBI") label(2 "NIIP hipotética como porcentaje de PBI"))

graph export "niip.png", as(png) replace

gen NIIP_h = .
replace NIIP_h = -0.2435 in 1
gen t = _n  
forvalues i = 2/13 {
    quietly replace NIIP_h = NIIP_h[_n-1] + CurrentAccount in `i'
}

tsline NIIP_h, ylabel(0 "0%" -0.05 "-5%" -0.1 "-10%" -0.15 "-15%" -0.2 "-20%" -0.25 "-25%" -0.3 "-30%" -0.35 "-35%" -0.4 "-40%" -0.45 "-45%" -0.5 "-50%") ytitle("Porcentaje del PBI") xtitle("Año") xlabel(2012(2)2024) legend(label(1 "NIIP como porcentaje de PBI") label(2 "NIIP hipotética como porcentaje de PBI"))
graph export "niip_h.png", as(png) replace

tsline NIIP NIIP_h, ylabel(0 "0%" -0.05 "-5%" -0.1 "-10%" -0.15 "-15%" -0.2 "-20%" -0.25 "-25%" -0.3 "-30%" -0.35 "-35%" -0.4 "-40%" -0.45 "-45%" -0.5 "-50%") ytitle("Porcentaje del PBI") xtitle("Año") xlabel(2012(2)2024) legend(label(1 "NIIP como porcentaje de PBI") label(2 "NIIP hipotética como porcentaje de PBI"))
graph export "niip_h_niip.png", as(png) replace





