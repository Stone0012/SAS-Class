libname pg2 '~/Courses/PG2V2/data';

***********************************************************;
*  Activity 4.01                                          *;
*  1) Add a FORMAT statement in the DATA step to format   *;
*     the following values:                               *;
*       Date => 3-letter month and 4-digit year (MONYY7.) *;
*       Volume => Add commas (COMMA12.)                   *;
*       CloseOpenDiff, HighLowDiff =>                     *;
*           Add dollar signs and include 2 decimal        *;
*           places (DOLLAR8.2)                            *;
*  2) Run the program and verify the formatted values in  *;
*     the PROC PRINT output.                              *;
*  3) Add a FORMAT statement in the PROC MEANS step to    *;
*     format the values of Date to show only a four-digit *;
*     year. Run the PROC MEANS step again.                *;
*  4) What is the advantage of adding a FORMAT statement  *;
*     to the DATA step versus the PROC step?              *;
***********************************************************;

data work.stocks;
    set pg2.stocks;
    CloseOpenDiff=Close-Open;
    HighLowDiff=High-Low;
    format volume comma18. CloseOpenDiff HighLowDiff dollar12.2 date monyy7.; /*can also use date9. for DDMMMYYYY*/
run;

proc print data=stocks (obs=5);
    var Stock Date Volume CloseOpenDiff HighLowDiff;
run;

/*Formats by category*/
proc means data=stocks maxdec=0 nonobs mean min max;
    class Stock Date;
    var Open; 
    format date year4.; 
run;

***********************************************************;
*  Activity 4.02                                          *;
*  1) In the PROC FORMAT step, modify the second VALUE    *;
*     statement to create a format named HRANGE that has  *;
*     the following criteria:                             *;
*     * A range of 50 - 57 has a formatted value of       *;
*       Below Average.                                    *;
*     * A range of 58 - 60 has a formatted value of       *;
*       Average.                                          *;
*     * A range of 61 - 70 has a formatted value of       *;
*       Above Average.                                    *;
*  2) In the PROC PRINT step, modify the FORMAT statement *;
*     to format Height with the HRANGE format.            *;
*  3) Run the program and verify the formatted values in  *;
*     the PRINT output.                                   *;
*  4) Why is the Height value for the first row not       *;
*     formatted?                                          *;
***********************************************************;

proc format;
    value $regfmt 
		'C'='Complete'
    	'I'='Incomplete'
;
    *modify the following VALUE statement;
    value hrange 
		low - <58 = 'Below Avg'
		58 - 60 = 'Avg'
		60< - high = 'Above Avg'
;
/* applies assumes whole numbers between 50 and 70 anything else is unformatted*/
run;

proc print data=pg2.class_birthdate noobs;
    where Age=12;
    var Name Registration Height;
    format Registration $regfmt. height hrange.;
run;

***********************************************************;
*  Activity 4.03                                          *;
*  1) Review the PROC FORMAT step that creates the        *;
*     $REGION format that assigns basin codes into        *;
*     groups. Highlight the step and run the selected     *;
*     code.                                               *;
*  2) Notice the DATA step includes IF-THEN/ELSE          *;
*     statements to create a new column named BasinGroup. *;
*  3) Delete the IF-THEN/ELSE statements and replace it   *;
*     with an assignment statement to create the          *;
*     BasinGroup column. Use the PUT function with Basin  *;
*     as the first argument and $REGION. as the second    *;
*     argument.                                           *;
*  4) Highlight the DATA and PROC MEANS steps and run the *;
*     selected code. How many BasinGroup values are in    *;
*     the summary report?                                 *;
***********************************************************;

proc format;
    value $region 
		'NA' = 'Atlantic'
        'WP','EP','SP' = 'Pacific'
        'NI','SI' = 'Indian'
		' ' = 'Missing'
        other = 'Unknown'
;
run;

data storm_summary;
    set pg2.storm_summary;
    Basin=upcase(Basin);

    *Delete the IF-THEN/ELSE statements and replace them with an assignment statement;
    if Basin='NA' then BasinGroup='Atlantic';
    	else if Basin in ('WP','EP','SP') then BasinGroup='Pacific';
    	else if Basin in ('NI','SI') then BasinGroup='Indian';
   		else if Basin=' ' then BasinGroup='Missing';
    	else BasinGroup='Unknown';
run;

data storm_summaryB;
    set pg2.storm_summary;
    Basin=upcase(Basin);

	BasinGroup = put(Basin, $region.);
run;

proc means data=storm_summaryB maxdec=1 missing;
	class BasinGroup;
	var MaxWindMPH MinPressure;
run;

***********************************************************;
*  LESSON 4, PRACTICE 3                                   *;
*  a) Access the Base SAS 9.4 Procedures Guide. Find the  *;
*     PROC FORMAT section and the VALUE statement page.   *;
*     Scroll to the bottom of the page to look at         *;
*     examples where existing SAS formats are used for    *;
*     labels in a custom format.                          *;
*  b) Open p204p03.sas from the practices folder.         *;
*  c) Add a PROC FORMAT step to create a format named     *;
*     DECADE that categorizes dates as identified below.  *;
*     January 1, 2000 - December 31, 2009 => 2000-2009.   *;
*     January 1, 2010 - December 31, 2017 => 2010-2017.   *;
*     January 1, 2018 - March 31, 2018 => 1st Quarter 2018*;
*     April 1, 2018 and beyond => actual date value using *;
*                                 the MMDDYY10. format.   *;
*  d) Modify the PROC MEANS step so that the DECADE       *;
*     format is applied to the Date column.               *;
*  e) Run the program and review the output. Verify that  *;
*     the descriptive values for the Date column are      *;
*     displayed.                                          *;
***********************************************************;

/* Add a PROC FORMAT Step */
proc format; 
	value decade

	low - '31DEC2009'd = '2000 - 2009'

	'01JAN2010'd-'31DEC2017'd = '2010 - 2017'

	'01JAN2018'd-'31MAR2018'd = '1st Quater 2018'

	'01APR2018'd - high = [mmddyy10.]

	other='n/a'
;

run;

title1 'Precipitation and Snowfall';
title2 'Note: Amounts shown in inches';
proc means data=pg2.np_weather maxdec=2 sum mean nonobs;
    where Prcp > 0 or Snow > 0;
    var Prcp Snow;
    class Date Name;
	format date decade.;
run;
title;

***********************************************************;
*  Activity 4.04                                          *;
*  1) Run the program to create the $SBFMT and CATFMT     *;
*     formats. View the log to confirm both were output.  *;
*  2) Uncomment the PROC FORMAT step at the end of the    *;
*     program. Highlight the step and run the selected    *;
*     code. A report for all formats in the WORK library  *;
*     is generated.                                       *;
*  3) Add the following statement in the last PROC FORMAT *;
*     step to limit the report to selected formats. Run   *;
*     the step.                                           *;
*           select $sbfmt catfmt;                         *;
*  4) What are the default lengths for the $SBFMT and     *;
*     CATFMT formats?                                     *;
***********************************************************;

/*Create the $SBFMT format for subbasin codes*/

data sbdata;

/*Every data set used to define a formmat must have three variables 
	with controlled attributes:

		1. FmtName -- Names the format (is a character variable) 
						includes the $ at the start of the character format 

		2. Start -- Defines the starting value of a format range 
						numeric or character, usually character to accomdate all possible 
						values usable in a range

		3. Lable -- Value to be displayed for a given format range 

		
		End is optional, if it isn't present End=Start	 
*/

    retain FmtName '$sbfmt';
    set pg2.storm_subbasincodes(rename=(Sub_Basin=Start 
                                        SubBasin_Name=Label));
    keep Start Label FmtName;
run;

proc format cntlin=sbdata;
/*	cntlin -- read in a 'control' data set to define formats
	cntlout -- can name a data set that has the format information
*/
run;

/*Create the CATFMT format for storm categories*/
data catdata;
    retain FmtName "catfmt";
    set pg2.storm_categories(rename=(Low=Start 
                                     High=End
                                     Category=Label));
    keep FmtName Start End Label;
run;

proc format cntlin=catdata;
run;

proc format fmtlib library=work;
	select $sbfmt catfmt;
run;

***********************************************************;
*  Activity 4.05                                          *;
*  1) In the PROC FORMAT statement, add the LIBRARY=      *;
*     option to save the formats to the PG2.FORMATS       *;
*     catalog.                                            *;
*  2) Run the PROC FORMAT step and verify in the log that *;
*     the two formats were created in a permanent         *;
*     location.                                           *;
*  3) Before the PROC PRINT step, add an OPTIONS          *;
*     statement so that SAS can find the two permanent    *;
*     formats.                                            *;
*         options fmtsearch=(pg2.formats);                *;
*  4) Run the OPTIONS statement and the PROC PRINT step.  *;
*     Are the Registration and Height values formatted?   *;
***********************************************************;

libname output '~/Out';

proc format library=output.format;
    value $reg
		'C' = 'Complete'
		'I' = 'Incomplete'                             
         other = 'Miscoded';

    value hght 
		low-<58  = 'Below Average'
		58-60   = 'Average'
		60<-high = 'Above Average';
run;

*add an OPTIONS statement;

proc print data=pg2.class_birthdate noobs;
    where Age=12;
    var Name Registration Height;
    format Registration $reg. Height hght.;
	options fmtsearch=(pg2.formats);
run;
























