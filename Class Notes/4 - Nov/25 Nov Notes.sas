*2.6.5: ESTIMATE and LSMESTIMATE in PROC MIXED;
proc mixed data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status|sex / solution;
	estimate 'Borderline: Female-Male' sex 1 -1
	chol_status*sex 1 -1 0 0 0 0 / cl;
	estimate 'Female, Male diff, Borderline vs Desirable'
	chol_status*sex 1 -1 -1 1 0 0 / cl e;
/*estimate in mixed looks just like it does in GLM, but it does let you get a confidence interval as well*/
	lsmestimate chol_status*sex 'Borderline: Female-Male' 1 -1 0 0 0 0 / cl;
	lsmestimate chol_status*sex 'Female, Male diff, Borderline vs Desirable'
	1 -1 -1 1 0 0 / cl;
/*lsmestimate -- is and estimate applied to a set of lsmeans, 
	lsmestimate effect 'label' coefficients;
	coefficients are applied to the means generated for the chosen effect*/
ods select none;
ods output lsmestimates=lsmest estimates=est;
run;

ods select all;
proc print data=est noobs;
	var label estimate tvalue probt lower upper;
run;

proc print data=lsmest noobs;
	var label estimate tvalue probt lower upper;
run;

proc mixed data=sashelp.heart;
	class chol_status sex;
	model systolic = chol_status | sex / solution;
	lsmestimate chol_status ''
			0.5 0.5 1 / cl e;
	lsmeans chol_status;
run;

*2.6.6: Slope and Slope Difference Estimates in PROC MIXED;
proc mixed data=sashelp.heart;
	class chol_status;
	model systolic = smoking|chol_status / solution cl;
	where sex eq 'Female' and ageAtStart le 50;
	estimate 'Smoking Effect, Desirable Chol'
	smoking 1 smoking*chol_status 0 1 0 / cl;
	estimate 'Smoking Effect, Borderline Chol'
	smoking 1 smoking*chol_status 1 0 0 / cl;
	estimate 'Diff. in Smoking Effect,
	Borderline versus Desirable'
	smoking 0 smoking*chol_status 1 -1 0 / cl;
	estimate 'Diff. in Smoking Effect,
	Borderline versus High'
	smoking*chol_status 0 1 -1 / cl;
ods select none;
ods output estimates=slopeEst;
run;
ods select all;

proc print data=slopeEst noobs;
	var label estimate tvalue probt lower upper;
run;







