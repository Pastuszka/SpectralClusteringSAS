%EM_REGISTER(key=vectors, type=data);
%EM_REGISTER(key=tree, type=data);
%EM_REGISTER(key=cluster, type=data);

proc iml;
    
	package load spectralclust;
	
	use &em_import_data;
		read all var _num_ into m;
	close &em_import_data;
	
	m = spectralClust(m, 3, 'normalizedRW', 'gaussian', 1);
	
	create &em_user_vectors from m;
		append from m;
	close &em_user_vectors;
quit;
