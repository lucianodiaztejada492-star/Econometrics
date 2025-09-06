clear
cd "C:\Users\USUARIO\Desktop\base_caso2"
use consolidation_dd_example

collapse (mean) district_services_exp_pp, by(year treat)

twoway ///
(line district_services_exp_pp year if treat == 1, sort lcolor(blue) lpattern(solid)) ///
(line district_services_exp_pp year if treat == 0, sort lcolor(red) lpattern(dash)) ///
, ///
legend(order(1 "Tratados" 2 "No tratados")) ///
title("Tendencias de gasto por alumno") ///
xtitle("Año") ytitle("Gasto promedio por alumno") ///
xline(1997, lpattern(dot) lcolor(black)) ///
note("Línea vertical en 1997: primer año de tratamiento")




use "consolidation_dd_example.dta", clear


preserve
keep if treat == 1
collapse (mean) mean_trat = district_services_exp_pp ///
         (sd) sd_trat = district_services_exp_pp ///
         (count) n_trat = district_services_exp_pp, by(year)
save tratados, replace
restore


keep if treat == 0
collapse (mean) mean_control = district_services_exp_pp ///
         (sd) sd_control = district_services_exp_pp ///
         (count) n_control = district_services_exp_pp, by(year)
save control, replace

merge 1:1 year using tratados, nogen


gen diff = mean_trat - mean_control
gen se = sqrt((sd_trat^2 / n_trat) + (sd_control^2 / n_control))
gen ic_sup = diff + invnormal(0.995) * se
gen ic_inf = diff - invnormal(0.995) * se




	gen significativo = (ic_inf > 0 | ic_sup < 0)

twoway ///
    (rarea ic_inf ic_sup year, color(gs12)) ///
    (line diff year, lcolor(black) lwidth(medthick)) ///
    (scatter diff year if significativo==1, msymbol(circle) mcolor(red) msize(medium)) ///
    (scatter diff year if significativo==0, msymbol(circle) mcolor(blue) msize(medium)) ///
    , ///
    title("Diferencia de gasto promedio: Tratados vs No tratados") ///
    subtitle("Con intervalos de confianza al 99%") ///
    xtitle("Año académico") ///
    ytitle("Diferencia en gasto por alumno (USD)") ///
    legend(order(2 "Diferencia promedio" 3 "Significativo (p<0.01)" 4 "No significativo") ///
           ring(0) position(1) col(1)) ///
    yline(0, lpattern(dash) lcolor(black)) ///
    xline(1997, lpattern(dash) lcolor(maroon)) ///
    note("Línea vertical en 1997: primer año de tratamiento", size(small))







