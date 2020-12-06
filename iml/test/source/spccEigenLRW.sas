%macro spccEigenLRW1;
	proc iml;
		package load spectralclust;
		m = {0 3 2 0, 3 0 3 2, 2 3 0 3, 0 2 3 0};
		max = {1.0001 1.0001 1.0001, -2.1638 0.2889 1.0001, 2.1639 -0.2888 1.0001, -0.9999 -0.9999 1.0001};
		min = {0.9999 0.9999 0.9999, -2.1639 0.2888 0.9999, 2.1638 -0.2889 0.9999, -1.0001 -1.0001 0.9999};
		out = spccEigenLRW(m, 3);
		out[,1] = out[,1] * (1 / out[1,1]);
		out[,2] = out[,2] * (1 / out[1,2]);
		out[,3] = out[,3] * (1 / out[1,3]);
		result = all(out <= max) & all(out >= min);
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%test(spccEigenLRW1);