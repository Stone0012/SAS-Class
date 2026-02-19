/* Continued Notes on Importing Files */

/* Text fields can be embedded in quotes, so that comments inside the quotes are ignored for seperating data */

/* Open the CSV file in SAS, and click import, set the output library, and name it
-- DMBS is file type
-- OUT = SAS table you are going to create
-- Getnames = yes */

libname PG1 '~/Courses/PG1V2/data';

/* - Importing a CSV file */
proc import datafile= '~/Courses/PG1V2/data/storm_damage.csv' /* Input file, as a path */
	dbms=csv /* File type, (CSV, tab, xlsx,..) */
	out=storm_damage_import /* Output table (SAS Data Set) */
	replace; /* default behavior is to preserve the out= table if it exists, this changes to replacement of the table */
	getnames=yes;/* use the first row of data as the variable names */ 
run; 

proc contents data = storm_damage_import;
run; 

/*  - Importing a tab file */
proc import datafile="~/Courses/PG1V2/data/storm_damage.tab"
	dbms=tab 
	out=storm_damage_tab
	replace;
	getnames=yes; /* add just incase, regardless of default behavior */
run;


/*  Importing excel data from a single workbook */
proc import datafile='~/Courses/PG1V2/data/eu_sport_trade.xlsx'
	dbms=xlsx
	out=eu_sport_trade
	replace;
	getnames=yes;
run;

proc contents data = eu_sport_trade; 
run;

/* Class Example of importing a specific sheet from an xlsx */
proc import datafile='~/Courses/PG1V2/data/class.xlsx'
	dbms=xlsx
	out=work.class_birthdate
	replace;
	sheet= class_birthdate; /* if non standard name, either put in quotes or add 'n at the end to specify it is a non standard name */ 
	getnames=yes;
run; 

/* This workbook has multiple sheets -- by defualt you get the first one... use sheet = to modify this, as its own statment */

proc contents data = work.class; 
run;

proc means data=work.class; 
	var height 'weight'n;
run;


proc import datafile= '~/Courses/PG1V2/data/np_traffic.csv' 
	dbms=csv
	out=np_traffic_import 
	replace;
	guessingrows = max; /* avoids truncation within the rows, by defualt- this is set to 20 */ 
	getnames=yes;
run;

proc contents data = np_traffic_import;
run;

/* do the challenge for activity 3 in lesson 2 */