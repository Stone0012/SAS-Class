libname pg2 '~/Courses/PG2V2/data';

***********************************************************;
*  Activity 1.05b (SAS Studio)                            *;
*  1) Run the program. Observe the values of Year and     *;
*     ProjectedSales written in the log.                  *;
*  2) How many rows are in the input and output tables?   *;
***********************************************************;

data forecast;
	set sashelp.shoes;

	Year=1;
	ProjectedSales=Sales*1.05; /* 5% increases */
	putlog Year= ProjectedSales= _N_=;
	Year=2;
	ProjectedSales=ProjectedSales*1.05;
	putlog Year= ProjectedSales= _N_=;
	Year=3;
	ProjectedSales=ProjectedSales*1.05;
	putlog Year= ProjectedSales= _N_=;

/* output effectively occurs here, only the projection for 
		year 3 goes to the final data set */

	format ProjectedSales dollar10.;
	keep Region Product Subsidiary Year ProjectedSales;
run;

data forecast;
	set sashelp.shoes;

	Year=1;
	ProjectedSales=Sales*1.05; 
	output; /* output a projection each time it is made */
	Year=2;
	ProjectedSales=ProjectedSales*1.05;
	output; /* here also */
	Year=3;
	ProjectedSales=ProjectedSales*1.05;
	output; /* need this one also-- any explicit output statement anywhere 
				in a data step turns off all implicit output 
				this occurs during compilation */


	format ProjectedSales dollar10.;
	keep Region Product Subsidiary Year ProjectedSales;

run;

data OK ReallBad;
	set sashelp.heart; 
	if chol_status eq 'Really Bad' then output ReallBad; 
/* this if is never true, bt there is still no implicit output */
run;


***********************************************************;
*  LESSON 1, PRACTICE 3                                   *;
*  a) Modify the DATA step to create three tables:        *;
*     monument, park, and other. Use the value of         *;
*     ParkType as indicated above to determine which      *;
*     table the row is output to.                         *;
*  b) Drop ParkType from the monument and park tables.    *;
*     Drop Region from all three tables.                  *;
*  c) Submit the program and verify the output.           *;
***********************************************************;

data  monument park other;
	set pg2.np_yearlytraffic;

	if ParkType eq 'National Monument' then output Monument; 
		else if ParkType eq 'National Park' then output Park;
			else output Other;
run;

data  monument park other;
	set pg2.np_yearlytraffic;

	if find(ParkType, 'Monument') ne 0 then output Monument; 
		else if find(ParkType, 'Park') then output Park;
			else output Other;
/* find(expression,target) searches for the target string in the expression and 
	returns the first position where the target is found. If it is not found
	it returns 0 

	the index function works in a similar way*/
run;

data  monument park other;
	set pg2.np_yearlytraffic;

	if scan(ParkType,2) eq 'Monumnet' then output Monument; 
		else if scan(ParkType,2) eq 'Park' then output Park;
			else output Other;
/* scan (expression,word) pcisk the word from teh given position 
	the string based on a defaults set of delimiters (which you can change*/
run;

data  monument(drop=ParkType) park(drop=ParkType) other; /*drop from specific tables */ 
	set pg2.np_yearlytraffic (drop=region); /* drop from all tables */

	if scan(ParkType,2) eq 'Monumnet' then output Monument; 
		else if scan(ParkType,2) eq 'Park' then output Park;
			else output Other;
run;

data camping(keep=ParkName Month DayVisits CampTotal) 
	lodging(keep= ParkName Month DayVisits LodgingOther); 
	set pg2.np_2017; 

	*CampTotal = sum(CampingOther, CampingTest, CampingRV, CampingBackcountry);
	CampTotal = sum(of camping:); /* sum (arg1,arg1,...) or sume(of varlist) adds up columns, irgnoring missing */

	if CampTotal gt 0 then output camping;
	if lodgingother gt 0 then output lodging;
run;

***********************************************************;
*  LESSON 1, PRACTICE 5                                   *;
*  rewrite this replacing the if-then-else with a 		  *;
*   select block 								          *;
***********************************************************;

/* Practice 3 program */
data  monument(drop=ParkType) park(drop=ParkType) other; /*drop from specific tables */ 
	set pg2.np_yearlytraffic (drop=region); /* drop from all tables */

	if scan(ParkType,2) eq 'Monumnet' then output Monument; 
		else if scan(ParkType,2) eq 'Park' then output Park;
			else output Other;
run;
















