%em_getname(key=vectors, TYPE=DATA);

%em_report(key=vectors,
	   viewtype=Data,
	   block=eigenvectors,
      views=1
      autodisplay=Y,
	   description=Eigenvector Table);

%em_report(key=vectors,
	   viewtype=Histogram,
	   block=eigenvectors,
      x=COL1,
      views=2,
      autodisplay=N,
      choicetext=COL1,
	   description=Eigenvector histogram);

%em_report(
      views=2,
      x=COL2 ,
      choicetext=COL2);

%em_report(
      views=2,
      x=COL3 ,
      choicetext=COL3);


