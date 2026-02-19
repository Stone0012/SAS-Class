/* For systolic and diastolic blood pressures in the Heart data set. 
(a) Find the variance and standard deviation. 
(b) Find the five quartiles. 
(c) Find the range and inter-quartile range. 
(d) Can you find all of the above in a single procedure run?
 [Done using PROC means plus listing all the stats]*/ 

libname SASData '~/SASData';

proc sgplot data=SASData.ipums2005mini;
	histogram MortgagePayment / binstart = 100 binwidth=100 scale=proportion dataskin=gloss;
/* reference point for any bar/bin is its center, 
	bin start is where to place the center of the first bar */
	xaxis label = 'MortgagePayment' valuesformat=dollar8.
		values = (50 to 550 by 100);
	yaxis display= (nolabel) valuesformat= percent7.;
 	where MortgagePayment gt 0; 
run;

proc format; 
value City 2 = "Inside City" 3 = "Outside City" 4 = "City Status Unknown" ; 
run; 

proc sgplot data=SASData.ipums2005mini; 
	vbox MortgagePayment / group=metro 
	groupdisplay=cluster extreme whiskerattrs=(color=red) 
	grouporder=ascending; 
	keylegend / across=1 position=topleft 
	location=inside title='' noborder; 
	yaxis display=(nolabel) valuesformat=dollar8.; 
	where MortgagePayment gt 0 
		and metro ge 2; format metro city.; 
run;

proc sgplot data=sashelp.heart; 
	vbox systolic / group=chol_status 
						groupdisplay=cluster outlierattrs=(symbol=squarefilled size=4pt)
							meanattrs=(color=black symbol=x)
							/*extreme whiskerattrs=(color=red)*/ grouporder=ascending ; 
	keylegend / across=1 position=topleft 
	location=inside title='' noborder; 
	yaxis display=(nolabel); 
	where not missing(chol_status); /* where not missing(); -- missings are included as a seperate group level, but i dont want them 
	-- missing() is 1 if the record contains a missing value, 0 otherwise */
run;

proc means data=sashelp.heart lclm mean uclm alpha=0.10;
	var systolic;
	class chol_status;
run;

proc format; 
	value $DesOrNOt
	'Desirable' = 'Desirable'
	other = 'Not Desirable'
;
run; 

proc freq data=sashelp.heart; 
	table chol_status / binomial; /* binomial gives intervals and hypothesis test for 
										proportions */  
	format chol_status $DesOrNOt.;
	where not missing(chol_status); /* missings behave strangley in FREQ
										if they are included in a format bin */
run; 


proc freq data=sashelp.heart; 
	table chol_status / binomial alpha=.1; 
	format chol_status $DesOrNOt.;
	where not missing(chol_status); 
run; 

proc freq data=sashelp.heart; 
	table weight_status*chol_status / binomial alpha=.1; /*binomial is only valid in one-way tables */
	format chol_status $DesOrNOt.;
	where not missing(chol_status); 
run; 

proc sort data=sashelp.heart out=heartSort;
	by weight_status; 
run; 

proc freq data=heartSort; 
	by weight_status; /*stratification available with by statement */
	table chol_status / binomial alpha=.1; 
	format chol_status $DesOrNOt.;
	where not missing(chol_status); 
run; 


proc freq data=sashelp.heart; 
	table chol_status / binomial; 
	*if it is not two categories and you use binomial, freq makes it two...
		first category is the target, all others are not;
	where not missing(chol_status); 
run; 











