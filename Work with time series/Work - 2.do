//1.b
clear all
import excel using "C:\Users\Lucia\Downloads\ventas.xlsx", firstrow clear 

gen t = _n                      
tsset t   
gen ln_ventas= ln(f_ventas)

tsline ln_ventas

cap drop t
gen t = _n
tsset t

//Vemos si hay algo
gen D_ln_ventas = D.ln_ventas
gen ln_ventas_l1 = L.ln_ventas
gen D_ln_ventas_l1 = L.D_ln_ventas
gen D_ln_ventas_l2 = L2.D_ln_ventas
gen D_ln_ventas_l3 = L3.D_ln_ventas
gen D_ln_ventas_l4 = L4.D_ln_ventas
gen D_ln_ventas_l5 = L5.D_ln_ventas
gen D_ln_ventas_l6 = L6.D_ln_ventas

gen trend = _n

reg D_ln_ventas ln_ventas_l1 D_ln_ventas_l1 D_ln_ventas_l2 D_ln_ventas_l3 D_ln_ventas_l4 D_ln_ventas_l5 D_ln_ventas_l6 trend 

dfuller ln_ventas, lags(6) trend
pperron ln_ventas, lags(6) trend

//elimino el trend

reg D_ln_ventas ln_ventas_l1 D_ln_ventas_l1 D_ln_ventas_l2 D_ln_ventas_l3 D_ln_ventas_l4 D_ln_ventas_l5 D_ln_ventas_l6

dfuller ln_ventas, lags(6)
pperron ln_ventas, lags(6) 

//elimino la constante

reg D_ln_ventas ln_ventas_l1 D_ln_ventas_l1 D_ln_ventas_l2 D_ln_ventas_l3 D_ln_ventas_l4 D_ln_ventas_l5 D_ln_ventas_l6, noconstant

dfuller ln_ventas, lags(6) noconstant
pperron ln_ventas, lags(6) noconstant

//tengo que controlar por quiebres estructurales

//1.c. 

zandrews ln_ventas, maxlags(6) break(both)

gen T1 =1

forvalues i = 1/141 {
    quietly replace T1 = 0 in `i'
}

reg D_ln_ventas ln_ventas_l1 D_ln_ventas_l1 D_ln_ventas_l2 D_ln_ventas_l3 D_ln_ventas_l4 D_ln_ventas_l5 D_ln_ventas_l6 T1 trend

reg D_ln_ventas ln_ventas_l1 D_ln_ventas_l1 D_ln_ventas_l2 D_ln_ventas_l3 D_ln_ventas_l4 D_ln_ventas_l5 D_ln_ventas_l6 T1 

zandrews ln_ventas if t>141, break(both) maxlags(6) //si hay uno: se encuentra en 266

gen T2 =1

forvalues i = 1/266 {
    quietly replace T2 = 0 in `i'
}

reg D_ln_ventas ln_ventas_l1 D_ln_ventas_l1 D_ln_ventas_l2 D_ln_ventas_l3 D_ln_ventas_l4 D_ln_ventas_l5 D_ln_ventas_l6 T1 T2 trend

reg ln_ventas trend T1 T2
predict ln_ventas_clean, residuals
dfuller ln_ventas_clean, lags(6) trend

gen D_ln_ventas_clean = D.ln_ventas_clean
dfuller D_ln_ventas_clean, lags(6)

ac D_ln_ventas_clean, lags(20)
pac D_ln_ventas_clean, lags(20)




