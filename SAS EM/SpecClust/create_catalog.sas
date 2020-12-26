﻿%macro CreateSources(dirPath, libraryname, catname);

	libname &libraryname "&dirPath";
	filename src_cat catalog "&libraryname..&catname..spcl.source";
	filename mydata "&dirPath.\main.sas";
	data _null_;
		file src_cat;
		infile mydata;
		input;
		put _infile_;
	run;
	filename src_cat catalog "&libraryname..&catname..spcl_create.source";
	filename mydata "&dirPath.\create.sas";
	data _null_;
		file src_cat;
		infile mydata;
		input;
		put _infile_;
	run;
	filename src_cat catalog "&libraryname..&catname..spcl_train.source";
	filename mydata "&dirPath.\train.sas";
	data _null_;
		file src_cat;
		infile mydata;
		input;
		put _infile_;
	run;
	filename src_cat catalog "&libraryname..&catname..spcl_score.source";
	filename mydata "&dirPath.\score.sas";
	data _null_;
		file src_cat;
		infile mydata;
		input;
		put _infile_;
	run;
	filename src_cat catalog "&libraryname..&catname..spcl_report.source";
	filename mydata "&dirPath.\report.sas";
	data _null_;
		file src_cat;
		infile mydata;
		input;
		put _infile_;
	run;

	proc catalog cat=&libraryname..&catname.;
		copy out=sashelp.&catname.;
	run;
%mend CreateSources;

%CreateSources(path\to\SpectralClusteringSAS\SAS EM\SpecClust, specc, specc)
LIBNAME specc CLEAR;
