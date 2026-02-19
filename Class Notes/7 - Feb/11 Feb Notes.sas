libname SASData '~/SASData';

proc format;
    value $carortruck
        'SUV', 'Truck' = 'Truck'
        other = 'Car'
        ;
run;

proc logistic data=sashelp.cars;
    format type $carortruck.;
    class origin DriveTrain;
    model type = Origin -- length / selection=forward; 
        /* Default for SL for entry is 0.05, can set with SLENTRY= */
run;

proc logistic data=sashelp.cars;
    format type $carortruck.;
    class origin DriveTrain;
    model type = Origin -- length / selection=backward; 
    /* Default for SL for stay is 0.05 can set with SLSTAY = */
run;

proc logistic data=sashelp.cars;
    format type $carortruck.;
    class origin DriveTrain;
    model type = Origin -- length / selection=stepwise; 
    /* Default for selections are 0.05 */
run;

proc logistic data=sashelp.cars;
    format type $carortruck.;
    class origin DriveTrain;
    model type = Origin -- length / selection=score; 
        /*  Any categorical predictor requires k-1 parameters
            -- score does not work for categorical predictors with more than 2 levels*/
run;

proc logistic data=sashelp.cars;
    format type $carortruck.;
    model type = MSRP -- length / selection=score best=1; 
        /* Gives chi-square statistics, which is helpful for models with the same number of predictors, but
            not for different complexity*/
run; /** Logistic doesn't offer much beyond stepwise slection with significance level */


/** hpgselect isn't great, but better than logistic - not as good as glm select */

proc format;
    value $carortruck
        'SUV', 'Truck' = 'Truck'
        other = 'Car'
        ;
run;

proc hpgenselect data=sashelp.cars;
    format type $carortruck.;
    class origin DriveTrain;
    model type = Origin -- length / dist=binomial; 
        /** I do have to tell it what dist (and perhaps link) I want 
                it does not try to make a chouce if you give a character response */
    selection method=stepwise;
        /** Selection is a statement here in which you specify a method option 
            default criteria for forward, backwards, stepwise are SL (significance level)*/
run;

proc hpgenselect data=sashelp.cars;
    format type $carortruck.;
    class origin DriveTrain;
    model type = Origin -- length / dist=binomial; 
    selection method=stepwise (SLENTRY=0.10 SLSTAY=0.10 choose=SBC);
    /** Forward, backward, stepwise always run on select = SL
        but you can pick a Choose= criterion (AIC,AICC,BIC,SBC)*/
run;

proc hpgenselect data=sashelp.cars;
    format type $carortruck.;
    class origin DriveTrain;
    model type = Origin -- length / dist=binomial; 
    selection method=stepwise (SLENTRY=0.10 SLSTAY=0.10 choose=AIC);
    /** Forward, backward, stepwise always run on select = SL
        but you can pick a Choose= criterion (AIC,AICC,BIC,SBC)*/
run;


proc hpgenselect data=sashelp.cars;
    format type $carortruck.;
    class origin DriveTrain;
    model type = Origin -- length / dist=binomial; 
    selection method=stepwise (SLENTRY=0.10 SLSTAY=0.10 choose=Validate);
    partition fraction (seed=42 Validate=.25 test=.25);
run;











