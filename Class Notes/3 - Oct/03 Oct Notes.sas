libname SASData '~/SASData';
libname IPEDS '~/IPEDS';

proc format cntlout=SampleFMT; /* cntlout= is a data set that contains format definitions */ 
	value GEHalf
		0- <0.5 = 'No'
		0.5-high = 'Yes' ;
run;

proc contents data= work._all_ nods; 
run;

proc format lib=work fmtlib; 
	/* pick a library and ask for details with FMTLIB */
run;


proc print data = ipeds.characteristics label; 
	format _numeric_ best12. _character_ $50.;
run;

proc contents data = ipeds.characteristics; 
run;

options fmtsearch = (IPEDS); 
proc format lib=IPEDS fmtlib;
run;


proc format cntlin=ipeds.ipedsformats; /*cntlin is a dataset that has format definitions */
run;

proc print data = ipeds.characteristics label; 
	format fips best12.;
run;

options fmtsearch = (IPEDS); /*fmtsearch= sets libraries in which to search for format catalogs */

proc print data = ipeds.characteristics label; 
	format fips best12.;
run;



proc sort data=ipeds.graduation out=gradsort; 
	by unitid group;
run; 


data gradrates;

	merge gradsort ipeds.characteristics(keep=unitiD control); 
	by unitid;
	retain GradWomen GradMen Grads; 

	if first.unitid then do; 
		GradWomen = Women ;
		GradMen = Men;
		Grads= total;
end; 
	
	if last.unitid then do;  
		RateWomen=GradWomen/Women; 
		if RateWomen ge .5 then GE50Women = 'Yes';
			else GE50Women = 'No';
		RateMen = GradMen/Men;
		if RateMen ge .5 then GE50Men = 'Yes';
			else GE50Men = 'No';
		Rate = Grads / Total;
output;
end; 

run;

proc ttest data=gradrates; 
	class control;
	var rate; 
	where put (control, control.) contains 'Public' or put (control, control.) contains 'not';
		/* control is numeric, not character */
	/* put(variable, format.); converts a numeric variable to character using the specified format */
	*where control in (1 2);
run;

proc ttest data=gradrates; 
	class control;
	var rate; 
	where (put (control, control.) contains 'Public' or put (control, control.) contains 'not')
		and total ge 100;
run;


proc format; 
	value GEHalf
		0- <0.5 = 'no'
		0.5-high = 'Yes' ;
run;

proc freq data=gradrates order=formatted; 
	where (put (control, control.) contains 'Public' or put (control, control.) contains 'not')
		and total ge 100;
	table control * rate / chisq riskdiff;
	format rate geHalf.;
	ods exclude fishersExact; 
run;
































