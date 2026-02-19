libname SASData '~/SASData';
libname IPEDS '~/IPEDS';
options fmtsearch = (IPEDS);

*Summary Tables to be Used in UNION Examples;
proc sql;
	select c21enprf, mean(tuition2) format=dollar12.2
		from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
			on tc.unitID eq ch.unitID
		where c21enprf gt 0
		group by c21enprf
;
	select control, mean(tuition2) format=dollar12.2
		from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
			on tc.unitID eq ch.unitID
		where control gt 0
		group by control
;
quit;

*UNION of Summary Tables, Version 1;
proc sql;
	select c21enprf, mean(tuition2) format=dollar12.2
		from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
			on tc.unitID eq ch.unitID
		where c21enprf gt 0
		group by c21enprf

union

	select control, mean(tuition2) format=dollar12.2
		from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
			on tc.unitID eq ch.unitID
		where control gt 0
		group by control
		/*aligning the startification variables and the averages seems reasonable 
			for a union, but the result is strange

		Each of conttrol and c21enprf are numeric variables that are formatted--
			the column constructed by the union inherits the first format encountered */
;
quit;

proc sql;
	select c21enprf as type, mean(tuition2) as AvgInState format=dollar12.2
		from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
			on tc.unitID eq ch.unitID
		where c21enprf gt 0
		group by c21enprf

union corresponding

	select control as type, mean(tuition2) as AvgInState format=dollar12.2
		from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
			on tc.unitID eq ch.unitID
		where control gt 0
		group by control
;
quit;

*UNION of Summary Tables, Final Version v1;
proc sql;
	select put(c21enprf,c21enprf.) as Type,
			mean(tuition2) format=dollar12.2
		from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
			on tc.unitID eq ch.unitID
		where c21enprf gt 0
		group by Type

union

select put(control,control.) as Type,
		mean(tuition2) format=dollar12.2
	from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
		on tc.unitID eq ch.unitID
	where control gt 0
	group by Type
;
quit;

*UNION of Summary Tables, Final Version v2;
proc sql;
	select catx('-','Carnegie',put(c21enprf,1.),put(c21enprf,c21enprf.)) as Type,
			mean(tuition2) format=dollar12.2
		from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
			on tc.unitID eq ch.unitID
		where c21enprf gt 0
		group by Type

union

select catx('-','Control',put(control,1.),put(control,control.)) as Type,
		mean(tuition2) format=dollar12.2
	from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
		on tc.unitID eq ch.unitID
	where control gt 0
	group by Type
;
quit;

*Ex1;
proc sql;
	select Event, BasinName, StartDate, EndDate, MaxWindMPH, cost format = dollar18.
		from sasdata.storm_damage as damage inner join
			sasdata.storm_final as final
			on upcase(scan(Event,-1)) eq name 
		and Year(date) eq season
;
quit;

*Ex2;
proc sql;
	select Event, BasinName, StartDate, EndDate, MaxWindMPH, cost format = dollar18.
		from sasdata.storm_damage as damage inner join
			sasdata.storm_final as final
			on upcase(scan(Event,-1)) eq name 
		and Year(date) eq season
	order by Season desc, cost desc
;
quit;

proc sql outobs=10;

	select np_2015.ParkCode, np_2015.Region, np_2015.State, np_2015.Month, 
			np_2014.DayVisits as Vis2014 label="Vistis:2014" format = comma18.,
			np_2015.DayVisits as Vis2015 label="Vistis:2015" format = comma18.,
			np_2016.DayVisits as Vis2016 label="Vistis:2016" format = comma18.,
			Vis2014 + Vis2015 + Vis2016 as VisTot label = 'Total Vistits' format = comma18.

		from (SASData.np_2014 inner join SASData.np_2015 
				on Park eq ParkCode and np_2014.month eq np_2015.month)
			inner join SASData.np_2016 
				on np_2015.ParkCode eq np_2016.ParkCode and np_2015.month eq np_2016.month
;
quit;

proc sql outobs=10;

	select np_2015.ParkCode,
			sum(np_2014.DayVisits) as Vis2014 label="Vistis:2014" format = comma18.,
			sum(np_2015.DayVisits) as Vis2015 label="Vistis:2015" format = comma18.,
			sum(np_2016.DayVisits) as Vis2016 label="Vistis:2016" format = comma18.,
			calculated Vis2014 + calculated Vis2015 + calculated Vis2016 
					as VisTot label = 'Total Vistits' format = comma18.

		from (SASData.np_2014 inner join SASData.np_2015 
				on Park eq ParkCode and np_2014.month eq np_2015.month)
			inner join SASData.np_2016 
				on np_2015.ParkCode eq np_2016.ParkCode and np_2015.month eq np_2016.month
		group by np_2015.ParkCode

;
quit;

proc sql;

	select np_2015.ParkCode,
			sum(np_2014.DayVisits) as Vis2014 label="Vistis:2014" format = comma18.,
			sum(np_2015.DayVisits) as Vis2015 label="Vistis:2015" format = comma18.,
			sum(np_2016.DayVisits) as Vis2016 label="Vistis:2016" format = comma18.,
			calculated Vis2014 + calculated Vis2015 + calculated Vis2016 
					as VisTot label = 'Total Vistits' format = comma18.

		from (SASData.np_2014 inner join SASData.np_2015 
				on Park eq ParkCode and np_2014.month eq np_2015.month)
			inner join SASData.np_2016 
				on np_2015.ParkCode eq np_2016.ParkCode and np_2015.month eq np_2016.month
		group by np_2015.ParkCode
		having VisTot ge 15000000
		order by VisTot desc

;
quit;




































