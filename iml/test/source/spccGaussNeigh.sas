%macro spccGaussNeigh1;
	proc iml;
		package load spectralclust;
		m = {1 2, 3 4};
		max = {0 1.1254e-7, 1.1254e-7 0};
		min = {0 1.1253e-7, 1.1253e-7 0};
		out = spccGaussNeigh(m, 0.5);
		result = all(out <= max) & all(out >= min);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%test(spccGaussNeigh1);