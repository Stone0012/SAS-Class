/* SAS Functions by Category (SAS 9.4, Via 3.5)*/

data projects; 
	infile '~/SASData/projects.txt' dlm = '09'x dsd missover;
	input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment:dollar. Personnel:dollar. PollutionCode:$1.; 
	JobTotal = Equipment + Personnel; 
	length Pollutant $4; 
	select (PollutionCode); /* Selected(expressions) --> check equality of expression against conditions when clauses
								if no expression (and no parentheses are given) each when must contain a complete condition */ 
	when(1) Pollutant = 'TSP';
	when(2) Pollutant = 'LEAD';
	when(3) Pollutant = 'CO';	
	when(4) Pollutant = 'SO2';
	otherwise Pollutant = 'O3'; /* Not always required */ 
end; /* select is a block, uses an end to terminate */ 

/* If the When conditions do not cover all posibilities, the otherwise is required */

format date weekdate. Equipment Personnel Jobtotal dollar12.;
run;


data projects; 
	infile '~/SASData/projects.txt' dlm = '09'x dsd missover;
	input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment:dollar. Personnel:dollar. PollutionCode:$1.; 
	JobTotal = Equipment + Personnel; 

	length Pollutant $4; 
	select (PollutionCode); 

	when(1,3,4,5) Pollutant = 'Not Lead';
	when(2) Pollutant = 'LEAD';
	otherwise Pollutant = '????'; 
end; 

format date weekdate. Equipment Personnel Jobtotal dollar12.;
run;


data work.cars; 
	infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
	input Make:$50. Model:$50. Type:$50. Origin:$50. Driveterain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
		Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
	label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway'; 
	format MSRP Invoice dollar12. weight comma8.; 
run;

proc freq data=cars; 
	table make type origin driveterain; 
/* need some clean up on make and type, others look ok */
run; 

proc means data=cars; 
run; 

proc univariate data=cars; 
run;

proc means data=cars; 
	var weight wheelbase length; 
	class origin;
/* units for these are based on units from origin region */ 
run; 

data work.cars; 
	infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
	input Make:$50. Model:$50. Type:$50. Origin:$50. Driveterain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
		Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;

/* put everything in Imperial Units (pounds and inches) */

	if origin ne 'USA' then do;
		weight = weight * 2.2; /* convert kg to lbs */ 
		wheelbase = wheelbase / 2.54; 
		length = length / 2.54; /* convert cm to inch */

end;

	label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway'; 
	format MSRP Invoice dollar12. weight comma8.; 
run;

proc means data=cars; 
	var weight wheelbase length; 
	class origin;
/* units for these are based on units from origin region */ 
run; 


data work.cars; 
	infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
	input Make:$50. Model:$50. Type:$50. Origin:$50. Driveterain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
		Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;


	if origin ne 'USA' then do;
		weight = round(weight * 2.2,10); 
		/* if I want to round to a certain precision, I can */
		wheelbase = round(wheelbase / 2.54,.1); 
		length = round(length / 2.54,1); 
		/* Round (numeric-expression, precision) -> precision is expressed with a 1 in the appropriate position */ 

end;

	label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway'; 
	format MSRP Invoice dollar12. weight comma8.; 
run;

data work.cars; 
	infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
	input Make:$50. Model:$50. Type:$50. Origin:$50. Driveterain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
		Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;


	if origin ne 'USA' then do;
		weight = round(weight * 2.2,10); 

		wheelbase = round(wheelbase / 2.54,.1); 
		length = round(length / 2.54,1); 

end;

	if scan(lowcase(make),1) eq 'mercedes' then Merc=1;
	else Merc = 0;

	label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway'; 
	format MSRP Invoice dollar12. weight comma8.; 
run;







