libname pg2 '~/Courses/PG2V2/data';

*Lesson 5 Level Challenge Practice;

*Sort the three tables;
proc sort data=pg2.np_CodeLookup out=sortnames(keep=ParkName ParkCode);
    by ParkName;
run;

proc sort data=pg2.np_final out=sortfinal;
    by ParkName;
run;

proc sort data=pg2.np_species
	out = birds(Keep= ParkCode Species_ID Scientific_Name Common_Names);
	by ParkCode Species_ID;
	where category='Bird' and Abundance = 'Common';
run;

*Merge 2 of them in one data step;
data highuse(keep=ParkCode ParkName);
    merge sortfinal sortnames;
    by ParkName;
    if DayVisits ge 5000000;
run;

*Sort merged table so that parkcode is in alphabetical order;
proc sort data=highuse;
    by ParkCode;
run;

*Merge the newly merged table of 2 with the last unmerged table;
data birds_largepark;
    merge birds highuse(in=inPark);
    by ParkCode;
    if inPark=1;
run;

***********************************************************;
*  Activity 7.02                                          *;
*  1) Examine the DATA step code and run the program.     *;
*     Uncomment the RETAIN statement and run the program  *;
*     again. Why is the RETAIN statement necessary?       *;
*  2) Add a subsetting IF statement to include only the   *;
*     last row per student in the output table. Run the   *;
*     program.                                            *;
*  3) What must be true of the input table for the DATA   *;
*     step to work?                                       *;
***********************************************************;

data class_wide;
	set pg2.class_test_narrow;
	by Name;
	retain Name Math Reading;

	if TestSubject="Math" then Math=TestScore;
		else if TestSubject="Reading" then Reading=TestScore;
			/*set a new variable corresponding to the score for each different test type */

	if last.name then output;
		/*Output when complete for each student*/

keep Name Math Reading;
run;

***********************************************************;
*  LESSON 7, PRACTICE 1                                   *;
*  a) Highlight the PROC PRINT step and run the selected  *;
*     code. Note that the Tent, RV, and Backcountry       *;
*     columns contain visitor counts.                     *;
*  b) To convert this wide table to a narrow table, the   *;
*     DATA step must create a new column named CampType   *;
*     with the values Tent, RV, and Backcountry, and      *;
*     another new column named CampCount with the numeric *;
*     counts. The DATA step includes statements to output *;
*     a row for CampType='Tent'. Modify the DATA step to  *;
*     output additional rows for RV and Backcountry.      *;
*  c) Add a LENGTH statement to ensure that the values of *;
*     the CampType column are not truncated.              *;
*  d) Run the DATA step. Confirm that each ParkName value *;
*     has three rows corresponding to the Tent, RV, and   *;
*     Backcountry visitor counts.                         *;
***********************************************************;

proc print data=pg2.np_2017camping(obs=10);
run;

data work.camping_narrow(drop=Tent RV Backcountry);
	set pg2.np_2017Camping;
	length CampType $20;

	CampType='Tent'; CampCount=Tent; output; /*make a type and count variable and output*/
	*Add statements to output rows for RV and Backcountry;
	CampType='RV'; CampCount=RV; output;
	CampType='BackCountry'; CampCount=BackCountry; output; /*for each of the camping types*/

	format CampCount comma12.;
run;

data np_2016campwide;

	set pg2.np_2016camping;
	by parkname;

	retain tent backcountry rv;

	select(CampType);	
		when('Tent') Tent=CampCount;
		when('RV') RV=CampCount;
		when('BackCountry') BackCountry=CampCount;
end;

	if last.parkname then output; 

	keep ParkName Tent RV BackCountry; 

run;

/*Default Transpose*/
proc transpose data= pg2.np_2017Camping;
run; /*columns to rows or rows to columns -- numeric values only by default*/

proc transpose data= pg2.np_2017Camping;
	var _all_;
run;/*Always outputs a seperate data set even if you don't say out=*/

/*Use transpose to take np_2016Camping to one record per park*/

proc transpose data=np_2016Camping; 
	by ParkName; /*groups of rows are identified by the parkname -- transposition occurs within each group*/
	var CampCount; /*values to change (column to row) are in campcount*/
run;

proc transpose data=np_2016Camping out=Camp2016T(drop=_name_); 
	by ParkName; 
	var CampCount; 
run;

proc transpose data=np_2016Camping out=Camp2016T2(drop=_name_); 
	by ParkName; 
	var CampCount; 
	id CampType; /*If you have a variable that identifies the rows in each group uniquely, you can use it as 
						a creator for the transposed variable name with the ID statement*/
run;

proc transpose data=Camp2016T2 out=goback; 
	by parkname; 
	var Tent RV BackCountry;
run;

proc transpose data=pg2.np_2017Camping
				out=camp2017T(rename=(_name_ = CampType col1=CampCount));
	by parkname; 
	var Tent RV BackCountry;
run;













