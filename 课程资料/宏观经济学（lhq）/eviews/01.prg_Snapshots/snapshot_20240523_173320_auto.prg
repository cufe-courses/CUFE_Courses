create openm u 1 200
smpl 1 200

genr xrc=1
xrc.label(d) Exchange rate: units of RMB against 1 unit of dollar

genr xru=1/xrc
xru.label(d) Exchange rate: units of dollars against 1 unit of RMB

genr bccd=40
bccd.label(d) Bills issued by China acquired by Chinese: demand

genr bccs=bccd
bccs.label(d) Bills issued by China acquired by Chinese: supply

genr bcud=40
bcud.label(d) Bills issued by US acquired by Chinese: demand

genr bcus=bcud*xru
bcus.label(d) Bills issued by US acquired by Chinese: supply

genr bucd=40
bucd.label(d) Bills issued by China acquired by Americans: demand

genr bucs=bucd*xrc
bucs.label(d) Bills issued by China acquired by Americans: supply

genr buud=40
buud.label(d) Bills issued by US acquired by Americans: demand

genr buus=buud
buus.label(d) Bills issued by US acquired by Americans: supply

genr hmcd=20
hmcd.label(d) Demand for cash in China

genr hmcs=hmcd
hmcs.label(d) Supply for cash in China

genr hmud=20
hmud.label(d) Demand for cash in US

genr hmus=hmud
hmus.label(d) Supply for cash in US

genr gc=20
gc.label(d) Government expenditure in China

genr gu=20
gu.label(d) Government expenditure in US

genr tc=20
tc.label(d) Government tax in China

genr tu=20
tu.label(d) Government tax in US

genr thetac=0.2
thetac.label(d) Tax rate in China

genr thetau=thetac
thetau.label(d) Tax rate in US

genr cc=80
cc.label(d) Consumption in China

genr cu=80
cu.label(d) Consumption in US

genr yc=100
yc.label(d) Income in China

genr yu=100
yu.label(d) Income in US

genr ydc=80
ydc.label(d) Disposable income in China

genr ydu=80
ydu.label(d) Disposable income in US

genr xc=25
xc.label(d) Exports from China

genr imu=xc
imu.label(d) Import for US

genr xu=25
xu.label(d) Exports from US

genr imc=xu
imc.label(d) Import for China

genr vc=100
vc.label(d) Net financial assets of China

genr vu=100
vu.label(d) Net financial assets of US

genr rc=0.04
rc.label(d) Interest rate on China bills

genr ru=0.04
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
open1.append @identity bucs=bucs(-1)-d(bccs)-d(hmcs)+gc-tc
open1.append hmus=hmud
open1.append hmcs=hmcd
open1.append xru=bucd/bucs
open1.append @identity buus=buus(-1)-d(bcus)-d(hmus)+gu-tu
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
open1.append hmcd=vc-bccd-bucd
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

copy gu gu_base
smpl 5 200
gu=gu+1
smpl 1 200

open1.scenario "Scenario 1"
open1.solve

group chart1_g (yc_1/yc_0)*100 (yu_1/yu_0)*100
group chart2_g (xu_1-imu_1)-(xu_0-imu_0)(xrc_1/xrc_0-0.99)*6
group chart3_g (bcus_1/vc_1)/(bcus_0/vc_0)(bcud_1/vc_1)/(bcud_0/vc_0)

smpl 1 40

freeze(chart1) chart1_g.line
chart1.addtext(t) Shock to $ Govt. Expenditure
chart1.elem(1) legend(China Output)
chart1.elem(2) legend(US Output)

freeze(chart2) chart2_g.line
chart2.addtext(t) Shock to $ Govt. Expenditure
chart2.elem(1) legend(US Balance of Trade)
chart2.elem(2) legend(US Exchange Rate)

freeze(chart3) chart3_g.line
chart3.addtext(t) Shock to $ Govt. Expenditure
chart3.elem(1) legend(B ¥s as share of V ¥)
chart3.elem(2) legend(B ¥d as share of V ¥)
