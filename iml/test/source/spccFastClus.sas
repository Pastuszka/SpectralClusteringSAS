%macro spccNegEuclidNeigh1;
	ods graphics off;
	ods exclude all;
	ods noresults;
	proc iml;
		package load spectralclust;
		m = {0 0,  0 1, 0 2, 0 3};
		out = spccFastClus(m, 2, 'normalizedSym', 'gaussian', 0.5, 'complete', 0);
		result = all(out[,7] = {1, 1, 2, 2}) | all(out[,7] = {2, 2, 1, 1});
		if result then call symput('return_code', '0');
		else call symput('return_code', '1');
	quit;
	ods graphics on;
	ods exclude none;
	ods results;
%mend;

%test(spccNegEuclidNeigh1);