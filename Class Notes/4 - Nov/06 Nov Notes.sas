libname IPEDS '~/IPEDS';
options fmtsearch = (IPEDS);

*Computing a new column;
proc sql outobs=5; 
	select *, men/total as PropMen format = percent8.1
			, women/total as PropWomen format = percent8.1
		from IPEDS.graduation 
;
	select group, men/total as PropMen, women/total as Propwomen
		from IPEDS.graduation
;
quit;

*Using a computed (calculated) column;
proc sql outobs=5 noerrorstop;
	select unitid, group, men/total as PropMen, 
			1 - PropMen as PropWomen
		from IPEDS.Graduation
;
	select unitid, group, men/total as PropMen, 
			1 - calculated PropMen as PropWomen
		from IPEDS.Graduation
;
	select unitid, group, men/total as PropMen, 
			1 - calculated PropMen as PropWomen
		from IPEDS.Graduation
		where calculated PropWomen lt 0.55 
;
quit;

*Conditional Logic in Select: Case-when;
proc sql outobs=5; 
	select unitid,
			case	
				when board eq 1 then 'Yes, with set maximum meals per week'
				when board eq 2 then 'Yes, with variable meals per week'
				else 'No meal plan'
			end 
				as MealPlan,
				roomamt, boardamt
		from IPEDS.TuitionAndCosts
;
	select unitid,
			case board 
				when 1 then 'Yes, with set maximum meals per week'
				when 2 then 'Yes, with variable meals per week'
				else 'No meal plan'
			end
				as MealPlan,
			roomamt,boardamt
		from IPEDS.TuitionAndCosts			
;
quit;

*Conditioning on Derived Columns- Using Calculated or Not;
proc sql;
	select
			case
				when board eq 1 then 'Yes, with set maximum meals per week' 
				when board eq 2 then 'Yes, with variable meals per week'
				else 'No meal plan'
			end
				as MealPlan,
			avg(roomamt) as avgRoom, avg(boardamt) as avgBoard
		from IPEDS.TuitionAndCosts
		where calculated MealPlan contains 'Yes'
		group by MealPlan
;
	select
			case
				when board eq 1 then 'Yes, with set maximum meals per week' 
				when board eq 2 then 'Yes, with variable meals per week'
				else 'No meal plan'
			end
				as MealPlan,
			avg(roomamt) as avgRoom, avg(boardamt) as avgBoard
		from IPEDS.TuitionAndCosts
		group by MealPlan
		having MealPlan contains 'Yes'
;
quit;

*Creating a Table via a query;
proc sql;
	create table Work.Salaries as 
		select rank,
				mean(sa09mot/sa09mct) as AvgSalary
					format=dollar12.2 label='9 Month Avg.',
				mean(sa09mom/sa09mcm) as AvgSalaryM
					format=dollar12.2 label='Men 9 Month Avg.',
				mean(sa09mow/sa09mcw) as AvgSalaryW
					format=dollar12.2 label='Women 9 Month Avg.'
			from IPEDS.Salaries
			where sa09mct ge 10
			group by rank 
			having AvgSalaryM-AvgSalaryW ge 2750
;
quit;

*Creating a view via a query;
proc sql;
	create view Work.SalariesView as
		select rank,
				mean(sa09mot/sa09mct) as AvgSalary
					format=dollar12.2 label='9 Month Avg.',
				mean(sa09mom/sa09mcm) as AvgSalaryM
					format=dollar12.2 label='Men 9 Month Avg.',
				mean(sa09mow/sa09mcw) as AvgSalaryW
					format=dollar12.2 label='Women 9 Month Avg.'
			from IPEDS.Salaries
			where sa09mct ge 10
			group by rank
			having AvgSalaryM-AvgSalaryW ge 2750
;
quit;

*1.7 Exercises; 
proc sql; 
	create table ex1 as
		select stock, date, high, low,
			high-low as difference format=dollar8.2,
			calculated difference/low as pctdiff format=percent8.2
		from sashelp.stocks
		where year(date) eq 2005
		order by stock, date
;
	create table ex2 as
		select stock, date, high, low,
			high-low as difference format=dollar8.2,
			calculated difference/low as pctdiff format=percent8.2
		from sashelp.stocks
		where year(date) eq 2005
			and (calculated difference ge 5 or calculated pctdiff ge .10)
		order by stock, date
;
quit;


proc sql; 
	create table ex2 as
		select stock, date, high, low,
			high-low as difference format=dollar8.2,
			calculated difference/low as pctdiff format=percent8.2
		from sashelp.stocks(where=(year(date) eq 2005))
		where calculated difference ge 5 or calculated pctdiff ge .10
		order by stock, date
;
quit;

proc sql;
	select stock, 
		mean(high) as HighMean format=dollar8.2,
		mean(low) as LowMean format=dollar8.2
	from sashelp.stocks 
	group by stock
;
	select stock, 
		mean(high) as HighMean format=dollar8.2,
		mean(low) as LowMean format=dollar8.2,
		calculated HighMean - calculated LowMean as MeanDiff 
				format=dollar12.2	
	from sashelp.stocks 
	group by stock
;
quit;


















