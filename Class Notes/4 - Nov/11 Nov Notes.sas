libname SASData '~/SASData';

proc sql;
create table FullJoin as 

	select ParkName, ParkCode, Traf2016.* 

	from SASData.np_codeLookUp full join 
		SASData.np_2016Traffic as Traf2016
		on ParkCode eq Code 
/*Full Join is like the data step match merge default logic.. preserve all mismatches and matches*/
;
quit;

proc sql; 
create table FullJoin as 

	select ParkName, ParkCode, Traf2016.* 

	from SASData.np_codeLookUp full join 
		SASData.np_2016Traffic as Traf2016
		on ParkCode eq Code 
;

create table Leftjoin as 

	select ParkName, ParkCode, Traf2016.* 

	from SASData.np_codeLookUp left join 
		SASData.np_2016Traffic as Traf2016
		on ParkCode eq Code 
; /*Left join preserves all records from the "left"/first table...*/

create table RightJoin as 

	select ParkName, ParkCode, Traf2016.* 

	from SASData.np_codeLookUp right join 
		SASData.np_2016Traffic as Traf2016
		on ParkCode eq Code 
; /*Right join keeps all from the "right"/second table*/

create table InnerJoin as 

	select ParkName, ParkCode, Traf2016.* 

	from SASData.np_codeLookUp inner join 
		SASData.np_2016Traffic as Traf2016
		on ParkCode eq Code 
;
quit;

libname pg2 '~/Courses/PG2V2/data';

*Exercise 1; 

*Using a Data Step;
proc sort data=pg2.storm_final out=storm_final_sort;
	by Season Name;
run;

proc sort data=storm_damage;
	by Season Name;
run;

data damage_detail NoDamageInfo NoStormInfo;
	merge storm_final_sort(in=inFinal) storm_damage(in=inDamge);
	by Season Name;
	if inDamage and InFinal then output damage_detail;
run;

*Using SQL;
proc sql;
create table Exercise1 as 

	select Event, BasinName, StartDate, EndDate, MaxWindMPH, cost format = dollar18.

	from SASData.Storm_Damage as damage inner join
			sasdata.storm_final as final
			on upcase(scan(event,-1)) eq Name 
				/*get the equivalent name from event in damage, match to Name on Final*/
			and year(date) eq Season
				/*and make an equivalent to Season in Final from Date in Damage*/
;
quit;


libname IPEDS '~/IPEDS';
options fmtsearch = (IPEDS);

*Extra-- Grad Rate Calculations;
proc sql; 
create table GradeRates as 

	select grads.unitID, grads.total/cohort.total as GradRate,
				grads.men/cohort.men as GradRateMen,
				grads.women/cohort.women as GradRateWomen
	
	from ipeds.graduation(where= (group contains 'Completers')) as Grads inner join
			ipeds.graduation(where= (group contains 'Incoming')) as Cohort
			on Grads.UnitID eq Cohort.UnitID

;
create table GradeRatesPublic as 

	select grads.unitID, grads.total/cohort.total as GradRate,
				grads.men/cohort.men as GradRateMen,
				grads.women/cohort.women as GradRateWomen
	
	from (select * ipeds.graduation where group contains 'Completers') as Grads inner join
		/*can put a query anywhere a table is permitted, called an in-line view*/
			(select * ipeds.graduation where group contains 'Incoming') as Cohort
			on Grads.UnitID eq Cohort.UnitID
	where Grads.UnitID in (select ch.unitID from IPEDS.Characterstics as ch where control eq 1)
		/*UnitIDs for public Institutions*/
;
quit;

/*Set Operators in SQL*/

libname IPEDS '~/IPEDS';
options fmtsearch = (IPEDS);
libname SASData '~/SASData';

proc sql; 
create table Ma2Year as 

	select UnitId
	from ipeds.characteristics
	where put(c21enprf,c21enprf.) contains 'two-year'
		and fipstate(fips) eq 'MA'
	order by UnitId
; 
create table OOS10X as

	select unitid
	from ipeds.TuitionAndCosts
	where tuition2 ne . and tuition3 ge 10*tuition2
	order by unitID
;
quit;

proc sql; 
	select Ma2Year.UnitId
	from May2Year inner join OOS10X on Ma2Year.UnitId eq OOS10X.UnitId
; 
quit;

proc sql; 
create table intersect as

	select UnitId
	from ipeds.characteristics
	where put(c21enprf,c21enprf.) contains 'two-year'
		and fipstate(fips) eq 'MA'

intersect

	select unitid
	from ipeds.TuitionAndCosts
	where tuition2 ne . and tuition3 ge 10*tuition2

;
quit;

proc sql; 
create table except as

	select UnitId
	from ipeds.characteristics
	where put(c21enprf,c21enprf.) contains 'two-year'
		and fipstate(fips) eq 'MA'

except /*A \(not or except) B (this says In A, Not B)*/
		/*Order dependent-- preserves records from the first listed, then removes the ones that are not in the second*/

	select unitid
	from ipeds.TuitionAndCosts
	where tuition2 ne . and tuition3 ge 10*tuition2
;
quit;


proc sql; 
create table Union as

	select UnitId
	from ipeds.characteristics
	where put(c21enprf,c21enprf.) contains 'two-year'
		and fipstate(fips) eq 'MA'

union /*union is everything but duplicates are removed*/

	select unitid
	from ipeds.TuitionAndCosts
	where tuition2 ne . and tuition3 ge 10*tuition2
	order by UnitId
;
quit;

proc sql; 
create table Unionall as

	select UnitId
	from ipeds.characteristics
	where put(c21enprf,c21enprf.) contains 'two-year'
		and fipstate(fips) eq 'MA'

union all /*Keeps Duplicates*/

	select unitid
	from ipeds.TuitionAndCosts
	where tuition2 ne . and tuition3 ge 10*tuition2
	order by UnitId
;
quit;

proc sql;
create table NP1415 as

	select *
	from sasdata.np_2014

union

	select *
	from sasdata.np_2015
;
create table NP1516 as

	select *
	from sasdata.np_2015

union 

	select *
	from sasdata.np_2016
;
/*these both work the same, even without the renaming 
		we did with Data Step concatenation...
		Alignment with set operators is positional --
		first columns are aligned, second, ...*/

/*Even if names match, positions are used (position in select statement should be the same*/

/*OR-- use 'Union Corresponding' to align on column names-- only keeps things in both tables*/
quit;


*Union of 3 tables; 
proc sql;
create table NP141516U as

	select *
	from sasdata.np_2014

union

	select *
	from sasdata.np_2015

union

	select *
	from sasdata.np_2016

/*Order by statement still has to come at the very end here*/
;
quit;

proc sql;
create table NP141516UC as

	select *
	from sasdata.np_2014

union corresponding

	select *
	from sasdata.np_2015

union corresponding

	select *
	from sasdata.np_2016

/*Order by statement still has to come at the very end here*/
;
quit;

proc sql;
create table NP141516OU as

	select *
	from sasdata.np_2014

outer union

	select *
	from sasdata.np_2015

outer union

	select *
	from sasdata.np_2016

/*Order by statement still has to come at the very end here*/
;
quit;















