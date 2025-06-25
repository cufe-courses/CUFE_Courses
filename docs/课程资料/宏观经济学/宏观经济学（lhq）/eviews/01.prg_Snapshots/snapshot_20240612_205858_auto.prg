create openm u 1 200
smpl 1 200

genr xrc=6.7347
xrc.label(d) Exchange rate: units of RMB against 1 unit of dollar

genr xru=1/xrc
xru.label(d) Exchange rate: units of dollar against 1 unit of RMB

genr bccd=270.6
bccd.label(d) Bills issued by China acquired by Chinese: demand

genr bccs=bccd
bccs.label(d) Bills issued by China acquired by Chinese: supply

genr bcud=81.6
bcud.label(d) Bills issued by US acquired by Chinese: demand

genr bcus=bcud*xru
bcus.label(d) Bills issued by US acquired by Chinese: supply

genr bucd=23.2
bucd.label(d) Bills issued by China acquired by American: demand

genr bucs=bucd*xrc
bucs.label(d) Bills issued by China acquired by American: supply

genr buud=51.2
buud.label(d) Bills issued by US acquired by American: demand

genr buus=buud
buus.label(d) Bills issued by US acquired by American: supply

genr bcb_cd=15.2
bcb_cd.label(d) Bills demand for China Central Bank

genr bcb_cs=bcb_cd
bcb_cs.label(d) Bills supply for China Central Bank

genr bcb_cud=165.1
bcb_cud.label(d) Bills issued by China acquired by US Central Bank: demand

genr bcb_cus=bcb_cud/xru
bcb_cus.label(d) Bills issued by China acquired by US Central Bank: supply

genr hmcd=11.5
hmcd.label(d) Demand for cash in China

genr hmcs=hmcd
hmcs.label(d) Supply for cash in China

genr hmud=23.2
hmud.label(d) Demand for cash in US

genr hmus=hmud
hmus.label(d) Supply for cash in US

genr gc=27.5
gc.label(d) Government expenditure in China

genr gu=9.6
gu.label(d) Government expenditure in US

genr tc=18.1
tc.label(d) Government tax in China

genr tu=41.0
tu.label(d) Government tax in US

genr thetac=0.1437
thetac.label(d) Tax rate in China

genr thetau=thetac
thetau.label(d) Tax rate in US

genr cc=45.0
cc.label(d) Consumption in China

genr cu=19.68
cu.label(d) Consumption in US

genr yc=126.1
yc.label(d) Income in China

genr yu=279.4
yu.label(d) Income in US

genr ydc=39.2
ydc.label(d) Disposable income in China

genr ydu=60.3
ydu.label(d) Disposable income in US

genr xc=23.8
xc.label(d) Exports from China

genr imu=xc
imu.label(d) Import for US

genr xu=25.8
xu.label(d) Exports from US

genr imc=xu
imc.label(d) Import for China

genr vc=34.5
vc.label(d) Net financial assets of China

genr vu=118.8
vu.label(d) Net financial assets of US

genr rc=0.014508
rc.label(d) Interest rate on China bills

genr ru=0.042
ru.label(d) Interest rate on US bills

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
open1.append bucd=vu*(lam0-lam1*ru+lam1*rc)
open1.append bccd=vc*(lam0+lam1*rc-lam1*ru)
open1.append bcud=vc*(lam0-lam1*rc+lam1*ru)
open1.append hmud=vu-buud-bucd
open1.append hmcd=vc-bccd-bcud

open1.append tu=thetau*yu
open1.append cu=a1*ydu+a2*vu(-1)
open1.append xu=imc*xru
open1.append log(imu)=mu0u+mu1u*log(yu)+mu2u*log(xru)

open1.append tc=thetac*yc
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
smpl 5 200
genr gov_spending_shock=1
gc=gc+gov_spending_shock
smpl 1 200
open1.solve

group chart1_g (yc_1/yc_0)*100 (yu_1/yu_0)*100
group chart2_g (xu_1-imu_1)-(xu_0-imu_0) (xc_1-imc_1)-(xc_0-imc_0) (xrc_1/xrc_0-0.99)
group chart3_g (hmcs_1/hmcs_0)*100 (bcb_cus_1/bcb_cus_0-hmcs_1/hmcs_0)*100 (bcb_cs_1/bcb_cs_0)*100

smpl 1 40

freeze(chart1) chart1_g.line
chart1.addtext(t) Shock to government expenditure
chart1.elem(1) legend(China output Scenario 1)
chart1.elem(2) legend(US output Scenario 1)

freeze(chart2) chart2_g.line
chart2.addtext(t) Shock to government expenditure
chart2.elem(1) legend(US balance of trade Scenario 1)
chart2.elem(2) legend(China balance of trade Scenario 1)
chart2.elem(3) legend(exchange rate Scenario 1)

freeze(chart3) chart3_g.line
chart3.addtext(t) Shock to government expenditure
chart3.elem(1) legend(Stock of money in China Scenario 1)
chart3.elem(2) legend(Foreign reserves of China central bank Scenario 1)
chart3.elem(3) legend(stock of China bills held by China central bank Scenario 1)


