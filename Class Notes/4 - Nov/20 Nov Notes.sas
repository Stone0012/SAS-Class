*Comparisons to a Control in LSMEANS;
proc glm data=sashelp.heart;
	class weight_status;
	model systolic = weight_status;
	lsmeans weight_status / diff=control adjust=dunnett cl;
ods select lsmeans lsmeandiffcl;
run;

*Choosing the Control Level in LSMEANS;
proc glm data=sashelp.heart;
	class smoking_status;
	model systolic = smoking_status;
	lsmeans smoking_status / diff=control('Non-smoker') cl;
ods select lsmeans lsmeandiffcl;
run;

*Two Additive, Categorical Predictors;
ods graphics off;
proc glm data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status sex / solution clparm;
	lsmeans chol_status / diff=all cl;
	lsmeans sex / diff cl;
/*can look at each one with a seperate lsmeans*/
*ods select 'Type III Model ANOVA' lsmeans diff;
run;

ods graphics off;
proc glm data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status sex / solution clparm;
	lsmeans chol_status sex / diff=all adjust=tukey;
/*for something like sex with 2 levels, the Tukey adjustment is no adjustment at all --
	Tukey adjusts for multiple comparisons, here the 'multiple' is 1*/
	lsmeans sex / diff;/*diff is unadjusted*/
*ods select 'Type III Model ANOVA' lsmeans diff;
run;

*Two Categorical Predictors with an Interaction;
ods graphics off;
proc glm data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex;
	lsmeans chol_status*sex / lines adjust=tukey;
		lsmeans sex / lines adjust = tukey;
ods select 'Type III Model ANOVA' lsmlines;
ods output lsmeans=means;
run;

proc sgplot data=means;
	series y=lsmean x=chol_status / group=sex 
		markers markerattrs=(symbol=circlefilled) lineattrs=(pattern=2);
run;

/*If a cross product interactions shows a p value of .10 or less, I would say it is significant and investigate it*/
proc sgplot data=means;
	series y=lsmean x=sex / group=chol_status 
		markers markerattrs=(symbol=circlefilled) lineattrs=(pattern=2) nomissinggroup;
run;

/*
- Interaction (inconsistent behaviour) is important. -> This must be the focus of our analysis, other tests involving 
	these may be derevitive
- Additive (parallel) no real interaction or crossover 

*/

*Effect Slices in LSMEANS;
proc glm data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex;
	lsmeans chol_status*sex / slice=chol_status slice=sex;
ods select slicedANOVA;
run;

*Effect Slices in PROC MIXED;
ods graphics off;
proc mixed data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex;
	slice chol_status*sex / sliceby=sex /*Select what to slice by*/
	diff adjust=tukey ; 
ods select sliceTests;
ods output sliceDiffs=slDiff;
run;

/*
- In mixed, the class and model syntax is the same
- It does have an lsmeans statement, but for interactions, it also has a slice statement
*/

proc print data=slDiff;
by slice;
id slice;
var Chol_Status _Chol_Status estimate adjp;
run;









