cscript

global base_dir "C:/stata/talks/china-2021-turntech"

use $base_dir/data/auto_zh.dta, clear

**# BASIC EXAMPLES OF -table- AND -collect-
table (维修记录78) ()

table () (维修记录78)

table (国籍) (维修记录78) 
 
**# REMOVE TOTALS 
table (国籍) (维修记录78), nototals

**# ROW AND COLUMN TOTALS
table (国籍) (维修记录78), totals(维修记录78)

table (国籍) (维修记录78), totals(国籍)

**# STACKED CATEGORIES
table (国籍 维修记录78) (), totals(维修记录78)

table (维修记录78 国籍) (), nototals

table () (国籍 维修记录78), nototals

table () (维修记录78 国籍), nototals
