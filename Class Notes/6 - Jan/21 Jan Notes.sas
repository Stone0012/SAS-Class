*Program 5.4: Detailed Testing of the Proportional Odds Assumption;

proc format;
	value $CholReOrder
	'Desirable'='1. Desirable'
	'Borderline'='2. Borderline'
	'High'='3. High'
;
run;

Title "Proportional Odds, Both Predictors";
proc logistic data=sashelp.heart;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit;
	ods select FitStatistics;
run;

Title "No Proportional Odds";
proc logistic data=sashelp.heart;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit unequalslopes;
	ods select FitStatistics;
run;


Title "Proportional Odds for Weight Only not Age";
proc logistic data=sashelp.heart;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit unequalslopes=AgeAtStart;
	ods select FitStatistics;
run;


Title "Proportional Odds for Age Only not Weight";
proc logistic data=sashelp.heart;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit unequalslopes=Weight;
	ods select FitStatistics;
run;
/*AIC says do proportional odds for age (not weight)

SBC says do both as proportional odds for both (original model)

same as cumulative*/


Title "Proportional Odds, Both Predictors";
Title2 'From SBC';
proc logistic data=sashelp.heart descending;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit;
	ods select ResponseProfile FitStatistics CumulativeModelTest
	ParameterEstimates OddsRatios;
run;

Title "Proportional Odds for Age Only not Weight";
Title2 'From AIC';
proc logistic data=sashelp.heart descending;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit unequalslopes=Weight;
	ods select ResponseProfile FitStatistics CumulativeModelTest
	ParameterEstimates OddsRatios;
run;

Title "Adjacent Categories";
proc logistic data=sashelp.heart descending;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=alogit;
	*ods select ResponseProfile FitStatistics CumulativeModelTest
	ParameterEstimates OddsRatios;
run;


*Exercises; 

*For the CDI data set, fit a model to predict when a county’s poverty level is 10% or more using the predictors:
region, BA/BS rate, and percentage of population over 65. Interpret the parameters for the model, including
their significance in predicting a 10% or higher poverty level.;

libname SASData '~/SASData';

proc format; 
	value poverty 
		10 - high = 'Above 10%'
		other = 'Below 10%'
;
run;

proc logistic data=sasdata.cdi;
	format poverty poverty.;
	class region / param=glm; /*use param=glm to show the reference category so that you can see it*/
	model poverty = region ba_bs over65;
run;











