version 17

/*
	table (row variables) (column variables)
*/
cscript

use auto_zh.dta, clear

table (维修记录78) ()

table () (维修记录78)

table (国籍) (维修记录78) 
 
**# remove totals 
table (国籍) (维修记录78), nototals

**# add row and column totals
table (国籍) (维修记录78), totals(维修记录78)

table (国籍) (维修记录78), totals(国籍)

**# stack categories
table (国籍 维修记录78) (), totals(维修记录78)

table (维修记录78 国籍) (), nototals

table () (国籍 维修记录78), nototals

table () (维修记录78 国籍), nototals

table (国籍 维修记录78 价格区间) (), nototals