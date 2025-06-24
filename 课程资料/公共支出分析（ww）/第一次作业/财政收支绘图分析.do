sort id year 




//支出占比混合图'
drop if year<2007
gr tw ///
    (bar 投资性支出 year if id==1, bcolor(gs15) yaxis(2) ytitle("支出/亿元", axis(2))) ///
    (line 投资性支出占比 year if id==1, lcolor(black) yaxis(1) ytitle("占比%") xtitle("年份") xlabel(2007(1)2021, angle(45))), ///
    name(g0, replace)legend(order(1 "投资性支出" 2 "投资性支出占比"))
gr tw ///
    (bar 消费性支出 year if id==1, bcolor(gs15) yaxis(2) ytitle("支出/亿元", axis(2))) ///
    (line 消费性支出占比 year if id==1, lcolor(black) yaxis(1) ytitle("占比%") xtitle("年份") xlabel(2007(1)2021, angle(45))), ///
    name(g1, replace)legend(order(1 "消费性支出" 2 "消费性支出占总比"))
gr tw ///
    (bar 转移性支出 year if id==1, bcolor(gs15) yaxis(2) ytitle("支出/亿元", axis(2))) ///
    (line 转移性支出占比 year if id==1, lcolor(black) yaxis(1) ytitle("占比%") xtitle("年份") xlabel(2007(1)2021, angle(45))), ///
    name(g2, replace)legend(order(1 "转移性支出" 2 "转移性支出占比"))note("数据来源: CEIC")
gr combine g0 g1 g2 ,note("数据来源: CEIC")
	
	
//支出占比对比图
gr tw ///
    (line 支出同比增长率 year if id==1,  yaxis(1) ytitle("增长率%") xtitle("年份") xlabel(2001(3)2021, angle(45))) ///
	(line 支出同比增长率 year if id==3,  yaxis(1) ytitle("增长率%") xtitle("年份") xlabel(2001(3)2021, angle(45))), ///
    name(g0, replace)legend(order(1 "上海市" 2 "全国" )) title("支出同比增长率折线图")
gr tw ///
    (line 支出边际倾向 year if id==1,  yaxis(1) ytitle("系数/1") xtitle("年份") xlabel(2001(3)2021, angle(45))) ///
	(line 支出边际倾向 year if id==3,  yaxis(1) ytitle("系数/1") xtitle("年份") xlabel(2001(3)2021, angle(45))), ///
    name(g1, replace)legend(order(1 "上海市" 2 "全国" )) title("支出边际倾向折线图")
gr tw ///
    (line 支出弹性系数 year if id==1,  yaxis(1) ytitle("系数/1") xtitle("年份") xlabel(2001(3)2021, angle(45))) ///
	(line 支出弹性系数 year if id==3,  yaxis(1) ytitle("系数/1") xtitle("年份") xlabel(2001(3)2021, angle(45))), ///
    name(g2, replace)legend(order(1 "上海市" 2 "全国" )) title("支出弹性系数折线图")
	drop if year<2007
gr tw ///
    (line 行政支出占总支出比 year if id==1,  yaxis(1) ytitle("占比%") xtitle("年份") xlabel(2007(1)2021, angle(45))) ///
	(line 行政支出占总支出比 year if id==3,  yaxis(1) ytitle("占比%") xtitle("年份") xlabel(2007(1)2021, angle(45))), ///
    name(g3, replace)legend(order(1 "上海市" 2 "全国" )) title("行政支出占比折线图") 
gr combine g0 g1 g2 g3,note("数据来源: CEIC")

//支出三线对比图
drop if year<2007
gr tw ///
    (line 投资性支出 year if id==1,  yaxis(1) ytitle("支出/亿元") xtitle("年份") xlabel(2007(1)2021, angle(45))) ///
	(line 消费性支出 year if id==1,  yaxis(1) ytitle("支出/亿元") xtitle("年份") xlabel(2007(1)2021, angle(45))) ///
    (line 转移性支出 year if id==1,  yaxis(1) ytitle("支出/亿元") xtitle("年份") xlabel(2007(1)2021, angle(45))), ///
    legend(order(1 "投资性支出" 2 "消费性支出" 3 "转移性支出")) title("上海市公共支出结构")
	

graph pie 投资性支出 消费性支出 转移性支出,plabel(_all percent, size(*1.5) color(white))  plotregion(lstyle(none))title("上海市公共支出占比")subtitle("2021")note("数据来源: 上海市2021年财政决算数据")
