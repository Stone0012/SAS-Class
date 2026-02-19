libname SASData '~/SASData';

/*
	
	1. For the CDI Data 
	
		(a) - Taking crime rate as the response, fit a model for it with poverty rate, BA/BS degree rate, and population density individual, 
				additive predictors. Interpret the parameter estimates   

		(b) - Add in all potential cross-products of preduictors and give your best interpretation of the model

*/

data cdi; 

	set sasdata.cdi;

crimerate = crimes / pop * 100000;

popden =  pop / land;

run;

proc stdize data=cdi out= StdCDI method=mean;  
	var popden poverty ba_bs; 
run;

*1A;
proc glm data=stdCDI; 
	model crimerate = popden poverty ba_bs;
ods select ParameterEstimates;
run;

*1B;
proc glm data=stdCDI; 
	model crimerate = popden | poverty | ba_bs;
ods select ParameterEstimates;
run;

proc stdize data=cdi out= StdCDI2 method=mean
	sprefix=C Oprefix=O;  
	var popden poverty ba_bs; 
run;

proc glm data=stdCDI2; 
	model crimerate = Cpopden | Cpoverty | Cba_bs;
ods select ParameterEstimates;
ods output ParameterEstimates=Parms;
run;


/*
	
	2. For the CDI Data 
	
		(a) - Add region to the predictor set in 1(A), and interpret it. How does the result change from that in 1(A) 

		(b) - Allow for all cross-products between region and the qunatiative variables in the previous case and interpret that model  

		(c) - Allow all 2-predictor cross-products and interpret

*/

data cdi; 

	set sasdata.cdi;

crimerate = crimes / pop * 100000;

popden =  pop / land;

run;

proc format;
	value region 
		1 = 'North East'
		2 = 'North Central'
		3 = 'South'
		4 = 'West'
	;
run;

proc stdize data=cdi out= StdCDI2 method=mean
	sprefix=C Oprefix=O;  
	var popden poverty ba_bs; 
run;

*1A;
proc glm data=stdCDI2; 
	model crimerate = cpopden cpoverty cba_bs;
ods select ParameterEstimates;
run;

*2A;
proc glm data=stdCDI2; 
	class region;
	model crimerate = region cpopden cpoverty cba_bs / solution noint;
ods select ParameterEstimates;
	format region region.;
run;

*2B;
proc glm data=stdCDI2; 
	class region;
	model crimerate = 	region | cpopden 
						region | cpoverty 
						region | cba_bs 
/ solution;
ods select ParameterEstimates;
	format region region.;
run;

*ods trace on;
proc glm data=stdCDI2; 
	class region;
	model crimerate = 	region | cpopden 
						region | cpoverty 
						region | cba_bs 
/ solution;
ods select ParameterEstimates 'Type III Model Anova';
	format region region.;
run;

*ods trace on;
proc glm data=stdCDI2; 
	class region (ref ='South');
	model crimerate = 	region | cpopden 
						region | cpoverty 
						region | cba_bs 
/ solution;
ods select ParameterEstimates 'Type III Model Anova';
	format region region.;
run;

*2C;
proc glm data=stdCDI2; 
	class region;
	model crimerate = region | cpopden | cpoverty | cba_bs @ 2 / solution;
		/*@k limites to up to interactions/products of any K variables*/
ods select ParameterEstimates 'Type III Model Anova';
	format region region.;
run;













