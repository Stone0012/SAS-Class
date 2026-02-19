libname SASData '~/SASData';

proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
run;
/** you can add titles and footnotes with golbal statements --
	have up to 10 lines of each **/

Title ' Five Number Summary'; /** is the first title line **/
Title2 ' On Equiptment, personnel, and Total Cost'; /** is the second title line **/
proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
footnote 'Stratified on Poultion Type and Region'; /** footnotes are basically same as the titles, 
	but the appear at the bottom. Needs to be active before or during a procedure execution **/
run; 


/** Titels are global statements both in terms of processing and effect**/

Title2 'On Total Cost'; 
footnote 'Stratified on region';
proc means data=sasdata.projects min q1 median q3 max;
	var jobtotal;
	class region; 
run;

ods noproctitle; /** Removes procedure auto title, global statement **/
Title ' Five Number Summary';
Title2 ' On Equiptment, personnel, and Total Cost'; 
footnote 'Stratified on Poultion Type and Region'; 
/** if provide a new version of a title or footnote line, that line is updated 
	and expunge any others with a higher number **/
footnote2 'Created on 8/26/25';
proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
footnote 'Stratified on Poultion Type and Region';
run; 

/** Lables can bes set for the run of any procedure.. **/
proc print data = sasdata.projects(obs=20) label noobs; 
/** can use dataset options -- libref.dataset(options)-- 
	(obs =) says how many observations to process**/
run;


proc print data = sasdata.projects(obs=20) label noobs; 
	var stname region pol_type equipmnt personel jobtotal;
	label stname = 'State' region = 'Region' pol_type = 'Polution' 
		equipmnt = 'Equiptment Cost ($)'
		personel = 'Personnel Costs ($)'
		jobtotal = 'Total Costs ($)' 
; /** can set labels for as many variables as you like, not global in effect **/
run;

proc print data = sasdata.cdi(obs=20) label noobs; 
	var county land pop inc_per_cap; 
	label land = 'Area, Square miles';
run; 
	
/** You can also change display styles using formats **/ 

proc print data = sasdata.projects(obs=20) label noobs; 
	var stname region pol_type date equipmnt personel jobtotal;
	label stname = 'State' region = 'Region' pol_type = 'Polution' 
		data = 'Completion Date'
		equipmnt = 'Equiptment Cost ($)'
		personel = 'Personnel Costs ($)'
		jobtotal = 'Total Costs ($)' 
; 
format equipmnt personel jobtotal dollar10.2;
/** decimal place, or specification of what to do width **/ ;
	/** formate varA varB ... varK with thisformat. ...;
		applies to all variables listed in front of it **/
run;

 /** format names: 
	must start with a $ if they are for character values (and must not if they're for numbers)
	follow the same conventions as variable names with one exception
	digits at the end (if included) define the total width allocated to formatted values 
	must include a dot-- either at the end or as a separateor for numeric formats between
	total width and number of digits past the decimal to display **/ 

/** dollar10.2 -- # of characters (total width) . decimal place, or specification of what to do width **/

proc print data = sasdata.projects(obs=20) label noobs; 
	var stname region pol_type date equipmnt personel jobtotal;
	label stname = 'State' region = 'Region' pol_type = 'Polution' 
		data = 'Completion Date'
		equipmnt = 'Equiptment Cost ($)'
		personel = 'Personnel Costs ($)'
		jobtotal = 'Total Costs ($)' 
; 
	format equipmnt personel jobtotal dollar10.2
	date weekdate. /** mmddyy10. or ddmmyy10.**/
;
run;

/** can google sas comments by category **/ 

proc format; 
	value $pollute 
	'CO' = 'Carbon Monoxide' 
	'SO2' = 'Sulfar Dioxide' 
	'Lead' = 'Lead' 
	'TSP' = 'Total Susp. Part.'
	'O3' = 'Ozone'
;

proc freq data=sasdata.projects; 
	table pol_type; 
	format pol_type $pollute.;
run; 