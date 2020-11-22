%macro train;
	%em_getname(key=vectors, TYPE=DATA);
	
	proc iml;
    
		package load spectralclust;
		varnames = { %EM_INTERVAL_INPUT };
		print varnames;
		use &em_import_data;
		read all var varnames into m;
		close &em_import_data;
		
		m = spectralClust(m, &EM_PROPERTY_ClusterNum, 'normalizedRW', 'gaussian', 1);
		
		create &em_user_vectors from m;
			append from m;
		close &em_user_vectors;
	quit;
%mend train;