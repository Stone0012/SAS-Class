libname pg2 '~/Courses/PG2V2/data';

proc sort data=pg2.np_acres out = parksort;	
	by parkname;
run; 

data multiState singleState;
	set parksort;
	by Parkname; 

	if first.Parkname and last.Parkname then output SingleState;
		/* ^^ only one record for a park */
	else output multistate;

	
	keep Region Parkname State GrossAcres;

run;


/* re do this one to get the same set of maz variables for all parks of any type */

proc sort data=pg2.np_monthlytraffic out=trafficsort;
	by parkname descending count;
run;


data maxtraffic;
    set trafficsort;
	by Parkname;

	if first.parkname then output;

	rename count=TrafficMax month=Max location=LocationMax; 	
run;

/* get the three highest counts for each park--
	so, three records per park */

data maxtraffic;
    set trafficsort;
	by Parkname;

	if first.parkname then c=0; /* set a counter for each park */
		c+1; /* Increment It */

	if c le 3 then output;
 	
run;

/* This time mae one data set that is one row per parl
	for multi-state parks, the acerage should be the total 
	across all states and the state variable should list
	all states that the park spans */

data Parks;
	set parksort;
	by Parkname; 
	retain states;
	length states $16;

	if first.Parkname and last.Parkname then do; 
		states = state; 
		output;
end;/*one record for a park*/

	else if first.ParkName then states=state; /*if not, then start with this*/
		else if last.parkname then do; 
			states = catx(', ' , states,state); /* add currrent state to the list of states */ 
	output;/* output when last */
end;

	else states = catx(', ' , states,state);/* add currrent state to the list of states, dont output yet */ 

	keep Region Parkname States GrossAcres;

run;

data try; 
	input tens; 
	retain Count 100;
    Count+Tens;
datalines;
10
20
30
40
;
run;











