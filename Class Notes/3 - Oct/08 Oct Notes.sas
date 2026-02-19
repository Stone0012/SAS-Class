libname pg2 '~/Courses/PG2V2/data';

***********************************************************;
*  Activity 2.01                                          *;
*  1) Modify the program to retain TotalRain and set the  *;
*     initial value to 0.                                 *;
*  2) Run the program and examine the results. Why are    *;
*     all values for TotalRain missing after row 4?       *;
*  3) Change the assignment statement to use the SUM      *;
*     function instead of the plus symbol. Run the        *;
*     program again. Why are the results different?       *;
***********************************************************;

data zurich2017;
	set pg2.weather_zurich;
	retain TotalRain 0; /* does not need an 'eq' designation*/
	TotalRain= sum(TotalRain,Rain_mm);
run;

data zurich2017;
	set pg2.weather_zurich;

	TotalRain + Rain_mm;
		/* Sum Statement: [same as sum(TotalRain,Rain_mm)]
			a+b; a= variable, b = expression
			a is automatically retained and initialized to 0 
			a+b does the operation, ignoring missings, and stores back in a */
run;


***********************************************************;
*  LESSON 2, PRACTICE 1                                   *;
*  a) Open the PG2.NP_YEARLYTRAFFIC table. Notice the     *;
*     Count column records the number of cars that have   *;
*     passed through a particular Location.               *;
*  b) Modify the DATA step to create a column, totTraffic,*;
*     that is the running total of Count.                 *;
*  b) Keep the ParkName, Location, Count, and             *;
*     totTraffic columns in the output table.             *;
*  c) Format totTraffic so values are displayed with      *;
*     commas.                                             *;
***********************************************************;

data totalTraffic;
    set pg2.np_yearlyTraffic;

	totTraffic + Count;
	
	keep ParkName Location Count totTraffic;
	format totTraffic comma15.;

run;

data ParkTypeTraffic;
    set pg2.np_yearlyTraffic;

	where scan(ParkType, 2) in ('Monument', 'Park');

	if scan(ParkType, 2) eq 'Monument' then MonumentTraffic + Count; 
		else ParkTraffic + Count;

	format MonumentTraffic ParkTraffic comma15.;

run;

/* if I really want the grant totals ... */
data ParkTypeTraffic;
    set pg2.np_yearlyTraffic end=finish;
/* end=variable is an indicator for the final record-- 1 on final record, 0 otherwise */

	where scan(ParkType, 2) in ('Monument', 'Park');

	if scan(ParkType, 2) eq 'Monument' then MonumentTraffic + Count; 
		else ParkTraffic + Count;

	if finish then output;
	keep MonumentTraffic ParkTraffic;

	format MonumentTraffic ParkTraffic comma15.;

run;

proc means data =  pg2.np_yearlyTraffic sum;
	where scan(ParkType, 2) in ('Monument', 'Park');
	class  ParkType; 
	var count; 
	ods output summary=TrafficSum; 
run;	


























