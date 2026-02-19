libname pg2 '~/Courses/PG2V2/data';

***********************************************************;
*  Activity 3.01                                          *;
*  1) Run the program. Why does the DATA step fail?       *;
*     Correct the error by overwriting the value of the   *;
*     column Name in uppercase.                           *;
*  2) Examine the expressions for Mean1, Mean2, and       *;
*     Mean3. Each one is a method for specifying a list   *;
*     of columns as arguments in a function. Run the      *;
*     program and verify that the values in these three   *;
*     columns are the same.                               *;
*  3) In the expression for Mean2, delete the keyword OF  *;
*     and run the program. What do the values in Mean2    *;
*     represent?                                          *;
***********************************************************;

data quiz_summary;
	set pg2.class_quiz;

	Name = upcase(Name);

	Mean1=mean(Quiz1, Quiz2, Quiz3, Quiz4, Quiz5);
	/* Numbered Range: col1-coln where n is a sequential number */ 

	Mean2=mean(of Quiz1-Quiz5);
	/* Name Prefix: all columns that begin with the specified character string */ 

	Mean3=mean(of Q:);

	Mean4 = mean(of Quiz1 -- Quiz5);
		/* varA -- varB is all variables between varA and VarB in their column order (inclusive) */
run;

***********************************************************;
*  Activity 3.02                                          *;
*  1) Examine the program and notice that all quiz scores *;
*     for two students are changed to missing values.     *;
*     Highlight the first DATA step and submit the        *;
*     selected code.                                      *;
*  2) In a web browser, access SAS Help at                *;
*     http://support.sas.com/documentation. In the Syntax *;
*     Shortcuts section, click the Programming: SAS 9.4   *;
*     and Viya link.                                      *;
*  3) In the Syntax - Quick Links section, click CALL     *;
*     Routines. Use the documentation to read about the   *;
*     CALL MISSING routine.                               *;
*  4) Simplify the second DATA step by using CALL MISSING *;
*     to assign missing values for the two students' quiz *;
*     scores. Run the step.                               *;
***********************************************************;

/* Step 1 */
data quiz_report;
    set pg2.class_quiz;
	if Name in("Barbara", "James") then do;
		Quiz1=.;
		Quiz2=.;
		Quiz3=.;
		Quiz4=.;
		Quiz5=.;
	end;
run;

/* Step 4 */
data quiz_report;
    set pg2.class_quiz;
	if Name in("Barbara", "James") then call missing(of Quiz:);
run;

***********************************************************;
*  Activity 3.03                                          *;
*  1) Notice that the expressions for WindAvg1 and        *;
*     WindAvg2 are the same. Run the program and examine  *;
*     the output table.                                   *;
*  2) Modify the WindAvg1 expression to use the ROUND     *;
*     function to round values to the nearest tenth (.1). *;
*  3) Add a FORMAT statement to format WindAvg2 with the  *;
*     5.1 format. Run the program. What is the difference *;
*     between using a function and a format?              *;
***********************************************************;

data wind_avg;
	set pg2.storm_top4_wide;
	*WindAvg1=mean(of Wind1-Wind4); 
	WindAvg1=round(mean(of Wind1-Wind4),.1); 
	WindAvg2=mean(of Wind1-Wind4); 
	format windAvg2 5.1;

	diff = windAvg1 - windAvg2; 
		/*Round is not the same as formatting, 
			rounding changes the value 
			formatting only changes the display */

	*windAvg1 = round(windAvg1, .1);
		/* round(expression, percision) -- percision is expressed 
			with a 1 in the place of desired precision 
			e.g. 0.01 is the nearest hundredth */
run;

***********************************************************;
*  Activity 3.04                                          *;
*  1) Notice that the INTCK function does not include the *;
*     optional method argument, so the default discrete   *;
*     method is used to calculate the number of weekly    *;
*     boundaries (ending each Saturday) between StartDate *;
*     and EndDate.                                        *;
*  2) Run the program and examine rows 8 and 9. Both      *;
*     storms were two days, but why are the values        *;
*     assigned to Weeks different?                        *;
*  3) Add 'c' as the fourth argument in the INTCK         *;
*     function to use the continuous method. Run the      *;
*     program. Are the values for Weeks in rows 8 and 9   *;
*     different?                                          *;
***********************************************************;
*  Syntax Help                                            *;
*     INTCK('interval', start-date, end-date, <'method'>) *;
*         Interval: WEEK, MONTH, YEAR, WEEKDAY, HOUR, etc.*;
*         Method: DISCRETE (D) or CONTINUOUS (C)          *;
***********************************************************;

data storm_length;
	set pg2.storm_final(obs=10);
	keep Season Name StartDate Enddate StormLength Days Weeks;

	Weeks = intck('week', StartDate, EndDate);
		/* intck counts time intervals, default separator 
			is discrete -- traditional boundry 
				- Sat/Sun for week 
				- Last day / first day of month 
				- Dec 31 / Jan 1 for year */
	WeeksB = intck('week', StartDate, EndDate, 'c');
		/* coninious -- counts the number of days and divides ... */		
	Days = EndDate - StartDate;

	format startdate enddate weekdate.;
run;

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

data projections; 
	set StormSort; 

	projDate1 = intnx ('year',StartDate, 1);
	projDate8 = intnx ('year',StartDate, 8);

	projDate1E = intnx ('year',StartDate, 1, 'end');
	projDate8E = intnx ('year',StartDate, 8, 'end');

	projDate1S = intnx ('year',StartDate, 1, 'same');
	projDate8S = intnx ('year',StartDate, 8, 'same');

	format proj: weekdate.;
	keep startdate proj:;
run;

data projectionsb; 
	set StormSort; 
	by basin; 
	retain ProjFirst; 

	if first.basin then projFirst = intnx ('year',StartDate, 1, 'same');
	if last.basin then do; 
		projlast = intnx ('year',StartDate, 1, 'same');
	output;
end;


	format proj: weekdate.;
	keep basin proj:;
run;

/* make the projected earliest first storm three weeks prior to the 
	current first storm in a basin, 
	projected latest three weeks after the last storm */



















