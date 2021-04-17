[![Apache license](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/Pastuszka/SpectralClusteringSAS/blob/main/LICENSE)

# SpectralClusteringSAS
Implementation of spectral clustering for SAS Enterprise Miner and more.

## Installation of IML package

To install the package use within proc iml:
```
package install 'path to spectralClust.zip';
```
Load the package with:
```
package load spectralClust;
```

## Installation guide for SAS Enterprise Miner

You must have IML package spectralClust installed for the SAS EM Spectral clustering node to work properly.

1. Clone this repository or download it as ZIP and place it in location on your disk available for SAS.

2. Open SAS session, copy below code, change *Path_to_repository* to path where your SpectralClusteringSAS directory is placed and run the code.
```
%include "Path_to_repository\SpectralClusteringSAS\SAS EM\SpecClust\create_catalog.sas";
%createCatalog(Path_to_repository);
```
You might need administrator privilages to perform this operation.

3. Copy XML file from repository (SpectralClusteringSAS\SAS EM\SpecClust\SpectralClustering.xml) to directory SASHome\SASEnterpriseMinerWorkstationConfiguration\\&lt;version&gt;\WEB-INF\classes\components.

Usually SASHome directory is in C:\Program Files directory on Windows.

&lt;version&gt; means wersion of SAS Enterprise Miner, e.g. 15.1

4. Add below line to file SASHome\SASEnterpriseMinerWorkstationConfiguration\\&lt;version&gt;\WEB-INF\classes\components\EMList.txt
```
SpectralClustering=SpectralClustering.xml
```

5. Copy icons from 
 * SpectralClusteringSAS\SAS EM\SpecClust\gif, 
 * SpectralClusteringSAS\SAS EM\SpecClust\gif16 
 * SpectralClusteringSAS\SAS EM\SpecClust\gif32 

to repsective directories in SASHome\SASEnterpriseMinerWorkstationConfiguration\\&lt;version&gt;\WEB-INF\classes\components.

You might need administrator privilages to perform this operation.

6. Start or restart SAS Enterprise Miner

7. In Exploration tab there should be available new Spectral Clustering node

