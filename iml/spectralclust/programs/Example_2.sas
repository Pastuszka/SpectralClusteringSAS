libname clust 'path to the \data folder';

/* create a dataset without the label variable */

data clust.jain_x;
	set clust.jain;
	keep VAR1 VAR2;
run;

/* Within the iml procedure */
/* load the package */
/* load the dataset into a matrix */
/* use the spccFastClus function */
/* save resulting matrix to a new dataset */

proc iml;
    
	package load spectralclust;
	
	use clust.jain_x;
		read all var _num_ into m;
	close clust.jain_x;
	
	m = spccFastClus(m, 2, 0, 'normalizedRW', 'gaussian', 1, 'knn', 5);
	
	create clust.out from m;
		append from m;
	close clust.out;
quit;


/* plot the result */

proc sgplot data=clust.out;
 scatter x=COL1 y=COL2 / group=COL3;
run;
