ods trace on;
proc logistic data=sashelp.cars;
	model origin = horsepower weight mpg_city msrp length / link=glogit;
	output out=predict1 predprobs = (I);
	ods output oddsratios = oddsR;
run;

proc print data= predict1;
	format oddsRatios lowercl uppercl best12.;
run;

ods graphics off;
proc logistic data=sashelp.cars;
	model origin = horsepower weight mpg_city msrp length / link=glogit;
	units msrp=1000 sd mpg_city = 1 3 5 ;
	oddsratio msrp / cl=wald;
	oddsratio mpg_city / cl=wald;
	output out = predict2 predprobs = (I); 
run;

*5.2: Using PROC Logistic to Model the Blood Pressure Status;
	*take bp status as response from heart with ageatstart and weight as predictors;

proc freq data=sasdhelp.heart;
	table bp_status;
	/*ordinal, ordered worst to best by default (alphabetically)*/
run;

proc logistic data=sashelp.heart;
	model bp_status = AgeAtStart Weight / link=logit;
		/*For multi-category, logit is cumulative logit
			this is ordinal, and the categories  alphabetical ordering corresponds to a ranking (worst to best*/
	ods select ModelInfo ResponseProfile ParameterEstimates OddsRatios;
run;

proc logistic data=sashelp.heart descending;
	model bp_status = AgeAtStart Weight / link=logit;
	ods select ModelInfo ResponseProfile ParameterEstimates OddsRatios;
run;

proc logistic data=sashelp.heart;
	model bp_status = AgeAtStart Weight / link=alogit;
	ods select ModelInfo ResponseProfile ParameterEstimates OddsRatios;
run;

proc freq data=sashelp.heart;
	table chol_status;
run; /*Chol_status is ordinal, but the alphabetical ordering of its values is not a proper ranking*/

*Program 5.3: Using PROC Logistic to Model the Cholesterol Pressure Status;

proc format;
	value $CholReOrder
	'Desirable'='1. Desirable'
	'Borderline'='2. Borderline'
	'High'='3. High'
;
run;


proc logistic data=sashelp.heart;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit;
	ods select ResponseProfile FitStatistics CumulativeModelTest
	ParameterEstimates OddsRatios;
run;

proc logistic data=sashelp.heart;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit unequalslopes;
	ods select ResponseProfile FitStatistics CumulativeModelTest
	ParameterEstimates OddsRatios;
run;

proc logistic data=sashelp.heart;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit unequalslopes=AgeAtStart;
	ods select ResponseProfile FitStatistics CumulativeModelTest
	ParameterEstimates OddsRatios;
run;

proc logistic data=sashelp.heart;
	format chol_status $CholReOrder.;
	model chol_status = AgeAtStart Weight / link=logit unequalslopes=weight;
	ods select ResponseProfile FitStatistics CumulativeModelTest
	ParameterEstimates OddsRatios;
run;












	