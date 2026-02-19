*Heatmap;
proc sgplot data=mapsgfk.uscounty; 
	polygon x=x y=y id=id / colorresponse=density fill outline;
	where state eq 37;
run; 

/* -- Levels of Measurement --

	1. Quantitative - measure quantity or amount 
		1.1. Measures some qunatity with units (universally agreed upon standard/size )
		1.2. Continous (generally)
		1.3. Interval vs Ration 
			1.3.1 - Differrence between two values retains its meaning in the original units 
				1.3.1.1 - 2nd highest level of measurement
			1.3.2 - Ratios are meaningful (true if 0 means none) 
				1.3.2.1 - highest level of measurement

	2. Qualitative (categorical) - identifies a characteristic of the item, may be represented in a variety of ways, typically without units
		2.1. Category that the observation belongs in 
		2.2. Quality it has 
		2.3. Discrete (generally)
		2.4. Nominal vs Ordinal 
			2.4.1 - Ordinal means that the categories have a ranking (ordering) that is universally agreed upon 
				2.4.1.1 - 2nd lowest level of measurement
			2.4.2 - Nominal places into unranked categories 
				2.4.1.2 - lowest level of measurement

	3. Discrete vs Continous 
		3.1. Discrete variables are distinct, separate, and countable
		3.2. Continuous variables can take on any value within a given range, there are an infinite number of possibilities between any two points

	4. Measure of Variation 
		4.1. The most well known measure of variability is standard deviation (and its alter ego, variance). The standard deviation is designed 
				to measure the mean distance from the sample mean. 
		4.2. Standard deviation is the square root if the sample variance 
		4.3. the mean distance from the mean is computed as the square root of the average squared distance, with 
				a divisor of n-1 instead of n  
		4.4. The distance between these two, Q3 − Q1, is taken as a measure of variability known as the inter-quartile range.
		4.5. Variability for nominal measurements is generally ignored, but that does not mean there are no such measures. 
				One case that does not get ignored is the binary case, like yes/no responses.
*/

proc sort data=sashelp.heart out=HeartSort; 
	by descending bp_status; 
run;

proc freq data = HeartSort order=data; 
	table bp_status; 
run; 

proc means data = sashelp.heart median; 
	var Diastolic Systolic; 
run; 

*can do it this way, but not most efficent; 
proc sort data=sashelp.heart out=BPSort; 
	by descending Diastolic Systolic; 
run;

proc freq data = BPSort order=data; 
	table Diastolic Systolic; 
run; 
*;

/* For systolic and diastolic blood pressures in the Heart data set. 
(a) Find the variance and standard deviation. 
(b) Find the five quartiles. 
(c) Find the range and inter-quartile range. 
(d) Can you find all of the above in a single procedure run?
 */ 




