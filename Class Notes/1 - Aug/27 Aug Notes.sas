libname SASData '~/SASData';

/**
Comparison (equal) symbol (=) mnemonic (eq) 

Comparison (not equal) symbol (^) mnemonic (ne) 

Comparison (greater than) symbol (>) mnemonic (gt) 

Comparison (greater or equal) symbol (>=) mnemonic (ge) 

Comparison (less than) symbol (<) mnemonic (lt) 

Comparison (less or equal) symbol (<=) mnemonic (le) 

Compound condition (and) 

Compound condition (or)  
**/

/** You can limit the data processed with WHERE statements**/
Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region eq 'Beaumount' or region eq 'Boston';
/** Only processes records for which the condition is true*
		-- character values are case-sensative*/
footnote 'Stratified on Poultion Type and Region';  
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region eq 'Beaumount' or pol_type eq 'CO';
/** Compound conditions have to be complete on eache side of and/or
	-- evaluation of variables or values on their own is based on
		0/null being false, all other values = true
**/ 
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region in ('Beaumount' 'Boston'); /** This is the same as example on line 38**/ 
/** IN allows for a space or comma seperated list to be give in parentheses, 
	if any value is matched, the condition is true (its an or set) **/
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region not in ('Beaumount' 'Boston'); 
/** NOT is a negation of the condition **/
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects mean median std;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where jobtotal le 80000 and jobtotal ge 50000; 
/**  **/
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects mean median std;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where jobtotal between 50000 and 80000; 
/** Between A and B is avaiable for simplyfying ranges **/
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects mean median std;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region between 'A' and 'M'; 
/** Between A and B does work for character, it uses 
	Alphabetical ordering with case-sensitivity **/
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects mean median std;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where pol_type contains 'O'; 
/** contains 'string' looks for that string anywhere in the variable value 
		and returns true if it is present atleast once **/
run; 


Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects mean median std;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region not contains 'B'; 
/** contains can be negated as well **/
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects mean median std;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region like 'B%'; 
/** You can use LIKE with two types of wildcards
	% -- any number of characters, including 0 
	_ -- is exactley one character **/
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects mean median std;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region like '%B%'; /** same as line 117 **/
/** **/
run;

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects mean median std;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region like '%o%o%'; 
/** **/
run;

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region not in ('Beaumount' 'Boston')
		and pol_type contains 'O';
/** **/
run; 


Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects (where = (region not in ('Beaumount' 'Boston'))) 
			min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
		and pol_type contains 'O';
/** WHERE (as WHERE =) is a data set option**/
run; 

Title ' Five Number Summary'; 
Title2 ' On Equiptment, personnel, and Total Cost'; 
proc means data=sasdata.projects min q1 median q3 max;
	var equipmnt personel jobtotal;
	class pol_type region; 
	where region not in ('Beaumount' 'Boston')
		and pol_type contains 'O';
ods output summary=work.means(where=(nobs ge 60));
/** can use WHERE to condition output without changing the structure of the data**/
run; 

/** Practice Exercise **/

proc means data=sasdata.index n q1 median q3 mean std;
	var r1000value r1000growth; 
run; 

proc means data=sasdata.index n q1 median q3 mean std;
	var r1000:; 
/** name with a : refrences any variable that starts with 
	the prefix characters and has any other characters
	(including none) after **/ 
run; 

proc means data=sasdata.index n q1 median q3 mean std nonobs;
	var r1000value r1000growth; 
	class dt; 
	format dt monname.;
run;
















