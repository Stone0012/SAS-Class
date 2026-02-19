/*
	1. Statistical Hypothesis 

		1.1 - Any statement made about a population parameter(s), 
				or a statement that can be formulated in terms of a parameter(s)

	2. Null Hypothesis (H0) 

		2.1- A statement that there is no significant effect, relationship, or difference 
				between variables in a population, serving as the default assumption in hypothesis testing.

	3. Alternative Hypothesis (HA) 

		3.1 - A statement that claims there is a significant difference or relationship 
				between two or more groups or variables, directly contradicting the null hypothesis 

	4. The decision to reject H0 or not is based on a probability calculation, known as a p-value from sample data. 

	5. In practice, the type I error rate is set by the investigator. It is denoted by α and is set to a relatively low value, 
		usually less than 0.10. (Yes, this is related to the α used in confidence intervals.) The type II error rate is then a 
			function of items similar to what influences the size of the margin of error for an interval

		5.1 - Sample size, Effect size (which includes variability), Type 1 errir rate (α) 

	6. Degrees of Freedom (DF) is n - 1 

	7. (t) value represents the difference between the observed data and the null hypothesis, scaled by the standard error 
			and (T) is a random variable 

	8. p-value is the probability of observing the sample data, or more extreme data, assuming the null hypothesis is true. 
		A low p-value (typically < 0.05) suggests that your results are unlikely to have occurred by random chance alone, 
			leading you to reject the null hypothesis in favor of the alternative hypothesis

	9. If your computed p value (Pr > |t|) is less than your type 1 error (set by you) then you reject the null in favor of 
		the hypothesis. 
		
		9.1 - α: fixed significance level . p-value: observed 

			9.1.1 T test automatically gives you both directions (if 95% confidenet then on either side of the bell curve
				you have 2.5% error rate) if you are looking for one specific direction you can have all 5% on one side

*/

proc means data=sashelp.heart  n mean std stderr;
	var systolic; 
	where weight_status eq 'Normal';
run; 

proc means data=sashelp.heart  n lclm mean std uclm;
	var systolic; 
	where weight_status eq 'Normal';
run; 

proc means data=sashelp.heart  t probt;
	/* t and probt are t-statistics and its p-value, respectively 
		assuming the null mean is 0 (and you cant change that)*/
	var systolic; 
	where weight_status eq 'Normal';
run; 

/* can make it work .. */ 
data heartMod; 
	set sashelp.heart; 
	where weight_status eq 'Normal';
	systolicAdj = systolic - 130; 
run; 

proc means data = heartMod t probt; 
	/* move 130 to 0 as an adjustment */
	var systolicAdj; 
run; 

/* t- test allows you to pick the null value */ 

ods graphics off;
proc ttest data=sashelp.heart h0=130; 
	var systolic;
	where weight_status eq 'Normal';
run;

proc format; 
	value $hbp 
	'High'='High' 
	other='Not High'; 
run; 

proc freq data=sashelp.heart; 
	format BP_status $hbp.;
	where weight_status eq 'Normal';
	table BP_status / binomial(h0=0.3); 
	*ods select onewayfreqs binomialTest;
run;

proc freq data=sashelp.heart; 
	table BP_status / binomial(h0=0.45); 
	format BP_status $hbp.; 
	*ods select onewayfreqs binomialTest;
run;

/* if you are doing one tail, you have to ensure the sample lands on the side that you are interested in */ 












