%macro spccEigenLSym1;
	proc iml;
		package load spectralclust;
		m = {0 3 2 0, 3 0 3 2, 2 3 0 3, 0 2 3 0};
		max = {0.2917 -0.7982 0.5271, -0.7390 -0.2700 0.61722, 0.7391 0.2701 0.6173, -0.2916 0.7983 0.5271};
		min = {0.2916 -0.7983 0.5270, -0.7391 -0.2701 0.61721, 0.7390 0.2700 0.6172, -0.2917 0.7982 0.5270};
		out = spccEigenLSym(m, 3);
		result = all(out <= max) & all(out >= min);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%test(spccEigenLSym1);