%macro train;
	%em_getname(key=vectors, TYPE=DATA);
	
	proc iml;
    
		package load spectralclust;
		varnames = { %EM_INTERVAL_INPUT };
		print varnames;
		use &em_import_data;
		read all var varnames into m;
		close &em_import_data;
		print "&EM_PROPERTY_Laplacian.";
		print "&EM_PROPERTY_Neighborhood.";
		m = spectralClust(m, &EM_PROPERTY_ClusterNum , "&EM_PROPERTY_Laplacian.", "&EM_PROPERTY_NeighFun.", &EM_PROPERTY_Sigma );
		
		create &em_user_vectors from m;
			append from m;
		close &em_user_vectors;
	quit;
%mend train;
