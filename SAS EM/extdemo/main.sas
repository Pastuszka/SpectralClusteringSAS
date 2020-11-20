%macro main;
	%if %upcase(&EM_ACTION) = CREATE %then %do;
		filename temp catalog 'sashelp.em61ext.reg_create.source';
		%include temp;
		filename temp;
		%create;
	%end;

	%else
	%if %upcase(&EM_ACTION) = TRAIN %then %do;
		filename temp catalog 'sashelp.em61ext.reg_train.source';
		%include temp;
		filename temp;
		%train;
	%end;

	%if %upcase(&EM_ACTION) = SCORE %then %do;
		filename temp catalog 'sashelp.em61ext.reg_score.source';
		%include temp;
		filename temp;
		%score;
	%end;

%mend main;
%main;