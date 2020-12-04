%macro getNObs(inds, nobs);
/*macro for setting macrovariable numobs with number of observations in dataset inds*/                                                                                                          
    %global &nobs;                                                                                                                      
    data _null_;                                                                                                                        
        set &inds end=eof;                                                                                                              
        if eof then call symputx("&nobs", _N_);                                                                                          
    run;                                                                                                                                
    quit;                                                                                                                               
%mend  getNObs;

%macro train;
	%em_getname(key=vectors, TYPE=DATA);
	
	%if (^%sysfunc(exist(&EM_IMPORT_DATA)) and
		^%sysfunc(exist(&EM_IMPORT_DATA, VIEW)))
		or "&EM_IMPORT_DATA" eq "" %then %do;
		%let EMEXCEPTIONSTRING = exception.server.IMPORT.NOTRAIN,1;
		%goto doenda;
	%end;

	%if (%EM_INTERVAL_INPUT %EM_ORDINAL_INPUT  %EM_BINARY_INPUT eq ) %then %do;
		%let EMEXCEPTIONSTRING = ERROR;
		%put &em_codebar;
		%put Error: Must use at least one interval, ordinal or binary input;
		%put &em_codebar;
		%goto doenda;
	%end;

	%getNObs(&EM_IMPORT_DATA, indsNObs);
	%put Number of observations in dataset: &indsNObs;

	%if %SYSEVALF(&EM_PROPERTY_ClusterNum >= &indsNObs) %then %do;
		%let EMEXCEPTIONSTRING = ERROR;
		%put &em_codebar;
		%put Error: Number of clusters(&EM_PROPERTY_ClusterNum) should be smaller than;
		%put number of observations(&indsNObs);
		%put &em_codebar;
		%goto doenda;
	%end;
	
	proc iml;
    
		package load spectralclust;
		varnames = { %EM_INTERVAL_INPUT %EM_ORDINAL_INPUT %EM_BINARY_INPUT };
		print 'Used variables:';
		print varnames;

		use &em_import_data;
		read all var varnames into m;
		close &em_import_data;

		m = spccSpectralize(m, &EM_PROPERTY_ClusterNum , "&EM_PROPERTY_Laplacian.",
                            "&EM_PROPERTY_NeighFun.", &EM_PROPERTY_Sigma , 
                            "&EM_PROPERTY_Neighborhood.", &EM_PROPERTY_K );

		create &em_user_vectors from m;
			append from m;
		close &em_user_vectors;
	quit;
	%doenda:
%mend train;
