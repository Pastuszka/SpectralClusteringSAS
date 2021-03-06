﻿%macro create;
	%EM_PROPERTY(NAME=ClusterNum,	VALUE=2);
	%EM_PROPERTY(NAME=Neighborhood,	VALUE=complete);
	%EM_PROPERTY(NAME=Laplacian,	VALUE=normalizedRW);
	%EM_PROPERTY(NAME=NeighFun,		VALUE=gaussian);
	%EM_PROPERTY(NAME=Sigma,		VALUE=1.0);
	%EM_PROPERTY(NAME=K,			VALUE=5);
	%EM_PROPERTY(NAME=MaxIter,		VALUE=10);
	%EM_PROPERTY(NAME=Distance,		VALUE=EUCLIDEAN);
	%EM_PROPERTY(NAME=Seed,			VALUE=12346);
	%EM_PROPERTY(NAME=Impute,		VALUE=none);
	%EM_PROPERTY(NAME=Standard,		VALUE=N);
	%EM_PROPERTY(NAME=ClusRole,		VALUE=SEGMENT,		ACTION=SCORE);
	

	%EM_REGISTER(key=import_data, type=data);
	%EM_REGISTER(key=vectors, type=data);
	%EM_REGISTER(key=indvectors, type=data);
	%EM_REGISTER(key=OUTSTAT, type=DATA);                                                                                                                                                                                                                       
    %EM_REGISTER(key=graph_table, type=DATA);                                                                                                                                                                                                                   
    %EM_REGISTER(key=MODELINFO, TYPE=DATA);                                                                                                                                                                                                                     
    %EM_REGISTER(key=CLUSTERSUM, type=DATA);                                                                                                                                                                                                                    
    %EM_REGISTER(key=ITERSTAT, type=DATA);                                                                                                                                                                                                                   
    %EM_REGISTER(key=OVERALLVARSTAT, TYPE=DATA);                                                                                                                                                                                                                
    %EM_REGISTER(key=CLUSTERBASEDVARSTAT, type=DATA);

%mend create;
