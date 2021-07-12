/*
	table (row dimensions) (column dimensions)
       , command(command)
*/

cscript

global base_dir "C:/stata/talks/china-2021-turntech"

use $base_dir/data/auto_zh.dta, clear


**# classical hypothesis tests 
ttest 油耗, by( 国籍)
return list

collect clear
table (command) (result),                       ///
      command(国内 = r(mu_1)                     ///
              国外 = r(mu_2)                     ///
              差异   = (r(mu_2)-r(mu_1))      /// 
              P值       =  r(p)              ///
              : ttest 油耗, by(国籍))
 
            
collect dims 
collect levelsof command 

collect label list command, all

collect label levels command 1 "油量消耗(公升每一百公里)", modify
collect preview

collect levelsof result  
collect label list result, all 
collect style cell result[国内 国外 差异], ///
        nformat(%6.1f)
collect style cell result[P值], nformat(%6.4f)
collect style cell border_block, border(right, pattern(nil))
collect preview


// EXAMPLE OF AN EVEN LARGER TABLE 
**# a larger example
local myresults "国内 = r(mu_1) 国外 = r(mu_2) 差异 = (r(mu_2)-r(mu_1)) P值 = r(p)"

collect clear
table (command) (result),                                ///
      command(`myresults' : ttest 油耗,      by(国籍))  /// 
      command(`myresults' : ttest 价格,      by(国籍))  ///
      command(`myresults' : ttest 里程,      by(国籍))  ///
      command(`myresults' : ttest 头部空间,     by(国籍))  ///                
      command(`myresults' : ttest 后备厢,  by(国籍))  ///              
      command(`myresults' : ttest 重量, by(国籍))  ///  
      command(`myresults' : ttest 车长,     by(国籍))  ///
      command(`myresults' : ttest 转弯半径,   by(国籍))  ///
      command(`myresults' : ttest 排气量,     by(国籍))  ///
      command(`myresults' : ttest 变速比, by(国籍))                 

              
collect levelsof command  
collect label list command, all               

collect preview


collect label levels command 1  "油量消耗(公升每一百公里)"   ///
                             10  "传动比"                 ///
                             2  "价格 ($)"                ///
                             3  "里程(英里每加仑) "        ///
                             4  "头部空间(厘米)"           ///
                             5  "后备厢空间(立方米)"       ///
                             6  "重量(公斤)"              ///
                             7  "车长(厘米)"              ///
                             8  "转弯半径(米)"            ///
                             9 "排气量(cc)"              ///
                             , modify
collect style cell result[国内 国外 差异], ///
        nformat(%6.1f)
collect style cell result[P值], nformat(%6.4f)
collect style cell border_block, border(right, pattern(nil))
collect preview  
 
**# export to files
collect export "$base_dir/output/stats.html", as(html) replace
collect export "$base_dir/output/stats.docx", as(docx) replace
