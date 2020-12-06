%macro spccMutKNNNeigh1;
	proc iml;
		package load spectralclust;
		m = {0 3 2 1, 3 0 3 2, 2 3 0 3, 1 2 3 0};
		correct = {0 3 0 0, 3 0 3 0, 0 3 0 3, 0 0 3 0};
		out = spccMutKNNNeigh(m, 1);
		result = all(correct = out);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%macro spccMutKNNNeigh2;
	proc iml;
		package load spectralclust;
		m = {0 3 2 1, 3 0 3 2, 2 3 0 3, 1 2 3 0};
		correct = {0 3 0 0, 3 0 3 0, 0 3 0 3, 0 0 3 0};
		out = spccMutKNNNeigh(m, 2);
		result = all(correct = out);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%macro spccMutKNNNeigh3;
	proc iml;
		package load spectralclust;
		m = {0 3 1, 3 0 2, 1 2 0};
		correct = {0 3 0, 3 0 0, 0 0 0};
		out = spccMutKNNNeigh(m, 1);
		result = all(correct = out);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;


%test(spccMutKNNNeigh1);

%test(spccMutKNNNeigh2);

%test(spccMutKNNNeigh3);