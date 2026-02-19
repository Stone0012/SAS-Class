proc sgplot data=sashelp.cars;
	hbar origin / response=msrp stat=mean;
		xaxis values=(0 to 50000 by 5000) label='Average Retail Price'
			labelattrs=(family='Liberation Sans' style=italic size=12pt);
		yaxis display= (nolabel) valueattrs=(weight=bold color=blue);
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=mean group = type groupdisplay= cluster;
	where type ne 'Hybrid';
		/* the legend can be odified with the KEYLEGEND statement */ 
	keylegend / border position=topright location=inside;
		/*location = inside or outside the graphing area */
		/* keylegend name / options; name can be and often is blank */  
	yaxis display= (nolabel) valueattrs=(weight=bold color=red);
	xaxis values=(0 to 25 by 5) label='Average City MPG'
			labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;


proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=mean group = type groupdisplay= cluster;
	where type ne 'Hybrid';
	keylegend / border position=bottomright location=inside across = 1;  
		/* across= limits the available columns, down= limits rows (typically you pick one) */
	yaxis display= (nolabel) valueattrs=(weight=bold color=red);
	xaxis values=(0 to 25 by 5) label='Average City MPG'
			labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=mean group = type groupdisplay= cluster;
	where type ne 'Hybrid';
	keylegend / border position=topright location=inside across = 1;  
		/* sometimes the legend doesn't exactly fit where you may want it...*/
	yaxis display= (nolabel) valueattrs=(weight=bold color=red);
	xaxis values=(0 to 25 by 5) label='Average City MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt)
		offsetmax=0.040 /* offsetmax=0.025 -> distance between last tick and edge of box to be 2.5% of the available area */ ;
run;


proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=mean group = type groupdisplay= cluster;
	where type ne 'Hybrid';
	keylegend / border position=topright location=inside across = 1
		title='';  
			/* There is no label for a legend, it is a title.
				to remove it, use a null string */
	yaxis display= (nolabel) valueattrs=(weight=bold color=red);
	xaxis values=(0 to 25 by 5) label='Average City MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt)
		offsetmax=0.040;
run;

proc sgplot data=sashelp.cars;
	hbar origin / response=mpg_city stat=mean group = type groupdisplay= cluster;
	where type ne 'Hybrid';
	keylegend / border position=topright location=inside across = 1
		title='' valueattrs=(color=cx31d942 weight=bold);  
	/* attrs are available for title and values in the legend*/
	yaxis display= (nolabel) valueattrs=(weight=bold color=red);
	xaxis values=(0 to 25 by 5) label='Average City MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt)
		offsetmax=0.040;
run;

proc sgplot data=sashelp.cars;
	where type ne 'Hybrid';
	hbar origin / response=mpg_highway stat=mean;
	hbar origin / response=mpg_city stat=mean;
	/* you can have multiple potting statements inside a procedure. 
		the first one is put down first, second one is nex, and so on... 
		color cycling is automatic and so is the legend*/
	yaxis display= (nolabel) valueattrs=(weight=bold);
	xaxis values=(0 to 30 by 5) label='Average MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;

proc sgplot data=sashelp.cars;
	where type ne 'Hybrid';
	hbar origin / response=mpg_city stat=mean;
	hbar origin / response=mpg_highway stat=mean transparency=.3;
		/* transparency= is also a proportion: default is 0 -> fully opaque
			1 is the max, fully transparent*/
	yaxis display= (nolabel) valueattrs=(weight=bold);
	xaxis values=(0 to 30 by 5) label='Average MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;


proc sgplot data=sashelp.cars;
	where type ne 'Hybrid';
	hbar origin / response=mpg_city stat=mean;
	hbar origin / response=mpg_highway stat=mean 
			transparency=.3 barwidth=0.6;
		/*barwidth= is a proportion too. It is the proportion of space allocated 
			to the bar */
	yaxis display= (nolabel) valueattrs=(weight=bold);
	xaxis values=(0 to 30 by 5) label='Average MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;


proc sgplot data=sashelp.cars;
	where type ne 'Hybrid';
	hbar origin / response=mpg_city stat=mean
			barwidth=0.4 discreteoffset=0.2;
	hbar origin / response=mpg_highway stat=mean 
			barwidth=0.4 discreteoffset=-0.2;
		/*discreteoffset= only works for a categorical/discrete axis
			moves the plotting position away from the major tick mark, (default center) */
	keylegend /position=bottomright location=inside;
	yaxis display= (nolabel) valueattrs=(weight=bold);
	xaxis values=(0 to 30 by 5) label='Average MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt);
	label mpg_city = 'City' mpg_highway = 'Highway';
run;

proc sgplot data=sashelp.cars;
	where type ne 'Hybrid';
	hbar origin / response=mpg_city stat=mean
			barwidth=0.4 discreteoffset=0.2
			filltype=gradient
			fillattrs=(color=cx6666ff);
	hbar origin / response=mpg_highway stat=mean 
			barwidth=0.4 discreteoffset=-0.2
			filltype=gradient
			fillattrs=(color=cxffaa66);
/* fillattrs= can control color and transparency for bar fills
		can't give more than one color */
	keylegend /position=bottomright location=inside;
	yaxis display= (nolabel) valueattrs=(weight=bold);
	xaxis values=(0 to 30 by 5) label='Average MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt);
	label mpg_city = 'City' mpg_highway = 'Highway';
run;
	

proc sgplot data=sashelp.cars;
	styleattrs datacolors= (cx1b9e77 cxd95f02 cx7570b3 cxe7298a cx66a61e)
			datacontrastcolors=(black);
		/* styleattrs allows you to alter default stype lists, 
				datacolors= sets the fill colors
			datacontrastcolors= is for lines and markers, 
				here I am setting it so that all bar outlines are black
			if you don't give it a list long enough for your colors, but 
				has more than one element it tries to alter the gradient 
				as it moves across categories */
	hbar origin / response=mpg_city stat=mean group = type groupdisplay= cluster;
	where type ne 'Hybrid';
	keylegend / border position=topright location=inside across = 1
		title='' valueattrs=(color=cx31d942 weight=bold);  
	/* */
	yaxis display= (nolabel) valueattrs=(weight=bold color=red);
	xaxis values=(0 to 25 by 5) label='Average City MPG'
		labelattrs=(family='Liberation Sans' style=italic size=12pt)
		offsetmax=0.040;
run;

















