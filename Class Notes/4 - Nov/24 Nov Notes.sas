*Two Categorical Predictors with an Interaction;
ods graphics off;
proc glm data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex;
	lsmeans chol_status*sex / lines adjust=tukey;
ods select 'Type III Model ANOVA' lsmlines;
run;

*Effect Slices in LSMEANS;
proc glm data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex;
	lsmeans chol_status*sex / slice=chol_status slice=sex;
ods select slicedANOVA;
run;

*Effect Slices in PROC MIXED;
proc mixed data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex;
	slice chol_status*sex / sliceby=sex 
	diff adjust=tukey;
ods select sliceTests;
ods output sliceDiffs=slDiff;
run;

proc print data=slDiff;
	by slice;
	id slice;
	var Chol_Status _Chol_Status estimate adjp;
run;

*LSMEANS for a Model Including a Quantitative Predictor;
*Additive model for one categorical and one quantitative predictor;
ods graphics off;
proc glm data=sashelp.heart;
	class chol_status;
	model systolic = weight chol_status / solution;
	lsmeans chol_status / diff adjust=tukey;
*ods select parameterEstimates lsmeans diff;
run;

*Setting Values of a Quantitative Predictor with AT;

proc standard data=sashelp.heart out=heartc mean=0;
	var weight;
run; /*something is wrong in this*/

ods graphics off;
proc glm data=heartc;
	class chol_status;
	model systolic = weight chol_status / solution;
	lsmeans chol_status / diff adjust=tukey;
ods select parameterEstimates lsmeans diff;
run;

proc glm data=heartc;
	class chol_status;
	model systolic = weight chol_status;
	lsmeans chol_status / at weight=-50 cl adjust=tukey;
	lsmeans chol_status / at weight=-25 cl adjust=tukey;
	lsmeans chol_status / at weight=50 cl adjust=tukey;
	lsmeans chol_status / at means cl adjust=tukey;
ods select lsmeans lsmeandiffcl;
run;

*Analyzing an Interaction with AT;
ods graphics off;
proc glm data=heartc;
	class sex;
	model systolic = weight|sex / solution;
	lsmeans sex / diff at weight=100;
	lsmeans sex / diff at weight=125;
	lsmeans sex / diff at weight=150;
	lsmeans sex / diff at weight=200;
ods select lsmeans diff;
run;

ods graphics off;
proc glm data=sashelp.heart;
	class sex;
	model systolic = weight|sex  AgeAtStart|sex / solution;
	lsmeans sex / at means diff = all;
	lsmeans sex / at weight = 125 diff=all;
	lsmeans sex / at weight = 175 diff=all;
	lsmeans sex / at AgeAtStart = 35 diff = all;
	lsmeans sex / at AgeAtStart = 55 diff = all;
	lsmeans sex / at (weight AgeAtStart) = (125 35) diff= all;
	lsmeans sex / at (weight AgeAtStart) = (175 35) diff= all;
	lsmeans sex / at (weight AgeAtStart) = (125 55) diff= all;
	lsmeans sex / at (weight AgeAtStart) = (175 35) diff= all;
run;

*2.6.1: Estimate Derived from GLM Parameters;
proc glm data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex / solution;
	estimate 'Chol=Desirable, Female' intercept 1 /*include the intercept*/
									sex 1 0 /*include females*/
									chol_status 0 1 0 /*include desirable chol*/
									chol_status*sex 0 0 1 0 0 0; /*also include females w/ desirable chol*/
	estimate 'Chol=Desirable, Male' intercept 1
									sex 0 1
									chol_status 0 1 0
									chol_status*sex 0 0 0 1 0 0;
	estimate 'Chol=Desirable, MaleV2' intercept 1
									sex 0 0
									chol_status 0 1 0
									chol_status*sex 0 0 0 0 0 0;
/*cant get these coeffecients from rows in x, so it does not produce an estimate*/
	estimate 'Chol=Desirable, MaleV3' intercept 1									
									chol_status 0 1 0								
/*this is really the mean for desirable cholesterol across both sexes -- SAS choses coefficiets for sex and chol_status*sex 
	relative to sample size estimate across sexes*/
ods select parameterEstimates estimates;
run;

ods graphics off;
proc glm data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex / solution;
	lsmeans chol_status*sex / diff cl;
	estimate 'Chol=Desirable, Female' intercept 1 /*include the intercept*/
									sex 1 0 /*include females*/
									chol_status 0 1 0 /*include desirable chol*/
									chol_status*sex 0 0 1 0 0 0; /*also include females w/ desirable chol*/
	estimate 'Chol=Desirable, Male' intercept 1
									sex 0 1
									chol_status 0 1 0
									chol_status*sex 0 0 0 1 0 0;
	estimate 'Desirable Chol, Female-Male' intercept 0
									sex 1 -1
									chol_status 0 0 0
									chol_status*sex 0 0 1 -1 0 0;
				/*difference in the first set of coefficients and the second*/
run;













