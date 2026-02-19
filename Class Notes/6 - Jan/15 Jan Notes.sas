*4.1;

proc format;
	value $type
	'Sedan','Wagon'='Car'
	'Truck','SUV'='Truck'
;
run;

proc logistic data=sashelp.cars;
	where type not in ('Sports','Hybrid');
	model type = weight enginesize; 
	format type $type.;
run;

proc logistic data=sashelp.cars descending;
	where type not in ('Sports','Hybrid');
	model type = weight enginesize; 
	format type $type.;
run;

*4.2;

proc genmod data=sashelp.cars;
	where type not in ('Sports','Hybrid');
	format type $type.;
	model type = weight enginesize / dist=binomial link=logit;
		/*in GENMOD you get to pick the distrobution and the link function that you want*/
run;

*4.3: Using a Categorical Predictor in PROC LOGISTIC and GENMOD;

proc logistic data=sashelp.cars;
	where type not in ('Sports','Hybrid');
	class origin;
	model type = origin weight enginesize;
	format type $type.;
	ods select ParameterEstimates;
/*Logisitic uses effects parameterization for categorical predictors ...*/
run;

proc genmod data=sashelp.cars;
	where type not in ('Sports','Hybrid');
	format type $type.;
	class origin;
	model type = origin weight enginesize / dist=binomial link=logit;
	ods select ParameterEstimates;
/*genmod does GLM style*/
run;

/*In General, I want GLM style*/
proc logistic data=sashelp.cars;
	where type not in ('Sports','Hybrid');
	class origin / param=glm; /*we will take this as a required option*/
	model type = origin weight enginesize;
	format type $type.;
	ods select ParameterEstimates;
run;

proc logistic data=sashelp.cars;
	where type not in ('Sports','Hybrid');
	class origin / param=glm; 
	model type = origin weight enginesize;
	format type $type.;
	lsmeans origin / exp diff adjust=tukey;
ods graphics off;
run;

proc logistic data=sashelp.cars;
	where type not in ('Sports','Hybrid');
	class origin / param=glm; 
	model type = origin weight enginesize;
	format type $type.;
	output out=predictions predprobs=(I);
ods graphics off;
run;

proc freq data=predictions; 
	table _from_*_into_;
run;










