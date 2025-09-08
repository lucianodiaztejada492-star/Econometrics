
//2.
//2.a 
//2.a.1
clear all
set seed 12345
set obs 1000

gen t = _n                      
tsset t                         

gen e1 = rnormal(0, 1)           

gen y1 = .                       
replace y1 = 0 in 1              

local rho = 0.5                 

forvalues i = 2/1000 {
    quietly replace y1 = `rho' * y1[_n-1] + e1 in `i'
}

gen e2 = rnormal(0, 1)           

gen y2 = .                       
replace y2 = 0 in 1              

local rho = 0.85                 

forvalues i = 2/1000 {
    quietly replace y2 = `rho' * y2[_n-1] + e2 in `i'
}

gen e3 = rnormal(0, 1)           

gen y3 = .                       
replace y3 = e3 in 1              

local rho = 0.994                

forvalues i = 2/1000 {
    quietly replace y3 = `rho' * y3[_n-1] + e3 in `i'
}

tsline y1
graph export "linea1.png", replace
tsline y2
graph export "linea2.png", replace
tsline y3
graph export "linea3.png", replace

//2.a.2: Aplicación del DF y el PP
dfuller y1, lags(21) 
dfuller y2, lags(21)
dfuller y3, lags(21) 

pperron y1, lags(21)
pperron y2, lags(21)
pperron y3, lags(21)

//2.a.3: Resolverla como siempre 

//2.b.1.
gen e4 = rnormal(0,1)
gen y4=.
replace y4 = 0 in 1
local rho = 0.985   
local thetha = 0.5    
forvalues i = 2/1000 {
    quietly replace y4 = `rho' * y4[_n-1] + `thetha'* e4[_n-1]+ e4 in `i'
	
}

tsline y4
graph export "linea4.png", replace

//2.b.2: nótese lo tradicional 
dfuller y4, lags(21)
pperron y4, lags(21)

//2.b.3: teoría en el Word

//2.c.1
gen e5=rnormal(0,1)
gen y5=.
replace y5 = 0 in 1

local rho = 0.5

forvalues i = 2/299 {
    quietly replace y5 = `rho' * y5[_n-1] + e5 in `i'
}

forvalues i = 300/1000 {
    quietly replace y5 = 4+ `rho' * y5[_n-1] + e5 in `i'
}

tsline y5

//2.c.2
dfuller y5, lags(21)
zandrews y5, maxlags(21) 

//2.c.3: La explicación, de nuevo, en el Word
