clear all
import excel using "C:\Users\Lucia\Downloads\Copia de Variación_porcentual_del_bc_y_del_PBI.xlsx", firstrow clear

gen year = real(substr(Fecha, 1, 4))
gen q = real(substr(Fecha, 6, 1))
gen fecha = yq(year, q)
format fecha %tq
gen obs_id = _n
tsset obs_id fecha


tsline ejemplo1 ejemplo2, ytitle("Variación porcentual") xtitle("Trimestre") legend(label(1 "Variación porcentual BC") label(2 "Variación porcentual PBI"))

correlate PBI BC_descontada
graph export "grafico_willy_1.png", as(png) replace
