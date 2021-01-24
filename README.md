[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/Pastuszka/SpectralClusteringSAS/blob/main/LICENSE)

# SpectralClusteringSAS
Implementation of spectral clustering for SAS EM and more

to install the package use within proc iml:
```
package install 'path to spectralClust.zip';
```
load the package with:
```
package load spectralClust;
```
## Installation for SAS Enterprise Miner

### Creating catalog in sashelp
Open SAS session, copy below code, change *Path_to_repository* to path where your SpectralClusteringSAS directory is palced and run code.
```
%include "Path_to_repository\SpectralClusteringSAS\SAS EM\SpecClust\create_catalog.sas";
%createCatalog(Path_to_repository);
```
You might need administrator privilages to perform this operation.
### Copying other files
Copy XML file SpectralClusteringSAS\SAS EM\SpecClust\SpectralClustering.xml to SASHome\SASEnterpriseMinerWorkstationConfiguration\<version>\WEB-INF\classes\components.
Usually SASHome directory is in C:\Program Files directory on Windows.
Add below line to file SASHome\SASEnterpriseMinerWorkstationConfiguration\<version>\WEB-INF\classes\components\EMList.txt
```
SpectralClustering=SpectralClustering.xml
```
Copy icons from SpectralClusteringSAS\SAS EM\SpecClust\gif, SpectralClusteringSAS\SAS EM\SpecClust\gif16, SpectralClusteringSAS\SAS EM\SpecClust\gif32 to repsective directories in SASHome\SASEnterpriseMinerWorkstationConfiguration\<version>\WEB-INF\classes\components.
You might need administrator privilages to perform this operation.
