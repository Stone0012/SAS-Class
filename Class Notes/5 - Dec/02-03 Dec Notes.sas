libname SASData '~/SASData';

proc format; 
	value reg
	1 = 'Northeast'
	2 = 'North-central'
	3 = 'South'
	4 = 'West' 
;
run;

ods graphics off;
proc glm data = sasdata.realestate; 
	class Quality; 
	*format Quality qual.; 
	model price = Quality | sq_ft / solution; 
	lsmeans Quality / at sq_ft = 1600 diff= all lines;
	lsmeans Quality / at sq_ft = 2100 diff= all lines;
	lsmeans Quality / at sq_ft = 2600 diff= all lines;
	lsmeans Quality / at sq_ft = 3100 diff= all lines;
	*ods select lsmlines parameterEstimates;
run;

proc sgplot data=sasdata.realestate;
	reg x = sq_ft y = price / group = quality degree=1 markerattrs=(symbol = circle size = 4 pt);
run;


/*
Estimate the difference in mean price between high and medium quality homes at 3300 sq_ft
	Estimate that difference at 2200 sq_ft
	Estimate those differecnes
*/


ods graphics off;
proc glm data = sasdata.realestate; 
	class Quality; 
	*format Quality qual.; 
	model price = Quality | sq_ft / solution; 
	lsmeans Quality / at sq_ft = 2200 diff= all lines;
	lsmeans Quality / at sq_ft = 3300 diff= all lines;
	estimate 'High Quality Price @3300 sq.ft' intercept 1
												quality 1 0 0
												sq_ft 3300
												sq_ft*quality 3300 0 0
;
	estimate 'Medium Quality Price @3300 sq.ft' intercept 1
												quality 0 1 0
												sq_ft 3300
												sq_ft*quality 0 3300 0
;
	estimate 'High - Medium Quality Price @3300 sq.ft' intercept 0
												quality 1 -1 0
												sq_ft 0
												sq_ft*quality 3300 -3300 0
;
	estimate 'High - Medium Quality Price @2200 sq.ft' intercept 0
												quality 1 -1 0
												sq_ft 0
												sq_ft*quality 2200 -2200 0
;
	estimate 'High - Medium Quality Price @3300 vs 2200 sq.ft' intercept 0
												quality 0 0 0
												sq_ft 0
												sq_ft*quality 1100 -1100 0
;
	*ods select lsmlines parameterEstimates;
run;

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
	*format region reg.; 
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
	*format region reg.;
	model inc_per_cap = region|ba_bs 
						region|popDensity / solution; 
	lsmeans region / at (ba_bs popDensity)  =(15 300) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 300) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 300) diff= all lines;
	ods select lsmlines parameterEstimates;
run;

/*Of course, we can set both -- perhaphs changing both or possibly changing one and holding the other steady*/

ods graphics off; 
proc glm data=cdi; 
	class region;
	*format region reg.;
	model inc_per_cap = region|ba_bs 
						region|popDensity / solution; 
	lsmeans region / at (ba_bs popDensity) = (20 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 500) diff= all lines;
	ods select lsmlines parameterEstimates;
run;

proc sgplot data=cdi;
	reg x = popDensity y = inc_per_cap / group=region degree=1
											markerattrs=(symbol = circle size = 4pt);
	where popDensity le 5000;
run;

ods graphics off; 
proc glm data=cdi; 
	class region;
	format region reg.;
	model inc_per_cap = region|ba_bs 
						region|popDensity / solution; 
	lsmeans region / at (ba_bs popDensity) = (15 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (15 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (15 500) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 500) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 500) diff= all lines;
	ods select lsmlines diff;
run; /*with no interaction between the quantitative covariates, this grid is unnecessary,
		the relationships cannot e inconsistent across varrying combinations of ba/bs and density*/


/*If you put that interaction in, it is significant and then the grid is the correct approach*/
ods graphics off; 
proc glm data=cdi; 
	class region;
	format region reg.;
	model inc_per_cap = region|ba_bs 
						region|popDensity / solution; 
	lsmeans region / at (ba_bs popDensity) = (15 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (15 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (15 500) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 500) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 500) diff= all lines;
	ods select lsmlines diff;
run;

ods graphics off; 
proc glm data=cdi; 
	class region;
	format region reg.;
	model inc_per_cap = region|ba_bs|popDensity / solution; 
run;

ods graphics off; 
proc glm data=cdi; 
	class region;
	format region reg.;
	model inc_per_cap = region|ba_bs 
						region|popDensity / solution; 
	lsmeans region / at (ba_bs popDensity) = (15 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (15 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (15 500) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (20 500) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 200) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 350) diff= all lines;
	lsmeans region / at (ba_bs popDensity) = (25 500) diff= all lines;
	ods select lsmlines diff;
run;


/*Add in crime rate to ouur potential predictors, but we'll make it categorical
	median rate is ~ 52.5 crimes per 1000 people -- make (or format) a predictor 
	that is binary, above the median or below

	-- Put that into a model (for per-capita income) with region and ba/bs rate and all of their interactions 
		interpret what is significant
*/

data cdi; 
	set sasdata.cdi; 
	popDensity = pop/land;
	crimeRate = crimes/pop * 1000;
run;

proc means data=cdi median; 
	var crimeRate; 
run;

proc format; 
	value cr 
	low - 52.5 = 'Bottom Half'
	52.5 - high = 'Top Half'
; 
run;

ods graphics off; 
proc glm data=cdi; 
	class region crimeRate;
	format region reg. crimeRate cr.;
	model inc_per_cap = region|ba_bs|crimeRate / solution; 
run; /*Three factor iteraction is not important*/

ods graphics off; 
proc glm data=cdi; 
	class region crimeRate;
	format region reg. crimeRate cr.;
	model inc_per_cap = region|ba_bs|crimeRate @2 / solution; 
run;

ods graphics off; 
proc glm data=cdi; 
	class region crimeRate;
	format region reg. crimeRate cr.;
	model inc_per_cap = ba_bs|region 
						ba_bs|crimeRate / solution; 
run;


ods graphics off; 
proc glm data=cdi; 
	class region crimeRate;
	format region reg. crimeRate cr.;
	model inc_per_cap = ba_bs|region 
						ba_bs|crimeRate / solution; 
	lsmeans crimeRate / at ba_bs = 10 diff;
	lsmeans crimeRate / at ba_bs = 15 diff;

	lsmeans crimeRate / at ba_bs = 20 diff;
	lsmeans crimeRate / at ba_bs = 25 diff;
	lsmeans crimeRate / at ba_bs = 30 diff;
run;

/*
Keep crimerate as is, create a biinary pop density variable below 350 vs above 350, 
	and make a 4- category ba/bs: below 15  lowest, 
									15 - 20 is low 
									20 - 25 is high 
									25+ highest

for the response is inc_per_cap, put all of these three categorical predictors in with all interactions and interpret
*/


data cdi; 
	set sasdata.cdi; 
	popDensity = pop/land;
	crimeRate = crimes/pop * 1000;
run;

proc format; 
value cr 
	low - 52.5 = '1. Bottom Half'
	52.5 - high = '2. Top Half'
; 
value density 
	low - 350 = '1. Low D'
	350 - high = '2. High D'
;
value babs
	low - 15 = '1. Lowest'
	15 - 20 = '2. Low'
	20 - 25 = '3. High'
	25 - high = '4. Highest'
;
run; /*forcing the order by numbering*/

proc glm data = cdi; 
	class CrimeRate ba_bs popDensity; 
	format crimeRate cr. ba_bs babs. popDensity density.;
	model inc_per_cap = crimeRate|ba_bs|popDensity / solution; 
run;

ods graphics off;
proc glm data = cdi; 
	class CrimeRate ba_bs popDensity; 
	format crimeRate cr. ba_bs babs. popDensity density.;
	model inc_per_cap = crimeRate|ba_bs|popDensity / solution; 
	lsmeans crimerate * ba_bs * popDensity / lines adjust=tukey;
run;

ods graphics off;
*ods trace on;
proc mixed data = cdi; 
	class CrimeRate ba_bs popDensity; 
	format crimeRate cr. ba_bs babs. popDensity density.;
	model inc_per_cap = crimeRate|ba_bs|popDensity ; 
	slice crimerate * ba_bs * popDensity / sliceby=crimeRate*popDensity lines 
													adjust=tukey;
ods select SliceLines;
run;


ods graphics off;
*ods trace on;
proc mixed data = cdi; 
	class CrimeRate ba_bs popDensity; 
	format crimeRate cr. ba_bs babs. popDensity density.;
	model inc_per_cap = crimeRate|ba_bs|popDensity ; 
	slice crimerate * ba_bs * popDensity / sliceby=popDensity*ba_bs lines 
													adjust=tukey;
ods select SliceLines;
run;

ods graphics off;
*ods trace on;
proc mixed data = cdi; 
	class CrimeRate ba_bs popDensity; 
	format crimeRate cr. ba_bs babs. popDensity density.;
	model inc_per_cap = crimeRate|ba_bs|popDensity ; 
	slice crimerate * ba_bs * popDensity / sliceby=ba_bs*crimeRate lines 
													adjust=tukey;
ods select SliceLines;
run;













