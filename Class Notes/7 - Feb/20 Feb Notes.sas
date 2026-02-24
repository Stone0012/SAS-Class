/*st106d01.sas*/
libname stat1 '~/ECST142/data';

%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
         Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
         Masonry_Veneer Lot_Shape_2 Central_Air;

ods graphics;

proc glmselect data=STAT1.ameshousing3
               plots=all 
               valdata=STAT1.ameshousing4;
    class &categorical / param=glm ref=first;
    model SalePrice=&categorical &interval / 
               selection=backward
               select=sbc 
               choose=validate;
    store out=amesstore; /**can store model information to score "new" data -- in GLM select
                            the score is for the model picked by the choose= criterion*/
    title "Selecting the Best Model using Honest Assessment";
run;

/*st106d02.sas*/  /*Part A*/

proc plm restore=amesstore;
    score data=STAT1.ameshousing4 out=scored;
        /**out= is scored/predicted values */
    code file="~/scoring.sas";/**writes some code.. */
run;

data scoreData;
    set stat1.ameshousing4;
    %include "~/scoring.sas";/**.. that you can include in a data step to do the scoring */
run;

*Categorical Data Analysis;

/*st107d05.sas*/
ods graphics on;
proc logistic data=STAT1.ameshousing3 plots(only)=(effect oddsratio);
    class Fireplaces(ref='0') Lot_Shape_2(ref='Regular') / param=ref;
    model Bonus(event='1')=Basement_Area Fireplaces Lot_Shape_2 / clodds=pl;
    units Basement_Area=100;
    title 'LOGISTIC MODEL (2):Bonus= Basement_Area Fireplaces Lot_Shape_2';
run;
