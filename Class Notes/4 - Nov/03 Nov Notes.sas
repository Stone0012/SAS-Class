libname pg2 '~/Courses/PG2V2/data';

proc contents sashelp.class;
	ods select variables;
run;

proc contents pg2.class_new2;
	ods select variables;
run;

data class_current;
	set sashelp.class pg2.class_new2;
/*

	-- Read all records from sashelp.class, once finished read all records from pg2.class_new2

	-- At compilation, the set of variables is determined by sequentially looking at attributes 
		(metadata) for each table  

	-- Columns are aliigned on name and type 
		(Same name + different types = error)
		Other attributes are set by first encounter (null is not an attribute) 
			Length, Label, Format

*/

run;

proc contents class_current;
	ods select position;
run;

data class_currentB;
	set sashelp.class pg2.class_new2(rename=(student=name));
	/*rename can be used for realignment of names*/
run;

data class_currentc;
	length anme $10.;
	set sashelp.class pg2.class_new2(rename=(student=name));
run;

proc contents data=class_currentC varnum;
	ods select position;
run;

***********************************************************;
*  LESSON 5, PRACTICE 1                                   *;
*  a) Complete the SET statement to concatenate the       *;
*     PG2.NP_2015 and PG2.NP_2016 tables to create a new  *;
*     table, NP_COMBINE.                                  *;
*  b) Use a WHERE statement to include only rows where    *;
*     Month is 6, 7, or 8.                                *;
*  c) Create a new column named CampTotal that is the sum *;
*     of CampingOther, CampingTent, CampingRV, and        *;
*     CampingBackcountry. Format the new column with      *;
*     commas.                                             *;
***********************************************************;

proc contents data=pg2.np_2015 varnum;
	ods select position;
run;

proc contents data=pg2.np_2016 varnum;
	ods select position;
run;

data work.np_combine;
    set pg2.np_2015 pg2.np_2016;
	where month in (6,7,8); /*this applies to the tables all the way through processing*/
	CampTotal = sum (of Camping:);
    drop Camping:;
	format CampTotal comma15.;
run;

proc sort data=np_combine;
	by ParkCode;
run;

proc contents data=pg2.np_2014 varnum;
	ods select position;
run;

proc contents data=pg2.np_2015 varnum;
	ods select position;
run;

proc contents data=pg2.np_2016 varnum;
	ods select position;
run;

data work.np_combineB;
    set pg2.np_2014(rename=(Park=ParkCode Type=ParkType)) 
		pg2.np_2015 pg2.np_2016;
	where month in (6,7,8) and ParkType eq 'National Park';
	CampTotal = sum (of Camping:);
    drop Camping:;
	format CampTotal comma15.;
run;

proc sort data=np_combineB;
	by ParkType ParkCode Year Month; /*In this instance could also just sort by parkcode-- everything else is redundant*/
run;


*************************************************************;
*  Activity 5.04                                            *;
*  1) Modify the final DATA step to create an additional    *;
*     table named STORM_OTHER that includes all             *;
*     nonmatching rows.                                     *;
*  2) Drop the Cost column from the STORM_OTHER table only. *;                             *;
*  3) How many rows are in the STORM_OTHER table?           *;
*************************************************************;

proc sort data=pg2.storm_final out=storm_final_sort;
	by Season Name;
run;

data storm_damage;
	set pg2.storm_damage;
	Season=Year(date); /*the original storm_damage data sets doesnt have a season, but we can make one*/
	Name=upcase(scan(Event, -1));
		/*the name in the storm_final data corresponds to the list "word" in the event in storm_damage and we match casing*/
	format Date date9. Cost dollar16.;
	drop event;
run;

/*now that we have variables that will match reords*/
proc sort data=pg2.storm_final out=storm_final_sort;
	by Season Name;
run;

proc sort data=storm_damage;
	by Season Name;
run; /*sort both data sets by these*/

data damage_detail NoDamageInfo NoStormInfo;
	merge storm_final_sort(in=inFinal) storm_damage(in=inDamage);
		/*in= establishes a variable that is 1 if the current record 
			contains a contribution from that table, 0 if not*/
	keep Season Name BasinName MaxWindMPH MinPressure Cost;
	by Season Name;
	if inDamage=1 and inFinal=1 then output damage_detail;
		/*is stating that when we have a match 
				-- contribution from both data sets*/
	  else if initial then output nodamageinfo;
		else if inDamage then output NoStormInfo;
run;

data Full Inner Left Right;
	merge storm_final_sort(in=inFinal) storm_damage(in=inDamage);
	keep Season Name BasinName MaxWindMPH MinPressure Cost;
	by Season Name;
	output Full; 
	if inDamage=1 and inFinal=1 then output Inner;
		if initial then output Left;
		if inDamage then output Right;
run;


***********************************************************;
*  LESSON 5, PRACTICE 3                                   *;
*  a) Submit the two PROC SORT steps. Determine the name  *;
*     of the common column in the sorted tables.          *;
*  b) Modify the second PROC SORT step to use the RENAME= *;
*     option after the PG2.NP_2016TRAFFIC table to rename *;
*     Code to ParkCode. Modify the BY statement to sort   *;
*     by the new column name.                             *;
*  c) Write a DATA step to merge the sorted tables by the *;
*     common column to create a new table,                *;
*     WORK.TRAFFICSTATS. Drop the Name_Code column from   *;
*     the output table.                                   *;
***********************************************************;

*Lesson 5 Level 1 Practice;
proc sort data=pg2.np_codelookup out=work.codesort;
	by ParkCode;
run;

proc sort data=pg2.np_2016traffic(rename=(Code=ParkCode)) out=work.traffic2016Sort;
	by ParkCode month;
run;

data work.trafficStats;
	merge work.traffic2016Sort
		  work.codesort;
	by ParkCode;
	drop Name_Code;
run;


data work.trafficStatsb;
	merge work.traffic2016Sort(in=inTraffic)
		  work.codesort;
	by ParkCode;
	if inTraffic;
	drop Name_Code;
run;


*Lesson 5 Level 2 Practice;
proc sort data=pg2.np_CodeLookup
          out=work.sortedCodes;
    by ParkCode;
run;

proc sort data=pg2.np_2016
          out=work.sorted_code_2016;
    by ParkCode;
run;

data work.parkStats(keep=ParkCode ParkName Year Month DayVisits)
     work.parkOther(keep=ParkCode ParkName);
    merge work.sorted_code_2016(in=inStats) work.sortedCodes;
    by ParkCode;
    if inStats=1 then output work.parkStats;
    else output work.parkOther;
run;



















