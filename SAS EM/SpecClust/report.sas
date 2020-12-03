%macro report;
	%em_getname(key=vectors, TYPE=DATA);
	%em_getname(key=indvectors, TYPE=DATA);
	%EM_GETNAME(key=OUTSTAT, type=DATA);
	%EM_GETNAME(key=CLUSTERSUM, type=DATA);
	%EM_REGISTER(key=graph_table, type=DATA);                                                                                                                                                                                                                   
    %EM_REGISTER(key=MODELINFO, TYPE=DATA);  

/*	Eigenvectors*/
	proc sort data=&em_user_vectors out=&em_user_indvectors(drop=_CLUSTER_ID_ _DISTANCE_);
		by _CLUSTER_ID_ _DISTANCE_;
	run;

	data &em_user_indvectors;
		set &em_user_indvectors;
		array x{*} _NUMERIC_;
		i + 1;
		do j=1 to dim(x);
			variable = vname(x[j]);
			value = x[j];
			output;
		end;
		keep variable value i;
	run;

	%em_report(key=indvectors,
		viewtype=Lattice,
		latticetype=Lineplot,
		block=eigenvectors,
		views=3,
		autodisplay=Y,
		x=i,
		y=value,
		latticex=variable,
		equalizerowy=Y,
		description=Eigenvector Profiles);

	%em_report(key=vectors,
		viewtype=Data,
		block=eigenvectors,
		views=1,
		autodisplay=Y,
		description=Eigenvector Table);
/*	Outstat	*/
	data &em_user_outstat;                                                                                                                                                                                                                                      
        set &em_user_outstat;                                                                                                                                                                                                                                   
        label _Cluster_id_ = "Cluster ID";                                                                                                                                                                                                                   
        drop _iteration_;                                                                                                                                                                                                                                       
    run;                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                
	%EM_REPORT(key=OUTSTAT, viewtype=DATA, block=MODEL, autodisplay=Y, description=fitstatsplotlabel);
/*	Segment plot*/
	%if &em_property_ClusterNum <= 200 %then %do;                                                                                                                                                                                                                  
		data &em_user_clustersum;                                                                                                                                                                                                                                   
			set &em_user_clustersum;                                                                                                                                                                                                                                
			label cluster = "Cluster ID"                                                                                                                                                                                                                         
				frequency  = "Frequency"                                                                                                                                                                                                                      
				SSE = "SSE";                                                                                                                                                                                                                                  
		run;                                                                                                                                                                                                                                                        
		%EM_REPORT(key=CLUSTERSUM, viewtype=PIE, x=Cluster, freq=Frequency, block=PLOT, autodisplay=Y, description=segmentplotlabel )                                                                                                                               
	%end;
/*	Model info*/
data &em_user_modelinfo;                                                                                                                                                                                                                                        
    set &em_user_modelinfo;                                                                                                                                                                                                                                     
    label parameter = "Parameter"                                                                                                                                                                                                                         
          setting =  "Setting";                                                                                                                                                                                                                           
run;                                                                                                                                                                                                                                                            
%EM_REPORT(key=MODELINFO, viewtype=DATA, block=MODEL, autodisplay=N, description=modelinfolabel); 
  


%mend report;
