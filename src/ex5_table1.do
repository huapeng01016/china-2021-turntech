version 17

/*
	collect dims
	collect levelsof 
	collect label
	collect label list
	collect preview
	collect label levels
	
	collect recode
	collect layout
	collect style
*/

cscript

use auto_zh.dta, clear

**# classic table 1
table (var) (维修记录78),              ///
      statistic(fvfrequency 国籍)  ///
      statistic(fvpercent 国籍)     ///
      statistic(mean 价格)          ///
      statistic(sd 价格) nototals
	  
**# change label	  
collect label dim 维修记录78 "1978年维修记录", modify
collect preview

**# change label for values of 维修记录	  
collect levelsof 维修记录78
collect label list 维修记录78, all
collect label levels 维修记录78 1 "优秀" 2 "良好" 3 "合格" 4 "一般" 5 "差"
collect preview

**# recode dimesion	  
collect levelsof result
collect recode result fvfrequency = 第一列 ///
                      fvpercent   = 第二列 ///
                      mean        = 第一列 ///
                      sd          = 第二列
collect preview

**# transpose
collect layout (var) (维修记录78#result[第一列 第二列])


**# hide column headers 
collect style header result, level(hide)
collect preview

**# change headers 
collect style row stack, nobinder spacer
collect preview

**# remove vertical line 
collect style cell border_block, border(right, pattern(nil))
collect preview

**# format mean sd of 价格
collect style cell var[价格]#result[第一列 第二列], nformat(%6.1fc)
collect preview

**# format (sd) of 价格
collect style cell var[价格]#result[第二列], ///
        sformat("(%s)")
collect preview

**# format percent of 国籍
collect style cell var[国籍]#result[第二列], ///
        nformat(%6.1f) sformat("%s%%")
collect preview


**# a larger example
collect clear
table (var) (维修记录78),              ///
      statistic(mean 价格)          ///
      statistic(sd 价格)				///      
	  statistic(fvfrequency 国籍)  ///
      statistic(fvpercent 国籍)     ///
      statistic(mean 转弯半径 排气量 油耗)          ///
      statistic(sd  转弯半径 排气量 油耗) nototals



**# change label	  
collect label dim 维修记录78 "1978年维修记录", modify
collect preview
collect levelsof 维修记录78
collect label list 维修记录78, all
collect label levels 维修记录78 1 "优秀" 2 "良好" 3 "合格" 4 "一般" 5 "差"
collect preview
collect levelsof result
collect recode result fvfrequency = 第一列 ///
                      fvpercent   = 第二列 ///
                      mean        = 第一列 ///
                      sd          = 第二列
collect layout (var) (维修记录78#result[第一列 第二列])
collect style header result, level(hide)
collect preview
collect style row stack, nobinder spacer
collect style cell border_block, border(right, pattern(nil))
collect preview
collect style cell var[价格 转弯半径 排气量 油耗]#result[第一列 第二列], nformat(%6.1fc)
collect style cell var[价格 转弯半径 排气量 油耗]#result[第二列], ///
        sformat("(%s)")
collect style cell var[国籍]#result[第二列], ///
        nformat(%6.1f) sformat("%s%%")
collect preview


**# export to files
collect export oex5.html, as(html) replace
collect export oex5.docx, as(docx) replace
