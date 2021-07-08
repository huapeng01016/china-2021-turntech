clear all
collect clear

// THIS DO-FILE REQUIRES Stata 17 OR HIGHER
version 17

capture cd "$GoogleDriveWork"
capture cd "$GoogleDriveLaptop"
capture cd "$Presentations"
capture cd ".\Talks\AllTalks\31_Tables\examples\"

set linesize 120
capture log close
log using TableExamples, replace

global Width16x9 = 1920*2
global Height16x9 = 1080*2

global Width4x3 = 1440*2
global Height4x3 = 1080*2

**# USE THE DATA FROM THE WEB
webuse nhanes2l
save nhanes2l, replace

describe age sex race height weight bmi highbp        ///
         bpsystol bpdiast tcresult tgresult hdresult

//label define highbp 0 "Normotensive" 1 "Hypertensive"
//label values highbp highbp




**# BASIC EXAMPLES OF -table- AND -collect-
// ==================================================================
table (highbp) ()

table () (highbp)

table (sex) (highbp) 
 
**# REMOVE TOTALS 
table (sex) (highbp), nototals

**# ROW AND COLUMN TOTALS
table (sex) (highbp), totals(highbp)

table (sex) (highbp), totals(sex)


**# STACKED CATEGORIES
table (sex highbp) (), totals(highbp)

table (highbp sex) (), nototals

table () (sex highbp), nototals

table () (highbp sex), nototals

table (highbp sex diabetes) (), nototals


**# This is a bookmark 
table () (highbp),          ///
      statistic(frequency)  ///
      statistic(percent)

table (sex) (highbp),       ///
      statistic(frequency)  ///
      statistic(percent)     
     
table (sex) (highbp),       ///
      statistic(frequency)  ///
      statistic(percent)    ///
      nototals


**# FORMAT THE NUMBERS IN THE OUTPUT     
table (sex) (highbp),           ///
      statistic(frequency)      ///
      statistic(percent)        ///
      statistic(mean age)       ///
      statistic(sd age)         ///
      nototals                       
 
 
**# FORMAT THE NUMBERS IN THE OUTPUT     
table (sex) (highbp),           ///
      statistic(frequency)      ///
      statistic(percent)        ///
      statistic(mean age)       ///
      statistic(sd age)         ///
      nototals                  ///
      nformat(%9.0fc frequency) ///
      sformat("%s%%" percent)   ///
      nformat(%6.2f  mean sd)   /// 
      sformat("(%s)" sd)


	  
// INTRODUCE -collect-
collect clear    
table (sex) (highbp),     ///
      statistic(frequency)      ///
      statistic(percent)        ///
      statistic(mean age)       ///
      statistic(sd age)         ///
      nototals                  ///
      nformat(%9.0fc frequency) ///
      sformat("%s%%" percent)   ///
      nformat(%6.2f  mean sd)   /// 
      sformat("(%s)" sd)   
      

// DISPLAY THE COLLECTION'S DIMENSIONS
collect dims 

//collect style cell highbp, halign(center)
//collect preview

// CHANGE THE LABEL OF EACH LEVEL OF THE DIMENSION highbp
// ANALOGOUS TO CHANGING VALUE LABELS
collect levelsof highbp

collect label list highbp, all

collect label levels highbp 0 "No" 1 "Yes"

collect label list highbp, all

collect preview

// CHANGE THE LABEL OF THE DIMENSION highbp
// ANALOGOUS TO CHANGING THE VARIABLE LABEL
collect label dim highbp "Hypertension", modify

collect label list highbp, all

collect preview


// MODIFY THE LABELS OF THE DIMENSION results
collect levelsof result

collect label list result, all

collect label levels result frequency "Freq."        ///
                            mean      "Mean (Age)"   ///
                            percent   "Percent"      ///
                            sd         "SD (Age)"    ///
                            , modify
collect preview

// REMOVE THE VERTICAL LINE
collect style cell border_block, border(right, pattern(nil))
collect preview

collect export mytable.html, as(html) replace

collect export mytable.pdf, as(pdf) replace

collect export mytable.docx, as(docx) replace





// CLASSIC TABLE 1
// =============================================================================
collect clear
table (var) (highbp),              ///
      statistic(fvfrequency sex )  ///
      statistic(fvpercent sex)     ///
      statistic(mean age)          ///
      statistic(sd age) nototals

// CHANGE THE LABEL OF THE DIMENSION highbp
// ANALOGOUS TO CHANGING THE VARIABLE LABEL
collect label dim highbp "Hypertension", modify
collect preview

// CHANGE THE LABEL OF EACH LEVEL OF THE DIMENSION highbp
// ANALOGOUS TO CHANGING VALUE LABELS
collect levelsof highbp
collect label list highbp, all
collect label levels highbp 0 "No" 1 "Yes"
collect preview

     
      
// RECODE DIMENSION result      
collect recode result fvfrequency = column1 ///
                      fvpercent   = column2 ///
                      mean        = column1 ///
                      sd          = column2

collect layout (var) (highbp#result[column1 column2])

// HIDE THE COLUMN HEADERS FOR DIMENSION result
collect style header result, level(hide)
collect preview

// CLEAN UP THE ROW HEADERS
collect style row stack, nobinder spacer
collect preview

// REMOVE THE VERTICAL LINE
collect style cell border_block, border(right, pattern(nil))
collect preview

// FORMAT THE FREQUENCIES (frequency -> mean)
//collect style cell var[sex]#result[mean], nformat(%6.0fc)
collect style cell var[sex]#result[column1], nformat(%6.0fc)
collect preview

// FORMAT THE NUMBERS FOR THE PERCENTAGES (precent -> sd)
collect style cell var[sex]#result[column2], ///
        nformat(%6.1f) sformat("%s%%")
collect preview

// FORMAT THE MEAN AND SD OF age
collect style cell var[age]#result[column1 column2], ///
        nformat(%6.1f)
collect preview

// PUT PARENTHESES AROUND THE STANDARD DEVIATION
collect style cell var[age]#result[column2], ///
        sformat("(%s)")
collect preview

// SAVE THE LABELS AND STYLE
collect label save mylabels, replace
collect style save mystyle, replace

// USE THE LABELS AND STYLE FROM THE FILE
collect clear
table (var) (highbp),              ///
      statistic(fvfrequency sex )  ///
      statistic(fvpercent sex)     ///
      statistic(mean age)          ///
      statistic(sd age) nototals
collect layout (var) (highbp#result)
collect recode result fvfrequency = column1 ///
                      fvpercent   = column2 ///
                      mean        = column1 ///
                      sd          = column2
collect label use mylabels      
collect style use mystyle
collect preview






// EXAMPLE OF A LARGER TABLE
collect clear
table (var) (highbp),                             ///
      statistic(mean age bmi)                     ///
      statistic(sd   age bmi)                     ///
      statistic(fvfrequency sex race hlthstat)    ///
      statistic(fvpercent   sex race hlthstat)    ///
	  statistic(mean tcresult tgresult hdresult)  ///
	  statistic(sd   tcresult tgresult hdresult)

collect label dim highbp "Hypertension", modify
collect label levels highbp 0 "No" 1 "Yes"
collect recode result fvfrequency = column1 ///
                      fvpercent   = column2 ///
                      mean        = column1 ///
                      sd          = column2
collect layout (var) (highbp#result[column1 column2])
collect style header result, level(hide)
collect style row stack, nobinder spacer
collect style cell border_block, border(right, pattern(nil))
collect style cell var[sex race hlthstat]#result[column1], nformat(%6.0fc)
collect style cell var[sex race hlthstat]#result[column2], ///
        nformat(%6.1f) sformat("%s%%")
collect style cell var[age bmi tcresult tgresult hdresult]#result[column1 column2], ///
        nformat(%6.1f)
collect style cell var[age bmi tcresult tgresult hdresult]#result[column2], ///
        sformat("(%s)")
collect preview





 



// CLASSICAL HYPOTHESIS TESTS
// =============================================================================
ttest age, by(highbp)
return list

collect clear
table (command) (result),                       ///
      command(Normotensive = r(mu_1)            ///
              Hypertensive = r(mu_2)            ///
              Difference   = (r(mu_2)-r(mu_1))  /// 
              pvalue       =  r(p)              ///
              : ttest age, by(highbp)) 
            
collect dims 
collect levelsof command 
 
collect label list command, all

collect label levels command 1 "Age (years)", modify
collect preview

collect levelsof result  
collect label list result, all 
collect style cell result[Normotensive Hypertensive Difference], ///
        nformat(%6.1f)
collect style cell result[pvalue], nformat(%6.4f)
collect style cell border_block, border(right, pattern(nil))
collect preview

 
 
 
// EXAMPLE OF A LARGER TABLE 
collect clear
table (command) (result),                                   ///
      command(Normotensive = r(mu_1) Hypertensive = r(mu_2) ///
              Difference = (r(mu_2)-r(mu_1)) pvalue = r(p)  ///
              : ttest age, by(highbp))                      /// 
      command(Normotensive = r(mu_1) Hypertensive = r(mu_2) ///
              Difference = (r(mu_2)-r(mu_1)) pvalue = r(p)  ///
              : ttest tcresult, by(highbp))                 ///
      command(Normotensive = r(mu_1) Hypertensive = r(mu_2) ///
              Difference = (r(mu_2)-r(mu_1)) pvalue = r(p)  ///
              : ttest tgresult, by(highbp))                 ///
      command(Normotensive = r(mu_1) Hypertensive = r(mu_2) ///
              Difference = (r(mu_2)-r(mu_1)) pvalue = r(p)  ///
              : ttest hdresult, by(highbp))  

              
//COLLECT THE RESULTS USING A LOCAL MACRO              
local myresults "Normotensive = r(mu_1) Hypertensive = r(mu_2) Difference = (r(mu_2)-r(mu_1)) pvalue = r(p)"
                 
display "`myresults'"                 
              
table (command) (result),                                   ///
      command(`myresults' : ttest age, by(highbp))          /// 
      command(`myresults' : ttest tcresult, by(highbp))     ///
      command(`myresults' : ttest tgresult, by(highbp))     ///
      command(`myresults' : ttest hdresult, by(highbp))               
              
collect label levels command 1 "Age (years)"                 ///
                             2 "Serum cholesterol (mg/dL)"   ///
                             3 "Serum triglycerides (mg/dL)" ///
                             4 "High density lipids (mg/dL)" ///
                             , modify
collect style cell result[Normotensive Hypertensive Difference], nformat(%8.1f)
collect style cell result[pvalue], nformat(%6.4f)
collect style cell border_block, border(right, pattern(nil))
collect preview 
 
 
 
// EXAMPLE OF AN EVEN LARGER TABLE 
local myresults "Normotensive = r(mu_1) Hypertensive = r(mu_2) Difference = (r(mu_2)-r(mu_1)) pvalue = r(p)"

collect clear
table (command) (result),                                ///
      command(`myresults' : ttest age,      by(highbp))  /// 
      command(`myresults' : ttest hgb,      by(highbp))  ///
      command(`myresults' : ttest hct,      by(highbp))  ///
      command(`myresults' : ttest iron,     by(highbp))  ///                
      command(`myresults' : ttest albumin,  by(highbp))  ///              
      command(`myresults' : ttest vitaminc, by(highbp))  ///  
      command(`myresults' : ttest zinc,     by(highbp))  ///
      command(`myresults' : ttest copper,   by(highbp))  ///
      command(`myresults' : ttest lead,     by(highbp))  ///
      command(`myresults' : ttest height,   by(highbp))  ///              
      command(`myresults' : ttest weight,   by(highbp))  ///              
      command(`myresults' : ttest bmi,      by(highbp))  ///               
      command(`myresults' : ttest bpsystol, by(highbp))  ///  
      command(`myresults' : ttest bpdiast,  by(highbp))  ///  
      command(`myresults' : ttest tcresult, by(highbp))  ///
      command(`myresults' : ttest tgresult, by(highbp))  ///
      command(`myresults' : ttest hdresult, by(highbp))                 

              
collect levelsof command  
collect label list command, all               

// NOTE THAT THE LABEL LEVELS ARE SORTED ALPHABETICALLY
// THIS IS WHY THE LEVELS ARE ORDERED 1,10,11, ... ,17,2,3,4 ...              
collect label levels command 1  "Age (years)"                 ///
                             10 "Height (cm)"                 ///
                             11 "Weight (kg)"                 ///
                             12 "Body Mass Index"             ///
                             13 "Systolic Blood Pressure"     ///
                             14 "Diastolic Blood Pressure"    ///
                             15 "Serum cholesterol (mg/dL)"   ///
                             16 "Serum triglycerides (mg/dL)" ///
                             17 "High density lipids (mg/dL)" ///
                             2  "Hemoglobin (g/dL)"           ///
                             3  "Hematocrit (%)"              ///
                             4  "Serum iron (mcg/dL)"         ///
                             5  "Serum albumin (g/dL)"        ///
                             6  "Serum vitamin C (mg/dL)"     ///
                             7  "Serum zinc (mcg/dL)"         ///
                             8  "Serum copper (mcg/dL)"       ///
                             9 "Lead (mcg/dL)"                ///
                             , modify
collect style cell result[Normotensive Hypertensive Difference], nformat(%8.2f)
collect style cell result[pvalue], nformat(%6.4f)
collect style cell border_block, border(right, pattern(nil))
collect preview  
 
 

 
  
 
 
 
// TABLE OF REGRESSION RESULTS
// =============================================================================
logistic highbp c.age##i.sex i.diabetes                 
                 
collect clear

table () (command result),                                   ///
         command(logistic highbp c.age##i.sex i.diabetes)

collect label list result, all                  

table () (command result),                                   ///
         command(_r_b _r_se _r_z _r_p _r_ci                  ///
                 : logistic highbp c.age##i.sex i.diabetes)  
         
table () (command result),                                   ///
         command(_r_b _r_se _r_z _r_p _r_ci                  ///
                 : logistic highbp c.age##i.sex i.diabetes)  ///
         nformat(%5.2f  _r_b _r_se _r_ci )                   ///
         nformat(%5.4f  _r_p)                                ///
         sformat("[%s]"  _r_ci )                             ///
         cidelimiter(,)
         
         

// CHANGE 'Coefficient' TO 'Odds Ratio'         
collect label list result, all 

collect label levels result _r_b "Odds Ratio", modify  
collect preview      

// CHANGE THE LABEL FOR command TO  'Model Results'         
collect label levels command 1 "Logistic Regression Model for Hypertension", modify
collect preview

// REMOVE THE FACTOR VARIABLE BASE LEVELS
collect style showbase off
collect preview

// STACK THE ROW HEADERS AND CHANGE THE INTERACTION DELIMITER
collect style row stack, delimiter(" x ") nobinder
collect preview

	





// TABLE FOR REGRESSION RESULTS FROM MULTIPLE MODELS
// =============================================================================
/*collect clear  
table () (command), command(logistic highbp c.age i.sex)              ///
 	                command(logistic highbp c.age##i.sex)             ///
					command(logistic highbp c.age##i.sex i.diabetes)  ///
					nformat(%9.2f  _r_b _r_ci)                        ///
					stars(_r_p 0.01 "**" 0.05 "*", attach(_r_b))
*/
 
 
logistic highbp c.age i.sex 

estat ic

return list

matlist r(S)
 
display r(S)[1,"BIC"] 
 
 
// COLLECT THE ODDS RATIO AND STANDARD ERROR FROM A LOGISTIC REGRESSION MODEL
collect clear 
collect create MyModels  
collect _r_b _r_se,                    ///
        name(MyModels)                 ///
        tag(model[(1)])                ///
        : logistic highbp c.age i.sex

collect AIC=r(S)[1,"AIC"]    ///
        BIC=r(S)[1,"BIC"],   ///
        name(MyModels)       ///
        tag(model[(1)])      ///
        : estat ic                    
                    
collect clear                 
// FIT THE FIRST MODEL                  
collect _r_b _r_se, tag(model[(1)]): logistic highbp c.age i.sex
collect AIC=r(S)[1,"AIC"] BIC=r(S)[1,"BIC"], tag(model[(1)]): estat ic

// FIT THE SECOND MODEL
collect _r_b _r_se, tag(model[(2)]): logistic highbp c.age##i.sex
collect AIC=r(S)[1,"AIC"] BIC=r(S)[1,"BIC"], tag(model[(2)]): estat ic

// FIT THE THIRD MODEL					
collect _r_b _r_se, tag(model[(3)]): logistic highbp c.age##i.sex i.diabetes
collect AIC=r(S)[1,"AIC"] BIC=r(S)[1,"BIC"], tag(model[(3)]): estat ic

collect dims
collect levelsof model
collect label list model, all

collect levelsof result
collect label list result, all

                   
// CREATE THE LAYOUT OF THE COLLECTION                    
collect layout (colname#result) (model)                 
                    
// TURN OFF BASE LEVELS FOR FACTOR VARIABLES                    
collect style showbase off
collect preview

// REMOVE THE VERTICAL LINE
collect style cell border_block, border(right, pattern(nil))  
collect preview

// FORMAT THE NUMBERS
collect style cell, nformat(%5.2f)
collect preview


// PUT PARENTHESES AROUND THE STANDARD ERRORS
collect style cell result[_r_se], sformat("(%s)")
collect preview
  
// CENTER ALLIGN THE NUMBERS AND HEADERS  
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
  

  
  
  
  
  
  
  
// SAVE STYLES AND LABELS
// =============================================================================
collect clear
collect create mylogit
collect style clear
collect style showbase off
collect style row stack, delimiter(" x ") nobinder
collect style cell border_block[corner row-header],  ///
        border(right, pattern(nil)) nowarn
collect style cell border_block,                     ///
        border(right, pattern(nil))

collect style cell result[_r_b _r_se _r_ci], nformat(%8.2f)
collect style cell result[_r_p], nformat(%5.4f) 
collect style cell result[_r_ci], sformat("[%s]") cidelimiter(,)
collect style header command, level(hide)
collect preview

collect style save MyLogitStyle, replace

collect clear
collect label levels result _r_b "Odds Ratio", modify 
collect label save MyLogitLabels, replace 


// USING SAVED STYLES AND LABELS
//collect style use MyLogitStyle         
//collect label use MyLogitLabels, modify
//collect preview
sysuse auto, clear

table () (command result),                                ///
         command(_r_b _r_se _r_z _r_p _r_ci               ///
                 : logistic foreign weight displacement)  ///
         style(MyLogitStyle, override)                    ///        
         label(MyLogitLabels)
                         
         
         

 
 
 
 
 
log close

translate "TableExamples.smcl" "TableExamples.log",   ///
           replace linesize(120) translator(smcl2log)


webuse nhanes2l, clear





