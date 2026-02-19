libname SASData '~/SASData';

/** For RealEstate Data: 

    1. Using any reasionable, potential predictor, find a "best" model for price. Use GLMSelect to consider all criteria 

    2. Compare to best subsets in REG on R^2adj, AIC, RIC, SBC

    3. Quality is response (hpgenselect)
        1 high 
        2 med 
        3 low 

        /** In Hpgenselect, use quality as response to fund best model */
*/

*1;

proc glmselect data=sasdata.realestate;
    class ac highway quality; /*variables you want to treat as categorical as well, or ones that are ordinal and not binary */
    model price = sq_ft -- highway /
        selection=stepwise(select=sl choose=cv) 
        stats=(AIC AICC BIC SBC) ;
run;


*2;

ods graphics off;
proc reg data=sasdata.realestate; 
    model price = sq_ft -- highway /
    selection = adjrsq aic bic sbc best=10;
    ods output subsetselsummary=subsets;
run;

data realEstate(drop=quality);
    set sasdata.realestate;

    high =(quality eq 1); /**pretty much one-hot-encoding */
    medium = (quality eq 2);

run; /** If three categories, only need to dummy encodings */

proc reg data=realestate; 
    model price = sq_ft -- medium /
    selection = adjrsq aic bic sbc;
    ods output subsetselsummary=subsets;
run;

proc glmselect data=realestate;
    class ac highway; /*variables you want to treat as categorical as well, or ones that are ordinal and not binary */
    model price = sq_ft -- medium /
        selection=stepwise(select=sl choose=cv) 
        stats=(AIC AICC BIC SBC) ;
run;

/** Typically Prefer SBC and CVPress */

proc glmselect data=realestate;
    class ac highway; /*variables you want to treat as categorical as well, or ones that are ordinal and not binary */
    model price = sq_ft -- medium /
        selection=stepwise(select=sl choose=cv slentry=.5 slstay=.5) 
        stats=(AIC AICC BIC SBC adjrsq) ;
run;



