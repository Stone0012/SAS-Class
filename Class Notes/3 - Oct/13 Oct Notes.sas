libname pg2 '~/Courses/PG2V2/data';

data cuyahoga_maxtraffic;
    set pg2.np_monthlyTraffic;

	where scan (ParkName, 1) eq 'Cuyahoga';
    retain TrafficMax 0 MonthMax LocationMax;

    if Count gt TrafficMax then do; /* if the new one is the largest ... */
        TrafficMax=Count;
        MonthMax=Month;
        LocationMax=Location;
    end;

    format Count TrafficMax comma15.;
    keep Location Month Count TrafficMax MonthMax LocationMax;
run;

/* -- Processing Data in Groups -- */

***********************************************************;
*  Activity 2.03                                          *;
*  1) Modify the PROC SORT step to sort the rows within   *;
*     each value of Basin by MaxWindMPH. Highlight the    *;
*     PROC SORT step and run the selected code. Which row *;
*     within each value of Basin represents the storm     *;
*     with the highest wind?                              *;
*  2) Add the following WHERE statement immediately after *;
*     the BY statement in the DATA step. The intent is to *;
*     include only the last row within each value of      *;
*     Basin. Does the program run successfully?           *;
*        where last.Basin=1;                              *;
***********************************************************;

proc sort data=pg2.storm_2017 out=storm2017_sort;
	by Basin descending MaxWindMPH;
run;

*this is wrong;
data storm2017_max;
	set storm2017_sort;
	by Basin;

	where first.Basin eq 1; 
		/* first. and last. variables are created during execution, 
			they are not part of the input table, which is what where 
			always refrences */ 

	StormLength=EndDate-StartDate;
	MaxWindKM=MaxWindMPH*1.60934;
run;

*this is right;
data storm2017_max;
	set storm2017_sort;
	by Basin;
	if first.Basin eq 1; 
		/* subsetting If (if with no then)--
			process the remaining statements (and 
			implicit output, if active) when the 
			statement is true */
	StormLength=EndDate-StartDate;
	MaxWindKM=MaxWindMPH*1.60934;
run;

**************************************************;
*  Activity 2.05                                 *;
*    Add a subsetting IF statement to output     *;
*    only the final day of each month.           *;
**************************************************;

proc contents data=pg2.weather_houston;
run;

data houston_monthly;
	set pg2.weather_houston;
	by Month;

	if first.Month=1 then MTDRain=0;
	MTDRain+DailyRain;

	if last.Month=1 then output;

	keep Date Month DailyRain MTDRain;
run;       

***********************************************************;
*  LESSON 2, PRACTICE 4                                   *;
*  a) Complete the PROC SORT step to sort the             *;
*     PG2.NP_YEARLYTRAFFIC table by ParkType and ParkName.*;
*  b) Modify the DATA step as follows:                    *;
*     1) Read the sorted table created in PROC SORT.      *;
*     2) Add a BY statement to group the data by ParkType.*;
*     3) Create a column, TypeCount, that is the running  *;
*        total of Count within each ParkType.             *;
*     4) Format TypeCount so values are displayed with    *;
*        commas.                                          *;
*     5) Keep only the ParkType and TypeCount columns.    *;
*  c) Run the program and confirm TypeCount is reset at   *;
*     the beginning of each ParkType group.               *;
*  d) Modify the program to write only the last row for   *;
*     each ParkType to the output table.                  *;
***********************************************************;

proc sort data=pg2.np_yearlyTraffic   
          out=sortedTraffic(keep=ParkType ParkName 
                                      Location Count);
    by ParkType Parkname;
run;

data TypeTraffic;
    set sortedTraffic;
	by ParkType; /* just have to match hierachy of proc sort statement */
	
	if first.ParkType then TypeCount = 0; /* reset count for each different type */
		
	TypeCount + Count; /* add to my accumlator */

	if last.ParkType then output; /* at the end of each type, output the results */
	

	format TypeCount comma12.;
	keep ParkName TypeCount;	
run;


proc sort data=sashelp.shoes out=sort_shoes;
    by Region Product;
run;

data profitsummary;
    set sort_shoes;
    by Region Product;

    Profit=Sales-Returns;

    if first.Product then TotalProfit=0;

    TotalProfit+Profit; /* or totalprofit = sales - returns -- a + b; a(has to be variable), b(can be expression) */

	if last.Product then output; 

    format TotalProfit dollar12.;
	keep Region Product TotalProfit;
run;


/* Exercises for Home */ 

proc sort data=pg2.np_acres 
          out=sortedAcres(keep=Region ParkName State GrossAcres);
    by Region ParkName;
run;
	
data multiState singleState;
    set sortedAcres;
    by Region ParkName;

    if First.ParkName=1 and Last.ParkName=1 
        then output singleState;
	else output multiState;

    format GrossAcres comma15.;
run;

/* re do this one to get the same set of maz variables for all parks of any type */
data cuyahoga_maxtraffic;
    set pg2.np_monthlyTraffic;

	where scan (ParkName, 1) eq 'Cuyahoga';
    retain TrafficMax 0 MonthMax LocationMax;

    if Count gt TrafficMax then do; /* if the new one is the largest ... */
        TrafficMax=Count;
        MonthMax=Month;
        LocationMax=Location;
    end;

    format Count TrafficMax comma15.;
    keep Location Month Count TrafficMax MonthMax LocationMax;
run;














