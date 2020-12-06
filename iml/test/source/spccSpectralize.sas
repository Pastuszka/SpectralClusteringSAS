%macro spccSpectralize1;
	%let gauss_correct = 0;
	%let knn_correct = 0;
	%let rw_correct = 0;
	proc iml;
		
		package load spectralclust;
		start spccGaussNeigh(m, sigma);
			expected = {0 1, 0 2, 0 3, 0 4};
			if sigma = 0.5 & m = expected then do;
				call symput('gauss_correct', '1');
			end;
			ret = {0 3 2 1, 3 0 3 2, 2 3 0 3, 1 2 3 0};
			return ret;
		finish;
		
		start spccKNNNeigh(m, k);
			expected = {0 3 2 1, 3 0 3 2, 2 3 0 3, 1 2 3 0};
			if k = 2 & m = expected then do;
				call symput('knn_correct', '1');
			end;
			ret = {0 3 2 0, 3 0 3 2, 2 3 0 3, 0 2 3 0};
			return ret;
		finish;
		
		start spccEigenLRW(m, nvecs);
			expected = {0 3 2 0, 3 0 3 2, 2 3 0 3, 0 2 3 0};
			if nvecs = 2 & m = expected then do;
				call symput('rw_correct', '1');
			end;
			ret = {1 1 1, -2.1638 0.2889 1, 2.1639 -0.2888 1, -1 -1 1};
			return ret;
		finish;
		
		m = {0 1, 0 2, 0 3, 0 4};
		expected = {1 1 1, -2.1638 0.2889 1, 2.1639 -0.2888 1, -1 -1 1};
		out = spccSpectralize(m, 2, 'normalizedRW', 'gaussian', 0.5, 'knn', 2);
		correct = all(out = expected);
		if &rw_correct & &gauss_correct & &knn_correct & correct then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
%mend;

%test(spccSpectralize1);