libname pg2 '~/Courses/PG2V2/data';

***********************************************************;
*  Activity 3.08                                          *;
*  1) Notice that the assignment statement for            *;
*     CategoryLoc uses the FIND function to search for    *;
*     category within each value of the Summary column.   *;
*     Run the program.                                    *;
*  2) Examine the PROC PRINT report. Why is CategoryLoc   *;
*     equal to 0 in row 1? Why is CategoryLoc equal to 0  *;
*     in row 15?                                          *;
*  3) Modify the FIND function to make the search case    *;
*     insensitive. Uncomment the IF-THEN statement to     *;
*     create a new column named Category. Run the program *;
*     and examine the results.                            *;
***********************************************************;
*  Syntax Help                                            *;
*     FIND(string, substring <, 'modifiers'>)             *;
*         Modifiers:                                      *;
*             'I'=case insensitive search                 *;
*             'T'=trim leading and training blanks from   *;
*			     string and substring                     *;
***********************************************************;

/*there are also functions called findC and findW (works like find without modifiers -- 
												the e modifier can give you word position instead
												of character position, but requires a delimiter choice 
												which can be blank
												CategoryLocW=findw(Summary, 'category', '', 'e');
There is also indexc and indexw
*/


data storm_damage2;
	set pg2.storm_damage;

	drop Date Cost;

	CategoryLoc=find(Summary, 'category');
	CategoryLocB=index(Summary, 'category');
	CategoryLocB2=index(lowcase(Summary), 'category');
	CategoryLocC=find(Summary, 'category','i');
		/* i modifier in FIND -- is a case insensative search*/
	CategoryLocD=find(Summary, 'category','i',2);
		/*number as a third or fourth argument is the starting position
			retunrs the position within the whole string*/
	CategoryLocE=find(Summary, 'category','i',-10);
		/* negative start means start at position x and look back to the left*/

	*if CategoryLoc > 0 then Category=substr(Summary,CategoryLoc, 10);
run;

proc print data=storm_damage2;
	var Event Summary Cat:;
run;

***********************************************************;
*  Activity 3.09                                          *;
*  1) Examine the assignment statements that use the CAT  *;
*     and CATS functions to create StormID1 and StormID2. *;
*     Run the program. How do the two columns differ?     *;
*  2) Add an assignment statement to create StormID3 that *;
*     uses the CATX function to concatenate Name, Season, *;
*     and Day with a hyphen inserted between each value.  *;
*     Run the program.                                    *;
*  3) Modify the StormID2 assignment statement to insert  *;
*     a hyphen only between Name and Season.              *;
***********************************************************;

data storm_id;
	set pg2.storm_final;

	Day=StartDate-intnx('year', StartDate, 0); /* begining, middle, end, and same are the four options here, begining = defualt */
		/*Day of the year that the strom started*/
	StormID1=cat(Name, Season, Day);
	StormID2=cats(Name, Season, Day);
	StormID3=catx(' - ',Name, Season, Day);
	StormID4=catx(' ', Day, catx(' - ',Name, Season, Day));

	keep StormID: Day StartDate;

run;

***********************************************************;
*  LESSON 3, PRACTICE 4                                   *;
*  a) Run the program and examine the data. Notice that   *;
*     ParkName includes a code at the end of each value   *;
*     that represents the park type. Also notice that     *;
*     some of the values for Location are in uppercase.   *;
*  b) Add a LENGTH statement to create a new              *;
*     five-character column named Type.                   *;
*  c) Add an assignment statement that uses the SCAN      *;
*     function to extract the last word from the ParkName *;
*     column and assigns the resulting value to Type.     *;
*  d) Add an assignment statement to use the UPCASE and   *;
*     COMPRESS functions to change the case of Region and *;
*     remove any blanks.                                  *;
*  e) Add an assignment statement to use the PROPCASE     *;
*     function to change the case of Location.            *;
***********************************************************;

data clean_traffic;
	set pg2.np_monthlytraffic;

	length Type $5;
    Type=scan(ParkName, -1);
    Region=upcase(compress(Region));
    Location=propcase(Location);

	drop Year;
run;

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

	keep ParkName locateNP ParkNameR ParkNameR2;

run;

proc print data=parks;
	var Park GateCode Month Count;
run;














