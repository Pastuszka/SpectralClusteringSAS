%macro makeScoreCode;
	%let predvar=;
	%if &em_dec_decmeta eq %then %do;
		%if %sysfunc(exist(EM_TARGETDECINFO)) %then %do;
			data _null_;
				set EM_TARGETDECINFO;
				where TARGET="&targetVar";
				call symput('em_dec_decmeta', DECMETA);
			run;
		%end;
	%end;
	%if (&em_dec_decmeta ne ) and %sysfunc(exist(&em_dec_decmeta)) %then %do;
		data _null_;
			set &em_dec_decmeta;
			where _TYPE_ = 'PREDICTED';
			call symput('predVar', strip(VARIABLE));
			call symput('predLabel', strip(LABEL));
		run;
	%end;

	%if &predVar eq %then %goto doendm;

	%fillFile(type=publish, predvar=&predVar, file=&EM_FILE_EMPUBLISHSCORECODE);
	%fillFile(type=flow, predvar=&predVar, file=&EM_FILE_EMFLOWSCORECODE);
	%doendm:

%mend makeScoreCode;

%macro fillFile(type=, predVar=, file=);
	filename tempf "&file";
	data _null_;
		file tempf;
		set &EM_USER_EFFECTS end=eof;
		if _N_=1 then do;
			put "&predVar = ";
			if Variable = 'Intercept' then
				put Estimate;
			else
				put Estimate '*' Variable;
		end;
		else do;
			put '+' Estimate '*' Variable;
		end;
		if eof then do;
			put ";";
		end;
	run;
	filename tempf;
%mend fillFile;


%macro procreg;
		%global targetVar;
		%let targetVar = %scan(%EM_INTERVAL_TARGET, 1, );
		ods output parameterestimates= &EM_USER_EFFECTS;
		proc reg data=&EM_IMPORT_DATA OUTEST=&EM_USER_OUTEST;
			model &targetVar = %EM_INTERVAL_INPUT %EM_INTERVAL_REJECTED
			%if %upcase(&EM_PROPERTY_METHOD) ne NONE %then %do;
				selection= &EM_PROPERTY_METHOD
			%end;
			;
		%if %EM_FREQ ne %then %do;
			freq %EM_FREQ;
		%end;
	run;
	ods _all_ close;
	ods listing;
%mend procreg;

%macro train;
	%if %sysfunc(index(&EM_DEBUG, SOURCE))>0 or
		%sysfunc(index(&EM_DEBUG, ALL))>0 %then %do;
		options mprint;
	%end;

	%if (^%sysfunc(exist(&EM_IMPORT_DATA)) and
		^%sysfunc(exist(&EM_IMPORT_DATA, VIEW)))
		or "&EM_IMPORT_DATA" eq "" %then %do;
		%let EMEXCEPTIONSTRING = exception.server.IMPORT.NOTRAIN,1;
		%goto doenda;
	%end;

	%if (%EM_INTERVAL_TARGET eq ) %then %do;
		%let EMEXCEPTIONSTRING = exception.server.METADATA.USE1INTERVALTARGET;
		%goto doenda;
	%end;

	%em_getname(key=OUTEST, TYPE=DATA);
	%em_getname(key=EFFECTS, type=DATA);
	%procreg;
	%makeScoreCode;

	%em_model(TARGET=&targetvar,
		ASSESS=Y,
		DECSCORECODE=Y,
		FITSTATISTICS=Y,
		CLASSIFICATION=N,
		RESIDUALS=Y);
	%em_report(key=EFFECTS,
		viewtype=BAR,
		TIPTEXT=VARIABLE,
		X=VARIABLE,
		Freq=TVALUE,
		Autodisplay=Y,
		description=%nrbquote(Effects Plot),
		block=MODEL);
	%doenda:
%mend train;