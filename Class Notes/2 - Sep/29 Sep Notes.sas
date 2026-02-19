libname SasData '~/SASData';

/* 

 1. Alpha is a probabilty of type 1 error 
	
	1.1 - Type 1 Error Null Hypothesis is true (Reject H0 | H0 True)

	1.2 - Type 2 errors is accept H0 even though H0 is false (Accept H0 | H0 False)

		1.2.1 - (Accept H0) Test as if variances are equal 

		1.2.2 - (H0 False) Variance Differences 

** Always resonably safe to us the unequal value** 

	-- Even if they are realtively equal, since there would be no difference. If they are unequal, 
		it is safer to use the unequal variance

	2. TwoIndependent Proportions

		2.1 - For interval estimates and tests for a single proportion, large-sample properties relating the sample 
				proportion to the standard normal (Z) distribution are used. Similar properties are used to construct 
				intervals and tests in the two-group case; however, the test is often modified to use a χ2 (chi-squared) 
				test statistic and distribution. This is directly related to the standard normal, but has the advantage 
				of being extendable to more than two groups (and more than two response categories).

		2.2 - Independence and Independence Tests

			2.2.1 - In order to better illustrate the concept of independence, a scenario and associated sample data are provided. 
						Suppose we return to a study that compares a current drug to a proposed drug; however, this time the response 
						is a simple binary condition. For example, presume the drug is a pain medication and the response of each subject 
						is simplified to the drug reduced their pain or did not. In this case, the difference in proportions of those who 
						had their pain reduced on each drug is the parameter of interest. Data for this scenario is given in the file 
						DrugTrial3, and code to summarize it, along with the summary output, are given below.

		2.3 - Independence 

			2.3.1 - P(Responding | New Drug) = P(Non Responding | Current Drug) = Response and Druge are independent of each other 

			2.3.2 - In general, Independence of A and B P(A | B) = P(A), [Response has to work in both directions]
						this is the null assumption

		2.4 - Conditional Probability = P(A and B) / P(B)

			2.4.1 - [P(A | B) = P(A)] = [P(A and B) / P(B)] or P(A | B) = P(A) * P(B)

			2.4.2 - Calulate expected cell counts of this is true 

** Margin of Error is the difference between the UCL and the LCL **
	

*/


*Independent Samples t-test in PROC TTEST;
ods graphics off;
proc ttest data=SASData.DrugTrial2; 
	class group; 
/* for independents groups, the grouping variable goes in a class 
		statement (can only have 2 levels)*/
	var reduction;
/* var is the response variable */
run; 

*Second Independent Samples t-testing in PROC TTEST;
ods graphics off;
proc ttest data=SASData.WeightLoss; 
	class group; 
	var loss; 
run;


*Frequency Table for Responders;
proc sort data=SASData.DrugTrial3 out=Trial3; 
	by descending group descending response; 
run;

proc freq data=Trial3 order=data;
	table group*response /nocol; 
run;

proc freq data=Trial3 order=data;
	table group*response /nocol expected; 
/* Expected gives expected cell counts under the independence assumption */ 
run;


proc freq data=Trial3 order=data;
	table group*response /nocol expected chisq; 
/* chisq produces several chi - square stats and p-values .. */ 
run;

proc freq data=Trial3 order=data;
	table group*response /nocol expected chisq
		deviation cellchi2; 
/* Individual cell contributions can be put into the table*/ 
run;

proc freq data=Trial3 order=data;
	table group*response /nocol chisq riskdiff alpha=.10; 
	ods exclude fishersexact RiskDiffCol2; 
/* */ 
run;












