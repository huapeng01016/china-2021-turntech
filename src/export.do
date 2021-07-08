cscript

global base_dir "C:/stata/talks/china-2021-turntech"

use $base_dir/data/auto_zh.dta, clear

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

collect preview

**# export to files
collect export "$base_dir/output/basic_1.html", as(html) replace
collect export "$base_dir/output/basic_1.pdf", as(pdf) replace
collect export "$base_dir/output/basic_1.docx", as(docx) replace
