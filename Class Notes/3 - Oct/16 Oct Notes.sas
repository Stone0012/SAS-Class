libname pg2 '~/Courses/PG2V2/data';


proc sort data=pg2.storm_final out=StormSort;
	by basin startdate; 
	where season eq 2017;
run;

/* use the most recent year's storms to project a first-storm 
	and last storm start date
	
	First storm projected date is the same as the first storm 
		moved into the next year 
	Same idea for the last storm
 */

data projectionsb; 
	set StormSort; 
	by basin; 
	retain ProjFirst; 

	if first.basin then projFirst = intnx('week',intnx ('year',StartDate, 1, 'same'),-3,'same');
	if last.basin then do; 
		projlast = intnx('week',intnx ('year',StartDate, 1, 'same'),3,'same');
	output;
end;


	format proj: weekdate.;
	keep basin proj:;
run;

***********************************************************;
*  LESSON 3, PRACTICE 1                                   *;
*  a) Highlight the PROC PRINT step and run the selected  *;
*     code. Examine the column names and the 10 rows      *;
*     printed from the np_lodging table.                  *;
*  b) Use the LARGEST function to create three new        *;
*     columns (Stay1, Stay2, and Stay3) whose values are  *;
*     the first, second, and third highest number of      *;
*     nights stayed from 2010 through 2017.               *;
*  c) Use the MEAN function to create a column named      *;
*     StayAvg that is the average number of nights stayed *;
*     for the years 2010 through 2017. Use the ROUND      *;
*     function to round values to the nearest integer.    *;
*  d) Add a subsetting IF statement to output only rows   *;
*     with StayAvg greater than zero. Highlight the DATA  *;
*     step and run the selected code.                     *;
***********************************************************;

proc print data=pg2.np_lodging(obs=10);
	where CL2010>0;
run;

data stays;
	set pg2.np_lodging;

	stayAvg = round(mean(of CL:),1);

	if stayAvg gt 0;

	stay1 = largest(1,of CL:);
	stay2 = largest(2,of CL:);
	stay3 = largest(3,of CL:);

	format Stay: comma11.;
	keep Park Stay:;
run;

*alternate way to accomplish same as above using a loop/array;
data staysB;
	set pg2.np_lodging;

	array stay (3); /* creates stay1, stay2, stay3 as data set
						variables but you can reference with an
						index stay(k)*/
		do i = 1 to 3; 
		stay(i)= largest(i, of CL:);
	end;

	format Stay: comma11.;
	keep Park Stay:;
run;

***********************************************************;
*  LESSON 3, PRACTICE 2                                   *;
*  a) Run the program and notice that each row includes a *;
*     datetime value and rain amount. The                 *;
*     MonthlyRainTotal column represents a cumulative     *;
*     total of Rain for each value of Month.              *;
*  b) Uncomment the subsetting IF statement to continue   *;
*     processing a row only if it is the last row within  *;
*     each month. After the subsetting IF statement,      *;
*     create the following new columns:                   *;
*     1) Date - the date portion of the DateTime column   *;
*     2) MonthEnd - the last day of the month             *;
*  c) Format Date and MonthEnd as a date value and keep   *;
*     only the StationName, MonthlyRainTotal, Date, and   *;
*     MonthEnd columns.                                   *;
***********************************************************;

data rainsummary;
	set pg2.np_hourlyrain;
	by Month;

	if first.Month=1 then MonthlyRainTotal=0;
	MonthlyRainTotal+Rain;

	if last.Month=1;
	date = datepart(datetime); 
	Monthend = intnx('month',date,0,'end');

	format date MonthEnd mmddyy10.;
	keep StationName MonthlyRainTotal Date MonthEnd;

run;

***********************************************************;
*  Activity 3.06                                          *;
*  1) Complete the NewLocation assignment statement to    *;
*     use the COMPBL function to read Location and        *;
*     convert each occurrence of two or more consecutive  *;
*     blanks into a single blank.                         *;
*  2) Complete the NewStation assignment to use the       *;
*     COMPRESS function with Station as the only          *;
*     argument. Run the program. Which characters are     *;
*     removed in the NewStation column?                   *;
*  3) Add a second argument in the COMPRESS function to   *;
*     remove both the space and hyphen. Both characters   *;
*     should be enclosed in a single set of quotation     *;
*     marks. Run the program.                             *;
***********************************************************;
*  Syntax Help                                            *;
*     COMPBL(string)                                      *;
*     COMPRESS (string <, characters>)                    *;
***********************************************************;

proc freq data=pg2.weather_japan;
	table Location Station;
run;

data weather_japan_clean;
    set pg2.weather_japan;	

    NewLocation= compbl(Location);
    NewStation= compress(Station,'- ') ;
	/* default compression is all spaces.. 
		-you can choose characters to compress 
		-it is treated as a list of individual characters 
			if more than one is supplied*/
run;

***********************************************************;
*  Activity 3.07                                          *;
*  1) Notice the subsetting IF statement that writes rows *;
*     to output only if Prefecture is Tokyo. Run the      *;
*     program and notice that the output table does not   *;
*     include any rows.                                   *;
*  2) Either use the DATA step debugger in Enterprise     *;
*     Guide or uncomment the PUTLOG statement to view the *;
*     values of Prefecture as the step executes. Why is   *;
*     the subsetting IF condition always false?           *;
*  3) Modify the program to correct the logic error. Run  *;
*     the program and confirm that four rows are          *;
*     returned.                                           *;
***********************************************************;

data weather_japan_clean;
	set pg2.weather_japan;

	Location = compbl(Location);

	CityA = scan(Location, 1, ',');
	CityB = propcase(CityA, ' '); 

	Prefecture = scan(Location, 2, ', ');
		/* space is in the default delimiter set, 
			but so is dash*/

	*putlog Prefecture $quote20.;

	if Prefecture="Tokyo";
run;
































