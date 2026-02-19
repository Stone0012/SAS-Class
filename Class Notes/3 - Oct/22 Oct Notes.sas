/*

	1. Multiple Regression -- Multiple (more than 1) predictors 

	2. Multivariate Regression -- Multiple responses



*/

ods graphics off;
proc reg data=sashelp.heart; 
	model systolic= weight height; 
	/*systolic = y, weight = x1, height = x2*/
run; 

ods graphics off;
proc glm data=sashelp.heart; 
	model systolic= weight height; 
	/*systolic = y, weight = x1, height = x2*/
run; 
/*
--Average increase in BP is .34 for 1 pound increase in weight, 
	for a fixed value of height. 
--BP decreses on average by
	1.88 for a 1 inch increase in height for a fixed value of weight
*/

proc standard data=sashelp.heart out=heartCentered mean=0; 
	var weight height;
	/* mean = 0 says transform to mean zero (subtract the mean)*/
run;

ods graphics off;
proc reg data=heartCentered; 
	model systolic= weight height; 
	/*systolic = y, weight = x1, height = x2*/
run; 

proc glm data=heartCentered; 
	model systolic= weight height; 
	/*systolic = y, weight = x1, height = x2*/
run; 



ods graphics off;
proc glm data=sashelp.heart; 
	model systolic= weight height weight*height; 
	/*products of predictors are allowed in glm using '*' */
ods select parameterEstimates;
run; 


/*PROC Reg does not support any modifications to 
	predictors in the column statement*/
data heart;
	set sashelp.heart;
	weightXheight = weight*height;
run;
/*make a version of the data with the product in there */

ods graphics off; 
proc reg data=heart;
	model systolic = weight height weightXheight; /*use it..*/
ods select parameterEstimates;
run;


ods graphics off;
proc glm data=heartCentered; 
	model systolic= weight height weight*height; 
	/*products of predictors are allowed in glm using '*' */
ods exclude anova modelanova;
run; 


/*this is the hard way- not really used in practice*/
data heartb;
	set sashelp.heart;
	where weight_status ne ''; /*dont want these (there aren't any)*/
	underweight=0; normal=0; overweight=0; /*initialized dummy variables to 0*/
	select(weight_status);
		when('Underweight') underweight=1;
		when('Normal') normal=1;
		when('Overweight') overweight=1;
	end; /*flip on the right one*/
run; 

proc reg data=heartb; 
	'Means':model systolic = underweight normal overweight / noint; 
		/*NOINT removes the intercept from the equation before estimating --
			no column of 1 in the x matrix*/
	'Effects':model systolic = underweight normal overweight;
		restrict underweight+normal+overweight=0;
		/*intercept is included with a restriction -- restriction is written 
			in terms of the variables byt applies to their associated parameters*/
	'Reference': model systolic = underweight normal;
		/*removed overweight, it becomes the reference category*/
	ods select ParameterEstimates;
run;

proc means data=sashelp.heart; 
	class weight_status;
	var systolic;
	ways 0 1; 
run;

proc glm data=sashelp.heart; 
	class weight_status; /*class treats these as nominal*/
	model systolic = weight_status / solution; 
		/*solution shows the estimated model even when only categorical 
			stuff is used*/
	ods select ParameterEstimates; 
run;

proc glm data=sashelp.heart; 
	class weight_status; /*class treats these as nominal*/
	model systolic = weight_status / solution noint; 
		/*solution shows the estimated model even when only categorical 
			stuff is used*/
	ods select ParameterEstimates; 
run;















