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


collect clear  
table () (command), command(logistic 国籍 c.油耗 i.价格指标)              ///
 	     command(logistic 国籍 c.油耗##i.价格指标)             ///
		command(logistic 国籍 c.油耗##i.价格指标 i.维修指标)  ///
		nformat(%9.2f  _r_b _r_ci)                        ///
		stars(_r_p 0.01 "**" 0.05 "*", attach(_r_b))

**# estimation commands for result		
logistic 国籍 c.油耗 i.价格指标
estat ic
return list
matlist r(S)
display r(S)[1,"BIC"] 

**# thress estimation models to collect		
collect clear                 
collect _r_b _r_se, tag(model[(1)]): logistic 国籍 c.油耗 i.价格指标
collect AIC=r(S)[1,"AIC"] BIC=r(S)[1,"BIC"], tag(model[(1)]): estat ic

collect _r_b _r_se, tag(model[(2)]): logistic 国籍 c.油耗##i.价格指标
collect AIC=r(S)[1,"AIC"] BIC=r(S)[1,"BIC"], tag(model[(2)]): estat ic

collect _r_b _r_se, tag(model[(3)]): logistic 国籍 c.油耗##i.价格指标 i.维修指标
collect AIC=r(S)[1,"AIC"] BIC=r(S)[1,"BIC"], tag(model[(3)]): estat ic

collect preview

collect dims
collect levelsof model
collect label list model, all

collect levelsof result
collect label list result, all
                   
collect layout (colname#result) (model)                 
collect style showbase off
collect preview

**# remove the vertical line and format numbers 
collect style cell border_block, border(right, pattern(nil))  
collect style cell, nformat(%5.2f)
collect preview

**# put sd in ()
collect style cell result[_r_se], sformat("(%s)")
collect preview
  
**# other format
collect levelsof cell_type
collect style cell cell_type[item column-header], halign(center)
collect preview
  
collect style header result, level(hide)
collect preview

collect style column, extraspace(1)
collect preview

collect style row stack, spacer delimiter(" x ")
collect preview

collect layout (colname#result result[AIC BIC]) (model)

collect style header result[AIC BIC], level(label)
collect preview

collect style cell result[AIC BIC], nformat(%8.0f)
collect preview
		 
**# export to files
collect export oex8.html, as(html) replace
collect export oex8.docx, as(docx) replace
