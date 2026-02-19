libname pg2 '~/Courses/PG2V2/data';

/* Understanding Data Step Processing */ 

data storm_complete;
	set pg2.storm_summary_small; 
	length Ocean $ 8;
	*drop EndDate;
		/* drop is a compile-time statement, and flags 
			column(s) to be dropped from the output data set, 
			this / these are available during processing/execution */
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;
	if substr(Basin,2,1)="I" then Ocean="Indian";
	else if substr(Basin,2,1)="A" then Ocean="Atlantic";
	else Ocean="Pacific";
	drop EndDate; /* position does not matter for drop statement */
run;

proc contents data=storm_complete;
run;

data problem;
	set pg2.storm_summary_small (drop=EndDate); 
		/* here I am dropping it from the input data... bad idea */
	length Ocean $ 8;
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;
	if substr(Basin,2,1)="I" then Ocean="Indian";
	else if substr(Basin,2,1)="A" then Ocean="Atlantic";
	else Ocean="Pacific";
run;

data Noproblem (drop=EndDate); /* same effect as Drop EndDate; */
	set pg2.storm_summary_small; 
	length Ocean $ 8;
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;
	if substr(Basin,2,1)="I" then Ocean="Indian";
	else if substr(Basin,2,1)="A" then Ocean="Atlantic";
	else Ocean="Pacific";
run;


data storm_complete;
	set pg2.storm_summary_small; 
	length Ocean $ 8;
		/*where does this need to be to avoid the truncation of ocean 
			-- anywhere before the first if statement */
	drop EndDate;
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;
	if substr(Basin,2,1)="I" then Ocean="Indian";
	else if substr(Basin,2,1)="A" then Ocean="Atlantic";
	else Ocean="Pacific";
run;


***********************************************************;
*  Syntax                                                 *;
*     PUTLOG _ALL_;                                       *;
*     PUTLOG column=;                                     *;
*     PUTLOG "message";                                   *;
***********************************************************;

data storm_complete;
	set pg2.storm_summary_small(obs=10); 
 	  	putlog "PDV after SET statement";
		putlog _all_; 
	length Ocean $ 8;
	drop EndDate;
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;
		putlog StormLength=;
	if substr(Basin,2,1)="I" then Ocean="Indian";
	else if substr(Basin,2,1)="A" then Ocean="Atlantic";
	else Ocean="Pacific";
	*Add PUTLOG statements;
run;

data storm_complete;
	set pg2.storm_summary_small(obs=10); 
 	  	putlog "PDV after SET statement";
		putlog _all_; 
	length Ocean $ 8;
	drop EndDate;
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;
		putlog StormLength=;
	if substr(Basin,2,1)="I" then Ocean="Indian";
	else if substr(Basin,2,1)="A" then Ocean="Atlantic";
	else Ocean="Pacific";
	putlog "Note: PDV at the end of the iteration";
	putlog _all_;
run;

***********************************************************;
*  LESSON 1, PRACTICE 2                                   *;
*  a) Examine the program and answer the following        *;
*     questions.                                          *;
*     1) Which statements are compile-time only?   		  *;
*     2) What will be assigned for the length of Size?	  *;
*  b) Run the program and examine the results.            *;
*  c) Modify the program to resolve the truncation of     *;
*     Size. Read the first 5 rows from the input table.   *;
*  d) Add PUTLOG statements to provide the following      *;
*     information in the log:                             *;
*     1) Immediately after the SET statement, write START *;
*        DATA STEP ITERATION to the log as a color-coded  *;
*        note.                                            *;
*     2) After the Type= assignment statement, write the  *;
*        value of Type to the log.                        *;
*     3) At the end of the DATA step, write the contents  *;
*        of the PDV to the log.                           *;
*  e) Run the program and read the log to examine the     *;
*     messages written during execution.                  *;
***********************************************************;

data np_parks;
	set pg2.np_final (obs=5);
		putlog "Note: Start Data Step Iteration";
		putlog _all_;
	length Size $ 8;
	keep Region ParkName AvgMonthlyVisitors Acres Size;
    where Type="PARK"; 
	format AvgMonthlyVisitors Acres comma10.;
    Type=propcase(Type);
	AvgMonthlyVisitors=sum(DayVisits,Campers,OtherLodging)/12;
		putlog type = AvgMonthlyVisitors;
	if Acres<1000 then Size="Small";
	else if Acres<100000 then Size="Medium";
	else Size="Large";
		putlog "Note: PDV at the end of the iteration";
		putlog _all_;
run;

data np_parks; /* Stylistic ReWrite */ 
	set pg2.np_final (obs=5);
    where Type="PARK";

	length Size $ 8;

	Type=propcase(Type);
	AvgMonthlyVisitors=sum(DayVisits,Campers,OtherLodging)/12;
		if Acres<1000 then Size="Small";
			else if Acres<100000 then Size="Medium";
			else Size="Large";

	format AvgMonthlyVisitors Acres comma10.;
	keep Region ParkName AvgMonthlyVisitors Acres Size;

run;

























