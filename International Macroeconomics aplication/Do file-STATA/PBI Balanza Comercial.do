clear all
import excel using "C:\Users\Lucia\Downloads\Copia de pbi_con_bc_descontada.xlsx", firstrow clear
gen year = real(substr(Fecha, 1, 4))
gen q = real(substr(Fecha, 6, 1))
gen fecha = yq(year, q)
format fecha %tq

tsset fecha 

tsline PBI BC_descontada, ytitle("Millones de dólares FOP") xtitle("Trimestre") legend(label(1 "PBI") label(2 "Balanza Comercial Descontada"))

correlate PBI BC_descontada
graph export "grafico_willy_1.png", as(png) replace
