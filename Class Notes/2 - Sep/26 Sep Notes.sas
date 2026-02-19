proc format; 
	value $hbp 
	'High'='High' 
	other='Not High'; 
run; 

/* get the upper bound for proportion w/95% confidence*/
proc freq data=sashelp.heart; 
	format BP_status $hbp.;
	where weight_status eq 'Normal';
	table BP_status / binomial(h0=0.3) alpha=0.10; 
/* 90% confidence in both directions = 95% confidence in only one (upper or lower) */ 
	*ods select onewayfreqs binomialTest;
run;

/* --- Two Sample Notes --- */ 

/*
	1. Independent and Dependent Samples 

		1.1 - Independent - How subjects respond under one condition has no bearing on the likelihood of how subjects 
				in the other condition respond 

			1.1.1 - Subjects are randomly assigned to receive the drug or a placebo. At the end of 16 weeks, their A1C levels are measured.

				1.1.2 - so long as people from different families/households are recruited, there should be no expectation that 
							the A1C values in one group are in any way related to those in the other group

		1.2 - Dependent - This is not expected to be the case, though it is possible
			
			1.2.1 - Subjects have their A1C measured when they are recruited for the study. They are then administered the drug and 
						have their A1C measured at the end of 16 weeks.
		
				1.2.2 - In the second design the same subjects are measured under the two different conditions, so there is
						 obviously a potential relationship between the values under each condition.

	2. Intervals and Tests for Means from Two Dependent Samples

		2.1 - Paired T - Test in SAS 
		
			2.1.1 - md = mean difference in ____ , d = end-start, µ = represents the population mean, which is the average of all 
					data points in an entire population 

			2.1.2 - For a hypothesis test, the null hypothesis has: H0 : µd = 0, but the potential alternatives should be
				 carefully considered. The hypothesis of efficacy is µd < 0, since effective implies the endpoint measurement
				 	is lower than the baseline, thus giving a negative difference. Of course, µd > 0 indicates the drug actually 
						makes blood pressure worse
						
	3. Differences in Means for Independent Samples

		3.1 - For independent samples, pairing is not possible; indeed, the two samples may even be of different sizes. 
				In these cases, the sample means are computed separately for each sample and the difference is taken between 
				those: X1 −X2. Toconstruct a margin of error or test statistic based on the t-distribution, the standard error 
				of this difference must be determined. However, the degrees of freedom associated with this estimator vary in 
				relation to the variances of the two groups.

		3.2 - Equal Variances

			3.2.1 - Lose 2 degrees of freedome here 

		3.3 - Unequal Variances 

			3.3.1 - 
				




*/

libname SasData '~/SASData';

ods graphics off;
proc ttest data=SASData.DrugTrial1; 
	paired endValue*baseline; 
/* Paired A * B; does A*B as a one-sample test */
run;
/* Highly significant evidence that the drug is effective,
		reduction appears to be at least 18mmhg, on average
			(with 95% confidence) */


ods graphics off; 
proc ttest data=sashelp.cars h0=-5; 
	/* testing to see if the difference is more/less than 5 
		with respect to how we are doing the difference 
			in PAIRED*/
	paired mpg_city * mpg_highway; 
	where type eq 'Truck';
run; 

data diffs; 
	set sashelp.cars; 
	where type eq 'Truck';
	mpgDiff = mpg_city - mpg_highway; 
run; 

proc means data=diffs;
	var mpgDiff; 
run; 

ods graphics off;
proc ttest data=SASData.DrugTrial2; 
	class group; 
/* for independents groups, the grouping variable goes in a class 
		statement (can only have 2 levels)*/
	var reduction;
/* var is the response variable */
run;













