%macro train;
	%em_getname(key=vectors, TYPE=DATA);
	
	%if (^%sysfunc(exist(&EM_IMPORT_DATA)) and
		^%sysfunc(exist(&EM_IMPORT_DATA, VIEW)))
		or "&EM_IMPORT_DATA" eq "" %then %do;
		%let EMEXCEPTIONSTRING = exception.server.IMPORT.NOTRAIN,1;
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

		m = spectralClust(m, &EM_PROPERTY_ClusterNum , "&EM_PROPERTY_Laplacian.", "&EM_PROPERTY_NeighFun.", &EM_PROPERTY_Sigma );
		
		create &em_user_vectors from m;
			append from m;
		close &em_user_vectors;
	quit;
	%doenda:
%mend train;
