proc import datafile="~/Courses/PG1V2/data/np_traffic.dat"
		dbms=dlm /* stands for delimited file */
		out=np_traffic_import
		replace;
	guessingrows=max;
	delimiter= '|'; /* the delimter statement allows you to choose delimiter(s) */
run;

/* '09'x is the ASCII hex code for a tab -- can give hex codes as '##'x- if it is a tab delimited file 
	--ASCII Table look up if needed */

/* Justification can tell you column type -- numeric is right justified and character is left justified */


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
	Horsepower City MPG HighwayMPG Weight Wheelbase Length;
/* Point to the file in INfile, list the names in column order in Input --
	this is called list input in the SAS Documentation */ 
run;

/* Infile presumes the file is space-delminited unless you specify otherwise
	and any variable in the Input is presumed neumeric unless you specify otherwise */ 