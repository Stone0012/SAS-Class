data work.cars; 
	infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
	input Make:$50. Model:$50. Type:$50. Origin:$50. Driveterain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
		Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;


	if origin ne 'USA' then do;
		weight = round(weight * 2.2,1); 

		wheelbase = round(wheelbase / 2.54,1); 
		length = round(length / 2.54,1); 
end;

	make = propcase(make); /* assign the updated value of Make back in Make */ 

	if scan(lowcase(make),1) eq 'mercedes' then Merc=1;
	else Merc = 0;

	label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway'; 
	format MSRP Invoice dollar12. weight comma8.; 
run;

proc freq data = cars; 
	table make type origin drivetrain; 
run;
	
data work.cars; 
	infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
	input Make:$50. Model:$50. Type:$50. Origin:$50. Driveterain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
		Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;


	if origin ne 'USA' then do;
		weight = round(weight * 2.2,1); 

		wheelbase = round(wheelbase / 2.54,1); 
		length = round(length / 2.54,1); 
end;

	make = propcase(make);  

	if scan(lowcase(make),1) eq 'mercedes' then make = 'Mercedes-Benz';

	label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway'; 
	format MSRP Invoice dollar12. weight comma8.; 
run;

data work.cars; 
	infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
	input Make:$50. Model:$50. Type:$50. Origin:$50. Driveterain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
		Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;


	if origin ne 'USA' then do;
		weight = round(weight * 2.2,1); 

		wheelbase = round(wheelbase / 2.54,1); 
		length = round(length / 2.54,1); 
end;

	make = propcase(make); 

	if scan(lowcase(make),1) eq 'mercedes' then make = 'Mercedes-Benz';

	*test = find(type,'Ut');

	if find(type,'Ut') then type = 'SUV'; /* Find(expression, 'substring') returns 0 if the substring is not present, 
			which = False in if. If the substring is present, it returns the starting position of the first instance */ 

	/* The index function works in a very similar way */ 

	label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway'; 
	format MSRP Invoice dollar12. weight comma8.; 
run;

proc freq data = cars; 
	table type; 
run;

/* Using compare */ 

data projects; 

	infile '~/SASData/projects.txt' dlm = '09'x dsd missover;
	input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment Personnel PollutionCode; 
	
JobTotal = Equipment + Personnel; 

	length Pollutant $4; 
	select (PollutionCode); 
 
	when(1) Pollutant = 'TSP';
		when(2) Pollutant = 'LEAD';
			when(3) Pollutant = 'CO';	
				when(4) Pollutant = 'SO2';
					otherwise Pollutant = 'O3'; 
end;


	format date weekdate. Equipment Personnel Jobtotal dollar12.;
run;


libname SASData '~/SASData';

/* Proc compare compares two data sets */ 
proc compare base=sasdata.projects comp=work.projects;
run; /* -base= and compare = name the two tables to be compared, records from the two tables will be labeled this way in output datasets

-- comparison is done on matching variables only-matching = same name and type

--- record comparison is matched on row number 
		first record in base is compared to fiirst record in compare 
			second record from each is compared, and so on... 

-- sort ordered is expected to be the same*/

/* - Step 1: check out variable names */ 

proc contents data=sasdata.projects; 
	ods select variables; 
run;

proc contents data=work.projects; 
	ods select variables; 
run;

proc compare base=sasdata.projects(rename=(equipmnt= equipment personel = personnel 
										pol_code = PollutionCode pol_type = Pollutant 
											stname = state))
				/* rename = (oldname1 = newname1 oldname2 = newname 2) */ 
	compare=work.projects;
run; /* variables now allign */

/* Row order? Find a primary key -> set (minimal) of variables that uniquely identifies a record and therefore produces a unique sort */ 

proc sort data=SASData.projects out=BaseProjects nodupkey dupout=dups; /* dupkey is going to tell me if I have successfully found the primary key*/
by jobID; 
run; /* not quite */ 

proc sort data=SASData.projects out=BaseProjects nodupkey dupout=dups; 
by jobID pol_type; 
run; /* closed */ 

proc sort data=SASData.projects out=BaseProjects nodupkey dupout=dups; 
by jobID date pol_type jobtotal; 
run;

proc sort data=work.projects out=CompareProjects nodupkey dupout=dups; 
by jobID date Pollutant jobtotal; 
run;

proc compare base=BaseProjects(rename=(equipmnt= equipment personel = personnel 
										pol_code = PollutionCode pol_type = Pollutant 
											stname = state))
	compare=CompareProjects out=Comparison outall;
/* can make an out= dataset 
	by default it only shows differences (subtraction for numeric  individual character comparison for text -> . is equal, x is  not)
	--outall is base, compare, and dif record for each observation
*/
run;

proc compare base=BaseProjects(rename=(equipmnt= equipment personel = personnel 
										pol_code = PollutionCode pol_type = Pollutant 
											stname = state))
	compare=CompareProjects out=Comparison outnoequal;
/* outnoequal only sends out sets for comparisons with unequal variables
*/
run;

/* Try this with our cars.datfile read in data, should be the same as sashelp.cars*/ 







