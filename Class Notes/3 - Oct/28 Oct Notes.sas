libname SASData '~/SASData';

proc format;
	value quality
		1 = '1 - High'
		2 = '2 - Mid'
		3 = '3 - Low'
	;
run;

*4A;
proc glm data=sasdata.realestate;
	class quality;
	model  price = quality / solution;
ods select ParameterEstimates;
	format quality quality.;
run;

*4B;
data RealEstate; 
	set sasdata.realestate;
	
	sqft = sq_ft - 2000;
run;

proc glm data=RealEstate;
	class quality;
	model  price = quality | sqft / solution;
ods select ParameterEstimates;
	format quality quality.;
run;

/*Take the model from 2b and add in population 18 to 34 and all possible cross producs between predictors -- 
	interpret*/
proc stdize data = sasdata.cdi out=cdi method=mean;
	var ba_bs pop18_34;
run;


proc format;
	value region 
		1 = 'North East'
		2 = 'North Central'
		3 = 'South'
		4 = 'West'
	;
run;


proc glm data=cdi;
	class region;
	model  inc_per_cap = ba_bs | region |  pop18_34 / solution;
ods select ModelAnova ParameterEstimates;
	format region region.;
run;

/*

18123.44 + 461.65(ba_bs) - 79.69 (pop) - 36.01 (ba_bs * pop) -> Model for the west

		- 79.69 -> Avg change (decrese) in per cap income for a 1% inc in pop 18-34, for wester county at avg (0) BA/BS scale 
		- 18123.44 -> Avg per cap income for a western county for averave values of Ba/BS rate and pop 18 - 34 
		- 461.65 -> avg increase in per cap income for a 1% increase in Ba/BS rate for a western county at average level of pop 18-34

+ 912.87 (NC) - 65.85 (ba_bs * NC) - 300.37 (pop NC) + 23.91 (ba_bs * pop NC)

+ 2033.52 (NE) - 113.42 (ba_bs * NE) - 311.12 (pop NE) + 11.69 (ba_bs * pop NE)

- 205.63 (S) - 1.77 (ba_bs * S) - 282.56 (pop S) +  26.18 (ba_bs * pop S)

*/

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

proc glm data=stdCDI; 
	model crimerate = popden poverty ba_bs;
ods select ParameterEstimates;
run;





