%macro spccNegEuclidNeigh1;
	proc iml;
		package load spectralclust;
		m = {0 0,  0 1, 0 2};
		expected = {0 1 0, 1 0 1, 0 1 0};
		out = spccNegEuclidNeigh(m);
		result = all(expected = out);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%test(spccNegEuclidNeigh1);