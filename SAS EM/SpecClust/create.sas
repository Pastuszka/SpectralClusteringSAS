%macro create;
	%EM_PROPERTY(NAME=ClusterNum,	VALUE=2);
	%EM_PROPERTY(NAME=Neighborhood,	VALUE=None);
	%EM_PROPERTY(NAME=Laplacian,	VALUE=normalizedRW);
	%EM_PROPERTY(NAME=NeighFun,		VALUE=gaussian);
	%EM_PROPERTY(NAME=Sigma,		VALUE=1.0);
	%EM_PROPERTY(NAME=ClustFun,		VALUE=CENTROID,		ACTION=SCORE);

	%EM_REGISTER(key=vectors, type=data);
	%EM_REGISTER(key=tree, type=data);
	%EM_REGISTER(key=cluster, type=data);
	%EM_REGISTER(key=indvectors, type=data);
%mend create;
