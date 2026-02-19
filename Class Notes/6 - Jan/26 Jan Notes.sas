libname STAT1 "~/ECST142/data"; /*This is our library assigningment for the Stats 1 Course*/

proc univariate data=stat1.normtemp;
	var bodytemp;
	histogram bodytemp / normal;
		inset n mean std; 
	qqplot bodytemp / normal(mu=est sigma=est);
		inset n mean std; 
run; 

proc ttest data=stat1.normtemp H0=98.6 plots=all; 
		/*default null hypothesis is 0 unless input*/
	var bodytemp; 
run;