clear all 
import excel using "C:\Users\Lucia\Downloads\sc_mensual.xlsx", firstrow clear 
//1.a

gen t = _n                      
tsset t   
gen ln_creditos1 = ln(Creditos)
gen ln_creditos=.
replace ln_creditos = 0 in 1                  

forvalues i = 2/1000 {
    quietly replace ln_creditos = ln_creditos1[_n] - ln_creditos1[_n-1]
}

tsline ln_creditos

cap drop t
gen t = _n
tsset t

gen D_ln_creditos = D.ln_creditos
gen ln_creditos_l1 = L.ln_creditos
gen D_ln_creditos_l1 = L.D_ln_creditos
gen D_ln_creditos_l2 = L2.D_ln_creditos
gen D_ln_creditos_l3 = L3.D_ln_creditos
gen D_ln_creditos_l4 = L4.D_ln_creditos
gen D_ln_creditos_l5 = L5.D_ln_creditos
gen D_ln_creditos_l6 = L6.D_ln_creditos

gen trend = _n

reg D_ln_creditos ln_creditos_l1 D_ln_creditos_l1 D_ln_creditos_l2 D_ln_creditos_l3 D_ln_creditos_l4 D_ln_creditos_l5 D_ln_creditos_l6 trend 

dfuller ln_creditos, lags(6) trend 

reg D_ln_creditos ln_creditos_l1 D_ln_creditos_l1 D_ln_creditos_l2 D_ln_creditos_l3 D_ln_creditos_l4 D_ln_creditos_l5 D_ln_creditos_l6 

dfuller ln_creditos, lags(6) 

//1.b
clear all
import excel using "C:\Users\Lucia\Downloads\ventas.xlsx", firstrow clear 



//anexo 


//1.b 

