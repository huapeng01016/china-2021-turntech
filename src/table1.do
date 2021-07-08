cscript

global base_dir "C:/stata/talks/china-2021-turntech"

use $base_dir/data/auto_zh.dta, clear

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
collect recode result fvfrequency = column1 ///
                      fvpercent   = column2 ///
                      mean        = column1 ///
                      sd          = column2
collect preview

**# transpose
collect layout (var) (维修记录78#result[column1 column2])


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
collect style cell var[价格]#result[column1 column2], nformat(%6.1fc)
collect preview

**# format (sd) of 价格
collect style cell var[价格]#result[column2], ///
        sformat("(%s)")
collect preview

**# format percent of 国籍
collect style cell var[国籍]#result[column2], ///
        nformat(%6.1f) sformat("%s%%")
collect preview
