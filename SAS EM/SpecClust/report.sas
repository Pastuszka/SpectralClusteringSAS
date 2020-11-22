%macro report;
	%em_getname(key=vectors, TYPE=DATA);
	%em_getname(key=indvectors, TYPE=DATA);

	proc sort data=&em_user_vectors out=&em_user_indvectors;
		by COL1;
	run;

	data &em_user_indvectors;
		set &em_user_indvectors;
		array x{*} _NUMERIC_;
		i + 1;
		do j=1 to dim(x);
			variable = vname(x[j]);
			value = x[j];
			put variable value;
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
	
	%em_report(key=vectors,
		viewtype=Histogram,
		block=eigenvectors,
		x=COL1,
		views=2,
		autodisplay=N,
		choicetext=COL1,
		description=Eigenvector histogram);
	
/*	%em_report(*/
/*		views=2,*/
/*		x=COL2 ,*/
/*		choicetext=COL2);*/
/*	*/
/*	%em_report(*/
/*		views=2,*/
/*		x=COL3 ,*/
/*		choicetext=COL3);*/
%mend report;
