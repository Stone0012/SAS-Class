libname STAT1 '~/ECST142/data';

*Using PROC TTEST to Compare Groups;

proc univariate data=stat1.german;
	class group;
	var change;
	qqplot change / normal(mu=est sigma=est);
run;
 
proc ttest data=STAT1.German; 
   class Group; 
   var Change; 
run;

/*There is normality, reject null, not significantly different*/

*ANOVA;

proc glm data=stat1.ameshousing;
	class Heating_QC; /*Categorical Variable has to be in the class statement*/
	model SalePrice = heating_qc / solution;
run;