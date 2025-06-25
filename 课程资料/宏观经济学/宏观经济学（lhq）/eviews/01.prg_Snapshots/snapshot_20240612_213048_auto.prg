create openm u 1 200
smpl 1 200

genr xrc=7.24
genr xru=1/xrc

genr bccd=280
genr bccs=bccd

genr bcud=83.2
genr bcus=bcud*xru

genr bucd=24.1
genr bucs=bucd*xrc

genr buud=53
genr buus=buud

genr bcb_cd=17.4
genr bcb_cs=bcb_cd

genr bcb_cud=170.2
genr bcb_cus=bcb_cud/xru

genr hmcd=10.5
genr hmcs=hmcd

genr hmud=24.0
genr hmus=hmud

genr gc=28
genr gu=9.2

genr tc=17.7
genr tu=42.0

genr thetac=0.1437
genr thetau=thetac

genr cc=45.0
genr cu=19.68

genr yc=127.3
genr yu=294.6

genr ydc=110
genr ydu=252.6

genr xc=23.8
genr imu=xc

genr xu=25.9
genr imc=xu

genr vc=64.5
genr vu=118.8

genr rc=0.014508
genr ru=0.042

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
chart1.addtext(t) shock to government expenditure
chart1.elem(1) legend(China output)
chart1.elem(2) legend(US output)

freeze(chart2) chart2_g.line
chart2.addtext(t) shock to government expenditure
chart2.elem(1) legend(US balance of trade)
chart2.elem(2) legend(China balance of trade)
chart2.elem(3) legend(exchange rate)

freeze(chart3) chart3_g.line
chart3.addtext(t) shock to government expenditure
chart3.elem(1) legend(Stock of money in china)
chart3.elem(2) legend(Foreign reserves of china central bank)
chart3.elem(3) legend(stock of china bills held by china central bank)
