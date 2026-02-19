/* Suppose we want to chart a quantative statistic other than mean, median, or sum (the ones you get in SGPLOT) */ 

/* I want a chart of third quartiles of MPG city across origin for cars data */

ods trace on;
proc means data=sashelp.cars q3; 
	class origin; /* your charting (and group) variable is the stratification variable in means */
	var mpg_city;
	ods output summary= ThirdQ;
run;

proc sgplot data = ThirdQ; 
	hbar origin / response=mpg_city_q3; /* use that summary stat as the response-- it's reduced to one summary stat, so stat= option is irrelevent */
											/* defualt is the sum - since the summary is only one value, the statistic choice is irrelevent */
run;


proc means data=sashelp.cars q3; 
	class origin type; 
	var mpg_city;
	ods output summary= ThirdQ;
run;

proc sgplot data = ThirdQ; 
	hbar origin / response=mpg_city_q3 group = type groupdisplay=cluster;
/* if you stratify by a second variable, it can be used as the group variable */
run;

proc means data=sashelp.cars q3; 
	class origin; 
	var mpg_city;
	output out = ThirdQ;
/* Output out = data-set-of info..
	ignores that stat-key words list in the proc means statement */
run;

proc means data=sashelp.cars noprint; 
	class origin; 
	var mpg_city;
	output out = Q3info q1=FirstQ q3=ThirdQ;
/* can make requests keyword=var name */
run; /* why do I get a blank origin (and type of 0) */


proc means data=sashelp.cars q3; 
	class origin type ; 
	var mpg_city;
	ways 0 1 2; /* ways N; N -> number of class variables to use in stratification */
	ods output summary=ThirdQ;
run;

proc means data=sashelp.cars noprint; 
	class origin; 
	var mpg_city;
	ways 1; /* Output does respect a ways request, if present */ 
	output out = Q3info q1=FirstQ q3=ThirdQ;
run;

proc sgplot data = Q3info; 
	hbar origin / response=ThirdQ ; 
/* use summary stat as response */
run;

proc sgplot data=sashelp.cars; 
	hbar origin / group=type groupdisplay=cluster stat=percent;
	where type ne 'Hybrid'; /* percentage of the whole - not percentage per car from the usa that are sadans */ 
run;

proc sgplot data=sashelp.cars; 
	hbar origin / group=type groupdisplay=cluster stat=percent;
	where type ne 'Hybrid';
run;

proc freq data=sashelp.cars; 
	table origin * type; 
	where type ne 'Hybrid';
	ods output crosstabfreqs = Percents; 
run;

proc sgplot data = Percents; 
	hbar origin / group=type response=rowpercent groupdisplay=cluster; 
run; 


proc freq data=sashelp.cars; 
	table origin * type; 
	where type ne 'Hybrid';
	ods output crosstabfreqs = Percents; 
run;

/* Defaults */ 

libname SASData '~/SASData';

proc format; 
	value $pollutant 
		'CO' = 'Carbon Monoxide' 
		'LEAD' = 'Lead'
		'SO2' = 'Sulfur - Dioxide ' /* technically do not need quotes on left size */
		'O3' = 'Ozone' 
		'TSP' = 'Total Suspended Particulates';
run; 



/* The value statement names the format and sets its ruls 
	format names must.. 
		1. Begin with a dollar sighn if they are for character values (and must not if for numeric)
		2. The reaming characters are letters, digits, underscores to a max of 32 including the dollar sign 
			and it must not end in digits (that's where the length goes)
		3. When creating the name, the dot is not included (any time you use it, the dot must be present)
*/ 

proc freq data=sasdata.projects; 
	table pol_type; 
	format pol_type $pollutant.; 
run; 

proc format; 
	value jobtotal 
		0-40000 = 'Up to $40,000'
		40000-80000 = '$40,000 to $80,000'
		80000-1000000 = 'More than $80,000' ; 
run; 

proc freq data= sasdata.projects ;
	table pol_type * jobtotal; 
	format pol_type $pollutant. jobtotal jobtotal.;
run;

proc sgplot data = sasdata.projects; 
	hbar jobtotal / stat=percent;
	format jobtotal jobtotal.;
run;

proc sgplot data = sasdata.projects; 
	hbar pol_type / stat=percent group=jobtotal groupdisplay=cluster;
	format pol_type $pollutant. jobtotal jobtotal.;
run;

*Or; 

proc format; 
	value jobtotal 
		low-<40000 = 'Less than $40,000'
		40000-<80000 = '$40,000 to $80,000'
		80000-high = 'M$80,000 or more' ; 
run;

proc freq data= sasdata.projects ;
	table pol_type * jobtotal; 
	format pol_type $pollutant. jobtotal jobtotal.;
run;














