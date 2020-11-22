%macro score;
	%em_getname(key=vectors, TYPE=DATA);
	%em_getname(key=tree, TYPE=DATA);
	%em_getname(key=cluster, TYPE=DATA);
	
	proc cluster data = &em_user_vectors method =&EM_PROPERTY_ClustFun print=15 outtree=&em_user_tree;
	run;
	
	proc tree data=&em_user_tree ncl=&EM_PROPERTY_ClusterNum out=&em_user_cluster;
	run;
	
	proc sort data=&em_user_cluster  sortseq=linguistic(numeric_collation=on) out=&em_user_cluster;
		by _NAME_;
		
	run;
	
	data &em_export_train;
		set &em_import_data;
		set &em_user_cluster;
	run;
%mend score;
