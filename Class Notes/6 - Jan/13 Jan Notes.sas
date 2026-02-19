libname stat1 '~/ECST142/data';
options fmtsearch=(stat1.myfmts);

libname stat1 '~/ECST142/data';
options fmtsearch=(stat1.myfmts);

*3.1 Modeling Binary Categories with a GLM;

data cars;
	set sashelp.cars;
	select(type);
	when('Sedan','Wagon') car=1;
/*these cars get a dummy encoiding of car =1*/
	when('Truck','SUV') car=0;
/*These are not a car = 0*/
	otherwise delete; /*If you have just a 'when' then you need an otherwise statement*/
/*remove all others*/

end;
run;

proc standard data=cars out=carsSTD mean=0;
	var weight enginesize;
run; /*going to center a couple of things I'll used as predictors (not needed but easier to graph
		and understand some numbers)*/

ods graphics off;
proc glm data=carsSTD;
	model car = weight enginesize / solution;
/*using that dummy variable as Y or response */
	ods select ParameterEstimates;
	output out=pred predicted=Pcar;
run;

proc sgplot data=pred;
	scatter x=weight y=enginesize /
	markerattrs=(symbol=circlefilled) colorresponse=Pcar;
run;

*3.2 Classifying Binary Outcomes;

data class;
	set pred;
	length PredType $5;
	if Pcar gt 0.5 then PredType='Car'; /*.5 is generally good, not always (setting prior probabilities) */
	else PredType='Truck';
run;

proc format;
	value $type
	'Sedan','Wagon'='Car'
	'Truck','SUV'='Truck'
;
run; /*make a format for use with they tpe variable*/

proc freq data=class order=formatted;
	table type*PredType;*/nopercent nocol;
	format type $type.;
run;

proc sgplot data=class;
	scatter x=weight y=enginesize /
		markerattrs=(symbol=circlefilled) group=PredType name='Scatter';
	lineparm x=0 y=%sysevalf((0.5-0.7766)/0.099159) 
/*lineparm, draws a line based on parameters: slope and an x,y point*/
		slope=%sysevalf(0.000402/0.099159);
	yaxis values=(-2 to 4 by 1);
	keylegend 'Scatter' / position=topleft location=inside title='' across=1;
run;


*3.3 Modeling Multiple Classes with GLM; 

data cars;
	set sashelp.cars;
	Asia=0;Europe=0;USA=0;
	select(origin);
	when('Asia') Asia=1;
	when('Europe') Europe=1;
	when('USA') USA=1;
end;
run;

ods graphics off;
ods select none;
proc glm data=cars;
	model Asia Europe USA = horsepower weight mpg_city msrp length;
	output out=predictions predicted=PAsia PEurope PUSA;
	where type ne 'Hybrid';
run;

ods select all;
proc sgplot data=predictions;
	scatter y=origin x=PASIA / jitter legendlabel='PAsia'
	markerattrs=(symbol=circle color=blue);
	scatter y=origin x=PEurope / jitter legendlabel='PEurope'
	markerattrs=(symbol=square color=red);
	scatter y=origin x=PUSA / jitter legendlabel='PUSA'
	markerattrs=(symbol=triangle color=green);
	xaxis label='Predicted';
	keylegend / across=1 position=topright location=inside;
run;