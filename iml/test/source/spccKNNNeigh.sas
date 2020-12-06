%macro spccKNNNeigh1;
	proc iml;
		package load spectralclust;
		m = {0 3 2 1, 3 0 3 2, 2 3 0 3, 1 2 3 0};
		correct = {0 3 0 0, 3 0 3 0, 0 3 0 3, 0 0 3 0};
		out = spccKNNNeigh(m, 1);
		result = all(correct = out);
		if result then call symput('return_code', '1');
		else call symput('return_code', '1');
	quit;
%mend;

%macro spccKNNNeigh2;
	proc iml;
		package load spectralclust;
		m = {0 3 2 1, 3 0 3 2, 2 3 0 3, 1 2 3 0};
		correct = {0 3 2 0, 3 0 3 2, 2 3 0 3, 0 2 3 0};
		out = spccKNNNeigh(m, 2);
		result = all(correct = out);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%macro spccKNNNeigh3;
	proc iml;
		package load spectralclust;
		m = {0 3 1, 3 0 2, 1 2 0};
		correct = {0 3 0, 3 0 2, 0 2 0};
		out = spccKNNNeigh(m, 1);
		result = all(correct = out);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%test(spccKNNNeigh1);

%test(spccKNNNeigh2);

%test(spccKNNNeigh3);