libname stat1 '~/ECST142/data';
options fmtsearch=(stat1.myfmts);

proc means data=stat1.garlic mean std;
	class fertilizer;
	var bulbwt;
run;

proc sgplot data=stat1.garlic;
	hbox bulbwt / group= fertilizer;
run;
	


proc glm data=stat1.garlic;
	class fertilizer;
	model bulbwt = fertilizer /solution;
	lsmeans fertilizer / diff adjust=tukey;
	means fertilizer / hovtest=levene;
	means fertilizer / hovtest=bartlett;
/*hovtest asks for an equal variances test acrss all groups --
	generalization of the f-test given in proc ttest*/
ods graphics off;
run;
/* Normality got ignored here, but we can check it... */

proc glm data=stat1.garlic;
	class fertilizer;
	model bulbwt = fertilizer /solution;
	output out=results r=residual;
/*get out the estimated errors, residuals*/
ods graphics off;
run;

proc univariate data=results;
	var residual;
	qqplot residual / normal(mu=est sigma=est);
run; /*check them for normality*/

/*The two sample t-test is also an GLM/ANOVA question */
proc glm data=stat1.german;
	class group;
	model change = group / solution;
	lsmeans group diff cl; 
	means fertilizer / hovtest=levene;
	means fertilizer / hovtest=bartlett;
	output out=resultsg r=residualg;
ods graphics off;
run;

proc univariate data=resultsg;
	var residualg;
	qqplot residualg / normal(mu=est sigma=est);
run; 


*Demo - st102d03; 
proc glm data=STAT1.ameshousing3
         plots(only)=(diffplot(center) controlplot);
    class Heating_QC;
    model SalePrice=Heating_QC;
    lsmeans Heating_QC / pdiff=all 
                         adjust=tukey cl;
    lsmeans Heating_QC / pdiff=control('Average/Typical') 
                         adjust=dunnett cl;
    format Heating_QC $Heating_QC.;
    title "Post-Hoc Analysis of ANOVA - Heating Quality as Predictor";
*ods select lsmeans diff diffplot controlplot;
run;

proc freq data=stat1.ameshousing3;
	table Heating_QC;
	format Heating_QC $Heating_QC.;
run;
	













