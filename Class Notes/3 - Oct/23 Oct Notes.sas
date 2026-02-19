*Concept Question 5.2.2;
proc glm data=sashelp.heart; 
	class weight_status (ref='Overweight'); /**/
	model systolic = weight_status / solution; 
		/**/
	ods select ParameterEstimates; 
run;

/*

	1. Models that combine Categorical and Quantitative Predictors 

		1.1 - Additive Models 

			100.9 + 0.20x if cholesterol is desirable 
			105.0 + 0.20x if cholesterol is borderline 
			110.9 + 0.20x if cholesterol is high

		1.2 - Cross-Products of Categorical and Quantitative Predictors

			




*/

*1.1;
proc glm data=sashelp.heart; 
	class chol_status;
	model systolic = chol_status weight / noint solution;
	ods select ParameterEstimates;
run;

proc glm data=sashelp.heart; 
	class chol_status;
	model systolic = chol_status weight / solution;
	ods select ParameterEstimates;
run;

*1.2;
proc glm data=sashelp.heart;
	class chol_status;
	model systolic = chol_status|weight / solution;
		/*A|B is A B A*B
			A|B|C thats A B A*B C A*C B*C A*B*C can extend 
			A|B|C @2 to get A B A*B C A*C B*C*/
	ods select ParameterEstimates;
run;

proc glm data=sashelp.heart;
	class chol_status;
	model systolic = chol_status chol_status*weight / solution noint;
	ods select ParameterEstimates;
run;

/* Exercises */

libname SASData '~/SASData';

/*

For the CDI1 data set, complete each of the following: 

	(a) Fit a bivariate model with Per Capita Income as the 
			response and BA/BS Rate as the predictor. Interpret 
			the resulting estimate. 
	(b) Fit a bivariate model with Per Capita Income as the
			response and Percentage of Population 18 to 34 as the predictor. 
			Interpret the resulting estimate. 
	(c) Fit a model with Per Capita Income as the response and BA/BS Rate
			and Percentage of Population 18 to 34 as predictors. Interpret the
			resulting estimate and compare it to the results of (a) and (b). 
	(d) Fit a model with Per Capita Income as the response and BA/BS Rate,
			Percentage of Population 18 to 34, and their cross-product as
			predictors. Interpret the resulting estimate and compare it to
			the results of (a), (b), and (c).

*/

*A; 
proc glm data=sasdata.cdi;
	model  inc_per_cap = ba_bs;
ods select ParameterEstimates;
run;

*B;
proc glm data=sasdata.cdi;
	model  inc_per_cap = pop18_34;
ods select ParameterEstimates;
run;

*C;
proc glm data=sasdata.cdi;
	model  inc_per_cap = ba_bs  pop18_34;
ods select ParameterEstimates;
run;

*D;
proc glm data=sasdata.cdi;
	model  inc_per_cap = ba_bs | pop18_34;
ods select ParameterEstimates;
run;












