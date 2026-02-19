libname SASData '~/SASData';


*For the CDI data set, fit a model to predict region from the variables BA/BS rate, income per capita, and
percentage of population 18 to 34. Interpret the parameters for the model, including their significance in
predicting the region.;

ods graphics off;
proc logistic data=sasdata.cdi;
	model region = ba_bs inc_per_cap pop18_34 / link=glogit; 
	units inc_per_cap = 1000;
	oddsratio inc_per_cap / cl=wald;
	output out=results predprobs=(I);
run;

proc freq data=results; 
	table _from_*_into_;
run;

ods graphics off;
proc logistic data=sasdata.cdi;
	where region ne 3;
	model region = ba_bs inc_per_cap pop18_34 / link=glogit; 
	units inc_per_cap = 1000;
	oddsratio inc_per_cap / cl=wald;
	output out=results2 predprobs=(I);
run;

proc freq data=results2; 
	table _from_*_into_;
run;

*For the Real Estate data set, fit a model with price categories of: $200K or less, above $200K up to $300K, and
above $300K, with square footage, number of bedrooms, and their cross-product as predictors. Give an
interpretation of the parameter estimates, and compare the results to Exercise 3(d) from General Linear
Models, Part I.;

proc format; 
	value pricecat
		low - 200000 = "1. Below $200K"
		200000 - 300000 = "2. $200 - $300k"
		300000 - high = "3. Above 300k"
;
run;


Title "Proportional Odds";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms;
	ods select fitstatistics;
run;

Title "No Proportional Odds";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes;
	ods select fitstatistics;
run;

Title "Unequal on sq_ft";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes=sq_ft;
	ods select fitstatistics;
run;

Title "Unequal on bedrooms";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes=bedrooms;
	ods select fitstatistics;
run;

Title "Unequal on interaction";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes=sq_ft*bedrooms;
	ods select fitstatistics;
run;

Title "Unequal on sq_ft and interaction";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes=(sq_ft sq_ft*bedrooms);
	ods select fitstatistics;
run;

Title "Unequal on bedrooms and interaction";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes=(bedrooms sq_ft*bedrooms);
	ods select fitstatistics;
run;

Title "Unequal on sq_ft and bedrooms ";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes=(bedrooms sq_ft bedrooms);
	ods select fitstatistics;
run;


Title "AIC - No Proportional Odds";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes;
	*ods select fitstatistics;
run;

Title "SVC - Unequal on sq_ft";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms / unequalslopes=sq_ft;
	*ods select fitstatistics;
run;

Title "Proportional Odds";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms;
	*ods select fitstatistics;
run;
/*If an interaction is present, default ratios odds are supressed..
	effects are inconsistent, so you are exppected to analyze them */

Title "Proportional Odds";
proc logistic data=sasdata.realestate; 
	format price pricecat.;
	model price = sq_ft|bedrooms;
	*ods select fitstatistics;
	ods graphics off;
	units sq_ft = 100;
	oddsratio sq_ft / at (bedrooms = 1 2 3);
	oddsratio bedrooms / at (sq_ft = 1500 2000 2500);
/*odds ratio performs a but like LSMEANS or SLICE but applies to any type of predictor, categorical or quantitative*/
run;


















