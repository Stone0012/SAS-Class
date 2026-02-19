libname pg2 '~/Courses/PG2V2/data';

***********************************************************;
*  LESSON 3, PRACTICE 5                                   *;
*  a) Notice that the DATA step creates a table named     *;
*     PARKS and reads only those rows where ParkName ends *;
*     with NP.                                            *;
*  b) Modify the DATA step to create or modify the        *;
*     following columns:                                  *;
*     1) Use the SUBSTR function to create a new column   *;
*        named Park that reads each ParkName value and    *;
*        excludes the NP code at the end of the string.   *;
*        Note: Use the FIND function to identify the      *;
*        position number of the NP string. That value can *;
*        be used as the third argument of the SUBSTR      *;
*        function to specify how many characters to read. *;
*     2) Convert the Location column to proper case. Use  *;
*        the COMPBL function to remove any extra blanks   *;
*        between words.                                   *;
*     3) Use the TRANWRD function to create a new column  *;
*        named Gate that reads Location and converts the  *;
*        string Traffic Count At to a blank.              *;
*     4) Create a new column names GateCode that          *;
*        concatenates ParkCode and Gate together with a   *;
*        single hyphen between the strings.               *;
***********************************************************;

data parks;
	set pg2.np_monthlytraffic;
	where find(Parkname,'NP');

	Park1 = substr(ParkName,4);
	Park2 = substr(ParkName,3);

	locateNP = find(Parkname,'NP');

	ParkNameR = substr(parkname, 1,find(Parkname,'NP')-1 );

	ParkNameR2 = tranwrd(Parkname, 'NP', '');
		/*tranwrd(expression, search-string,replacement-string*/

	*Gate = tranwrd(lowcase(location),'traffic count at', ''); 
	*Gate = tranwrd(Propcase(location),'Traffic Count At', ''); 
	*Gate = tranwrd(Propcase(location),'Traffic Count At ', ''); 
													/*^^ this is still a space*/
	*Gate = transtrn(Propcase(location),'Traffic Count At ', ''); 
													/*^^ literal interpretation is a space*/
	*Gate = transtrn(Propcase(location),'Traffic Count At ',trimn(''); 
													/*^^ this is a null character*/
	if find(propcase(locatiton), 'Traffic Count At ') eq 1
		then Gate = substr(propcase(location),18);
		else gate=location;

	location = propcase(compbl(location));

	GateCode = catx('-',ParkCode,Gate);

	keep ParkName: locateNP ParkNameR ParkNameR2 Gate:;

run;

data test; 
	set pg2.storm_2017; 
	length StDate $10; 

	StDate = StartDate; 
run;

***********************************************************;
*  Activity 3.10                                          *;
*  1) Highlight the PROC CONTENTS step and run the        *;
*     selected code. What is the type of High, Low, and   *;
*     Volume?                                             *;
*  2) Highlight the DATA and PROC PRINT steps and run the *;
*     selected code. Notice that although High is a       *;
*     character column, the Range column is accurately    *;
*     calculated.                                         *;
*  3) Open the log. Read the note printed immediately     *;
*     after the DATA step.                                *;
*  4) Uncomment the DailyVol assignment statement and run *;
*     the program. Is DailyVol created successfully?      *;
***********************************************************;

proc contents data=pg2.stocks2;
run;

data work.stocks2;
	set pg2.stocks2;
	length vol h 8; 

	vol = volume; /*this has commas, does not convert by default*/
	h = high; /* all legal characters for a numeric value, convert correctly*/

   Range=High-Low; /* This workds */
   DailyVol=Volume/30; /* This does not work */
run;


data work.stocks2;
	set pg2.stocks2;
	
	Range = input(High, best12.) - Low; /*Bestw. is a generic number format*/
	DailyVol = input (Volume, comma14.) / 30;  /*make sure you use a sufficient width on your format*/
	DateValue = input (date,date9.);

	WordDate = strip(put (DateValue, weekdate.));
		/* put(source,format) converts to character using the format given*/

	Format Datvalue mmddyy10. ; 
run;


proc format; 	
	value $pollutant

	'CO' = 
	'Lead'=
	'SO2'= 
	'O3' =
	'TSP'=
;
	value $COnot
	'CO'
	other = 'Not Carbon Monox'
;
run;

data projects; 
	set sasdata.projects 
	
	Pollutant = put(ppol_type, $pollutant.);
	CO = put (pol_type, $pollutant.);
		/*character-to-character conversion with PUT is usually only done with custome formats*/
run;

 
***********************************************************;
*  Activity 3.11                                          *;
*  1) Examine and run the program. In the output table,   *;
*     verify that Date2 is created as numeric. Notice     *;
*     that the table contains a character column named    *;
*     Volume.                                             *;
*  2) Add an assignment statement to create a column      *;
*     named Volume2. Use the INPUT function to read       *;
*     Volume using the COMMA12. informat. Run the program *;
*     and verify that Volume2 is created as a numeric     *;
*     column.                                             *;
*  3) In the assignment statement, change Volume2 to      *;
*     Volume so that you update the value of the existing *;
*     column.                                             *;
*  4) Run the program and notice that Volume is still     *;
*     character. Why is the assignment statement not      *;
*     changing the column type?                           *;
***********************************************************;

data work.stocks2;
    set pg2.stocks2(rename= (volume = VolChar));
		/*if I want to use volume as numeric, removed it from the input variable by renaming*/

	Range = input(High, best12.) - Low;
	volume = input (VolChar, comma14.);
		/*now that volume is free for me to use however I want*/


	DateValue = input (date,date9.);
	WordDate = strip(put (DateValue, weekdate.));
		
	format DateVvalue mmddyy10. volume comma10.;

	drop volchar;


run;

***********************************************************;
*  Activity 3.13                                          *;
*  1) Add to the RENAME= option to rename the input       *;
*     column Date as CharDate.                            *;
*  2) Add an assignment statement to create a numeric     *;
*     column Date from the character column CharDate. The *;
*     values of CharDate are stored as 01JAN2018.         *;
*  3) Modify the DROP statement to eliminate all columns  *;
*     that begin with Char from the output table.         *;
*  4) Run the program and verify that Volume and Date are *;
*     numeric columns.                                    *;
***********************************************************;

data stocks2;
	set pg2.stocks2(rename=(Volume=CharVolume 
							Date = CharDate
							High = CharHigh));

	Volume=input(CharVolume,comma12.);
	Date = input (chardate, date9.);
	High = input ( CharHight, best12.);
	
	format date mmddyy10. volume comma15.;    

   drop CharVolume;
run;













