clear all 
cd "C:\Esta Aplicada\Caso 1"

import excel using input/Mensuales-20231011-155127, firstrow clear 
br
rename PN01234PM tc
save Mensuales-20231011-155127, replace


cap drop x
gen x=substr(A,1,3)
cap drop y
gen y=substr(A,4,5)

cap drop z
gen z=19 
tostring z, replace

cap drop w
gen w=20
tostring w, replace

egen combinacion1=concat(z y)
egen combinacion2=concat(w y)

destring y, replace
replace combinacion1=combinacion2 if y<=24
drop y z w combinacion2
rename combinacion1 año 
drop in 1
rename x mes 
destring año, replace 


encode mes, gen (mes1)
tab mes1
recode mes1 (4/5 8 = 1 "Trimestre 1") (1 7 9=2 "Trimestre 2") (2 6 12=3 "Trimestre 3") (3 10 11=4 "Trimestre 4"), gen(mes2)
rename mes2 trimestre 
drop mes 
rename mes1 mes


destring tc, replace 
bys año trimestre: egen tc_trim = mean(tc)


drop A
help order
order año trimestre mes tc tc_trim

label var año año
label var mes mes
label var tc tc
label var tc_trim tc_trim
label var trimestre trimestre													

save data_tc, replace 


clear all 
import excel using input/Mensuales-20240417-225955, firstrow clear cellrange (A13:B386)
br
rename B ipc 
rename Nov91 A
gen inflación= (ipc[_n]-ipc[_n-1])/ipc[_n]
drop in 1



cap drop x
gen x=substr(A,1,3)
cap drop y
gen y=substr(A,4,5)

cap drop z
gen z=19 
tostring z, replace

cap drop w
gen w=20
tostring w, replace

egen combinacion1=concat(z y)
egen combinacion2=concat(w y)

destring y, replace
replace combinacion1=combinacion2 if y<=24
drop y z w combinacion2
rename combinacion1 año 
rename x mes 
destring año, replace 

bys año: egen media_infla=mean(inflación)

cap drop tipo_infla
gen tipo_infla=1 if inflación < media_infla 
replace tipo_infla=2 if inflación >= media_infla

drop A
order mes año ipc inflación media_infla tipo_infla
sort año

bys año tipo_infla: egen infl=mean(inflación)


collapse (mean) infl, by (tipo_infla año)
reshape wide infl, i(año) j(tipo_infla) 

label var infl1  "Media de la inflación mensual menor a su media anual"
label var infl2 "Media de la inflación mensual mayor o igual a su media anual"
drop año 
save base_inflacion_anual, replace 


clear all 
import excel using input/Mensuales-20240417-225955, firstrow clear cellrange (A13:B386)
br
rename B ipc 
rename Nov91 A
gen inflación= (ipc[_n]-ipc[_n-1])/ipc[_n]
drop in 1

cap drop x
gen x=substr(A,1,3)
cap drop y
gen y=substr(A,4,5)

cap drop z
gen z=19 
tostring z, replace

cap drop w
gen w=20
tostring w, replace

egen combinacion1=concat(z y)
egen combinacion2=concat(w y)

destring y, replace
replace combinacion1=combinacion2 if y<=24
drop y z w combinacion2
rename combinacion1 año 
rename x mes 
destring año, replace 

bys año: egen media_infla=mean(inflación)

cap drop tipo_infla
gen tipo_infla=1 if inflación < media_infla 
replace tipo_infla=2 if inflación >= media_infla

drop A
order mes año ipc inflación media_infla tipo_infla
sort año

bys año tipo_infla: egen infl=mean(inflación)


collapse (mean) infl, by (tipo_infla año)
reshape wide infl, i(año) j(tipo_infla) 

label var infl1  "Media de la inflación mensual menor a su media anual"
label var infl2 "Media de la inflación mensual mayor o igual a su media anual"
save bblka, replace 

use data_tc, clear 
merge m:1 año using bblka
save consolidado_tc_inflacion, replace

clear all



use input\BD2_crypto, clear
*Precio de cierre = close
	gsort crypto datetime
	cap drop n 
		bys crypto: gen n = _n
	cap drop acum_close
		gen acum_close = close if n == 1
	replace acum_close = close[_n] + acum_close[_n-1] if n>1
	cap drop SMA
		bys crypto: gen SMA = (acum_close[_n] - acum_close[_n-20])/20 if n >= 20
		replace SMA = acum_close / 20 if n == 20
																				
	cap drop n_20
		gen n_20 = 1 if inrange(n,1,20)
		replace n_20=n_20[_n-20]+1 if n>=21
		
	cap drop sd
		bys crypto n_20: egen sd = sd(close)
																				
	br datetime crypto close n n_20 SMA sd
	
	cap drop upper_band
		gen upper_band = SMA + 2*sd
	
	cap drop lower_band
		gen lower_band = SMA - 2*sd
	
	cap drop CompraVenta
		gen CompraVenta = 1 if close < lower_band
		replace CompraVenta = 0 if close > upper_band
	
	lab def CompraVenta 0"Venta" 1"Compra" 
		lab value CompraVenta CompraVenta
	

		
		drop if CompraVenta == .
		cap drop compra
			gen compra = 1 if CompraVenta == 1
		cap drop venta
			gen venta = 0 if CompraVenta == 0
		collapse (count) frecuencia_compra = compra (count) frecuencia_venta = venta, by(crypto)
		
		keep if crypto == "AVAXUSDT" | crypto == "BNBUSDT" | crypto == "BTCUSDT" | crypto == "DOGEUSDT" | crypto == "ETHUSDT" | crypto == "SHIBUSDT"
		
		lab var frecuencia_compra "Compra"
		lab var frecuencia_venta "Venta"

	set scheme stcolor
		graph hbar (sum) frecuencia_compra frecuencia_venta, over(crypto) title("Scalping strategy") subtitle("Análisis Técnico: Bollinger Bands") legend(order(1 "Compra" 2 "Venta")) ytitle("Cantidad de recomendaciones en los últimos 30 días") note("Información con frecuencia de 5 minutos, Binance Exchange: https://api.binance.com") blabel(total, position(inside)) 
	
	


	use input\BD2_crypto, clear
*Precio de cierre = close
	gsort crypto datetime
	cap drop n 
		bys crypto: gen n = _n
	cap drop acum_close
		gen acum_close = close if n == 1
	replace acum_close = close[_n] + acum_close[_n-1] if n>1
	cap drop SMA
		bys crypto: gen SMA = (acum_close[_n] - acum_close[_n-20])/20 if n >= 20
		replace SMA = acum_close / 20 if n == 20
		
	cap drop n_20
		gen n_20 = 1 if inrange(n,1,20)
		replace n_20=n_20[_n-20]+1 if n>=21
		
	cap drop sd
		bys crypto n_20: egen sd = sd(close)
	
	br datetime crypto close n n_20 SMA sd
	

	cap drop upper_band
		gen upper_band = SMA + 2*sd
	
	cap drop lower_band
		gen lower_band = SMA - 2*sd
	
	cap drop CompraVenta
		gen CompraVenta = 1 if close < lower_band
		replace CompraVenta = 0 if close > upper_band
	
	lab def CompraVenta 0"Venta" 1"Compra" 
		lab value CompraVenta CompraVenta
		
	keep if crypto == "BTCUSDT"
	tw (line close datetime) (line upper_band datetime) (line lower_band datetime), legend(order(1 "Precio" 2 "Cota Superior" 3 "Cota Inferior")) xtitle("Fecha") ytitle("Precio") title("BTCUSDT- evolución") subtitle("Precio y Bollinger Bands") note("Información con frecuencia de 5 minutos, Binance Exchange: https://api.binance.com")
