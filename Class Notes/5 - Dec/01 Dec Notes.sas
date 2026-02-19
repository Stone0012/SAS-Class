libname SASData '~/SASData';

/*
2. For the CDI data set, complete each of the following:

	(a) Fit a model with Per Capita Income as the response and Region as the predictor. Interpret the resulting
estimate.

	(b) Fit a model with Per Capita Income as the response and Region, BA/BS Rate, and their cross-product as
predictors. Interpret the resulting estimate.

*/

proc format; 
	value reg
	1 = 'Northeast'
	2 = 'North-central'
	3 = 'South'
	4 = 'West' 
;
run;

ods graphics off; 
proc glm data = sasdata.cdi; 
	class region; 
	format region reg.; 
	model inc_per_cap = region / solution; 
	lsmeans region / lines adjust=tukey;
run;

ods graphics off; 
proc glm data = sasdata.cdi; 
	class region; 
	format region reg.; 
	model inc_per_cap = region | ba_bs / solution; 
	*lsmeans region / lines adjust=tukey;
run;
/*because the cross product: regiion * ba_bs is significant, we analyze it as it 
	indicates there is an inconsistency of the ba/bs relationship to per capita income across regions*/

ods graphics off; 
proc glm data = sasdata.cdi; 
	class region;
	format region reg.; 
	model inc_per_cap = region | ba_bs / solution; 
	lsmeans region / lines adjust=tukey;
	lsmeans region / at means lines adjust=tukey;
run; /*if we ask for a region comparison now, it is done at the average value of ba_bas rate for the whole data
		set... useful, but perhaphs not the whole picture 

		I'll want to look at the comparisons for some other values of ba_bs rate*/

proc means data=sasdata.cdi min q1 median q3 max; 
	class region;
	var ba_bs;
	ways 0 1;
run; /*Check out the distribution of the quantitative predictor to help you choose*/

ods graphics off; 
proc glm data = sasdata.cdi; 
	class region;
	format region reg.; 
	model inc_per_cap = region | ba_bs / solution; 
	lsmeans region / at ba_bs = 10 lines adjust=tukey;
	lsmeans region / at ba_bs = 15 lines adjust=tukey;
	lsmeans region / at ba_bs = 20 lines adjust=tukey;
	lsmeans region / at ba_bs = 25 lines adjust=tukey;
	lsmeans region / at ba_bs = 30 lines adjust=tukey;
	ods select lsmlines; 
run;

/*
4. For the RealEstate data set, complete each of the following:

	(a) Fit a model with Price as the response and Quality as the predictor. Interpret the resulting estimate.

	(b) Fit a model with Price as the response and Quality, Square Footage, and their cross-product as predictors.
Interpret the resulting estimate.
*/

proc format; 
	value qual
	1='high'
	2='medium'
	3='low'
; 
run;
*a;
ods graphics off; 
proc glm data = sasdata.realestate; 
	class Quality; 
	format Quality qual.; 
	model price = Quality / solution; 
	lsmeans Quality / diff= all lines;
run;

/*They all test as significiantly different from each other, meaning further evaluation is needed*/

*b;
ods graphics off; 
proc glm data = sasdata.realestate; 
	class Quality; 
	format Quality qual.; 
	model price = Quality | sq_ft / solution; 
	lsmeans Quality / at means diff= all lines;
run;

proc means data=sasdata.realestate min q1 median q3 max; 
	class Quality;
	format Quality qual.; 
	var sq_ft;
	ways 0 1;
run;

ods graphics off;
proc glm data = sasdata.realestate; 
	class Quality; 
	format Quality qual.; 
	model price = Quality | sq_ft / solution; 
	lsmeans Quality / at sq_ft = 1600 diff= all lines;
	lsmeans Quality / at sq_ft = 2100 diff= all lines;
	lsmeans Quality / at sq_ft = 2600 diff= all lines;
	lsmeans Quality / at sq_ft = 3100 diff= all lines;
	ods select lsmlines parameterEstimates;
run; /*average price stays in its ordinal ranking vs quality for all square footages, 
		but the differences appear to change

		estimate the difference in average price between
			high quality homes and medium quality homes 
			3300 sqft (median for high) 2200 sqft (median for mid).. */

/*Estimate the differnces in mean price between high and med homes at 3300 sqft. Estimate the difference at 2200 sqft
	estimate the difference in those differences*/


data cdi; 
	set sasdata.cdi; 
	popDensity = pop/land;
run;

ods graphics off; 
proc glm data=cdi; 
	class region;
	format region reg.;
	model inc_per_cap = region|ba_bs 
						region|popDensity / solution; 
run;

proc means data=cdi min q1 median q3 max; 
	class region;
	format region reg.; 
	var popDensity;
	ways 0 1;
run;

proc sgplot data=cdi;
	scatter x=ba_bs y = popDensity / group = region markerattrs=(symbol= circlefilled size = 5pt);
	where popDensity le 5000;
run;

ods graphics off; 
proc glm data=cdi; 
	class region;
	format region reg.;
	model inc_per_cap = region|ba_bs 
						region|popDensity / solution; 
	lsmeans region / at ba_bs = 10 diff= all lines;
	lsmeans region / at ba_bs = 15 diff= all lines;
	lsmeans region / at ba_bs = 20 diff= all lines;
	lsmeans region / at ba_bs = 25 diff= all lines;
	lsmeans region / at ba_bs = 30 diff= all lines;
	/*we can set one of the covariates, the other is at the mean --
		that happens to be a rather poor choice for population 
		density because of the skewness*/
	ods select lsmlines parameterEstimates;
run;

ods graphics off; 
proc glm data=cdi; 
	class region;
	format region reg.;
	model inc_per_cap = region|ba_bs 
						region|popDensity / solution; 
	lsmeans region / at (ba_bs popDensity)  =(10 300) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (15 300) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 300) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 300) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (30 300) diff= all lines;
/*Of course, we can set both -- perhaphs changing both or possibly changing one and holding the other steady*/
	ods select lsmlines parameterEstimates;
run;









