libname SASData '~/SASData';
libname IPEDS '~/IPEDS';
options fmtsearch = (IPEDS);

/*
 For IPEDS (Use Proc SQL for all data manipulation)

	1. Take total graduation rate as response variable

		a. Use iclevel and In-state tuition as predictors in a GLM

		b. Interpret parameter estimates

		c. Use control and in state tutition

*/

proc contents data=ipeds.tuitionandcosts;
run;

proc contents data=ipeds.characteristics;
run;

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
quit;

ods graphics off; 
proc glm data=useglm;
	class iclevel;
	model gradrates = iclevel tution2 / solution;
/*our graduation data only includes 4-year institutions so iclevel cannot be a predictor for this response*/
run;

ods graphics off; 
proc glm data= useglm ;
	model GradRate = tuition1k / solution;
run;

proc sql;
create table UseGLMB as 

	select GradRate, control, tuition2 / 1000 as tuition1k 

	from GradRates inner join ipeds.characteristics as ch on gradrates.unitid eq ch.unitid
		inner join ipeds.tuitionandcosts as tc on ch.unitid eq tc.unitid
;
quit;

ods graphics off; 
proc glm data = useglmB ;
	class control;
	model GradRate = control tuition1k / solution;
run;

ods graphics off; 
proc glm data = useglmB ;
	class control;
	model GradRate = control | tuition1k / solution;
run;

proc standard data = useglmb out=GLMSTD mean=0;
var tuition1k;
run;

ods graphics off; 
proc glm data = GLMSTD;
	class control; 
	model gradrate = control | tuition1k / solution;
run;

/*
1. Can you do centering in your sql query instead of invoking another procedure

2. What if we wanted to use biological sez as a predictor? Can you set the data up to do that. 

*/




	























