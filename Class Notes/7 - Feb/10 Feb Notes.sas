libname SASData '~/SASData';

data CDI;
  set sasdata.cdi;
  popDensity = pop/land;
  CrimeRate = crimes/pop*1000;
run;

/*Using Cross Validation */
proc glmselect data=cdi seed=210;
    class region;
    model inc_per_cap = region land--unemp popDensity CrimeRate / 
            selection=stepwise(select=cv);
run;

proc glmselect data=cdi;
    class region;
    model inc_per_cap = region land--unemp popDensity CrimeRate / 
            selection=stepwise(select=sl choose=cv) /*Default fold is 5 */
            stats = (aic aicc bic sbc press);
run;
/*Folding is random, if you want to ensure folding is the same from one instance to another,use a specific seed value */

data rand;
    set cdi;
    rand=ranuni(0);
        /* rand is random uniform on (0,1)*/
run;

proc sgplot data=rand;
    histogram rand / binstart=0.5 binstart=0.1;
run;

proc sort data=rand;
    by rand;
run; /*random order, so cut into k folds */

proc glmselect data=cdi seed=210;
    class region;
    model inc_per_cap = region land--unemp popDensity CrimeRate / 
            selection=stepwise(select=cv);
run;

proc glmselect data=cdi seed=210;
    class region;
    model inc_per_cap = region land--unemp popDensity CrimeRate / 
            selection=stepwise(select=cv) cvmethod=block;
            /*block divides the data set as is into k block of rows 
                good for date/time */
run;

proc glmselect data=cdi seed=210;
    class region;
    model inc_per_cap = region land--unemp popDensity CrimeRate / 
            selection=stepwise(select=cv) cvmethod=random(10);
run;

proc glmselect data=cdi;
    model inc_per_cap = land--unemp popDensity CrimeRate / 
            selection=stepwise(select=cv) 
            cvmethod=index(region);
            /* Each testing set would be a different region
                Index uses a variable you've provided in the data to identify the folds (and 
                    so the number of folds is implicit) 
                region has 4 levels, you get 4 folds*/
run;

proc glmselect data=sashelp.cars;
    class origin type;
    model msrp = type origin mpg; weight enginesize / 
        selection = stepwise(select = cv);
run; 



