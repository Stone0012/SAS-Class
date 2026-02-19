libname pg2 '~/Courses/PG2V2/data';

/*

	1. Bivariate Linear Regression Models 

		1.1 - For error we typically assume ... 

			1.1.1 - Mean is 0 
			1.1.2 - Has constant variance 
			1.1.3 - Normally Distrobuted

		1.2 - In bivariate linear regression, one quantitative value is modeled as a 
				linear function of another quantitative value, allowing for random error 
				to be included. If y represents the response variable to be modeled, and 
				x the predictor variable, the bivariate linear model is: y =β0+β1x+ϵ 
				[ϵ is random error and E is expected value]

		1.3 - Given n pairs (xi, yi); i = 1,2, ..., n choose β0+β1 that best fit the relation 
				y =β0+β1x+ϵ .. estimate yi = ˆβ0 + ˆβ1xi

			1.3.1 - it seems reasonable to want to choose the estimator so that 
					1/n E n/i=1 (yi − ˆyi) = 0

			1.3.2 - To make sure that we are not using an estimate that simply balances out very 
						large positive and negative errors, the square of each error is used.
						 (yi − ˆyi)**2
*/

*ods graphics off;
	proc reg data=sashelp.heart; 
	model systolic= weight; /* The MODEL statement is required. For a bivariate model, the 
								response variable is listed on the left of the equal sign, 
								the predictor on the right.*/
/*model response - variable = predictor variable 
		systolic = y, weight = x --

		y =103.8+0.22x. - average rate of change in y for x
			0.22 -> on average, systolic BP is associated with a 0.22 increase for a 1 pound increase in weight 
			103.8 -> avg bp for someone who weighs 0 pounds (placeholder)*/
run; 


/*^^ Here, systolic blood pressure is modeled as a linear function of weight.

	1.Observations with a missing value for any variable included in the MODEL statement are excluded from the analysis. 

	2. TheAnalysis of Variance table will have utility for us later, but not at the moment. It will be eliminated from 
		output in the remaining PROC REG examples in this chapter. 

	3. The dependent mean is the mean of the response variable from the MODEL statement. The mean for the predictor is 
		not shown. 

	4. Theparameter estimates include the intercept and slope estimates. The slope estimate is paired with the name of 
		the predictor variable, which is necessary for clarity in later models that include more than one predictor.*/



proc standard data=sashelp.heart out=heartCentered mean=0; 
	var weight;
	/* mean = 0 says transform to mean zero (subtract the mean)*/
run;

ods graphics off;
	proc reg data=heartCentered; 
	model systolic= weight; 
run; 

ods graphics off;
	proc reg data=sashelp.heart; 
	model systolic= weight; 
run; 


proc glm data=sashelp.heart; 
	model systolic= weight;
run;

proc glm data=heartCentered; 
	model systolic= weight;
run;

/*
	1.Theonlychanges in the code are 1) replacing REG with GLM and 2) removal of the ODS GRAPHICS statement–GLM also 
	generates graphics by default, except in cases where the number of observations exceeds 5000, 
	which is true for the Heart data. So its inclusion/exclusion for this example is irrelevant. 

	2. TheMODELstatement is also required in GLM. Again, for a bivariate model, the response variable 
	is listed on the left of the equal sign, the predictor on the right. 

	3. Sohereagain, systolic blood pressure is modeled as a linear function of weight.
*/

/* 
1. Reverse the roles of the variables in the previous examples–let systolic be the predictor and 
	weight be the response. Is that model related to the ones in Programs 3.1 and 3.2? 

2. Philosophically,which is the better choice for roles of these variables? 
*/ 

ods graphics off;
	proc reg data=sashelp.heart; 
	model weight= systolic; 
run; 

proc glm data=sashelp.heart; 
	model weight= systolic;;
run;

/*

	1. General Linear Model for Two or More Quantitative Predictors 

		1.1 - Bivariate regression is a simple case of the more broadly applicable general linear
				model (GLM).While still allowing only for a single, quantitative response, the GLM 
				allows for a larger set of predictors of various types. To start, scenarios are 
				considered where all predictors are quantitative.
*/







