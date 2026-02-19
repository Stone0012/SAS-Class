proc import datafile= '~/SASData/cars.datfile'
		dbms=tab
		out=work.cars 
		replace;
	getnames= no;
	datarow=2;
	guessingrows=max;
run;

/* This data needs some intervention...
	-- One area for doing data processing in SAS is the data step */ 

/* We can use it to read text files */ 

data work.cars; /* data statements names the data set(s) to be created */
	/* the Infile and Input statements allows us to read from text files */
	/* Infile specifies the input file and potentially some instructions 
		about its structure */
	/* Input specifies the fields and some instructions on how to read each */ 
	infile '~/SASData/cars.datfile';
input Make Model Type Oeigin Drivetrain MSRP Invoice EngineSize Cylindders 
	Horsepower CityMPG HighwayMPG Weight Wheelbase Length;
/* Point to the file in INfile, list the names in column order in Input --
	this is called list input in the SAS Documentation */ 
run;

/* Infile presumes the file is space-delminited unless you specify otherwise
	and any variable in the Input is presumed neumeric unless you specify otherwise */ 

data work.cars;
/* DLM= set the delimiter in the infile statement*/
	infile '~/SASData/cars.datfile' dlm='09'x; /* Tab cannot be expressed directly as a literal 
													use its code (09) as a literal followed by x
													to tell SAS to conver */
/* For any variable that is character, you can give this instruction in Input
	by placing a $ after the variable name */
input Make:$200. Model$ Type$ Oeigin$ Drivetrain$ MSRP Invoice EngineSize Cylindders 
	Horsepower CityMPG HighwayMPG Weight Wheelbase Length;
run;
/* that first ros is of no use to me.. */

data work.cars;
	infile '~/SASData/cars.datfile' dlm='09'x firstobs=2; /* first obs tells which row to start in */ 
/* you can attach an informat to any variable using the : as the operator,
	the informat provides the read instruction for the variable (not all formats are informats) */
input Make$ Model$ Type$ Oeigin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
	Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
run; /* MSRP, Invoice, and weight should be numbers, but in the data file they have non standard characters, 
		so we need a special instruction for those */
/* informats are instructions for reading, not displaying. If you want to set the display use a format statement */


data work.cars;
	infile '~/SASData/cars.datfile' dlm='09'x firstobs=2;
input Make$ Model$ Type$ Oeigin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
	Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
format MSRP Invoice dollar12. weight comma8.; /* these become the display format by default */
label CityMPG ='MPG City' HighwayMPG = 'MPG Highway'; /* you can also create defualt lables */ 
run;

/* Default length for character variables is 8, but it can be changed */

data work.cars;
infile '~/SASData/cars.datfile' dlm='09'x firstobs=2;
length Make Model $50 Type $15; /* can say length variable(s) $number; number is the length desire*/
input Make$ Model$ Type$ Oeigin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
	Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway';
format MSRP Invoice dollar12. weight comma8.; 
run;

data work.cars;
infile '~/SASData/cars.datfile' dlm='09'x firstobs=2;
length Make Model $50 Type $15; /* attributes are set based on the first encouter of a variable 
									during processing, so these already length 8 from the input statement 
									and it is too late to change them now*/
input Make$ Model$ Type$ Oeigin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
	Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway';
format MSRP Invoice dollar12. weight comma8.; 
run;

data work.cars; /* variable attributes are set as variables are encountered during compilation */
infile '~/SASData/cars.datfile' dlm='09'x firstobs=2;
length Make Model $50 Type $15;
input Make$ Model$ Type$ Oeigin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
	Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway';
format MSRP Invoice dollar12. weight comma8.; 
run;

data work.cars; 
infile '~/SASData/cars.datfile' dlm='09'x firstobs=2 missover; /* if we reach the end of a row in the raw file before 
																	filling in all values for the input variables, make the
																	remaining ones missing (dont go to the next row and find something FLOWOVER)*/
input Make:$50. Model:$50. Type:$50. Oeigin:$50. Drivetrain:$50. MSRP:dollar. Invoice:dollar. EngineSize Cylindders 
/* standard character format/informat is :w$. */
	Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway';
format MSRP Invoice dollar12. weight comma8.; 
run;
/* we have a problem with the row for line 42, because a field is missing data 
	which means that row has two consecutive tab characters. 
	since the default delimiter is space, consecutive delimites are treated as a single delimiter by defualt */


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







	