libname SASData '~/SASData';

/* Exercises */

*1A; 
proc glm data=sasdata.cdi;
	model  inc_per_cap = ba_bs;
ods select ParameterEstimates;
run;

*1B;
proc glm data=sasdata.cdi;
	model  inc_per_cap = pop18_34;
ods select ParameterEstimates;
run;

*1C;
proc glm data=sasdata.cdi;
	model  inc_per_cap = ba_bs  pop18_34;
ods select ParameterEstimates;
run;

*1D;
proc glm data=sasdata.cdi;
	model  inc_per_cap = ba_bs | pop18_34;
ods select ParameterEstimates;
run;

proc stdize data=sasdata.cdi out=cdiSTD method=mean;
	/*proc stdize does various standardizations.. 
		it uses methods ... mean moves mean value to 0 (centers)*/
var ba_bs pop18_34;
run;

proc glm data=cdistd;
	model  inc_per_cap = ba_bs | pop18_34;
	ods select ParameterEstimates;
run;

*3A; 
proc glm data=sasdata.realestate;
	model  price = sq_ft;
ods select ParameterEstimates;
run;

*3B;
proc glm data=sasdata.realestate;
	model  price = bedrooms;
ods select ParameterEstimates;
run;

*3C;
proc glm data=sasdata.realestate;
	model  price = sq_ft bedrooms;
ods select ParameterEstimates;
run;

*3D;
proc glm data=sasdata.realestate;
	model  price = sq_ft | bedrooms;
ods select ParameterEstimates;
run;

data realestate;
	set sasdata.realestate;
	sqft = sq_ft-1500;
	beds = bedrooms -3;
run;

proc glm data=realestate;
	model  price = sqft | beds;
ods select ParameterEstimates;
run;

proc sgplot data=sasdata.realestate;
	scatter x=sq_ft y=bedrooms / markerattrs=(symbol=squarefilled) 
								colorresponse=price 
								colormodel=(cxfeedde cxfdae6b cxe6550d cxd94701); 
run;


*2A; 
proc format;
	value region 
		1 = 'North East'
		2 = 'North Central'
		3 = 'South'
		4 = 'West'
	;
run;

proc glm data=sasdata.cdi;
	class region(ref = 'South');
	model  inc_per_cap = region / solution;
	lsmeans region;
ods select ParameterEstimates lsmeans;
	format region region.;
run;


*2B;
proc glm data=sasdata.cdi;
	class region;
	model  inc_per_cap = ba_bs | region / solution;
	lsmeans region;
ods select ParameterEstimates lsmeans;
	format region region.;
run;

*2B.1;
proc glm data=cdistd;
	class region;
	model  inc_per_cap = ba_bs | region / solution;
	lsmeans region;
ods select ParameterEstimates lsmeans;
	format region region.;
run;

proc glm data=sasdata.cdi;
	class region;
	model  inc_per_cap = ba_bs | region / solution;
	lsmeans region;
		/*this plugs in the mean for any quanitative predictors 
			when estimating means for categories*/
ods select ParameterEstimates lsmeans;
	format region region.;
run;

proc glm data=sasdata.cdi;
	class region;
	model  inc_per_cap = ba_bs | region / solution;
	lsmeans region;
	lsmeans region / at ba_bs = 10;
	estimate 'NC vs S' ba_bs*region 1 0 - 1 0; 
		/*NC - S on the BA X Region effect difference in those slopes*/
ods select ParameterEstimates lsmeans;
	format region region.;
run;








