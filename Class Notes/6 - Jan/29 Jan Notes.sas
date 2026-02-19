libname stat1 '~/ECST142/data';
options fmtsearch=(stat1.myfmts);

*Practice: Using PROC GLM to Perform Post Hoc Pairwise Comparisons;

proc glm data=stat1.garlic;
	class fertilizer;
	model bulbwt = fertilizer / solution;
	lsmeans fertilizer / diff adjust= tukey lines;
run;

proc glm data=stat1.garlic;
	class fertilizer;
	model bulbwt = fertilizer / solution;
	lsmeans fertilizer / diff=control('4') adjust=dunnett;
run;

proc glm data=stat1.garlic;
	class fertilizer;
	model bulbwt = fertilizer / solution;
	lsmeans fertilizer / diff adjust=T;/*just do t-tests, no adjustments*/
run;

/*st102d04.sas*/  /*Part A*/
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

ods graphics / reset=all imagemap;
proc corr data=STAT1.AmesHousing3 rank
          plots(only)=scatter(nvar=all ellipse=none);
   var &interval;
   with SalePrice;
   id PID;
   title "Correlations and Scatter Plots with SalePrice";
run;

/*st102d04.sas*/  /*Part B*/
ods graphics off;
proc corr data=STAT1.AmesHousing3 
          nosimple 
          best=3;
   var &interval;
   title "Correlations and Scatter Plot Matrix of Predictors";
run;

proc corr data=stat1.AmesHousing3;
	var basement_area;
	with saleprice;
	ods output pearsonCorr = correlations;
run; 

proc glm data=stat1.AmesHousing3;
	model SalePrice = Basement_Area; /*only need class statement with categorical variables*/
	ods output ParameterEstimates=Params;
run;/*test for parameter significance in bivariate regression 
		and for correlation is exactly the same.. If the corr is the same between two variables than the betas will be as well*/

*Simple Linear Regression;

proc reg data=stat1.ameshousing3;
	model saleprice = lot_area;
	output out = results r=reside;
run;


proc reg data=stat1.bodyfat2;
	model PctBodyFat2 = weight;
	output out=results2 r=reside;
run;








