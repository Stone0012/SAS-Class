libname stat1 '~/ECST142/data';
options fmtsearch=(stat1.myfmts);

/*st103d01.sas*/  /*Part A*/
ods graphics off;
proc means data=STAT1.ameshousing3
           mean var std nway;
    class Season_Sold Heating_QC;
    var SalePrice;
    format Season_Sold Season.;
    title 'Selected Descriptive Statistics';
	ways 1 2;
run;

/*st103d01.sas*/  /*Part B*/
proc sgplot data=STAT1.ameshousing3;
    vline Season_Sold / group=Heating_QC 
                        stat=mean 
                        response=SalePrice 
                        markers;
    format Season_Sold season.;
run; 

/*st103d01.sas*/  /*Part C*/
ods graphics on;
/*This is a bad idea... have to test interaction first*/
proc glm data=STAT1.ameshousing3 order=internal;
    class Season_Sold Heating_QC;
    model SalePrice = Heating_QC Season_Sold;
    lsmeans Season_Sold / diff adjust=tukey;
    format Season_Sold season.;
    title "Model with Heating Quality and Season as Predictors";
run;

/*st103d02.sas*/  /*Part A*/
ods graphics on;

proc glm data=STAT1.ameshousing3 
         order=internal 
         plots(only)=intplot;
    class Season_Sold Heating_QC;
    model SalePrice = Heating_QC Season_Sold Heating_QC*Season_Sold;
						/*Heating_QC|Season_sold*/
    lsmeans Heating_QC*Season_Sold / diff slice=Heating_QC
										slice = Season_Sold;
    format Season_Sold Season.
			Heating_QC $Heating_QC.;
    store out=interact;
    title "Model with Heating Quality and Season as Interacting Predictors";
run; /*Okay, but incomplete*/

/*st103d02.sas*/  /*Part B*/
proc plm restore=interact plots=all;
    slice Heating_QC*Season_Sold / diff adjust=tukey;
    effectplot interaction(sliceby=Heating_QC) / clm;
run; /*I can get slices from GLM by storing the results and running it through PLM*/

title;

/*st103d02.sas*/  /*Part A pt 2*/
ods graphics on;
proc mixed data=STAT1.ameshousing3;
    class Season_Sold Heating_QC;
    model SalePrice = Heating_QC Season_Sold Heating_QC*Season_Sold;
						/*Heating_QC|Season_sold*/
    *lsmeans Heating_QC*Season_Sold / diff slice=Heating_QC
										slice = Season_Sold;
	slice Heating_QC*Season_Sold / diff adjust=tukey;
    format Season_Sold Season.
			Heating_QC $Heating_QC.;
run; 



