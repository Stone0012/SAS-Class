libname SASData '~/SASData';
libname IPEDS '~/IPEDS';

proc sql; 
	create table all2 as 
	select grads.*, cohort.men as incomingmen, cohort.women as inccomingwomen
	from grads full join cohort 
	on grads.unitid eq cohort.unitid;
quit;

proc ttest data=all2; 
	var diff; 
run;

/* Repeat for institutions that enrolled at least 100 men and women  */

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
	where men ge 100 and women ge 100;
run;

/*Build the data without spliitting into tables that you rejoin */

proc sort data=ipeds.graduation out=gradsort; 
	by unitid group;
run; 

data gradrates;
	set gradsort; 
	by unitid group;

	if first.unitid then do; /* This is the number of graduates */
		GradWomen = Women ;
		GradMen = Men;
end; 
	
	if last.unitid then do; 
		RateWomen=GradWomen/Women; /* now I have the cohort, can compute the rate */
		RateMen = GradMen/Men;
end; /* these are all missing because GradMen and GradWomen are missing ...
			each time a record is read, the Program Data vector (PDV) -- memory area 
			is wiped; all variables are reset to missing 
			no information is carried over unless you tell it to*/

run; 

proc sort data=ipeds.graduation out=gradsort; 
	by unitid group;
run; 

data gradrates;
	set gradsort; 
	by unitid group;
	retain GradWomen GradMen; /*retain tells the data step to hold tha value 
							from one iteration into subsequent ones */

	if first.unitid then do; 
		GradWomen = Women ;
		GradMen = Men;
end; 
	
	if last.unitid then do; 
		RateWomen=GradWomen/Women; 
		RateMen = GradMen/Men;
	output; /* completed the calculation, output the record */
end; 


run; 

proc ttest data=gradrates; 
	paired RateWomen * Ratemen; 
	where men ge 100 and women ge 100;
run;


/* Add in Yes/No on 50% or more for each of women and men */

data gradratesB;

	set gradsort; 
	by unitid group;
	retain GradWomen GradMen; 

	if first.unitid then do; 
		GradWomen = Women ;
		GradMen = Men;
end; 
	
	if last.unitid then do; 
		if men ne 0 and women ne 0; /*Subsetting if (if with no then ) 
			continues if true, returns to top if not */ 
		RateWomen=GradWomen/Women; 
		if RateWomen ge .5 then GE50Women = 'Yes';
			else GE50Women = 'No';
		RateMen = GradMen/Men;
		if RateMen ge .5 then GE50Men = 'Yes';
			else GE50Men = 'No';
	*if RateWomen ne . and RateMen ne . then output ; 
output;
end; 

run;

proc freq data=gradratesb; 
	table GE50Women * GE50Men / agree;
	where men ge 100 and women ge 100; 
run;

/* Do it without adding the GE50 variables -- use original gradrates */

proc format; 
	value GEHalf
		0- <0.5 = 'No'
		0.5-high = 'Yes' ;
run;

proc freq data=gradrates; 
	table RateWomen * Ratemen / agree; 
	format RateWomen RateMen GEhalf.; 
	where men ge 100 and women ge 100;
run;

proc print data = ipeds.characteristics label; 
	format _numeric_ best12. _character_ $50.;
run;

proc contents data = ipeds.characteristics; 
run;

proc format cntlin=ipeds.ipedsformats; /*cntlin is a dataset that has format definitions */
run;

proc print data = ipeds.characteristics label; 
	format fips best12.;
run;

options fmtsearch = (IPEDS); /*fmtsearch= sets libraries in which to search for format catalogs */

proc print data = ipeds.characteristics label; 
	format fips best12.;
run;



