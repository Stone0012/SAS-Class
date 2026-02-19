ods graphics off;
proc reg data=sashelp.heart;
model systolic = weight height;
*ods exclude NObs;
run;

ods trace on;
ods graphics off;
proc glm data=sashelp.heart;
model systolic = weight height;
*ods exclude NObs;
run;


ods graphics off;
proc glm data=sashelp.heart;
model systolic = weight height;
ods select 'Type III Model ANOVA';
run;

ods graphics off;
proc reg data=sashelp.heart;
model systolic = weight height / covb clb;
ods exclude NObs;
run;

ods graphics off;
proc reg data=sashelp.heart;
model systolic = weight height / covb clb alpha = .10;
ods exclude NObs;
run;

proc glm data=sashelp.heart;
model systolic = weight height / clparm;
ods select FitStatistics 'Type I Model ANOVA'
	parameterEstimates;
ods output parameterEstimates;
run;

/*
-- Type I --> is sequential or ordered. --

A -------> contribution of A alone 

B -------> contribution of B, given A in the model 

C -------> contribution of C, given A and B in the model 

-- Type III --> given all other are present in the model, not ordered or sequential. --

A -------> A given B and C

B -------> B given A and C

C -------> C given A and B

- Typically used type III since it is not sequenced. 


  */

proc glm data=sashelp.heart;
model systolic = height weight / clparm;
*ods select FitStatistics 'Type III Model ANOVA'
	parameterEstimates;
*ods output parameterEstimates;
run;

*Centering the Predictors and Using PROC GLM;
proc means data=sashelp.heart mean;
var weight height;
run;
proc standard data=sashelp.heart out=heartCent
mean=0;
var weight height;
run;
proc glm data=heartCent;
model systolic = weight height / clparm;
ods select parameterEstimates;
run;














