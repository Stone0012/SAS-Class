libname SASData '~/SASData';

/** so far we have learned proc means, proc freq, and proc print **/

ods noproctitle;
title 'Exercise 1';
proc means data=sasdata.index n q1 median q3 mean std;
	var r1000:; 
/** name with a : refrences any variable that starts with 
	the prefix characters and has any other characters
	(including none) after **/ 
run;

title 'Exercise 2';
proc means data=sasdata.index n q1 median q3 mean std nonobs;
	var r1000value r1000growth; 
	class dt; 
	format dt monname.;
run;


title 'Exercise 3';
proc freq data=sasdata.realestate;
	table pool * quality/ nocol;
run; 

title 'Exercise 4';
footnote 'Using projects data';
proc freq data=sasdata.projects;
	table date * region/ nocol;
	format date qtr.;
	label date= 'Quater';
run; 


title 'Exercise 5';
footnote 'Using projects data';
proc freq data=sasdata.projects;
	table pol_type * date * region/ nocol;
	format date qtr.;
	label date= 'Quater';
	where pol_type in ('LEAD','TSP');
run; 

title 'Exercise 6';
proc means data=sasdata.index n q1 median q3 mean std nonobs;
	var dt r1000value r1000growth; 
	class dt; 
	format dt year.;
	where dt ge '01JAN2000'd le '31DEC2006'd;
/** SAS date constant: ddMONyyyy'd converts to a SAS date **/ 
run;







