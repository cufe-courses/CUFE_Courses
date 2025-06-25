create openm u 1 200
smpl 1 200

genr xrc=1
xrc.label(d) Exchange rate:units of rmb against 1 unit of dollar

genr xru=1/xrc
xru.label(d) exchange rate:units of dollar against 1 unit of rmb

genr bccd=100
bccd.label(d) bills issued by china acquired by chinese:demand

genr bccs=bccd
bccs.label(d) bills issued by china acquired by chinese:supply

genr bcud=40
bcud.label(d) bills issued by us acquired by chinese:demand

genr bcus=bcud*xru
bcus.label(d) bills issued by us acquired by chinese:supply

genr bucd=40
bucd.label(d) bills issued by china acquired by american:demand

genr bucs=bucd*xrc
bucs.label(d) bills issued by china acquired by american:supply

genr buud=40
buud.label(d) bills issued by us acquired by american:demand

genr buus=buud
buus.label(d) bills issued by us acquired by american:supply

genr bcb_cd=40
bcb_cd.label(d) Bills demand for china Central bank

genr bcb_cs=bcb_cd
bcb_cs.label(d) Bills supply for china Central bank

genr bcb_cud=40
bcb_cud.label(d) Bills issued by china acquired by us Central bank:demand

genr bcb_cus=bcb_cud/xru
bcb_cus.label(d) Bills issued by china acquired by us Central bank:supply


genr hmcd=20
hmcd.label(d) demand for cash of china

genr hmcs=hmcd
hmcs.label(d) supply for cash of china

genr hmud=20
hmud.label(d) demand for cash of us

genr hmus=hmud
hmus.label(d) supply for cash of us

genr gc=20
gc.label(d) gov expendi in china

genr gu=20
gu.label(d) gov expendi in us

genr tc=20
tc.label(d) gov tex in china

genr tu=20
tu.label(d) gov tex in us

genr thetac=0.2
thetac.label(d) tax rate in china

genr thetau=thetac
thetau.label(d) tax rate in us

genr cc=80
cc.label(d) consum in china

genr cu=80
cu.label(d) consum in us

genr yc=100
yc.label(d) income in china

genr yu=100
yu.label(d) income in us

genr ydc=80
ydc.label(d) disposable income in china

genr ydu=80
ydu.label(d) disposable income in us

genr xc=25
xc.label(d) exports from china

genr imu=xc
imu.label(d) import for us

genr xu=25
xu.label(d) exports from us

genr imc=xu
imc.label(d) import for china

genr vc=100
vc.label(d) net financial assets of china

genr vu=100
vc.label(d) net financial assets of us

genr rc=0.04
rc.label(d) interest rate on china bills

genr ru=0.04
ru.label(d)  interest rate on us bills


genr lam0=0.4
genr lam1=2
genr a1=0.8
genr a2=0.16
genr mu0u=-1.3863
genr mu1u=1
genr mu2u=0.2
genr mu0c=-1.3863
genr mu1c=1
genr mu2c=0.2

model open1

open1.append @identity xrc=1/xru

open1.append bcus=bcud*xru
open1.append bccs=bccd

open1.append d(bcb_cs)=gc-tc-d(bccs)-d(bucs)
open1.append d(bcb_cd)=d(hmcs)-d(bcb_cus)*xru-d(bcb_cud)

open1.append bcb_cud=bcb_cus+bcb_cs-bcb_cd

open1.append d(buus)=gu-tu-d(bcus)-d(bcb_cus)-d(hmus)

open1.append bcb_cus=bcb_cud/xru

open1.append hmus=hmud
open1.append hmcs=hmcd

open1.append yu=cu+gu+xu-imu
open1.append ydu=yu-tu+d(xru)*bucs(-1)
open1.append vu=vu(-1)+ydu-cu

open1.append yc=cc+gc+xc-imc
open1.append ydc=yc-tc+d(xrc)*bcus(-1)
open1.append vc=vc(-1)+ydc-cc

open1.append buud=vu*(lam0+lam1*ru-lam1*rc)
open1.append bucd=vu*(lam0-lam1*ru-lam1*rc)
open1.append bccd=vu*(lam0+lam1*rc+lam1*ru)
open1.append bcud=vu*(lam0-lam1*rc+lam1*ru)
open1.append hmud=vu-buud-bucd
open1.append hmcd=vc-bccd-bcud

open1.append tu=thetau*yu
open1.append cu=a1*ydu+a2*vu(-1)
open1.append xu=imc*xru
open1.append log(imu)=mu0u+mu1u*log(yu)+mu2u*log(xru)

open1.append tc=thetau*yc
open1.append cc=a1*ydc+a2*vc(-1)
open1.append xc=imu*xrc
open1.append log(imc)=mu0c+mu1c*log(yc)+mu2c*log(xrc)

open1.scenario "Baseline"
open1.solve

copy mu1u mu1u_base
smpl 5 200
mu1u=mu1u+0.2
smpl 1 200

open1.scenario "Scenario 1"
open1.solve

group chart1_g (yc_1/yc_0)*100 (yu_1/yu_0)*100
group chart2_g (xu_1-imu_1)-(xu_0-imu_0) (xc_1-imc_1)-(xc_0-imc_0) (xrc_1/xrc_0-0.99)
group chart3_g (hmcs_1/hmcs_0)*100 (bcb_cus_1/bcb_cus_0-hmcs_1/hmcs_0)*100 (bcb_cs_1/bcb_cs_0)*100

smpl 1 40

freeze(chart1) chart1_g.line
chart1.addtext(t) shock to us propensity to import
chart1.elem(1) legend(China output)
chart1.elem(2) legend(US output)

freeze(chart2) chart2_g.line
chart2.addtext(t) shock to us propensity to import
chart2.elem(1) legend(US balance of trade)
chart2.elem(2) legend(China balance of trade)
chart2.elem(3) legend(exchange rate)

freeze(chart3) chart3_g.line
chart3.addtext(t) shock to us propensity to import
chart3.elem(1) legend(Stock of money in china)
chart3.elem(2) legend(Foreign reserves of china central bank)
chart3.elem(3) legend(stock of china bills held by china central bank)


