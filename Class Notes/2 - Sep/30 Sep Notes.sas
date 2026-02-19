libname SASData '~/SASData';

/*

	1. Dependent Proportions 

		1.1 - Situations where dependent proportions are compared are often focused on the concept of agreement. 
				For example, suppose two physicians are asked to read images (x-ray, MRI, or the like) for several 
				patients and render a binary diagnosis for each: tumor or not, arterial blockage or not, etc. It 
				would be expected that the two diagnoses, whether positive or negative, would be most likely to 
				match on each patient.Perfect agreement in a smaple says n12 = n21 = 0, which is clearly the full 
				opposite of independence. In general, we do not expect perfect agreement, but we do expect more 
				agreement than disagreement. And if the two items compared perform the same, we expect the proportions
				of disagreement not to favor any particular direction.

	2. Testing Depende Proportions 

		2.1 - To formulate a null hypothesis in this case, we expect disagreement to be randomly distributed, i.e. not 
				more likely in one direction than another. So the common test in this situation, McNemar’s test, focuses 
				on the disagreement proportions: H0 : p12 = p21 Ha : p12 ̸ = p21 And the test statistic is then entirely focused 
				on the n12 and n21 cell counts: Q= (n12 −n21)2 n12 +n21 (7.1) (7.2) The assumption that this statistic has an 
				approximate χ2 distribution requires n12 and n21 each to be relatively large (totalling at least 20).

	3. McNemar’s Test in PROC FREQ

		3.1 - ods graphics off; ods trace on;
				 proc freq data=StatData.DiagnosticTest order=freq; 
				table test1*test2 / agree; ods exclude KappaStatistics;
				run;

		3.2 - Testing for Agreement or Disagreement 



*/

ods graphics off; ods trace on;
	proc freq data=SASDATA.DiagnosticTest order=freq; 
/* order = freq starts with highest frequency...*/
	table test1*test2 / agree; ods exclude KappaStatistics;
/* agree conducts McNemar's test for dependent proportions (among other things)*/
run;


*Exercises;

/* 1. Using the SASHELP.CARS data as if it were a random sample: 

	(a) Test for a difference in average city MPG between cars from Asia and Europe. 
		Also, construct a confidence interval for the mean difference, and state a 
		conclusion from these results. 

	(b) Do the same as the previous for Asia vs. US, and US vs. Europe. */ 


*1.A; 

ods graphics off;
Title 'Asia v. Eurpoe';
proc ttest data=sashelp.cars; 
	class origin; 
	where origin ne 'USA';
	var mpg_city;
run; 

*1.B; 
ods graphics off;
Title 'US v. Eurpoe';
proc ttest data=sashelp.cars; 
	class origin; 
	where origin ne 'Asia';
	var mpg_city;
run; 

ods graphics off;
Title 'US v. Asia';
proc ttest data=sashelp.cars; 
	class origin; 
	where origin ne 'Europe';
	var mpg_city;
run; 


/* 2. Using the SASHELP.CARS data as if it were a random sample: 

	(a) Construct an interval for the average difference between highway gas 
		and city mileage. Conduct a test to see if the highway mileage exceeds 
		the city mileage by more than 5 MPG (be sure to state a conclusion). 

	(b) Do the same as the previous for Trucks and SUVs only. */ 

*2.A; 

ods graphics off;
Title 'Highway v. City MPG';
proc ttest data=sashelp.cars H0 = 5; 
/* null hypothesis is 5 */ 
	paired mpg_highway * mpg_city;
run; 

ods graphics off;
Title 'Truck v. SUV MPG';
proc ttest data=sashelp.cars H0 = 5; 
/* null hypothesis is 5 */ 
	paired mpg_highway * mpg_city;
	where type in ('Truck' 'SUV');
run; 


*2.B; 


*/ 3. Using the SASHELP.HEART data as if it were a random sample: 

	(a) Construct an interval for the difference in proportion of 
		people with high cholesterol for those who have high blood 
		pressure versus those who have normal blood pressure. 
		Conduct a test for this difference and state your conclusion. 

	(b) Using the same response, high cholesterol, repeat the previous 
		for the difference between females and males. */ 

*3.A;

proc format; 
	value $chol 
		'High' = 'High'
		other = 'Not High';
run;

ods graphics off;
	proc freq data=sashelp.heart order=formatted; 
	table bp_status * chol_status / chisq riskdiff;
	format chol_status $chol.;
	where chol_status ne '' and bp_status in ('High' 'Normal');
	ods exclude fishersExact;
run;

ods graphics off;
	proc freq data=sashelp.heart order=formatted; 
	table sex * chol_status / chisq riskdiff;
	format chol_status $chol.;
	where chol_status ne '';
	ods exclude fishersExact;
run;






















