/*
	table (row dimensions) (column dimensions)
       , command(command)
	
	collect dims
	collect levelsof 
	collect label
	collect label list
	collect preview
	collect label levels
	collect recode
	collect layout
	collect style
	collect stars	   
*/

cscript

use auto_zh.dta, clear

gen 价格指标 = cond( 价格 > 9000, 1, 0)
label define 价格指标 1 "豪华" 0 "非豪华" 
label value 价格指标 价格指标
gen  维修指标 = cond(维修记录78 < 2, 1, 0) if 维修记录78 < .
label define 维修指标 1 "质量良好" 0 "质量一般" 
label value 维修指标 维修指标

**# logit  
logistic 国籍 c.油耗##i.价格指标 i.维修指标

collect clear
table () (command result),                                   ///
         command(logistic 国籍 c.油耗##i.价格指标 i.维修指标)

collect label list result, all                  

table () (command result),                                   ///
         command(_r_b _r_se _r_z _r_p _r_ci                  ///
                 : logistic 国籍 c.油耗##i.价格指标 i.维修指标)  
         
table () (command result),                                   ///
         command(_r_b _r_se _r_z _r_p _r_ci                  ///
                 : logistic 国籍 c.油耗##i.价格指标 i.维修指标)  ///
         nformat(%5.2f  _r_b _r_se _r_ci )                   ///
         nformat(%5.4f  _r_p)                                ///
         sformat("[%s]"  _r_ci )                             ///
         cidelimiter(,)
         
collect label list result, all 

collect label levels result _r_b "优势比", modify	// Odds ratio
collect label levels result _r_se "标准误差", modify	
collect label levels result _r_z "Z分数", modify	
collect label levels result _r_p "P值", modify	
collect label levels result _r_ci "95$置信区间", modify	
  
collect preview      

**# chnage label for command
collect label levels command 1 "车俩数据逻辑回归模型", modify
collect preview

**# remove factor variable base levels
collect style showbase off
collect preview

**# stack row header and change delimiter
collect style row stack, delimiter(" x ") nobinder
collect preview
 
**# export to files
collect export oex7.html, as(html) replace
collect export oex7.docx, as(docx) replace
