%macro main;
	%if %upcase(&EM_ACTION) = CREATE %then %do;
		filename temp catalog 'sashelp.specc.spcl_create.source';
		%include temp;
		filename temp;
		%create;
	%end;

	%else
	%if %upcase(&EM_ACTION) = TRAIN %then %do;
		filename temp catalog 'sashelp.specc.spcl_train.source';
		%include temp;
		filename temp;
		%train;
	%end;

	%if %upcase(&EM_ACTION) = SCORE %then %do;
		filename temp catalog 'sashelp.specc.spcl_score.source';
		%include temp;
		filename temp;
		%score;
	%end;
	
	%if %upcase(&EM_ACTION) = REPORT %then %do;
		filename temp catalog 'sashelp.specc.spcl_report.source';
		%include temp;
		filename temp;
		%report;
	%end;

%mend main;
%main;
