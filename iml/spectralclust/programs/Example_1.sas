libname clust 'path to the \data folder';

/* create a dataset without the label variable */

data clust.jain_x;
	set clust.jain;
	keep VAR1 VAR2;
run;

/* Within the iml procedure */
/* load the package */
/* load the dataset into a matrix */
/* use the spectralClust function */
/* save resulting matrix to a new dataset */

proc iml;
    
	package load spectralclust;
	
	use clust.jain_x;
		read all var _num_ into m;
	close clust.jain_x;
	
	m = spectralClust(m, 2, 'normalizedRW', 'gaussian', 1);
	
	create clust.out from m;
		append from m;
	close m;
quit;

/* use a normal clustering method on the resulting dataset */

proc cluster data = clust.out method = centroid ccc print=15 outtree=Tree noprint;
run;

proc tree data=Tree noprint ncl=2 out=clust.outclust;
copy col1;
run;

/* sort the resulting dataset by _NAME_ to restore the original order of records*/

proc sort data=clust.outclust  sortseq=linguistic(numeric_collation=on) out=clust.out_ordered;
	by _NAME_;
	
run;

/* join the acquired labels with original data */

data clust.final;
	set clust.jain;
	set clust.out_ordered;
run;

/* plot the result */

proc sgplot data=clust.final;
 scatter x=VAR1 y=VAR2 / group=CLUSTER;
run;