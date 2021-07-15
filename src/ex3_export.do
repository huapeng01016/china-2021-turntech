version 17

/*
	collect dims
	collect levelsof 
	collect label
	collect label list
	collect preview
	
	collect export
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

**# collect
collect dims 
collect levelsof result
collect label list result, all
collect preview

**# export to files
collect export oex3.html, as(html) replace
collect export oex3.docx, as(docx) replace
collect export oex3.xlsx, as(xlsx) replace
