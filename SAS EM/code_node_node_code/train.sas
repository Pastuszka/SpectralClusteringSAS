%EM_REGISTER(key=vectors, type=data);
%EM_REGISTER(key=tree, type=data);
%EM_REGISTER(key=cluster, type=data);

proc iml;
    
	package load spectralclust;
	
	use &em_import_data;
		read all var _num_ into m;
	close &em_import_data;
	
	m = spectralClust(m, 2, 'normalizedRW', 'gaussian', 1);
	
	create &em_user_vectors from m;
		append from m;
	close &em_user_vectors;
quit;

/* use a normal clustering method on the resulting dataset */

proc cluster data = &em_user_vectors method = centroid ccc print=15 outtree=&em_user_tree noprint;
run;

proc tree data=&em_user_tree noprint ncl=2 out=&em_user_cluster;
copy col1;
run;

/* sort the resulting dataset by _NAME_ to restore the original order of records*/

proc sort data=&em_user_cluster  sortseq=linguistic(numeric_collation=on) out=&em_user_cluster;
	by _NAME_;
	
run;

/* join the acquired labels with original data */

data &em_export_train;
	set &em_import_data;
	set &em_user_cluster;
run;

/* plot the result */
