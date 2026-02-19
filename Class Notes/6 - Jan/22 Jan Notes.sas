*Exercises; 

*For the CDI data set, fit a model to predict when a county’s poverty level is 10% or more using the predictors:
region, BA/BS rate, and percentage of population over 65. Interpret the parameters for the model, including
their significance in predicting a 10% or higher poverty level.;

libname SASData '~/SASData';

proc format; 
	value poverty 
		10 - high = 'High Poverty'
		other = 'Low Poverty%'
;
run;

proc logistic data=sasdata.cdi descending;
	format poverty poverty.;
	class region / param=glm; 
	model poverty = region ba_bs over65;
	lsmeans region / diff adjust=tukey exp cl;
		/*EXP translates log-odds and differences into odds and odds ratios*/
run;

ods graphics off;
proc logistic data=sasdata.cdi descending;
	format poverty poverty.;
	class region / param=glm; 
	model poverty = region ba_bs over65;
	lsmeans region / diff adjust=tukey exp lines;
run;



proc logistic data=sasdata.cdi descending;
	format poverty poverty.;
	class region / param=glm; 
	model poverty = region ba_bs over65;
	lsmeans region / diff adjust=tukey exp at (ba_bs over65) = (12 10);
		/*does at means by default, but can select values to see odds*/
run;

*For the CDI data set, fit a model to predict when a county’s BA/BS rate is 20% or more using the predictors:
region, percentage of population over 65, population density, and crime rate. Interpret the parameters for the
model, including their significance in predicting a 20% or higher BA/BS rate.;

data cdimod;
	set sasdata.cdi;

	popdensity = pop/land;
	crimerate = crimes/pop*1000;
	
	label popdensity = 'People per Sq. mi.'
		  crimerate = 'Crimes per 1000 people';
run;


proc format; 
	value ba_bs 
		20 - high = 'High ba_bs'
		other = 'Low ba_bs'
;
run;

proc logistic data=cdimod;
	format ba_bs ba_bs.;
	class region / param=glm;
	model ba_bs = region over65 popdensity crimerate;
	lsmeans region / diff adjust=tukey exp;
	ods select responseProfile ParameterEstimates OddsRatios
				lsmeans diffs;
run;

proc logistic data=cdimod;
	format ba_bs ba_bs.;
	class region / param=glm;
	model ba_bs = region|over65|popdensity|crimerate @2;
		/*interactions amoung predictors are possible at various levels of complexity*/
run;

ods graphics off;
proc logistic data=cdimod;
	format ba_bs ba_bs.;
	class region / param=glm;
	model ba_bs = region|popdensity|crimerate @2 over65|region @2;
	lsmeans region / diff adjust=tukey exp at means;
	lsmeans region / diff adjust=tukey exp at over65=10;
	lsmeans region / diff adjust=tukey exp at over65=15;
run;


*For the CDI data set, fit a model to predict region from the variables BA/BS rate, income per capita, and
percentage of population 18 to 34. Interpret the parameters for the model, including their significance in
predicting the region.;

proc logistic data=sasdata.cdi;
	model region = ba_bs inc_per_cap pop18_34 / link=glogit; /*fixes the ordinal problem*/ 
run;
	/*Multi Category, is it ordinal or not (no), region is being treated as ordinal when it is not- so this is wrong*/























