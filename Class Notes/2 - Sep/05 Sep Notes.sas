/*look up SAS functions by category 
-- formats by category */

data work.cars; 
	infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
/* 
dsd is short for delimiter sensative data and does 3 thing 
	1. Switches the default delimiter to a comma (but you can still change it as we did)
	2. Treats consecutive delimeters as containing a missing value
	3. Ignores delimiters in values embedded in quotes
*/
	input Make:$50. Model:$50. Type:$50. Oeigin:$50. Drivetrain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
/* standard character format/informat is :w$. */
	Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
	label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway'; /* have to allow labels to display in output using the hamburder icon in the top right */
	format MSRP Invoice dollar12. weight comma8.; 
run;


data work.projects; 
	infile '~/SASData/projects.txt' dsd dlm='09'x missover; 
	input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment:dollar. Personnel:dollar. Pol_Count; 
/* digits can be left alone, or read as a character if you are not doing any sort of math with it
	state and region must be read as character, jobid and pol code can be read as either, 
	equiptment, personnel and data need to be numeric.  */ 
	format Equipment Personnel dollar12. Date mmddyy.; 
run;


data work.projects; 
	infile '~/SASData/projects.txt' dsd dlm='09'x missover; 
	input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment:dollar. Personnel:dollar. Pol_Count; 
	JobTotal = Equipment + Personnel; /* Variable = expression; assigns the calue of the expressions to the variable 
										it determines type and length as part of that */
format Equipment Personnel JobTotal dollar12. Date mmddyy.; 
run;

data work.projects; 
	infile '~/SASData/projects.txt' dsd dlm='09'x missover; 
	input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment:dollar. Personnel:dollar. Pol_Count; 
	JobTotal = Equipment + Personnel;
	Month = month(date); /* Month() extracts the month from a date as a whole number 1-12*/
	Description = catx('--',Region, put(date,mmddyy10.), put(Jobtotal,dollar12.));
/* catx(delimiter, expression 1, expression 2,..) -- concatenate expressions with the delimiter between
	put(variable,format) -> converts numeric to character using the specified format */ 
format Equipment Personnel JobTotal dollar12. Date mmddyy.; 
run;

libname SASData '~/SASData';
proc sort data=sasdata.projects nodupkey out=pollutants (keep=pol_code pol_type);
	by pol_code pol_type;
run; 


data work.projects; 
	infile '~/SASData/projects.txt' dsd dlm='09'x missover; 
	input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment:dollar. Personnel:dollar. PollutionCode:$1.; 
	JobTotal = Equipment + Personnel;
/* If-then-else conditional logic is available*/ 
/* length PollutionCode:$4;  can set length here */
if PollutionCode eq '1' then Pollution = 'TSP '; /* first encounter of Pollutant during compilation 
													is a 3 character literal-- that's its length
														can also just add spaces after 'TSP' */
	else if PollutionCode eq '2' then Pollution = 'Lead'; /* can put the longest length first */
		else if PollutionCode eq '3' then Pollution = 'CO';
			else if PollutionCode eq '4' then Pollution = 'SO2';
				else Pollution = 'O3';
format Equipment Personnel JobTotal dollar12. Date mmddyy.; 
run;

data work.projects; 
	infile '~/SASData/projects.txt' dsd dlm='09'x missover; 
	input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment:dollar. Personnel:dollar. PollutionCode:$1.; 
	JobTotal = Equipment + Personnel;
if PollutionCode eq '1' then Pollution = 'TSP '; 
	if PollutionCode eq '2' then Pollution = 'Lead'; 
		if PollutionCode eq '3' then Pollution = 'CO';
			if PollutionCode eq '4' then Pollution = 'SO2';
				if PollutionCode eq '5' then Pollution = 'O3';
/* dont really need the ELSE branching, but it is more effecient */
format Equipment Personnel JobTotal dollar12. Date mmddyy.; 
run;












