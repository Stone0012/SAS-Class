libname stat1 '~/ECST142/data';

ods graphics on;
ods trace on;
proc reg data=STAT1.ameshousing3;
    CONTINUOUS: model SalePrice 
                  = Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
                    Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
    title 'SalePrice Model - Plots of Diagnostic Statistics';
    output out=diagnostics p=pred r=resid rstudent=StudentRCV
            student=StudentR h=leverage;
    /**Output can be used to add some error diagnostic stats to the data 
        as a new output data set*/
run;
quit;

data diagnostics;
    set diagnostics;

    if leverage ge %sysevalf(16/300) then do;
        obs=_n_;
        w=1-leverage;
end;
      else do;
        obs=.;
        w = 1;
end;

run;

proc reg data=diagnostics;
    CONTINUOUS: model SalePrice 
                  = Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
                    Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom
                    / vif;
    /**Variance inflation factor  ... 5 or more is considered serious it's the 
        variance multiplier due to correlation in the standardized regression case*/
    title 'SalePrice Model - Plots of Diagnostic Statistics Weighted';
run;
quit;

proc reg data=sashelp.cars;
        model horsepower = msrp invoice mpg: wheelbase weight / vif;
run;

proc corr data=sashelp.cars;
    var msrp invoice mpg: wheelbase weight;
run; 

proc factor data=sashelp.cars nfact=2 out=factors; 
    var msrp invoice mpg: wheelbase weight;
run;

proc corr data=factors;
    var msrp invoice mpg: wheelbase weight;
    with factor: ;
run;

proc corr data=factors;
        var factor:;
run;

proc factor data=sashelp.cars nfact=2 rotate=varimax out=factors; 
    var msrp invoice mpg: wheelbase weight;
run;

proc reg data=factors;
    model horsepower = factor1 factor2;
run;