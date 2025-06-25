##############################################################################

# Empirical SFC macroeconomic model for Italy (1998-2026) using 'Bimets' package

# Authors: Rosa Canelli and Marco Veronese Passarella

# Last change: 9 May 2022

# Note: this R code reproduces the experiments discussed in: Canelli, R.,
# Fontana, G., Realfonzo, R. and Veronese Passarella, M. (2022) "Is the Italian
# government debt sustainable? Scenarios after the Covid-19 shock", Cambridge
# Journal of Economics. An early version of it was used to produce the
# simulations discussed in: Canelli, R., Fontana, G., Realfonzo, R. and Veronese
# Passarella, M. (2021) "Are EU Policies Effective to Tackle the Covid-19
# Crisis? The Case of Italy", Review of Political Economy.

# Instructions: just download the file and run/source it!

##############################################################################

#A) PREPARE THE ENVIRONMENT

#Clear environment
rm(list=ls(all=TRUE))

#Clear plots
if(!is.null(dev.list())) dev.off()

#Clear console
cat("\014")

#Upload libraries
library(mFilter)
library(bimets)
library(knitr)

#Upload data: time series for transactions-flow matrix and balance sheet
DataCJE <- read.csv("https://www.dropbox.com/s/xl6m4jmrirsdubp/cje_data.csv?dl=1") 
#Source: (our elaboration on) Eurostat data, December 2021

##############################################################################

#B) DEFINE MODEL EQUATIONS

S_model.txt="MODEL

COMMENT> FIRMS SECTOR

COMMENT> GDP
IDENTITY> y
EQ> y = cons + id + gov + nx                      

COMMENT> Target capital to output ratio
BEHAVIORAL> kappa
TSRANGE 1998 1 2019 1
EQ> kappa = kappa0 + kappa1*LAG(kappa,1)    
COEFF> kappa0 kappa1
STORE> coe(32)

COMMENT> Target capital stock (in real terms)
IDENTITY> kt
EQ> kt = kappa*y*100/p                      

COMMENT> Real investment 
BEHAVIORAL> idR
TSRANGE 1998 1 2019 1
EQ> idR = gamma1*TSLAG(y*100/p,1) + gamma2*(kt - k*100/p) + gamma3*(rl-rstar)*100     
COEFF> gamma1 gamma2 gamma3 
STORE> coe(1)

COMMENT> Nominal investment
IDENTITY> id
EQ> id = idR*p/100           

COMMENT> Capital stock (Note: delta=0, hence no depreciation)
IDENTITY> k
EQ> k = TSLAG(k,1) + id 

COMMENT> Firms' profit
IDENTITY> ff
EQ> ff = y - intf - wb

COMMENT> Interest payments on loans by firms
IDENTITY> intf
EQ> intf = rl*lf  

COMMENT> Interest rate on loans to firms
BEHAVIORAL> rl
TSRANGE 1998 1 2019 1
EQ> rl = rl0 + rl1*rstar + rl2*mub  
COEFF> rl0 rl1 rl2
STORE> coe(2)

COMMENT> Firms' undistributed profit
BEHAVIORAL> fuf
TSRANGE 1998 1 2019 1
EQ> fuf = theta*ff   
COEFF> theta
ERROR> AUTO(1)
STORE> coe(3)

COMMENT> Firms' distributed profit
IDENTITY> fdf
EQ> fdf = ff - fuf

COMMENT> Firms' demand for bank loans  
IDENTITY> lf
EQ> lf = TSLAG(lf,1) + id - fuf - (es-TSLAG(es,1))

COMMENT> Supply of shares  
IDENTITY> es
EQ> es = eh

COMMENT> Other payments or receipts received by firms (exogenous variable) 
BEHAVIORAL> opf
TSRANGE 1998 1 2019 1
EQ> opf = opf1*oaf
ERROR> AUTO(1)
COEFF> opf1
STORE> coe(38)

COMMENT> Total wealth accumulated by firms
IDENTITY> vf
EQ> vf = TSLAG(vf,1) + y - wb - intf - fdf + opf - id

COMMENT> Other financial assets held by firms
IDENTITY> oaf
EQ> oaf = vf + lf + es


COMMENT> HOUSEHOLD SECTOR

COMMENT> Disposable income  
IDENTITY> yd
EQ> yd = wb - tax + tr + inth + fdf + fb + oph

COMMENT> Other payments or receipts (exogenous variable)
BEHAVIORAL> oph
TSRANGE 1998 1 2019 1
EQ> oph = oph1*oah
ERROR> AUTO(1)
COEFF> oph1
STORE> coe(4)

COMMENT> Log of Real consumption 
BEHAVIORAL> LconsR
TSRANGE 1998 1 2019 1
EQ> LconsR = alpha1*(log(wb*100/p)) + alpha2*(log((yd-wb)*100/p)) + alpha3*log(TSLAG(nvh*100/p,1)) 
COEFF> alpha1 alpha2 alpha3
STORE> coe(5)

COMMENT> Real consumption
IDENTITY> consR
EQ> consR = exp(LconsR)

COMMENT> Nominal consumption
IDENTITY> cons
EQ> cons = consR*p/100

COMMENT> Net wealth of households - Note: yd = wb - tax + tr + inth + fdf + fb + oph    
IDENTITY> nvh
EQ> nvh = TSLAG(nvh,1) + yd - cons

COMMENT> Gross wealth of households  
IDENTITY> vh
EQ> vh = nvh + lh

COMMENT> Loans to households
BEHAVIORAL> lh
TSRANGE 1998 1 2019 1
EQ> TSDELTA(lh,1) = phi2*TSLAG(yd,1)  
COEFF> phi2
STORE> coe(6)

COMMENT> Interests paid by households on personal loans 
IDENTITY> intlh
EQ> intlh = rlh*lh  

COMMENT> Interests received by households on their government debt holdings 
IDENTITY> intgh
EQ> intgh = rb*bh

COMMENT> Net interest payments received by households 
IDENTITY> inth
EQ> inth = intgh - intlh

COMMENT> Interest rate on loans to households
BEHAVIORAL> rlh
TSRANGE 1998 1 2019 1
EQ> rlh = rlh0 + rlh1*rstar + rlh2*mub  
COEFF> rlh0 rlh1 rlh2
ERROR> AUTO(1)
STORE> coe(7)

COMMENT> Wage share (endogenous) 
IDENTITY> Omega
EQ> Omega = wb/y


COMMENT> BANKING SECTOR

COMMENT> Total loans  
IDENTITY> ls
EQ> ls = lf + lh

COMMENT> Supply of deposits  
IDENTITY> ms
EQ> ms = mh

COMMENT> Net interest payments received by banks on government bills
IDENTITY> intgb
EQ> intgb = rb*bb 

COMMENT> Banks profit (note: interest payments on advances and reserves are assumed = 0) 
IDENTITY> fb
EQ> fb = intf + intlh + intgb 

COMMENT> Stock of bills held by banks  
IDENTITY> bb
EQ> bb = bs - bcb - bcb_star - bh

COMMENT> Other payments or receipts received by banks (exogenous variable) 
BEHAVIORAL> opb
TSRANGE 1998 1 2019 1
EQ> opb = opb1*oab
ERROR> AUTO(1)
COEFF> opb1
STORE> coe(36)

COMMENT> Total wealth accumulated by banks     
IDENTITY> vb
EQ> vb = TSLAG(vb,1) + opb  

COMMENT> Other financial assets held by banks
IDENTITY> oab
EQ> oab = vb - hbs + ms - bb - ls


COMMENT> GOVERNMENT SECTOR

COMMENT> Government consumption net of loans and grants 
BEHAVIORAL> gov_net
TSRANGE 1998 1 2019 1
EQ> gov_net = sigma1*TSLAG(gov_net/p,1)*p
COEFF> sigma1
STORE> coe(12)

COMMENT> Tax revenue 
BEHAVIORAL> tax
TSRANGE 1998 1 2019 1
EQ> tax = tau1*wb + tau2*(yd - wb) + tau3*TSLAG(vh,1)
COEFF> tau1 tau2 tau3
STORE> coe(10)

COMMENT> Transfers and benefits 
BEHAVIORAL> tr
TSRANGE 1998 1 2019 1
EQ> tr = tau4*TSLAG(tr,1) + tau5*(ns-nd)
COEFF> tau4 tau5
STORE> coe(11)

COMMENT> Total government consumption, including loans and grants
IDENTITY> gov
EQ> gov = gov_net + loans + grants

COMMENT> Government deficit (based on consumption, taxes, transfers, interests, seigniorage and payments net of grants)
IDENTITY> def1
EQ> def1 = gov + tr + intg - tax - fcb - (grants - paym)

COMMENT> Goverment spending covered by loans from supranational institutions
BEHAVIORAL> loans
TSRANGE 1998 1 2019 1
EQ> loans = loans0
COEFF> loans0
STORE> coe(40)

COMMENT> Goverment spending covered by grants from supranational institutions
BEHAVIORAL> grants
TSRANGE 1998 1 2019 1
EQ> grants = grants0
COEFF> grants0
STORE> coe(41)

COMMENT> Payments to supranational institutions
BEHAVIORAL> paym
TSRANGE 1998 1 2019 1
EQ> paym = paym0
COEFF> paym0
STORE> coe(42)

COMMENT> Stock of loans from supranational institutions received by the government 
IDENTITY> deb_l
EQ> deb_l = TSLAG(deb_l,1) + loans 

COMMENT> Government debt stock
IDENTITY> deb
EQ> deb = bs + ogds 

COMMENT> Interest payments on government debt 
IDENTITY> intg
EQ> intg = deb*rb  

COMMENT> Additional entries of government balance
BEHAVIORAL> defa
TSRANGE 1998 1 2019 1
EQ> defa = defa0
ERROR> AUTO(1)
COEFF> defa0
STORE> coe(14)

COMMENT> Government deficit including additional entries
IDENTITY> def2
EQ> def2 = def1 + defa

COMMENT> Supply of government bills and bonds
IDENTITY> bs
EQ> bs = TSLAG(bs,1) + def2

COMMENT> Supply of additional goverment debt  
IDENTITY> ogds
EQ> ogds = ogdd 

COMMENT> Other payments or receipts by government (exogenous variable)
BEHAVIORAL> opg
TSRANGE 1998 1 2019 1
EQ> opg = opg0
COEFF> opg0
ERROR> AUTO(1)
STORE> coe(34)

COMMENT> Net wealth of goverment sector  (Note: negative value) 
IDENTITY> vg
EQ> vg = TSLAG(vg,1) - gov + tax - tr - intg + opg + fcb

COMMENT> Other financial assets held by government
IDENTITY> oag
EQ> oag = vg + bs + ogds


COMMENT> PORTFOLIO EQUATIONS

COMMENT> Holdings of shares (Note: rm = 0) 
BEHAVIORAL> eh
TSRANGE 1998 1 2019 1
EQ> eh = lambda10*vh + lambda11*rb*vh + lambda13*yd + lambda14*re*vh
COEFF> lambda10 lambda11 lambda13 lambda14 
STORE> coe(15)

COMMENT> Target holdings of government bills (Note: rm = 0) 
BEHAVIORAL> bh_star
TSRANGE 1998 1 2019 1
EQ> bh_star = lambda20*vh + lambda21*rb*vh + lambda23*yd + lambda24*re*vh
COEFF> lambda20 lambda21 lambda23 lambda24
STORE> coe(16)

COMMENT> Government bills held by households and other private agents
IDENTITY> bh
EQ> bh = bh_star

COMMENT> Holdings of cash
BEHAVIORAL> hh
TSRANGE 1998 1 2019 1
EQ> hh = lambdac*cons
ERROR> AUTO(1)
COEFF> lambdac
STORE> coe(17)

COMMENT> Holdings of deposits
IDENTITY> mh
EQ> mh = vh - hh - bh - eh - oah

COMMENT> Other assets
BEHAVIORAL> oah
TSRANGE 1998 1 2019 1
EQ> oah = lambdao*vh
ERROR>AUTO(1)
COEFF> lambdao
STORE> coe(18)


COMMENT> CENTRAL BANK

COMMENT> CB holdings of gov. securities
IDENTITY> bcb
EQ> bcb = lambdab*bs

COMMENT> Share of gov. securities purchased by CB
BEHAVIORAL> lambdab
TSRANGE 1998 1 2019 1
EQ> lambdab = lambdab1*bcb + lambdab2*LAG(lambdab,1)
COEFF> lambdab1 lambdab2
STORE> coe(31)

COMMENT> Extra purchases of gov. securities
BEHAVIORAL> bcb_star
TSRANGE 1998 1 2019 1
EQ> bcb_star = bcb_star0
COEFF> bcb_star0

COMMENT> Supply of cash
IDENTITY> hs
EQ> hs = -vcb + (bcb + bcb_star + oacb)

COMMENT> Other net assets held by central bank
IDENTITY> oacb
EQ> oacb = hh + hbs + vcb - bcb - bcb_star 

COMMENT> Profit realised and distributed by CB (note: interest payments on advances and reserves are assumed away) 
IDENTITY> fcb
EQ> fcb = intg - intgb - intgh 

COMMENT> Reserve requirement: demand 
IDENTITY> hbd
EQ> hbd = rho*ms

COMMENT> Total demand for cash and reserves 
IDENTITY> hd
EQ> hd = hbd + hh

COMMENT> Reserve requirement: supply
IDENTITY> hbs
EQ> hbs = hbd

COMMENT> Debt held by BoI, ECB, ESM and IMF
IDENTITY> debcb
EQ> debcb = deb*percb + bcb_star

COMMENT> Percentage of debt held by institutions above 
BEHAVIORAL> percb
TSRANGE 1998 1 2019 1
EQ> percb = percb1
COEFF> percb1
STORE> coe(35)

COMMENT> Other payments or receipts received by CB (exogenous variable) 
BEHAVIORAL> opcb
TSRANGE 1998 1 2019 1
EQ> opcb = opcb1*oacb
ERROR> AUTO(1)
COEFF> opcb1
STORE> coe(37)

COMMENT> Total wealth accumulated by central bank 
IDENTITY> vcb
EQ> vcb = TSLAG(vcb,1) + opcb


COMMENT> FOREIGN SECTOR

COMMENT> Gross import 
BEHAVIORAL> im
TSRANGE 1998 1 2019 1
EQ> im = m0 + m1*y
COEFF> m0 m1
STORE> coe(20)

COMMENT> Log of export
BEHAVIORAL> Lx
TSRANGE 1998 1 2019 1
EQ> Lx = x0 + x1*log(yf) +x2*log(prod)  
COEFF> x0 x1 x2 
STORE> coe(21)

COMMENT> Nominal export
IDENTITY> x
EQ> x = exp(Lx)

COMMENT> Foreign income
BEHAVIORAL> yf
TSRANGE 1998 1 2019 1
EQ> yf = yf1*TSLAG(yf,1) 
COEFF> yf1
STORE> coe(22)

COMMENT> Net export (trade balance)
IDENTITY> nx
EQ> nx = x - im

COMMENT> Additional stock of Italian goverment debt held by foreign agents
BEHAVIORAL> ogdd
TSRANGE 1998 1 2019 1
EQ> ogdd = lambdarow*vrow
COEFF> lambdarow
ERROR> AUTO(1)
STORE> coe(33)

COMMENT> Other payments or receipts received by RoW (including net received interest payments)
IDENTITY> oprow
EQ> oprow = -(opf + opb + opcb + oph + opg)

COMMENT> Total wealth accumulated by RoW 
IDENTITY> vrow
EQ> vrow = -(nvh+vf+vcb+vg+vb)

COMMENT> Other financial assets held by RoW 
IDENTITY> oarow
EQ> oarow = vrow - ogdd 


COMMENT> INTEREST RATES

COMMENT> Return rate on shares 
IDENTITY> re
EQ> re = fdf/eh

COMMENT> other interest rates either = 0 (ra, rh, rm) or already estimated (rl, rlh)

COMMENT> Policy rate
BEHAVIORAL> rstar
TSRANGE 1998 1 2019 1
EQ> rstar = r0 + r2*TSLAG(y,1)
COEFF> r0 r2
STORE> coe(25)

COMMENT> Return rate on government bills and other securities
BEHAVIORAL> rb
TSRANGE 1998 1 2019 1
EQ> rb = rb0 + rb1*rstar + rb2*(deb/y) + rb3*(bcb/bs)
COEFF> rb0 rb1 rb2 rb3
STORE> coe(39)

COMMENT> Aaverage risk premium on government bond
IDENTITY> mub
EQ> mub = rb - rstar


COMMENT> LABOUR MARKET

COMMENT> Wage bill
IDENTITY> wb
EQ> wb = w*nd
IF> ns>nd
IDENTITY> wb
EQ> wb = w*ns
IF> ns<nd

COMMENT> Labur productivity
BEHAVIORAL> prod
TSRANGE 1998 1 2019 1
EQ> prod = pr0 + pr1*TSLAG(y,1)
COEFF> pr0 pr1
STORE> coe(26)

COMMENT> Actual employment
BEHAVIORAL> nd
TSRANGE 1998 1 2019 1
EQ> nd = nu3 + nu4*y + nu5*w
ERROR> AUTO(1)
COEFF> nu3 nu4 nu5
STORE> coe(26)

COMMENT> Labour force
BEHAVIORAL> ns
TSRANGE 1998 1 2019 1
EQ> ns = nu1*TSLAG(ns,1) + nu2*(nd-TSLAG(ns,1))
COEFF> nu1 nu2
STORE> coe(27)

COMMENT> Wage rate growth (note: nun = 0; from 1998) 
BEHAVIORAL> gw
TSRANGE 1998 1 2019 1
EQ> gw = omega2*TSDELTA(un,1) + omega3*TSDELTAP(pc,1)
COEFF> omega2 omega3
STORE> coe(28)

COMMENT> Wage rate
IDENTITY> w
EQ> w = TSLAG(w,1)*(1+gw)

COMMENT> Unemployment rate
IDENTITY> un
EQ> un = 1-(nd/ns) 


COMMENT> CALCULATIONS

COMMENT> Government deficit net of seigniorage
IDENTITY> def0
EQ> def0 = def1 + fcb 

COMMENT> GDP growth rate
IDENTITY> gy
EQ> gy = (y-TSLAG(y,1))/TSLAG(y,1) 

COMMENT> consumption growth rate
IDENTITY> gc
EQ> gc = (cons/TSLAG(cons,1)) - 1 

COMMENT> Investment growth rate
IDENTITY> gid
EQ> gid = (id/TSLAG(id,1)) - 1 

COMMENT> Export growth rate
IDENTITY> gx
EQ> gx = (x/TSLAG(x,1)) - 1

COMMENT> Import growth rate
IDENTITY> gim
EQ> gim = (im/TSLAG(im,1)) - 1

COMMENT> Potential employment (if working hours were fixed; note: better calculated as: (y/p)/prod)
IDENTITY> nd_star
EQ> nd_star = y/prod

COMMENT> Max. interest rate implied by stability condition
IDENTITY> RR
EQ> RR = gy + (tax-tr-gov)/bs

COMMENT> Max. government spending implied by stability condition
IDENTITY> GG
EQ> GG = tax-tr-bs*(rb-gy)


COMMENT> PRODUCTION AND PRICES

COMMENT> Price level: GDP deflator 
BEHAVIORAL> p
TSRANGE 1998 1 2019 1
EQ> p = vi0 + vi1*TSLAG(p,1)
COEFF> vi0 vi1
STORE> coe(30)

COMMENT> Price level: CPI
BEHAVIORAL> pc
TSRANGE 1998 1 2019 1
EQ> pc = fi1*w + fi2*prod + fi3*TSLAG(p,1)
COEFF> fi1 fi2 fi3
STORE> coe(43)


END"


##############################################################################

#C) CALCULATE TARGET CAPITAL

#Deflate K 
kr = 100*DataCJE$K/DataCJE$P

#Take log of real capital
lk<-log(kr)

#Filter K log
lk.hp <- hpfilter(lk, freq=100, drift=FALSE)


##############################################################################

#D) LOAD THE MODEL AND ESTIMATE COEFFICIENTS

#Load the model
S_model=LOAD_MODEL(modelText = S_model.txt)

#Attribute values to model variables and coefficients
S_modelData=list(  
  y  = TIMESERIES(c(DataCJE$Y),   
                  START=c(1995,1),FREQ=1),
  cons  = TIMESERIES(c(DataCJE$CONS),   
                     START=c(1995,1),FREQ=1),
  id = TIMESERIES(c(DataCJE$INV),   
                  START=c(1995,1),FREQ=1),
  gov  = TIMESERIES(c(DataCJE$GOV),   
                    START=c(1995,1),FREQ=1),
  gov_net  = TIMESERIES(c(DataCJE$GOV),   
                        START=c(1995,1),FREQ=1),
  x  = TIMESERIES(c(DataCJE$X),   
                  START=c(1995,1),FREQ=1),
  Lx  = TIMESERIES(c(log(DataCJE$X)),   
                   START=c(1995,1),FREQ=1),
  im  = TIMESERIES(c(DataCJE$IM),   
                   START=c(1995,1),FREQ=1),
  consR  = TIMESERIES(c(DataCJE$CONS*100/DataCJE$P),   
                      START=c(1995,1),FREQ=1),
  LconsR  = TIMESERIES(c(log(DataCJE$CONS*100/DataCJE$P)),   
                       START=c(1995,1),FREQ=1),
  idR = TIMESERIES(c(DataCJE$INV*100/DataCJE$P),   
                   START=c(1995,1),FREQ=1),
  nx  = TIMESERIES(c(DataCJE$X-DataCJE$IM),   
                   START=c(1995,1),FREQ=1),
  wb  = TIMESERIES(c(DataCJE$WB),   
                   START=c(1995,1),FREQ=1),
  yd  = TIMESERIES(c(DataCJE$YD),   
                   START=c(1995,1),FREQ=1),
  nvh = TIMESERIES(c(DataCJE$NVh),   
                   START=c(1995,1),FREQ=1),
  vh  = TIMESERIES(c(DataCJE$NVh+(-DataCJE$Lh)),   
                   START=c(1995,1),FREQ=1),
  k  = TIMESERIES(c(DataCJE$K),   
                  START=c(1995,1),FREQ=1),
  intf = TIMESERIES(c(DataCJE$INTf),   
                    START=c(1995,1),FREQ=1),
  lf  = TIMESERIES(c(-DataCJE$Lf),   
                   START=c(1995,1),FREQ=1),
  fdf  = TIMESERIES(c(DataCJE$Fdf),   
                    START=c(1995,1),FREQ=1),
  ff  = TIMESERIES(c(DataCJE$Ff),   
                   START=c(1995,1),FREQ=1),
  fuf  = TIMESERIES(c(DataCJE$Fuf),   
                    START=c(1995,1),FREQ=1),
  es  = TIMESERIES(c(-DataCJE$Es),   
                   START=c(1995,1),FREQ=1),
  eh  = TIMESERIES(c(DataCJE$Eh),   
                   START=c(1995,1),FREQ=1),
  tax  = TIMESERIES(c(DataCJE$TAX),   
                    START=c(1995,1),FREQ=1),
  tr  = TIMESERIES(c(DataCJE$TR),   
                   START=c(1995,1),FREQ=1),
  lh  = TIMESERIES(c(-DataCJE$Lh),   
                   START=c(1995,1),FREQ=1),
  ls  = TIMESERIES(c(DataCJE$Ls),   
                   START=c(1995,1),FREQ=1),
  mh  = TIMESERIES(c(DataCJE$Mh),   
                   START=c(1995,1),FREQ=1),
  ms  = TIMESERIES(c(-DataCJE$Ms),   
                   START=c(1995,1),FREQ=1),
  inth  = TIMESERIES(c(DataCJE$INTh),   
                     START=c(1995,1),FREQ=1),
  un  = TIMESERIES(c(DataCJE$Un),   
                   START=c(1995,1),FREQ=1),
  Omega  = TIMESERIES(c(DataCJE$WB/DataCJE$Y),   
                      START=c(1995,1),FREQ=1),
  ns  = TIMESERIES(c(DataCJE$Ns),   
                   START=c(1995,1),FREQ=1),
  bs  = TIMESERIES(c(-DataCJE$Bs),   
                   START=c(1995,1),FREQ=1),
  intg = TIMESERIES(c(DataCJE$R_b*DataCJE$Deb),   
                     START=c(1995,1),FREQ=1),
  bh_star  = TIMESERIES(c(DataCJE$Bh),   
                        START=c(1995,1),FREQ=1),
  bh = TIMESERIES(c(DataCJE$Bh),   
                  START=c(1995,1),FREQ=1),
  rb = TIMESERIES(c(DataCJE$R_b),         
                  START=c(1995,1),FREQ=1),   
  fcb = TIMESERIES(c(DataCJE$Fcb),                       
                   START=c(1995,1),FREQ=1),
  re = TIMESERIES(c(DataCJE$Fdf/DataCJE$Eh),   
                  START=c(1995,1),FREQ=1),
  hh  = TIMESERIES(c(DataCJE$Hh),   
                   START=c(1995,1),FREQ=1),
  rho  = TIMESERIES(c(DataCJE$RHO),   
                    START=c(1995,1),FREQ=1),
  yf  = TIMESERIES(c(DataCJE$YRoW/1000),   
                   START=c(1995,1),FREQ=1),   
  fr  = TIMESERIES(c(DataCJE$FR),   
                   START=c(1995,1),FREQ=1),
  rstar  = TIMESERIES(c(DataCJE$R_star),   
                      START=c(1995,1),FREQ=1),
  mub  = TIMESERIES(c(DataCJE$R_b-DataCJE$R_star),   
                    START=c(1995,1),FREQ=1),
  deb  = TIMESERIES(c(DataCJE$Deb),   
                    START=c(1995,1),FREQ=1),
  ogdd  = TIMESERIES(c(DataCJE$OGD),   
                     START=c(1995,1),FREQ=1),
  ogds  = TIMESERIES(c(DataCJE$OGD),   
                     START=c(1995,1),FREQ=1),
  vg = TIMESERIES(c(DataCJE$Vg),   
                  START=c(1995,1),FREQ=1),
  def0  = TIMESERIES(c(DataCJE$DEF1+DataCJE$Fcb),   
                     START=c(1995,1),FREQ=1),
  def1  = TIMESERIES(c(DataCJE$DEF1),   
                     START=c(1995,1),FREQ=1),
  defa  = TIMESERIES(c(DataCJE$DEF2-DataCJE$DEF1),   
                     START=c(1995,1),FREQ=1),
  def2  = TIMESERIES(c(DataCJE$DEF2),   
                     START=c(1995,1),FREQ=1),
  nd  = TIMESERIES(c(DataCJE$Nd),   
                   START=c(1995,1),FREQ=1),
  w = TIMESERIES(c(DataCJE$w),   
                 START=c(1995,1),FREQ=1),
  gw = TIMESERIES(c(DataCJE$gw),   
                  START=c(1995,1),FREQ=1),
  bb = TIMESERIES(c(DataCJE$Bb),   
                  START=c(1995,1),FREQ=1),
  bcb = TIMESERIES(c(DataCJE$Bcb),   
                   START=c(1995,1),FREQ=1),
  bb_not = TIMESERIES(c(-DataCJE$Ms - DataCJE$Ls - DataCJE$HBd),                        
                      START=c(1995,1),FREQ=1),
  hbd = TIMESERIES(c(DataCJE$HBd),   
                   START=c(1995,1),FREQ=1),
  hbs = TIMESERIES(c(-DataCJE$HBs),   
                   START=c(1995,1),FREQ=1),
  hs = TIMESERIES(c(-DataCJE$Hs ),   
                  START=c(1995,1),FREQ=1),
  hd = TIMESERIES(c(-DataCJE$Hs),   
                  START=c(1995,1),FREQ=1),
  fb = TIMESERIES(c(DataCJE$Fb ), 
                  START=c(1995,1),FREQ=1),
  lambdab = TIMESERIES(c(-DataCJE$Bcb/DataCJE$Bs),   
                       START=c(1995,1),FREQ=1),
  pr = TIMESERIES(c(DataCJE$Y/DataCJE$Nd),   
                  START=c(1995,1),FREQ=1),
  oph = TIMESERIES(c(DataCJE$OPH),   
                   START=c(1995,1),FREQ=1),
  opb = TIMESERIES(c(DataCJE$OPB),
                   START=c(1995,1),FREQ=1),
  opcb = TIMESERIES(c(DataCJE$OPBC),   
                    START=c(1995,1),FREQ=1),
  opf = TIMESERIES(c(DataCJE$OPF),   
                   START=c(1995,1),FREQ=1),
  opg = TIMESERIES(c(DataCJE$OPG),   
                   START=c(1995,1),FREQ=1),
  oprow = TIMESERIES(c(DataCJE$OPROW),   
                     START=c(1995,1),FREQ=1),
  beta = TIMESERIES(c(DataCJE$Bb/(-DataCJE$Ms-DataCJE$Ls-DataCJE$HBd)),   
                    START=c(1995,1),FREQ=1),
  vb = TIMESERIES(c(DataCJE$Vb),                        
                  START=c(1995,1),FREQ=1),
  vf = TIMESERIES(c(DataCJE$Vf),   
                  START=c(1995,1),FREQ=1),
  vrow = TIMESERIES(c(DataCJE$Vrow),   
                    START=c(1995,1),FREQ=1),
  oah = TIMESERIES(c(DataCJE$OAh),   
                   START=c(1995,1),FREQ=1),
  oaf = TIMESERIES(c(DataCJE$OAf),   
                   START=c(1995,1),FREQ=1),
  oab = TIMESERIES(c(DataCJE$OAb),   
                   START=c(1995,1),FREQ=1),
  oag = TIMESERIES(c(DataCJE$OAg),   
                   START=c(1995,1),FREQ=1),
  oacb = TIMESERIES(c(DataCJE$OAcb),   
                    START=c(1995,1),FREQ=1),
  oarow = TIMESERIES(c(DataCJE$OAROW),   
                     START=c(1995,1),FREQ=1),
  vcb = TIMESERIES(c(DataCJE$Vcb),   
                   START=c(1995,1),FREQ=1),
  kt = TIMESERIES(c(exp(lk.hp$trend)),   
                  START=c(1995,1),FREQ=1),
  kappa = TIMESERIES(c(exp(lk.hp$trend)*DataCJE$P/(DataCJE$Y*100)),   
                     START=c(1995,1),FREQ=1),
  p = TIMESERIES(c(DataCJE$P),   
                 START=c(1995,1),FREQ=1),
  prod = TIMESERIES(c(DataCJE$Prod),   
                    START=c(1995,1),FREQ=1),
  gy = TIMESERIES(c(DataCJE$gy),   
                  START=c(1995,1),FREQ=1),
  gc = TIMESERIES(c(DataCJE$gc),   
                  START=c(1995,1),FREQ=1),
  gid = TIMESERIES(c(DataCJE$gid),   
                   START=c(1995,1),FREQ=1),
  gx = TIMESERIES(c(DataCJE$gx),   
                  START=c(1995,1),FREQ=1),
  gim = TIMESERIES(c(DataCJE$gim),   
                   START=c(1995,1),FREQ=1),
  nd_star = TIMESERIES(c(DataCJE$Nd),   
                       START=c(1995,1),FREQ=1),
  rl = TIMESERIES(c(-DataCJE$INTf/DataCJE$Lf),   
                  START=c(1995,1),FREQ=1),
  intgb  = TIMESERIES(c(DataCJE$INTgb),   
                      START=c(1995,1),FREQ=1),        
  intgh = TIMESERIES(c(DataCJE$R_b*DataCJE$Bh),   
                      START=c(1995,1),FREQ=1),            
  intlh = TIMESERIES(-c(((DataCJE$R_b*DataCJE$Bh)-DataCJE$INTh)),   
                     START=c(1995,1),FREQ=1),           
  rlh = TIMESERIES(c(((DataCJE$R_b*DataCJE$Bh)-DataCJE$INTh)/DataCJE$Lh),   
                   START=c(1995,1),FREQ=1),               
  pi = TIMESERIES(c(DataCJE$Pi),   
                  START=c(1995,1),FREQ=1),
  pf = TIMESERIES(c(DataCJE$PF),   
                  START=c(1995,1),FREQ=1),
  RR = TIMESERIES(c( DataCJE$gy+(DataCJE$TAX-DataCJE$GOV-DataCJE$TR)/(-DataCJE$Bs) ),   
                  START=c(1995,1),FREQ=1),
  GG = TIMESERIES(c( DataCJE$TAX-DataCJE$TR-(-DataCJE$Bs)*(DataCJE$R_b -DataCJE$gy) ),   
                  START=c(1995,1),FREQ=1),
  percb = TIMESERIES(c(DataCJE$PercB),   
                     START=c(1995,1),FREQ=1),
  debcb = TIMESERIES(c(DataCJE$PercB*DataCJE$Deb),   
                     START=c(1995,1),FREQ=1),
  bcb_star = TIMESERIES(c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),   
                        START=c(1995,1),FREQ=1),
  loans = TIMESERIES(c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),   
                     START=c(1995,1),FREQ=1),
  deb_l = TIMESERIES(c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),   
                     START=c(1995,1),FREQ=1),
  grants = TIMESERIES(c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),   
                      START=c(1995,1),FREQ=1),
  paym  = TIMESERIES(c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),   
                     START=c(1995,1),FREQ=1),
  pc = TIMESERIES(c(DataCJE$P2),   
                  START=c(1995,1),FREQ=1)
  )

#Load the data into the model
S_model=LOAD_MODEL_DATA(S_model,S_modelData)

#Estimate model coefficients
S_model=ESTIMATE(S_model
                 ,TSRANGE=c(1998,1,2019,1)
                 ,forceTSRANGE = TRUE
)

##############################################################################

#E) RUN AND SAVE IN-SAMPLE PREDICTIONS

# Define exogenization list
exogenizeList <- list(
  rstar = TRUE,
  defa = TRUE,
  percb = TRUE,
  oph = TRUE,
  vb = TRUE,
  opf = TRUE,
  opcb = TRUE,
  opg = TRUE,
  oprow = TRUE,
  loans = TRUE
)

# In-sample prediction (no add factors)
S_model <- SIMULATE(S_model
                    ,simType='STATIC'
                    ,TSRANGE=c(1997,1,2020,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=100
                    ,Exogenize=exogenizeList)

#Save selected pre-baseline values with no add factors
y_00 = S_model$simulation$y
yd_00 = S_model$simulation$yd
cons_00 = S_model$simulation$cons
id_00 = S_model$simulation$id
gov_00 = S_model$simulation$gov
x_00 = S_model$simulation$x
im_00 = S_model$simulation$im
def2_00 = S_model$simulation$def2
def1_00 = S_model$simulation$def1
def0_00 = S_model$simulation$def0
deb_00 = S_model$simulation$deb
debcb_00 = S_model$simulation$debcb
tax_00 = S_model$simulation$tax
tr_00 = S_model$simulation$tr
intg_00 = S_model$simulation$intg
fcb_00 = S_model$simulation$fcb
gy_00 = S_model$simulation$gy
gc_00 = S_model$simulation$gc
gid_00 = S_model$simulation$gid
gx_00 = S_model$simulation$gx
gim_00 = S_model$simulation$gim
bcb_00 = S_model$simulation$bcb + S_model$simulation$bcb_star
bs_00 = S_model$simulation$bs
un_00 = S_model$simulation$un
rb_00 = S_model$simulation$rb
p_00 = S_model$simulation$p
pi_00 = (S_model$simulation$p - TSLAG(S_model$simulation$p,1))/TSLAG(S_model$simulation$p,1)
pc_00 = S_model$simulation$pc
pic_00 = (S_model$simulation$pc - TSLAG(S_model$simulation$pc,1))/TSLAG(S_model$simulation$pc,1)
lambdab_00 = S_model$simulation$lambdab
yf_00 = S_model$simulation$yf
ns_00 = S_model$simulation$ns
nd_00 = S_model$simulation$nd
fr_00 = S_model$simulation$fr
hh_00 = S_model$simulation$hh
hs_00 = S_model$simulation$hs
hbs_00 = S_model$simulation$hbs
loans_00 = S_model$simulation$loans
grants_00 = S_model$simulation$grants
paym_00 = S_model$simulation$paym
rl_00 = S_model$simulation$rl
RR_00 = S_model$simulation$RR
GG_00 = S_model$simulation$GG
nd_00 = S_model$simulation$nd

##############################################################################

#F) FORECAST SERIES USING IN-SAMPLE ADJUSTMENT (ADD FACTORS)

# Extend exogenous and conditionally evaluated variables up to 2026
S_model$modelData <- within(S_model$modelData,{
  rho  = TSEXTEND(rho,  UPTO=c(2026,1))
  wb = TSEXTEND(wb,  UPTO=c(2026,1))
  beta = TSEXTEND(beta,  UPTO=c(2026,1))
  pf = TSEXTEND(pf,  UPTO=c(2026,1))
  hd = TSEXTEND(hd,  UPTO=c(2026,1))
})

# Define exogenization list to 2019
exogenizeList <- list(
  
  #Adjusted variables in 1996-2019
  LconsR = c(1996,1,2019,1),
  idR = c(1996,1,2019,1),
  x = c(1996,1,2019,1),
  im  = c(1996,1,2019,1),
  k = c(1996,1,2019,1),
  intf = c(1996,1,2019,1),
  fuf = c(1996,1,2019,1),
  ff = c(1996,1,2019,1),
  lh = c(1996,1,2019,1),
  inth = c(1996,1,2019,1),
  tax = c(1996,1,2019,1),
  tr = c(1996,1,2019,1),
  intg = c(1996,1,2019,1),
  eh = c(1996,1,2019,1),
  bh_star = c(1996,1,2019,1),
  hh = c(1996,1,2019,1),
  oah = c(1996,1,2019,1),
  yf = c(1996,1,2019,1),
  rb = c(1996,1,2019,1),
  nd = c(1996,1,2019,1),
  ns = c(1996,1,2019,1),
  nd_star = c(1996,1,2019,1),
  gw = c(1996,1,2019,1),
  p = c(1996,1,2019,1),
  pc = c(1996,1,2019,1),
  prod = c(1996,1,2019,1),
  w = c(1996,1,2019,1),
  deb = c(1996,1,2019,1),
  def2 = c(1996,1,2019,1),
  def1 = c(1996,1,2019,1),
  rl = c(1996,1,2019,1),
  rlh = c(1996,1,2019,1),
  def0 = c(1996,1,2019,1),
  fcb = c(1996,1,2019,1),
  lf = c(1996,1,2019,1),
  bb = c(1996,1,2019,1),
  bcb_star = c(1996,1,2019,1),
  nvh = c(1996,1,2019,1),
  ogdd = c(1996,1,2019,1),
  defa = c(1996,1,2019,1),
  lambdab = c(1996,1,2019,1),
  oph = c(1996,1,2019,1),
  vb = c(1996,1,2019,1),
  opf = c(1996,1,2019,1),
  oprow = c(1996,1,2019,1),
  opcb = c(1996,1,2019,1),
  opg = c(1996,1,2019,1),
  kappa = c(1996,1,2019,1),
  loans = c(1996,1,2019,1),
  
  #Adjusted variables in the whole period
  gov_net = c(1996,1,2019,1), 
  bcb = TRUE,
  rstar = TRUE,
  percb = TRUE
)

# Simulate model
S_model <- SIMULATE(S_model
                    ,simType='DYNAMIC'
                    ,TSRANGE=c(1996,1,2026,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=100
                    ,Exogenize=exogenizeList
                    ,quietly=TRUE)

#Save selected pre-baseline values
y_0 = S_model$simulation$y
yd_0 = S_model$simulation$yd
cons_0 = S_model$simulation$cons
id_0 = S_model$simulation$id
gov_0 = S_model$simulation$gov
x_0 = S_model$simulation$x
im_0 = S_model$simulation$im
def2_0 = S_model$simulation$def2
def1_0 = S_model$simulation$def1
def0_0 = S_model$simulation$def0
deb_0 = S_model$simulation$deb
debcb_0 = S_model$simulation$debcb
tax_0 = S_model$simulation$tax
tr_0 = S_model$simulation$tr
intg_0 = S_model$simulation$intg
fcb_0 = S_model$simulation$fcb
gy_0 = S_model$simulation$gy
gc_0 = S_model$simulation$gc
gid_0 = S_model$simulation$gid
gx_0 = S_model$simulation$gx
gim_0 = S_model$simulation$gim
bcb_0 = S_model$simulation$bcb + S_model$simulation$bcb_star
bs_0 = S_model$simulation$bs
un_0 = S_model$simulation$un
rb_0 = S_model$simulation$rb
p_0 = S_model$simulation$p
pi_0 = (S_model$simulation$p - TSLAG(S_model$simulation$p,1))/TSLAG(S_model$simulation$p,1)
pc_0 = S_model$simulation$pc
pic_0 = (S_model$simulation$pc - TSLAG(S_model$simulation$pc,1))/TSLAG(S_model$simulation$pc,1)
lambdab_0 = S_model$simulation$lambdab
yf_0 = S_model$simulation$yf
ns_0 = S_model$simulation$ns
nd_0 = S_model$simulation$nd
fr_0 = S_model$simulation$fr
hh_0 = S_model$simulation$hh
hs_0 = S_model$simulation$hs
hbs_0 = S_model$simulation$hbs
loans_0 = S_model$simulation$loans
grants_0 = S_model$simulation$grants
paym_0 = S_model$simulation$paym
rl_0 = S_model$simulation$rl
RR_0 = S_model$simulation$RR
GG_0 = S_model$simulation$GG
nd_0 = S_model$simulation$nd

##############################################################################

#G) ADD SHOCKS / SCENARIOS

#Re-define exogenization list up to 2020
exogenizeList <- list(
  
  #Adjusted variables in 1996-2020  #真实值，2020之后是预测值
  LconsR = c(1996,1,2020,1),
  idR = c(1996,1,2020,1),
  x = c(1996,1,2020,1),
  im  = c(1996,1,2020,1),
  k = c(1996,1,2020,1),
  intf = c(1996,1,2020,1),
  fuf = c(1996,1,2020,1),
  ff = c(1996,1,2020,1),
  lh = c(1996,1,2020,1),
  inth = c(1996,1,2020,1),
  tax = c(1996,1,2020,1),
  tr = c(1996,1,2020,1),
  intg = c(1996,1,2020,1),
  eh = c(1996,1,2020,1),
  bh_star = c(1996,1,2020,1),
  hh = c(1996,1,2020,1),
  oah = c(1996,1,2020,1),
  yf = c(1996,1,2020,1),
  rb = c(1996,1,2020,1), 
  nd = c(1996,1,2020,1),
  ns = c(1996,1,2020,1),
  nd_star = c(1996,1,2020,1),
  gw = c(1996,1,2020,1),
  p = c(1996,1,2020,1),
  pc = c(1996,1,2020,1),
  prod = c(1996,1,2020,1),
  w = c(1996,1,2020,1),
  deb = c(1996,1,2020,1),
  def2 = c(1996,1,2020,1),
  def1 = c(1996,1,2020,1),
  rl = c(1996,1,2020,1),
  rlh = c(1996,1,2020,1),
  def0 = c(1996,1,2020,1),
  fcb = c(1996,1,2020,1),
  lf = c(1996,1,2020,1),
  bb = c(1996,1,2020,1),
  bcb_star = c(1996,1,2020,1),
  nvh = c(1996,1,2020,1),
  ogdd = c(1996,1,2020,1),
  defa = c(1996,1,2020,1),
  lambdab = c(1996,1,2020,1),
  oph = c(1996,1,2020,1),
  opb = c(1996,1,2020,1),
  opf = c(1996,1,2020,1),
  oprow = c(1996,1,2020,1),
  opcb = c(1996,1,2020,1),
  opg = c(1996,1,2020,1),
  kappa = c(1996,1,2020,1),
  loans = c(1996,1,2020,1),
  
  #Adjusted variables in the whole period
  gov_net = c(1996,1,2020,1), 
  bcb = TRUE,
  rstar = TRUE,
  percb = TRUE
)

###########################

#SCENARIO 1
#New baseline including recovery fund (black) 

# Define add-factor list (defining shock)
constantAdjList <- list(
  
  cons = TIMESERIES(-36000,-41000,-58000,-58000,-58000,-58000,START=c(2021,1), FREQ='A'),
  rb = TIMESERIES(-0.005,-0.005,-0.005,-0.005,-0.005,-0.005,START=c(2021,1), FREQ='A'),
  tax = TIMESERIES(-50000,-40000,-10000,-10000,-10000,-10000,START=c(2021,1), FREQ='A'),
  loans = TIMESERIES((10938+6800)*0.7,(0+12700)*0.7,16200*0.7,29400*0.7,30100*0.7,25800*0.7,START=c(2021,1), FREQ='A'), #Notes: SURE + NGEU loans; it is assumed that 70% are used as additional resources
  grants = TIMESERIES((10900+3000)*0.7,(19100+6000)*0.7,(26500+6800)*0.7,(13400+6200)*0.7,(8300+5500)*0.7,(4300+3200)*0.7,START=c(2021,1), FREQ='A'), #Notes: grants + national resources; it is assumed that 70% are used as additional resources 
  paym = TIMESERIES(6230+(10938+6800)*0.3,10930+(0+12700)*0.3,15160+16200*0.3,7660+29400*0.3,4750+30100*0.3,2460+25800*0.3,START=c(2021,1), FREQ='A'), #Notes: due contribution for grants + 30% loans
  bcb_star = TIMESERIES((143308),(143308+37543),(143308+37543),(143308+37543),(143308+37543),(143308+37543),START=c(2021,1), FREQ='A')  # Notes: PEPP. Stock variable
)

# Simulate the model (following shock)
S_model <- SIMULATE(S_model
                    ,simType='DYNAMIC'
                    ,TSRANGE=c(1998,1,2026,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=100
                    ,Exogenize=exogenizeList
                    ,ConstantAdjustment=constantAdjList
                    ,quietly=TRUE)

# Save variables under experiment
y_1 = S_model$simulation$y
yd_1 = S_model$simulation$yd
wb_1 = S_model$simulation$wb
cons_1 = S_model$simulation$cons
id_1 = S_model$simulation$id
gov_1 = S_model$simulation$gov
gov_net_1 = S_model$simulation$gov_net
x_1 = S_model$simulation$x
im_1 = S_model$simulation$im
def2_1 = S_model$simulation$def2
def1_1 = S_model$simulation$def1
def0_1 = S_model$simulation$def0
deb_1 = S_model$simulation$deb
debcb_1 = S_model$simulation$debcb
tax_1 = S_model$simulation$tax
tr_1 = S_model$simulation$tr
intg_1 = S_model$simulation$intg
fcb_1 = S_model$simulation$fcb
gy_1 = S_model$simulation$gy
gc_1 = S_model$simulation$gc
gid_1 = S_model$simulation$gid
gx_1 = S_model$simulation$gx
gim_1 = S_model$simulation$gim
bcb_1 = S_model$simulation$bcb + S_model$simulation$bcb_star
bs_1 = S_model$simulation$bs
un_1 = S_model$simulation$un
rb_1 = S_model$simulation$rb
p_1 = S_model$simulation$p
pi_1 = (S_model$simulation$p - TSLAG(S_model$simulation$p,1))/TSLAG(S_model$simulation$p,1)
pc_1 = S_model$simulation$pc
pic_1 = (S_model$simulation$pc - TSLAG(S_model$simulation$pc,1))/TSLAG(S_model$simulation$pc,1)
lambdab_1 = S_model$simulation$lambdab
yf_1 = S_model$simulation$yf
ns_1 = S_model$simulation$ns
nd_1 = S_model$simulation$nd
fr_1 = S_model$simulation$fr
hh_1 = S_model$simulation$hh
hs_1 = S_model$simulation$hs
hbs_1 = S_model$simulation$hbs
loans_1 = S_model$simulation$loans
grants_1 = S_model$simulation$grants
paym_1 = S_model$simulation$paym
rl_1 = S_model$simulation$rl
RR_1 = S_model$simulation$RR
GG_1 = S_model$simulation$GG
nd_1 = S_model$simulation$nd

################################################################################

#CREATE TFM AND BS MATRICES FOR SCENARIO 1

#Choose a year. Note: 1 = 1998, 29 = 2026.
yr=23

##############################

#Create BS

#Create row names for BS matrix
rownames<-c( "Cash and reserves",
             "Deposits",
             "Securities",
             "Loans",
             "Shares",
             "Other securities",
             "Other net FA",
             "Net financial wealth",
             "[Fixed capital]",
             "Column total")

#Create firms aggregates
Firms        <-c( 0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  round(-S_model$simulation$lf[yr], digits = 0),                                                                    
                  round(-S_model$simulation$es[yr], digits = 0),                                                                     
                  0,
                  round(S_model$simulation$oaf[yr], digits = 0),                                                                     
                  round(S_model$simulation$vf[yr], digits = 0),                                                                    
                  paste("[",round(S_model$simulation$k[yr], digits = 0),"]"),
                  round(-S_model$simulation$lf[yr]-S_model$simulation$es[yr]+S_model$simulation$oaf[yr]-S_model$simulation$vf[yr], digits = 0)
)                                                                    

#Create table of results
FirmDataBS<-as.data.frame(Firms,row.names=rownames)

#Create banks aggregates
Banks        <-c( round(S_model$simulation$hbd[yr], digits = 0),                                                                    
                  -round(S_model$simulation$ms[yr], digits = 0),                                                                    
                  round(S_model$simulation$bb[yr], digits = 0),                                                                    
                  round(S_model$simulation$ls[yr], digits = 0),                                                                    
                  0,                                                                     
                  0,
                  round(S_model$simulation$oab[yr], digits = 0),                                                                     
                  round(S_model$simulation$vb[yr], digits = 0),
                  0,
                  round(S_model$simulation$hbd[yr]-S_model$simulation$ms[yr]+S_model$simulation$bb[yr]+S_model$simulation$ls[yr]+S_model$simulation$oab[yr]-S_model$simulation$vb[yr], digits = 0)
)                                                                    

#Create table of results
BankDataBS<-as.data.frame(Banks,row.names=rownames)

#Create ECB aggregates
ECB          <-c( -round(S_model$simulation$hs[yr], digits = 0),                                                                    
                  0,                                                                    
                  round(S_model$simulation$bcb[yr]+S_model$simulation$bcb_star[yr], digits = 0),                                                                    
                  0,                                                                    
                  0,                                                                     
                  0,
                  round(S_model$simulation$oacb[yr], digits = 0),                                                                     
                  round(S_model$simulation$vcb[yr], digits = 0),
                  0,
                  round(-S_model$simulation$hs[yr]+S_model$simulation$bcb[yr]+S_model$simulation$bcb_star[yr]+S_model$simulation$oacb[yr]-S_model$simulation$vcb[yr], digits = 0)
)                                                                    

#Create table of results
ECBDataBS<-as.data.frame(ECB,row.names=rownames)

#Create government aggregates
Government    <-c(0,                                                                    
                  0,                                                                    
                  round(-S_model$simulation$bs[yr], digits = 0),                                                                    
                  0,                                                                    
                  0,                                                                     
                  round(-S_model$simulation$ogds[yr], digits = 0),
                  round(S_model$simulation$oag[yr], digits = 0),
                  round(S_model$simulation$vg[yr], digits = 0),
                  0,
                  round(-S_model$simulation$bs[yr]+S_model$simulation$oag[yr]-S_model$simulation$ogds[yr]-S_model$simulation$vg[yr], digits = 0)
)                                                                    

#Create table of results
GovDataBS<-as.data.frame(Government,row.names=rownames)

#Create household aggregates
Households    <-c(round(S_model$simulation$hh[yr], digits = 0),                                                                    
                  round(S_model$simulation$mh[yr], digits = 0),                                                                    
                  round(S_model$simulation$bh[yr], digits = 0),                                                                    
                  round(-S_model$simulation$lh[yr], digits = 0),                                                                    
                  round(S_model$simulation$eh[yr], digits = 0),                                                                     
                  0,
                  round(S_model$simulation$oah[yr], digits = 0),
                  round(S_model$simulation$nvh[yr], digits = 0),
                  0,
                  round(S_model$simulation$hh[yr]+S_model$simulation$mh[yr]+S_model$simulation$bh[yr]-S_model$simulation$lh[yr]+S_model$simulation$eh[yr]+S_model$simulation$oah[yr]-S_model$simulation$nvh[yr], digits = 0)
)                                                                    

#Create table of results
HouseDataBS<-as.data.frame(Households,row.names=rownames)

#Create foreign sector aggregates
Foreign      <-c( 0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                     
                  round(S_model$simulation$ogdd[yr], digits = 0),  
                  round(S_model$simulation$oarow[yr], digits = 0),                                                                     
                  round(S_model$simulation$vrow[yr], digits = 0),
                  0,
                  round(S_model$simulation$ogdd[yr]+S_model$simulation$oarow[yr]-S_model$simulation$vrow[yr], digits = 0)
)                                                                    

#Create table of results
ROWDataBS<-as.data.frame(Foreign,row.names=rownames)

#Create row total (when entries > 2)
Total        <-c( round(S_model$simulation$hh[yr]+S_model$simulation$hbs[yr]-S_model$simulation$hs[yr], digits = 0),                                                                    
                  0,                                                                    
                  round(S_model$simulation$bh[yr]+S_model$simulation$bb[yr]+S_model$simulation$bcb[yr]+S_model$simulation$bcb_star[yr]-S_model$simulation$bs[yr], digits = 0),                                                                   
                  round(-S_model$simulation$lf[yr]-S_model$simulation$lh[yr]+S_model$simulation$ls[yr], digits = 0),                                                                    
                  0,                                                                     
                  0,  
                  round(S_model$simulation$oaf[yr]+S_model$simulation$oab[yr]+S_model$simulation$oacb[yr]+S_model$simulation$oag[yr]+S_model$simulation$oah[yr]+S_model$simulation$oarow[yr], digits = 0),                                                                     
                  round(S_model$simulation$vf[yr]+S_model$simulation$vb[yr]+S_model$simulation$vcb[yr]+S_model$simulation$vg[yr]+S_model$simulation$nvh[yr]+S_model$simulation$vrow[yr], digits = 0),
                  0,
                  paste("-")
)                                                                    

#Create table of results
TotalDataBS<-as.data.frame(Total,row.names=rownames)

#Create BS matrix
Italy_BS_Matrix<-cbind(FirmDataBS,BankDataBS,ECBDataBS,GovDataBS,HouseDataBS,ROWDataBS,TotalDataBS)
kable(Italy_BS_Matrix)

##############################

#Create TFM

#Create row names for TFM matrix
rownames<-c( "Consumption",
             "Investment",
             "Government spending",
             "Export",
             "Import",
             "[GDP]",
             "Taxes",
             "Transfers",
             "Wages",
             "Interest payments",
             "Dividends",
             "Distributed bank profit",
             "Distributed CB profit",
             "Other payments",
             "Change in net wealth",
             "Column total")

#Create firms aggregates
Firms        <-c( round(S_model$simulation$cons[yr], digits = 0),                                                                    
                  paste("[",round(S_model$simulation$id[yr], digits = 0),"]"),                                                                    
                  round(S_model$simulation$gov[yr], digits = 0),                                                                    
                  round(S_model$simulation$x[yr], digits = 0),                                                                    
                  round(-S_model$simulation$im[yr], digits = 0),                                                                    
                  paste("[",round(S_model$simulation$cons[yr]+S_model$simulation$id[yr]+S_model$simulation$gov[yr]+S_model$simulation$x[yr]-S_model$simulation$im[yr], digits = 0),"]"),                                                                 
                  0,                                                                    
                  0,                                                                    
                  round(-S_model$simulation$wb[yr], digits = 0),                                                                     
                  round(-S_model$simulation$intf[yr], digits = 0),                                                                     
                  round(-S_model$simulation$fdf[yr], digits = 0),                                                                    
                  0,                                                                    
                  0,
                  round(S_model$simulation$opf[yr], digits = 0),
                  round(S_model$simulation$vf[yr]-S_model$simulation$vf[yr-1], digits = 0),
                  paste(round(S_model$simulation$y[yr]-S_model$simulation$id[yr]-S_model$simulation$wb[yr]-S_model$simulation$intf[yr]-S_model$simulation$fdf[yr]+S_model$simulation$opf[yr]-(S_model$simulation$vf[yr]-S_model$simulation$vf[yr-1]), digits = 0))
                  )                                                                    

#Create table of results
FirmData<-as.data.frame(Firms,row.names=rownames)

#Create banks aggregates
Banks        <-c( 0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                 
                  0,                                                                    
                  0,                                                                    
                  0,                                                                     
                  round(S_model$simulation$fb[yr], digits = 0),                                                                     
                  0,                                                                    
                  round(-S_model$simulation$fb[yr], digits = 0),                                                                    
                  0,
                  round(S_model$simulation$opb[yr], digits = 0),
                  round(S_model$simulation$vb[yr]-S_model$simulation$vb[yr-1], digits = 0),
                  paste(round(S_model$simulation$opb[yr]-(S_model$simulation$vb[yr]-S_model$simulation$vb[yr-1]), digits = 0))
)                                                                    

#Create table of results
BankData<-as.data.frame(Banks,row.names=rownames)

#Create ECB aggregates
ECB          <-c( 0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                 
                  0,                                                                    
                  0,                                                                    
                  0,                                                                     
                  round(S_model$simulation$fcb[yr], digits = 0),                                                                     
                  0,                                                                    
                  0,                                                          
                  round(-S_model$simulation$fcb[yr], digits = 0),
                  round(S_model$simulation$opcb[yr], digits = 0),
                  round(S_model$simulation$vcb[yr]-S_model$simulation$vcb[yr-1], digits = 0),
                  paste(round(S_model$simulation$opcb[yr]-(S_model$simulation$vcb[yr]-S_model$simulation$vcb[yr-1]), digits = 0))
)                                                                    

#Create table of results
CBData<-as.data.frame(ECB,row.names=rownames)

#Create government aggregates
Government   <-c( 0,                                                                    
                  0,                                                                    
                  round(-S_model$simulation$gov[yr], digits = 0),                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                 
                  round(S_model$simulation$tax[yr], digits = 0),                                                                    
                  round(-S_model$simulation$tr[yr], digits = 0),                                                                    
                  0,                                                                     
                  round(-S_model$simulation$intg[yr], digits = 0),                                                                     
                  0,                                                                    
                  0,                                                          
                  round(S_model$simulation$fcb[yr], digits = 0),
                  round(S_model$simulation$opg[yr], digits = 0),
                  round(S_model$simulation$vg[yr]-S_model$simulation$vg[yr-1], digits = 0),
                  paste(round(-S_model$simulation$gov[yr]+S_model$simulation$tax[yr]-S_model$simulation$tr[yr]-S_model$simulation$intg[yr]+S_model$simulation$fcb[yr]+S_model$simulation$opg[yr]-(S_model$simulation$vg[yr]-S_model$simulation$vg[yr-1]), digits = 0))
)                                                                    

#Create table of results
GovData<-as.data.frame(Government,row.names=rownames)

#Create households aggregates
Households   <-c( round(-S_model$simulation$cons[yr], digits = 0),                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                 
                  round(-S_model$simulation$tax[yr], digits = 0),                                                                    
                  round(S_model$simulation$tr[yr], digits = 0),                                                                    
                  round(S_model$simulation$wb[yr], digits = 0),                                                                     
                  round(S_model$simulation$inth[yr], digits = 0),                                                                     
                  round(S_model$simulation$fdf[yr], digits = 0),                                                                    
                  round(S_model$simulation$fb[yr], digits = 0),                                                          
                  0,
                  round(S_model$simulation$oph[yr], digits = 0),
                  round(S_model$simulation$nvh[yr]-S_model$simulation$nvh[yr-1], digits = 0),
                  paste(round(-S_model$simulation$cons[yr]-S_model$simulation$tax[yr]+S_model$simulation$tr[yr]+S_model$simulation$wb[yr]+S_model$simulation$inth[yr]+S_model$simulation$fdf[yr]+S_model$simulation$fb[yr]+S_model$simulation$oph[yr]-(S_model$simulation$nvh[yr]-S_model$simulation$nvh[yr-1]), digits = 0))
)                                                                    

#Create table of results
HouseData<-as.data.frame(Households,row.names=rownames)

#Create Foreign sector aggregates
Foreign      <-c( 0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  round(-S_model$simulation$x[yr], digits = 0),                                                                    
                  round(S_model$simulation$im[yr], digits = 0),                                                                       
                  0,                                                                 
                  0,                                                                    
                  0,                                                                    
                  0,                                                                     
                  0,                                                                     
                  0,                                                                    
                  0,                                                          
                  0,
                  round(S_model$simulation$oprow[yr], digits = 0),
                  round(S_model$simulation$vrow[yr]-S_model$simulation$vrow[yr-1], digits = 0),
                  paste(round(-S_model$simulation$x[yr]+S_model$simulation$im[yr]+S_model$simulation$oprow[yr]-(S_model$simulation$vrow[yr]-S_model$simulation$vrow[yr-1]), digits = 0))
                  )                                                                    

#Create table of results
ROWData<-as.data.frame(Foreign,row.names=rownames)

#Create row total (when entries > 2)
Total        <-c( 0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                    
                  0,                                                                       
                  0,                                                                 
                  0,                                                                    
                  0,                                                                    
                  0,                                                                     
                  round((-S_model$simulation$intf[yr]+S_model$simulation$fb[yr]+S_model$simulation$fcb[yr]-S_model$simulation$intg[yr]+S_model$simulation$inth[yr]), digits = 0),                                                                     
                  0,                                                                    
                  0,                                                          
                  0,
                  round((S_model$simulation$opf[yr]+S_model$simulation$opb[yr]+S_model$simulation$opcb[yr]+S_model$simulation$opg[yr]+S_model$simulation$oph[yr]+S_model$simulation$oprow[yr]), digits = 0),
                  round((S_model$simulation$vf[yr]+S_model$simulation$vb[yr]+S_model$simulation$vcb[yr]+S_model$simulation$vg[yr]+S_model$simulation$nvh[yr]+S_model$simulation$vrow[yr]-(S_model$simulation$vf[yr-1]+S_model$simulation$vb[yr-1]+S_model$simulation$vcb[yr-1]+S_model$simulation$vg[yr-1]+S_model$simulation$nvh[yr-1]+S_model$simulation$vrow[yr-1])), digits = 0),
                  paste("-")
                  )                                                                    

#Create table of results
TotalData<-as.data.frame(Total,row.names=rownames)

#Create TFM matrix
Italy_TFM_Matrix<-cbind(FirmData,BankData,CBData,GovData,HouseData,ROWData,TotalData)
kable(Italy_TFM_Matrix)

################################################################################

#SCENARIO 2
#No intervention scenario (turquoise) 

# Define add-factor list (defining shock)
constantAdjList <- list(
  
  cons = TIMESERIES(-36000,-41000,-58000,-58000,-58000,-58000,START=c(2021,1), FREQ='A'),
  tax = TIMESERIES(-50000,-40000,-10000,-10000,-10000,-10000,START=c(2021,1), FREQ='A')
  
)

# Simulate the model (following shock)
S_model <- SIMULATE(S_model
                    ,simType='DYNAMIC'
                    ,TSRANGE=c(1998,1,2026,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=100
                    ,Exogenize=exogenizeList
                    ,ConstantAdjustment=constantAdjList
                    ,quietly=TRUE)

# Save variables under experiment 1bis
y_2 = S_model$simulation$y
yd_2 = S_model$simulation$yd
cons_2 = S_model$simulation$cons
id_2 = S_model$simulation$id
gov_2 = S_model$simulation$gov
x_2 = S_model$simulation$x
im_2 = S_model$simulation$im
def2_2 = S_model$simulation$def2
def1_2 = S_model$simulation$def1
def0_2 = S_model$simulation$def0
deb_2 = S_model$simulation$deb
debcb_2 = S_model$simulation$debcb
tax_2 = S_model$simulation$tax
tr_2 = S_model$simulation$tr
intg_2 = S_model$simulation$intg
fcb_2 = S_model$simulation$fcb
gy_2 = S_model$simulation$gy
gc_2 = S_model$simulation$gc
gid_2 = S_model$simulation$gid
gx_2 = S_model$simulation$gx
gim_2 = S_model$simulation$gim
bcb_2 = S_model$simulation$bcb + S_model$simulation$bcb_star
bs_2 = S_model$simulation$bs
un_2 = S_model$simulation$un
rb_2 = S_model$simulation$rb
p_2 = S_model$simulation$p
pi_2 = (S_model$simulation$p - TSLAG(S_model$simulation$p,1))/TSLAG(S_model$simulation$p,1)
pc_2 = S_model$simulation$pc
pic_2 = (S_model$simulation$pc - TSLAG(S_model$simulation$pc,1))/TSLAG(S_model$simulation$pc,1)
lambdab_2 = S_model$simulation$lambdab
yf_2 = S_model$simulation$yf
ns_2 = S_model$simulation$ns
nd_2 = S_model$simulation$nd
fr_2 = S_model$simulation$fr
hh_2 = S_model$simulation$hh
hs_2 = S_model$simulation$hs
hbs_2 = S_model$simulation$hbs
loans_2 = S_model$simulation$loans
grants_2 = S_model$simulation$grants
paym_2 = S_model$simulation$paym
rl_2 = S_model$simulation$rl
RR_2 = S_model$simulation$RR
GG_2 = S_model$simulation$GG
nd_2 = S_model$simulation$nd

###########################

#SCENARIO 3
#Mild austerity (yellow): -5% government spending

# Define add-factor list (defining shock)
constantAdjList <- list(
  
  cons = TIMESERIES(-36000,-41000,-58000,-58000,-58000,-58000,START=c(2021,1), FREQ='A'),
  rb = TIMESERIES(-0.005,-0.005,-0.005,-0.005,-0.005,-0.005,START=c(2021,1), FREQ='A'),
  tax = TIMESERIES(-50000,-40000,-10000,-10000,-10000,-10000,START=c(2021,1), FREQ='A'),
  gov = TIMESERIES(-0.05*1794935,-0.05*1794935,-0.05*1794935,-0.05*1794935,-0.05*1794935,-0.05*1794935,START=c(2021,1), FREQ='A'),
  loans = TIMESERIES((10938+6800)*0.7,(0+12700)*0.7,16200*0.7,29400*0.7,30100*0.7,25800*0.7,START=c(2021,1), FREQ='A'), 
  grants = TIMESERIES((10900+3000)*0.7,(19100+6000)*0.7,(26500+6800)*0.7,(13400+6200)*0.7,(8300+5500)*0.7,(4300+3200)*0.7,START=c(2021,1), FREQ='A'),  
  paym = TIMESERIES(6230+(10938+6800)*0.3,10930+(0+12700)*0.3,15160+16200*0.3,7660+29400*0.3,4750+30100*0.3,2460+25800*0.3,START=c(2021,1), FREQ='A'), 
  bcb_star = TIMESERIES((143308),(143308+37543),(143308+37543),(143308+37543),(143308+37543),(143308+37543),START=c(2021,1), FREQ='A')  
)

# Simulate the model (following shock)
S_model <- SIMULATE(S_model
                    ,simType='DYNAMIC'
                    ,TSRANGE=c(1998,1,2026,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=100
                    ,Exogenize=exogenizeList
                    ,ConstantAdjustment=constantAdjList
                    ,quietly=TRUE)

# Save variables under experiment 1bis
y_3 = S_model$simulation$y
yd_3 = S_model$simulation$yd
cons_3 = S_model$simulation$cons
id_3 = S_model$simulation$id
gov_3 = S_model$simulation$gov
x_3 = S_model$simulation$x
im_3 = S_model$simulation$im
def2_3 = S_model$simulation$def2
def1_3 = S_model$simulation$def1
def0_3 = S_model$simulation$def0
deb_3 = S_model$simulation$deb
debcb_3 = S_model$simulation$debcb
tax_3 = S_model$simulation$tax
tr_3 = S_model$simulation$tr
intg_3 = S_model$simulation$intg
fcb_3 = S_model$simulation$fcb
gy_3 = S_model$simulation$gy
gc_3 = S_model$simulation$gc
gid_3 = S_model$simulation$gid
gx_3 = S_model$simulation$gx
gim_3 = S_model$simulation$gim
bcb_3 = S_model$simulation$bcb + S_model$simulation$bcb_star
bs_3 = S_model$simulation$bs
un_3 = S_model$simulation$un
rb_3 = S_model$simulation$rb
p_3 = S_model$simulation$p
pi_3 = (S_model$simulation$p - TSLAG(S_model$simulation$p,1))/TSLAG(S_model$simulation$p,1)
pc_3 = S_model$simulation$pc
pic_3 = (S_model$simulation$pc - TSLAG(S_model$simulation$pc,1))/TSLAG(S_model$simulation$pc,1)
lambdab_3 = S_model$simulation$lambdab
yf_3 = S_model$simulation$yf
ns_3 = S_model$simulation$ns
nd_3 = S_model$simulation$nd
fr_3 = S_model$simulation$fr
hh_3 = S_model$simulation$hh
hs_3 = S_model$simulation$hs
hbs_3 = S_model$simulation$hbs
loans_3 = S_model$simulation$loans
grants_3 = S_model$simulation$grants
paym_3 = S_model$simulation$paym
rl_3 = S_model$simulation$rl
RR_3 = S_model$simulation$RR
GG_3 = S_model$simulation$GG
nd_3 = S_model$simulation$nd

###########################

#SCENARIO 4
#Strong austerity (tomato): -10% government spending

# Define add-factor list (defining shock)
constantAdjList <- list(
  
  cons = TIMESERIES(-36000,-41000,-58000,-58000,-58000,-58000,START=c(2021,1), FREQ='A'),
  rb = TIMESERIES(-0.005,-0.005,-0.005,-0.005,-0.005,-0.005,START=c(2021,1), FREQ='A'),
  tax = TIMESERIES(-50000,-40000,-10000,-10000,-10000,-10000,START=c(2021,1), FREQ='A'),
  gov = TIMESERIES(-0.1*1794935,-0.1*1794935,-0.1*1794935,-0.1*1794935,-0.1*1794935,-0.1*1794935,-0.1*1794935,START=c(2021,1), FREQ='A'),
  loans = TIMESERIES((10938+6800)*0.7,(0+12700)*0.7,16200*0.7,29400*0.7,30100*0.7,25800*0.7,START=c(2021,1), FREQ='A'), #SURE+ NGEU loans
  grants = TIMESERIES((10900+3000)*0.7,(19100+6000)*0.7,(26500+6800)*0.7,(13400+6200)*0.7,(8300+5500)*0.7,(4300+3200)*0.7,START=c(2021,1), FREQ='A'),  
  paym = TIMESERIES(6230+(10938+6800)*0.3,10930+(0+12700)*0.3,15160+16200*0.3,7660+29400*0.3,4750+30100*0.3,2460+25800*0.3,START=c(2021,1), FREQ='A'), 
  bcb_star = TIMESERIES((143308),(143308+37543),(143308+37543),(143308+37543),(143308+37543),(143308+37543),START=c(2021,1), FREQ='A')  
)

# Simulate the model (following shock)
S_model <- SIMULATE(S_model
                    ,simType='DYNAMIC'
                    ,TSRANGE=c(1998,1,2026,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=100
                    ,Exogenize=exogenizeList
                    ,ConstantAdjustment=constantAdjList
                    ,quietly=TRUE)

# Save variables under experiment 1bis
y_4 = S_model$simulation$y
yd_4 = S_model$simulation$yd
cons_4 = S_model$simulation$cons
id_4 = S_model$simulation$id
gov_4 = S_model$simulation$gov
x_4 = S_model$simulation$x
im_4 = S_model$simulation$im
def2_4 = S_model$simulation$def2
def1_4 = S_model$simulation$def1
def0_4 = S_model$simulation$def0
deb_4 = S_model$simulation$deb
debcb_4 = S_model$simulation$debcb
tax_4 = S_model$simulation$tax
tr_4 = S_model$simulation$tr
intg_4 = S_model$simulation$intg
fcb_4 = S_model$simulation$fcb
gy_4 = S_model$simulation$gy
gc_4 = S_model$simulation$gc
gid_4 = S_model$simulation$gid
gx_4 = S_model$simulation$gx
gim_4 = S_model$simulation$gim
bcb_4 = S_model$simulation$bcb + S_model$simulation$bcb_star
bs_4 = S_model$simulation$bs
un_4 = S_model$simulation$un
rb_4 = S_model$simulation$rb
p_4 = S_model$simulation$p
pi_4 = (S_model$simulation$p - TSLAG(S_model$simulation$p,1))/TSLAG(S_model$simulation$p,1)
pc_4 = S_model$simulation$pc
pic_4 = (S_model$simulation$pc - TSLAG(S_model$simulation$pc,1))/TSLAG(S_model$simulation$pc,1)
lambdab_4 = S_model$simulation$lambdab
yf_4 = S_model$simulation$yf
ns_4 = S_model$simulation$ns
nd_4 = S_model$simulation$nd
fr_4 = S_model$simulation$fr
hh_4 = S_model$simulation$hh
hs_4 = S_model$simulation$hs
hbs_4 = S_model$simulation$hbs
loans_4 = S_model$simulation$loans
grants_4 = S_model$simulation$grants
paym_4 = S_model$simulation$paym
rl_4 = S_model$simulation$rl
RR_4 = S_model$simulation$RR
GG_4 = S_model$simulation$GG
nd_4 = S_model$simulation$nd

##############################################################################

#H) PLOT (SELECTED) FINDINGS

#Create custom color
mycol3 <- rgb(107,39,169, max = 255, alpha = 10, names = "mypurple")

# FIGURE 1
layout(matrix(c(1,2,3,4,5,6), 3, 2, byrow = TRUE))

# Show predicted GDP growth rate after shock (with RF)
gyr_1 = ((100*y_1/p_1) - TSLAG(100*y_1/p_1,1))/TSLAG(100*y_1/p_1,1)
gyr_0 = ((100*y_0/p_0) - TSLAG(100*y_0/p_0,1))/TSLAG(100*y_0/p_0,1)
plot(100*(gyr_1),col=2,lty=1,lwd=2,font.main=1,cex.main=1,main="Fig. 1(a)  Real growth rate after shock",ylab = '%',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1996,2026),ylim=range(-11,7))
lines(100*(gyr_0),col=1,lty=2,lwd=2)
lines(100*(S_modelData$gy-S_modelData$pi),col=1,lty=1,lwd=2)
rect(xleft=2019,xright=2022,ybottom=-30,ytop=50,col=mycol3,border=NA)
rect(xleft=2019,xright=2025,ybottom=-30,ytop=50,col=mycol3,border=NA)
rect(xleft=2019,xright=2031,ybottom=-30,ytop=50,col=mycol3,border=NA)
abline(h=0,col="gray60")
abline(h=-8.94,col="purple1",lty=2)
abline(h=6.1,col="purple1",lty=2)
text(1998,-8,"-8.9%",cex =1,col="purple1")
text(2015,7,"6.1%",cex =1,col="purple1")
legend("left",c("Observed","Pre-shock forecast","Post-shock forecast"),  bty = "n", cex=1, lty=c(1,2,1), lwd=c(2,2,2), col = c(1,1,2), box.lty=0)

# Show predicted government debt to GDP ratio after shock (with RF)
plot(100*deb_1/y_1,col=2,lty=1,lwd=2,font.main=1,cex.main=1,main="Fig. 1(b)  Government debt to GDP ratio after shock",ylab = '%',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1996,2026),ylim=range(90,165))
lines(100*deb_0/y_0,col=1,lty=2,lwd=2)
lines(100*S_modelData$deb/S_modelData$y,col=1,lty=1,lwd=2)
rect(xleft=2019,xright=2022,ybottom=0,ytop=250,col=mycol3,border=NA)
rect(xleft=2019,xright=2025,ybottom=0,ytop=250,col=mycol3,border=NA)
rect(xleft=2019,xright=2031,ybottom=0,ytop=250,col=mycol3,border=NA)
abline(h=103.9,col="purple1",lty=2)
abline(h=155.6,col="purple1",lty=2)
text(2015,152,"155.6%",cex =1,col="purple1")
text(2015,107,"103.9%",cex =1,col="purple1")
legend("left",c("Observed","Pre-shock forecast","Post-shock forecast"),  bty = "n", cex=1, lty=c(1,2,1), lwd=c(2,2,2), col = c(1,1,2), box.lty=0)

#Debt sustainability condition
plot(100*(-def0_1+intg_1)/y_1,col="gray25",lty=1,lwd=2,font.main=1,cex.main=1,main="Fig. 2  Debt sustainability condition",ylab = '% of GDP',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1999,2026),ylim=range(-10,22))
lines(100*(rb_1-gy_1)*bs_1/y_1, type="l", lty = 1, lwd = 2, col="turquoise")
abline(h=0,col="gray60")
abline(v=2020,col="gray60")
legend("topleft",c("Primary balance", "Net change in interest burden"),  bty = "n", cex=1, lty=c(1,1), lwd=c(2,2), col = c("gray25","turquoise"), box.lty=0)

#GDP under alternative scenarios
plot(y_3*100/p_3,col="orange",lty=5,lwd=2,font.main=1,cex.main=1,main="Fig. 3(a)  Real GDP after shock",ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(2019,2026),ylim=range(min(y_4*100/p_4),max(y_0*100/p_0)))
lines(y_0*100/p_0,col=1,lty=3,lwd=2)
lines(y_2*100/p_2,col="turquoise",lty=2,lwd=2)
lines(y_4*100/p_4,col="tomato",lty=4,lwd=2)
lines(y_1*100/p_1,col=1,lty=1,lwd=2)
legend("bottomright",c("Pre-shock forecast","Baseline","Mild austerity","Strong austerity","No intervention"), cex=1, lty=c(3,1,5,4,2), lwd=c(2,2,2,2,2), col = c(1,1,"orange","tomato","turquoise"), box.lty=0)

#Government debt under alternative scenarios
plot(100*deb_3/y_3,col="orange",lty=3,lwd=2,font.main=1,cex.main=1,main="Fig. 3(b)  Gov. debt to GDP ratio after shock",ylab = '%',xlab = '', cex.axis=1,cex.lab=1,xlim=range(2019,2026),ylim=range(120,max(100*deb_4/y_4)))
lines(100*deb_0/y_0,col=1,lty=3,lwd=2)
lines(100*deb_2/y_2,col="turquoise",lty=2,lwd=2)
lines(100*deb_4/y_4,col="tomato",lty=4,lwd=2)
lines(100*deb_1/y_1,col=1,lty=1,lwd=2)
legend("bottomright",c("Pre-shock forecast","Baseline","Mild austerity","Strong austerity","No intervention"),  cex=1, lty=c(3,1,5,4,2), lwd=c(2,2,2,2,2), col = c(1,1,"orange","tomato","turquoise"), box.lty=0,bg="white")

#Maximum sustainable average interest rate vs. actual average interest rate on Italian debt
plot(100*RR_1,col="red1",lty=2,lwd=2,font.main=1,cex.main=1,main="Fig. 4  Max. sustain. average interest rate",ylab = '%',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2026),ylim=range(min(100*RR_1),max(100*RR_1)))
abline(h=0,col="gray60")
abline(h=2.5,col="gray60")
abline(h=5,col="gray60")
abline(v=2020,col="gray60")
lines(100*rb_1,col=1,lty=1,lwd=2)
legend("bottomleft",c("Max rate","Actual"),  bty = "n", cex=1, lty=c(2,1), lwd=c(2,2), col = c("red1",1), box.lty=0)
