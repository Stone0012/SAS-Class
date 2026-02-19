libname IPEDS '~/IPEDS';

proc sort data=ipeds.graduation out=gradSort;
  by unitId group;
run;

data grads cohort;
  set gradSort;
  by unitId group;

  if first.unitID then output grads;
  if last.unitID then output cohort;

run;

data gradRates1;
  merge grads(rename=(men=GradMen women=GradWomen total=GradTotal))
        cohort;
  by unitId;

  gradRate = GradTotal/Total;
  gradRateM = GradMen/Men;
  gradRateW = GradWomen/Women;

  format gradRate: percent8.2;

  drop total group;
run;

data gradRates2;
  set gradSort;
  by unitId group;
  retain GradWomen GradMen GradTotal;

  if first.unitID then do; 
     GradWomen=Women;
     GradMen=Men;
     GradTotal=Total;
  end;

  if last.unitID then do; 
    RateMen=GradTotal/Total;
    RateWomen=GradWomen/Women;
    RateMen=GradMen/Men;
    output;
  end;
  format Rate: percent8.2;
run;

data gradRates4;
  merge gradsprt(where=(group contains 'Completers') 
					rename=(men=GradMen women=GradWomen total=GradTotal))
        gradsort (where=(group contains 'Incoming') ;
  by unitId;

  gradRate = GradTotal/Total;
  gradRateM = GradMen/Men;
  gradRateW = GradWomen/Women;

  format gradRate: percent8.2;

  drop total group;
run;

proc transpose data=gradsort out=gradsortT (rename=(col1=Grads col2=Incoming) drop=_label_) name=Type;
	by unitID;
	var Total Women Men;
	*id group;
run;

data gradrates3; 
	set gradsortT;

	rate = Grads / Incoming;
	format rate percent8.2;
run;

proc sgplot data=gradrates3; 
	hbar type / response = rate stat=mean;
run;

/*SQL*/

options fmtsearch = (IPEDS);
proc sql; /*PROC SQL invokes an environment for wwritting queries*/
	select instnm, fips, c21enprf, control, locale /*entire query is one statement no matter how long*/
		from IPEDS.Characteristics(obs=10)
;  
quit; 

proc sql inobs=20 outobs=10 feedback;
	select *
		from IPEDS.graduation
;
quit;

proc sql inobs=10 feedback;
	select unitid, total, men, women
		from IPEDS.graduation
		where total gt 5000 and group contains 'Incoming'
;
quit;

*Use order by;
proc sql feedback;
	select instnm, fips, control, locale
		from IPEDS.Characteristics
		where instnm contains 'Utah'
		order by locale, control desc /*pretty much always going to come last*/
;
quit;

*Summary Functions;
proc sql feedback; 
	select count(total), mean(total), min(total), max(total)
		from IPEDS.graduation 
		where group containts 'Incoming'
;
quit;

*Summaries within groups; 
proc sql; 
	select group, count(total) as N, mean(total) as Mean,
			min(total) as Minimum, max(total) as Maximum
		from IPEDS.graduation 
		where men ge 10 and women ge 10
		group by group 
		order by group desc
;
quit;

*Logical Conditions as Arguments to Summary Functions; 
proc sql feedback;
	select group, count(total) as Count, 
			sum(total gt 100) label = 'More than 100 Studets' as MoreThan100,
			mean(total gt 100) format = percentn7.1 label = 'Proportion' as PropMore100
		from ipeds.graduation
		group by group 
;
quit;

*Group By that forces a Re - Merge; 
proc sql;
	select group, mean(total) as Mean
		from IPEDS.Graduation
		where men ge 10 and women ge 10
		group by group
;
	select unitid, 
		from IPEDS.Graduation
		where men ge 10 and women ge 10 
;

	select unitid, group, mean(total) as Mean, total
		from IPEDS.Graduation
		where men ge 10 and women ge 10
		group by group
		order by unitid, group desc
;
quit;

*Using the Having clause in a SQL Query; 
proc sql;
	select rank, mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2,
			mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2,
			mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2
		from IPEDS.Salaries
		where sa09mct ge 10
		group by rank
		having AvgSalaryM-AvgSalaryW ge 2750
		/*conditioning on group summaries must be done in having, 
			which gollows group by*/
		order by rank desc; /*still last*/
;
quit;

*Having clause vs. where clause;
proc sql feedback;
	select rank, mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2,
			mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2,
			mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2
		from IPEDS.Salaries
		where sa09mct ge 10
			and lowcase(put(rank,arank.)) contains 'professor'
		group by rank
		having AvgSalaryM-AvgSalaryW ge 2750
;
	select rank, mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2,
			mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2,
			mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2
		from IPEDS.Salaries
		where sa09mct ge 10
		group by rank
		having AvgSalaryM-AvgSalaryW ge 2750
			and lowcase(put(rank,arank.)) contains 'professor'
;
quit;


















