version 17

/*
	table (row variables) (column variables)
		, statistics(stats)
*/

cscript

use auto_zh.dta, clear

**# include statistics other than frequency  
table () (价格区间),           ///
      statistic(frequency)    ///
      statistic(percent)

table (国籍) (价格区间),        ///
      statistic(frequency)    ///
      statistic(percent)     
     
table (国籍) (价格区间),         ///
      statistic(frequency)     ///
      statistic(percent)       ///
      nototals

table (国籍) (价格区间),          ///
      statistic(frequency)      ///
      statistic(percent)        ///
      statistic(mean 油耗)       ///
      statistic(sd 油耗)         ///
      nototals                       
 
 
**# fromat the numbers
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
