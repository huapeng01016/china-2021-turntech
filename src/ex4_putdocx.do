version 17

/*
	collect dims
	collect levelsof 
	collect label
	collect label list
	collect preview

	collect label levels 
	putdocx collect
*/

cscript

use auto_zh.dta, clear

table (国籍) (价格区间),          ///
      statistic(frequency)      ///
      statistic(percent)        ///
      statistic(mean 油耗)        ///
      statistic(sd 油耗)          ///
      nototals                  ///     
      nformat(%9.0fc frequency) ///
      sformat("%s%%" percent)   ///
      nformat(%6.2f  mean sd)   /// 
      sformat("(%s)" sd)

**# collect and change labels of each level
collect dims 
collect levelsof result
collect label list result, all

collect label levels result  frequency  "频率"     ///
                             mean       "均值"     ///
                             percent    "百分比"   ///
                             sd         "方差"     ///
							 , modify           
collect preview

**# use collect with putdocx
putdocx clear 
putdocx begin

putdocx paragraph, style("Heading1")
putdocx text ("油耗与国籍及价格区间关系研究")

putdocx paragraph
putdocx text ("我们试图研究车辆每百公里油耗与其产地及价格区间的关系。")

putdocx paragraph, style("Heading2")
putdocx text ("描述变量")

**# use collect
putdocx paragraph
putdocx text ("使用collect生成表格。")
putdocx collect

**# use putdocx table
putdocx paragraph
putdocx text ("使用putdocx table生成表格。")
tabstat 油耗 国籍 价格区间, stats(n mean sd min max) save
matrix stats = r(StatTotal)'

putdocx table tbl_summ = matrix(stats),  ///
		nformat(%9.4g)					 ///
        rownames colnames                ///
        border(start, nil)               ///
        border(insideV, nil)             ///
        border(insideH, nil)             ///
        border(end, nil)

putdocx save oex4.docx, replace
