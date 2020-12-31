%macro getNObs(inds, nobs);
/*macro for setting macrovariable nobs with number of observations in dataset inds*/                                                                                                          
    %global &nobs;                                                                                                                      
    data _null_;                                                                                                                        
        set &inds end=eof;                                                                                                              
        if eof then call symputx("&nobs", _N_);                                                                                          
    run;                                                                                                                                
    quit;                                                                                                                               
%mend  getNObs;
options minoperator;
%macro train;
	/*Get datasets*/
	%EM_GETNAME(key=import_data, TYPE=DATA);
	%EM_GETNAME(key=vectors, TYPE=DATA);
    %EM_GETNAME(key=OUTSTAT, type=DATA);                                                                                                                                                                                                                        
    %EM_GETNAME(key=MODELINFO, TYPE=DATA);                                                                                                                                                                                                                      
    %EM_GETNAME(key=CLUSTERSUM, type=DATA);                                                                                                                                                                                                                     
    %EM_GETNAME(key=ITERSTAT, type=DATA);                                                                                                                                                                                                                       
    %EM_GETNAME(key=OVERALLVARSTAT, TYPE=DATA);                                                                                                                                                                                                                 
    %EM_GETNAME(key=CLUSTERBASEDVARSTAT, type=DATA)

	/*	-----Check for the existence of import data----- */
	%if (^%sysfunc(exist(&EM_IMPORT_DATA)) and
		^%sysfunc(exist(&EM_IMPORT_DATA, VIEW)))
		or "&EM_IMPORT_DATA" eq "" %then %do;
		%let EMEXCEPTIONSTRING = exception.server.IMPORT.NOTRAIN,1;
		%goto doenda;
	%end;
	/*	-----Check for the existence of interval, ordinal or binary input variable---- */
	%if (%EM_INTERVAL_INPUT %EM_ORDINAL_INPUT  %EM_BINARY_INPUT eq ) %then %do;
		%let EMEXCEPTIONSTRING = ERROR;
		%put &em_codebar;
		%put Error: Must use at least one interval, ordinal or binary input;
		%put &em_codebar;
		%goto doenda;
	%end;
	/*	-----Check if number of clusters is smaller than number of observations----*/
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
	/*	-----Check if k is smaller than number of observations----*/
	%if %SYSEVALF(&EM_PROPERTY_K >= &indsNObs) and &EM_PROPERTY_Neighborhood in (knn mutual_knn) %then %do;
		%let EMEXCEPTIONSTRING = ERROR;
		%put &em_codebar;
		%put Error: Parameter K(&EM_PROPERTY_K) should be smaller than;
		%put number of observations(&indsNObs);
		%put &em_codebar;
		%goto doenda;
	%end;
	

	/*	-----Standarization and imputation----*/
	data &em_user_import_data;
		set &em_import_data;
	run;

	PROC STANDARD data=&em_user_import_data %if &em_property_Standard eq Y %then MEAN=0 STD=1; 
%if &em_property_Impute eq mean %then REPLACE; OUT=&em_user_import_data;
		var %EM_INTERVAL_INPUT %EM_ORDINAL_INPUT %EM_BINARY_INPUT ;
	run;
	
	/*	-----Check input dataset for missing values----*/
	%if &em_property_Impute eq none %then %do;
		proc means data=&em_user_import_data nmiss noprint;
			var %EM_INTERVAL_INPUT %EM_ORDINAL_INPUT %EM_BINARY_INPUT ;
			output out=_tmp_miss nmiss=nmiss;
		run;

		data _null_;
			set _tmp_miss;
			call symputx("nmiss", nmiss, "L");
		run;
		%if %SYSEVALF(&nmiss > 0) %then %do;
			%let EMEXCEPTIONSTRING = ERROR;
			%put &em_codebar;
			%put Error: Dataset contains missing values!;
			%put &em_codebar;
			%goto doenda;
		%end;
	%end;

	/*	-----Preparing laplacian matrix----*/
	proc iml;
    
		package load spectralclust;
		varnames = { %EM_INTERVAL_INPUT %EM_ORDINAL_INPUT %EM_BINARY_INPUT };
		print 'Used variables:';
		print varnames;
		
		use &em_user_import_data;
		read all var varnames into m;
		close &em_user_import_data;

		m = spccSpectralize(m, &EM_PROPERTY_ClusterNum , "&EM_PROPERTY_Laplacian.",
                            "&EM_PROPERTY_NeighFun.", &EM_PROPERTY_Sigma , 
                            "&EM_PROPERTY_Neighborhood.", &EM_PROPERTY_K );

		create &em_user_vectors from m;
			append from m;
		close &em_user_vectors;
		CALL symput("nvar", putn(ncol(m), "BEST6."));
	quit;
	
	/*	-----Clusterization using k-means----*/
	ods listing exclude  Standardization ;                                                                                                                                                                                                 
    filename flowtemp "&em_file_emflowscorecode";                                                                                                                                                                                                               
    ods output PerformanceInfo = _tmp_outperformanceinfo ModelInfo = &em_user_modelinfo NObs = _tmp_outnobs                                                                                                                                                         
            ClusterSum = &em_user_clustersum IterStats = &em_user_ITERSTAT DescStats = &em_user_OVERALLVARSTAT                                                                                                                                                              
            WithinClusStats = &em_user_CLUSTERBASEDVARSTAT Timing = _tmp_outtiming                                                                                                                                                                                                                                              
    ;                                                                                                                                                                                                                                                           
    proc hpclus data= &em_user_vectors maxclusters = &EM_PROPERTY_ClusterNum maxiter = &EM_PROPERTY_MaxIter                                                                                                                              
        outstat = &EM_USER_OUTSTAT  distance = &EM_PROPERTY_Distance Seed=&EM_PROPERTY_Seed                                                                                                                                                                                                                                                  
    ;                                                                                                                                                                                                                                                           
       input %DO i=1 %to &nvar; COL&i %END;;                                                                                                                                                                                                                                                                                                                                                                                                                                                             
           /* score code */
		score out=_tmp_out_score;
        code file=flowtemp;                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                
        /* performance statement */                                                                                                                                                                                                                             
        &hpdm_performance.;                                                                                                                                                                                                                                     
    run;  
	
	/*	-----Preparing output dataset----*/
	data &em_export_train;
		set &em_user_import_data;
		set _tmp_out_score(drop=_DISTANCE_);
	run;

	data &em_user_vectors;
		set &em_user_vectors;
		set _tmp_out_score;
	run;
	
    filename pubtemp "&em_file_empublishscorecode";                                                                                                                                                                                                             
    %em_copyfile(infref=flowtemp, outfref=pubtemp,append=N);                                                                                                                                                                                                    
    filename flowtemp;                                                                                                                                                                                                                                          
    filename pubtemp;                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                
    proc datasets lib=work nolist;                                                                                                                                                                                                                              
        delete  _tmp:;                                                                                                                                                                                                                                          
    run; 
         

	
	%doenda:
%mend train;
