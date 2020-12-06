%let test_path = %nrstr(D:/sas projects/inżynierka/repo/SpectralClusteringSAS/iml/test/source);

%macro test(test_macro);
	%let tests_run = %eval(&tests_run. + 1);
	%put Running &test_macro;
	%let return_code = -1;
	%&test_macro;
	%if &return_code = 0 %then %do;
		%put Success!;
		%let tests_successful = %eval(&tests_successful. + 1);
	%end;
	%else %if &return_code = -1 %then %do;
		%put Test failed without a return code;
		%let failed_tests = &failed_tests &test_macro [&return_code.];
	%end;
	%else %do;
		%put Test failed with return code [&return_code.];
		%let failed_tests = &failed_tests &test_macro [&return_code.];
	%end;	
%mend test;


%macro include_files(dir,ext);
  %local filrf rc did memcnt name i;
  %let rc=%sysfunc(filename(filrf,&dir));
  %let did=%sysfunc(dopen(&filrf));      

   %if &did eq 0 %then %do; 
    %put Directory &dir cannot be open or does not exist;
    %return;
  %end;

   %do i = 1 %to %sysfunc(dnum(&did));   

   %let name=%qsysfunc(dread(&did,&i));

      %if %qupcase(%qscan(&name,-1,.)) = %upcase(&ext) %then %do;
        %include "&dir.\&name." ;
      %end;
      %else %if %qscan(&name,2,.) = %then %do;        
        %include_files(&dir\&name,&ext)
      %end;

   %end;
   %let rc=%sysfunc(dclose(&did));
   %let rc=%sysfunc(filename(filrf));     

%mend include_files;

%macro run_tests;
	%let tests_run = 0;
	%let tests_successful = 0;
	%let return_code = 0;
	%let failed_tests = %str();
	%put Starting tests;
	%let timer_start = %sysfunc(datetime());
	%include_files(&test_path,sas);
	%let dur = %sysevalf(%sysfunc(datetime()) - &timer_start);
	%put Finished testing!;
	%put Tests run: &tests_run;
	%put Tests successful: &tests_successful;
	%if &tests_run = &tests_successful %then %do;
		%put All tests executed succesfully!;
	%end;
	%else %do;
		%let tests_failed = %eval(&tests_run. - &tests_successful);
		%if &tests_failed = 1 %then %do;
			%put Failed 1 test:;
			%put &failed_tests;
		%end;
		%else %do;
			%put Failed &tests_failed tests;
			%put &failed_tests;
		%end;
	%end;
	%put Time elapsed: &dur;
%mend run_tests;

%run_tests;

