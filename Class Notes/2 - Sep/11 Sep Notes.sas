/* SGplot is used to make individual graphs */

proc sgplot data=sashelp.cars;
	hbar origin;
/* hbar -- horizontial bar chart */
run;

proc sgplot data=sashelp.class;
  vbar type;
/* vbar-vertical 
	each sumarizes frequency in each category of the listed variable */ 
run;

proc sgplot data=sashelp.stocks; 
	hbar date; 
		where high gt 100; 
run;  /* for charting variable in Hbar or Vbar, each distinct value 
			is a category/bar (like class in Means and Table in Freq)*/

proc sgplot data=sashelp.stocks; 
	hbar date; 
		where high gt 100; 
			format date qtr.; /* categorization is done with respect to the active format */
run;

proc sgplot data=sashelp.cars;
	hbar origin / stat=percent;
/* the summary statistic is changeable -> for categories only, you can have 
	frequency (default) or percent */ 
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city; 
/* response= chooses a numeric (quantitative) variable to summarize */
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=median;
/* when response= is active, mean, median, or sum(default) are available statistics */ 
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=percent;
/* if you mismatch a stat type= type and response=... */
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=mean;
/* ... a component is ignored (the quantitative part) */
run;

proc sgplot data=sashelp.stocks;
	hbar stock / response=volume group =date;
/* group= splits the bars into pieces corresponding to the different levels of the variable 
	-> categorization. This should be a limited set of categories 
		either natively or via formatting */
		format date qtr.;
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=median group = type;
		where type in ('SUV','Truck');
/* default behavior of stacking is not particularly appropriate for mean or median */ 
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=median group = type groupdisplay=cluster; /* stack or cluster are the only options the cluster 
																						 groupdisplay creates a separate bar for each level of
																							the group variable at each level of the charting variable */ 
		where type in ('SUV','Truck');
run;

proc sgplot data=sashelp.cars;
	hbox mpg_city / group = origin; 
run; 

proc sgplot data=sashelp.cars;
	hbox mpg_city / category = origin; 
run; 

/* some statements make plots like HBAR, HBOX, VBAR, VBOX,... 
	some statements style elements of the graph */ 
proc sgplot data=sashelp.cars;
	hbar origin / response=msrp stat=mean;
		xaxis values=(0 to 50000 by 2500) fitpolicy=stagger;
			/* axis (x or y) modify acis items -- values are the items placed at each major tick */ 
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=msrp stat=mean;
		xaxis values=(0 to 50000 by 5000) label='Average Retail Price' labelpos=center;
/* can set a label and its position */
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=msrp stat=mean;
		xaxis values=(0 to 50000 by 5000) label='Average Retail Price' labelpos=center;
			yaxis display= (nolabel);
/* display is used to turn things off typically... */
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=msrp stat=mean group=origin;
		xaxis values=(0 to 50000 by 5000) label='Average Retail Price' labelpos=center;
			yaxis display= none;
/* ... and that can be none if the acis features at all*/
run;

proc sgplot data=sashelp.cars noborder;
/* the axes are completed into a rectangular border, which can be removed using noborder */
	hbar origin / response=msrp stat=mean group=origin;
		xaxis values=(0 to 50000 by 5000) label='Average Retail Price' labelpos=center;
			yaxis display= none;
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=msrp stat=mean;
		xaxis values=(0 to 50000 by 5000) label='Average Retail Price'
			labelattrs=(family='Monseratt' style=italic size=12pt);
			/* labels are text, so labelattrs= controls those text attributes*/
		yaxis display= (nolabel) valueattrs=(weight=bold color=blue);
/*valueattrs= sets options for the text that is placed at the major tick marks*/
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=msrp stat=mean;
		xaxis values=(0 to 50000 by 5000) label='Average Retail Price'
			labelattrs=(family='Monseratt' style=italic size=12pt);
		yaxis display= (nolabel) valueattrs=(weight=bold color=cxff0000);
/*you can specify colors with various models -- one is RGB
	cxRRGGBB where each pair is in hex-code (00 to FF -> 0 to 225)*/
run;

/* -- Visabone color lab & Color Brewer-- website to find codes for colors 
		- color brewer is a little better for graphs*/ 






















