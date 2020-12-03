%macro score;

	filename _FHPTS  "&EM_FILE_CDELTA_TRAIN";                                                                                                                                                                                                                       
    data _null_;                                                                                                                                                                                                                                                
        file _FHPTS;                                                                                                                                                                                                                                           
        put 'if upcase(NAME) eq "_DISTANCE_" then Role="REJECTED";';                                                                                                                                                                                            
        put "if upcase(NAME) eq '_CLUSTER_ID_' then do;";                                                                                                                                                                                                       
        put "   Role='&em_property_clusrole';";                                                                                                                                                                                                                 
        put "   Level='NOMINAL';";                                                                                                                                                                                                                              
        put "end;";                                                                                                                                                                                                                                                 
    run;                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                
    filename _FHPTS;


%mend score;
