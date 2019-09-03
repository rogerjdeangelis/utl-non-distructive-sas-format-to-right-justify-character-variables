SAS format to right justify character variables.                                          
                                                                                          
I was suprised that a $charRight format does not exist.                                   
                                                                                          
* these works;                                                                            
data _null_;                                                                              
  length name $10;                                                                        
  name="John";                                                                            
  put "**" name $10.-r "**";                                                              
run;quit;                                                                                 
                                                                                          
**      John**                                                                            
                                                                                          
But this does not;                                                                        
                                                                                          
data _null_;                                                                              
  format name $10.-r;                                                                     
  name="John";                                                                            
  put "**" name "**";                                                                     
run;quit;                                                                                 
                                                                                          
Nor does this                                                                             
                                                                                          
proc format ;                                                                             
  value $cRight                                                                           
    other=[$10.-r]                                                                        
;run;quit;                                                                                
                                                                                          
**John **                                                                                 
                                                                                          
I could not find a $right format, so I used Rick's                                        
functions in formats to create a 'charRight' format                                       
                                                                                          
Problem: Right align all columns below                                                    
                                                                                          
   proc transpose data=sashelp.class(firstobs=10 obs=12) out=xpo;                         
      format _character_ $10.;                                                            
      id name;                                                                            
      var _all_;                                                                          
   run;quit;                                                                              
                                                                                          
                                                                                          
   WORK.XPO total obs=5                                                                   
                                                                                          
    _NAME_        JOHN           JOYCE            JUDY                                    
                                                                                          
    NAME      John            Joyce           Judy                                        
    SEX       M               F               F                                           
    AGE                 12              11              14                                
    HEIGHT              59            51.3            64.3                                
    WEIGHT            99.5            50.5              90                                
                                                                                          
The solution does not change the internal layout of the variable.                         
Internallyy stored as "John    " formatted as "    John";                                 
                                                                                          
*_                   _                                                                    
(_)_ __  _ __  _   _| |_                                                                  
| | '_ \| '_ \| | | | __|                                                                 
| | | | | |_) | |_| | |_                                                                  
|_|_| |_| .__/ \__,_|\__|                                                                 
        |_|                                                                               
;                                                                                         
                                                                                          
Up to 40 obs WORK.HAVE total obs=3                                                        
                                                                                          
Obs    NAME     SEX    AGE    HEIGHT    WEIGHT                                            
                                                                                          
 1     John      M      12     59.0      99.5                                             
 2     Joyce     F      11     51.3      50.5                                             
 3     Judy      F      14     64.3      90.0                                             
                                                                                          
                                                                                          
             _               _                                                            
  ___  _   _| |_ _ __  _   _| |_                                                          
 / _ \| | | | __| '_ \| | | | __|                                                         
| (_) | |_| | |_| |_) | |_| | |_                                                          
 \___/ \__,_|\__| .__/ \__,_|\__|                                                         
                |_|                                                                       
;                                                                                         
                                                                                          
    _NAME_      JOHN        JOYCE       JUDY                                              
                                                                                          
    NAME        John       Joyce        Judy                                              
     SEX           M           F           F                                              
     AGE          12          11          14                                              
  HEIGHT          59          51          64                                              
  WEIGHT         100          51          90                                              
                                                                                          
*                                                                                         
 _ __  _ __ ___   ___ ___  ___ ___                                                        
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                       
| |_) | | | (_) | (_|  __/\__ \__ \                                                       
| .__/|_|  \___/ \___\___||___/___/                                                       
|_|                                                                                       
;                                                                                         
                                                                                          
proc datasets lib=work kill;                                                              
run;quit;                                                                                 
                                                                                          
options cmplib=(work.functions);                                                          
* functions in formats Rick Langston;                                                     
                                                                                          
proc fcmp outlib=work.functions.charRight;                                                
  function charRight(txt $) $32;                                                          
    ryght=right(txt);                                                                     
  return(ryght);                                                                          
endsub;                                                                                   
run;quit;                                                                                 
                                                                                          
* put the function in a format;                                                           
proc format;                                                                              
  value $charRight other=[charRight()];                                                   
run;quit;                                                                                 
                                                                                          
proc transpose data=sashelp.class(firstobs=10 obs=12) out=xpo;                            
format _character_ $charRight8. _numeric_ 4.;                                                      
id name;                                                                                  
var _all_;                                                                                
run;quit;                                                                                 
                                                                                          
proc print data=xpo;                                                                                                                               
run;quit;                                                                                 
                                                                                          
