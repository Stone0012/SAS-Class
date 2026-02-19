libname SASData '~/SASData';

/* 4. The SAS data set Environment summarizes responses to survey questions from 
		the 2000 General Social Survey. Subjects were asked if they were willing
		to pay higher taxes to help the environment and also if they were willing 
		to cut living standards to help the environment1. Test to see if either 
		proposal has more support, being sure to state a conclusion in context. */ 

proc sort data= sasdata.environment out=sorted;
	by descending HigherTaxes descending CutLivingStandards;
run;

ods graphics off;
proc freq data=sorted order = data; /* integrate counts */
	table HigherTaxes * CutLivingStandards / agree;
	weight count;
run; 

/* 

	1. For P values 
	
		1.1 - 0.05 < - < 0.10: sugesstive evidence for H0
		1.2 - 0.01 - 0.05: Significant evidence for H0
		1.3 - <0.01: Highly Significant evidence for H0


*/

libname IPEDS '~/IPEDS';

*Two Sample Comparisons Exercises;

/* need to get graduation rates... 
	two rows for each institution -- one with an incoming cohort size and 
										number graduating within 150% of standard time

	need to divide the numberrs in one row by the numbers in another...

	divide numbers in completer row by the number in the cohort row and output that resul for each institution

 */ 

proc sort data=ipeds.graduation out=gradsort; 
	by unitid group;
run; 

data test1; 
	set gradsort; 
	by unitid group; /* for any sorted data set, i can use By statement, even in a data step 
		when this is active, for each variable in the BY, two special variables are created: 
			first.variable and last.variable
		they are automatically dropped, and you can't keep them (but we can see them)*/

	firstunitid=first.unitid; /* first.unitid is created */
	lastunitid=last.unitid; /* last.unitid is created */

	firstgroup=first.group; /* first.group is created */
	lastgroup=last.group; /* last.group is created */
run;

proc sort data=sashelp.cars out=sortcars; 
	by make type; 
run; 

data test2; 
	set sortcars; 
	by make type; 

	firstmake = first.make; 
	lastmake = last.make;

	firsttype = first.type; 
	lasttype = last.type;

run; /* these hel me track where groups start and end -- 
			it is tracking grouping, cariables in the nested 
			sort may start new groups even if the values do not change or repeat later */ 

data grads cohort; /* It is possible to make more than one data set in a data detps 
						if I do this, I will take controll of output somewhere 
						inside the data step*/ 
	set gradsort; 
	by unitid group;

	if first.unitid then output grads; 
	if last.unitid then output cohort; 
run; 

data all; 
	merge grads (rename=(men=Gradmen women=Gradwomen))
		cohort;  /* a merge matches recrods.. */
	by unitid; /* ... on a set of BY variables */ 

	graderateM = gradmen/men; 
	graderateW = gradwomen/women;

	diff = graderateM - graderateM;

	format gradrate: percent8.2;

	drop total group;

run;

proc ttest data=all; 
	paired graderateM * graderatew; 
run;

proc ttest data=all; 
	var diff; 
run;

proc sql; 
	create table all2 as 
	select grads.*, cohort.men as incomingmen, cohort.women as inccomingwomen
	from grads full join cohort 
	on grads.unitid eq cohort.unitid;
quit;
















