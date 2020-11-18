%macro create;
	/* Training Properties */
	%em_property(name=Method, value=NONE);
	%em_property(name=Details, value=N);

/* Scoring Properties */
	%em_property(name=ExcludedVariable, value=REJECT, action=SCORE);

	/* Register Data Sets */
	%EM_REGISTER(key=OUTEST, type=DATA);
	%EM_REGISTER(key=EFFECTS, type=DATA);
%mend create;