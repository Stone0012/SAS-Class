libname SASData '~/SASData';
libname IPEDS '~/IPEDS';
options fmtsearch = (IPEDS);

*Centering in the SQL Query;

proc sql; 
create table GradRates as 

	select grads.unitid,
		grads.total / cohort.total as GradRate

		from ipeds.graduation(where= (group contains 'Completers')) as Grads inner join
			ipeds.graduation(where= (group contains 'Incoming')) as Cohort
			on Grads.UnitID eq Cohort.UnitID
;
create table UseGLM as 

	select GradRate, iclevel, tuition2 / 1000 as tuition1k

	from GradRates inner join ipeds.characteristics as ch on gradrates.unitid eq ch.unitid
		inner join ipeds.tuitionandcosts as tc on ch.unitid eq tc.unitid
;
create table Centered as 

	select GradRate, iclevel, tuition2 / 1000 as tuition1k, mean(tuition2/1000) as Meant1k,
			calculated tuition1k - calculated Meant1k as centered1k

	from GradRates inner join ipeds.characteristics as ch on gradrates.unitid eq ch.unitid
		inner join ipeds.tuitionandcosts as tc on ch.unitid eq tc.unitid

;
quit;

ods graphics off;
proc glm data=somenewdata; 
	class control sex;
	model gradrate = control sex tuition1k / solution;
run; /* set up the data to do this*/

proc sql;
create table GradRatesB as 
	select grads.unitid, grads.men/cohort.men as men, grads.women/cohort.women as women

	from ipeds.graduation(where= (group contains 'Completers')) as Grads inner join
			ipeds.graduation(where= (group contains 'Incoming')) as Cohort
			on Grads.UnitID eq Cohort.UnitID	

	order by grads.unitid

;
quit;

proc transpose data=GradRatesB out=gradrateswm (rename=(col1= GradRate _name_= Sex));
	var Men Women;
	by UnitID;
run;

proc sql; 

create table UseWM as 

	select GradRate, control,sex ,iclevel, tuition2 / 1000 as tuition1k, mean(tuition2/1000) as Meant1k,
			calculated tuition1k - calculated Meant1k as centered1k

	from gradrateswm inner join ipeds.characteristics as ch on gradrateswm.unitid eq ch.unitid
		inner join ipeds.tuitionandcosts as tc on ch.unitid eq tc.unitid
;
quit;


ods graphics off;
proc glm data=UseWM; 
	class control sex;
	model gradrate = control | centered1k sex | centered1k  / solution;
run; 

proc means data=usewm min q1 mean median q3 max; 
	class control sex;
	var tuition1k; 
	ways 0 1 2;
run;

proc sql;
create table GradRatesB as

	select grads.unitid, grads.men/cohort.men as men, grads.women/cohort.women as women

	from ipeds.graduation(where= (group contains 'Completers')) as Grads inner join
			ipeds.graduation(where= (group contains 'Incoming')) as Cohort
			on Grads.UnitID eq Cohort.UnitID	

	order by grads.unitid
;
create table Joinwithmw as 

	select gradratesb.unitid, Men, Women, control, tuition2  / 1000 as tuition1k, mean(tuition2/1000) as Meant1k,
			calculated tuition1k - calculated Meant1k as centered1k

	from GradRatesB inner join ipeds.characteristics as ch on GradRatesB.unitid eq ch.unitid
		inner join ipeds.tuitionandcosts as tc on ch.unitid eq tc.unitid
;
quit;

proc transpose data = joinwithmw out=try1(rename=(col1= GradRate _name_= Sex));
	var Men Women;
	by Unitid;
run; /*only the variables used in the statements, plus the rname of _name_ appear*/

proc transpose data = joinwithmw out=try2(rename=(col1= GradRate _name_= Sex));
	var Men Women;
	by Unitid control tuition1k Meant1k;
run; /*any other variables are also unique to the By groups useful for copying over other variables to the transposed data*/ 


/*Can you create that data in SQL only? No transpose or anything else */

proc sql;
create table GradRatesMen as

	select grads.unitid, grads.men/cohort.men as men

	from ipeds.graduation(where= (group contains 'Completers')) as Grads inner join
			ipeds.graduation(where= (group contains 'Incoming')) as Cohort
			on Grads.UnitID eq Cohort.UnitID	

	order by grads.unitid
;
create table GradRatesWomen as

	select grads.unitid, grads.women/cohort.women as women

	from ipeds.graduation(where= (group contains 'Completers')) as Grads inner join
			ipeds.graduation(where= (group contains 'Incoming')) as Cohort
			on Grads.UnitID eq Cohort.UnitID	

	order by grads.unitid
;
quit;

proc sql; 
create table GradWomenMen as 

	select grads.unitid, 'Men' as Sex, grads.men/cohort.men as GradRate

		from ipeds.graduation(where= (group contains 'Completers')) as Grads inner join
			ipeds.graduation(where= (group contains 'Incoming')) as Cohort

			on Grads.UnitID eq Cohort.UnitID	

union

	select grads2.unitid, 'Women' as Sex, grads2.women/cohort2.women as GradRate

		from ipeds.graduation(where= (group contains 'Completers')) as Grads2 inner join
			ipeds.graduation(where= (group contains 'Incoming')) as Cohort2

			on Grads2.UnitID eq Cohort2.UnitID	

;
quit;




