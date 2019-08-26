#!MC 1410
$!VarSet |MFBD| = '/home/sal'
$!READDATASET  '"STANDARDSYNTAX" "1.0" "FILELIST_CGNSFILES" "1" "/home/sal/Desktop/CDNozzle1.47/ICDSV2/M2/p1/sol/merged_sol_aver.cgns" "LoadBCs" "Yes" "AssignStrandIDs" "Yes" "UniformGridStructure" "Yes" "LoaderVersion" "V3" "CgnsLibraryVersion" "3.3.0"'
  DATASETREADER = 'CGNS Loader'
  READDATAOPTION = NEW
  RESETSTYLE = YES
  ASSIGNSTRANDIDS = NO
  INITIALPLOTTYPE = CARTESIAN3D
  INITIALPLOTFIRSTZONEONLY = NO
  ADDZONESTOEXISTINGSTRANDS = NO
  VARLOADMODE = BYNAME
$!READSTYLESHEET  "/home/sal/Desktop/tecplotStuff/frames/M2_XVelocityMidPlane.sty"
  INCLUDEPLOTSTYLE = YES
  INCLUDETEXT = YES
  INCLUDEGEOM = YES
  INCLUDEAUXDATA = YES
  INCLUDESTREAMPOSITIONS = YES
  INCLUDECONTOURLEVELS = YES
  MERGE = NO
  INCLUDEFRAMESIZEANDPOSITION = NO
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'SetFluidProperties Incompressible=\'F\' Density=1 SpecificHeat=2.5 UseSpecificHeatVar=\'F\' SpecificHeatVar=1 GasConstant=287 UseGasConstantVar=\'F\' GasConstantVar=1 Gamma=1.4 UseGammaVar=\'F\' GammaVar=1 Viscosity=1 UseViscosityVar=\'F\' ViscosityVar=1 Conductivity=1 UseConductivityVar=\'F\' ConductivityVar=1'
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'SetFieldVariables ConvectionVarsAreMomentum=\'F\' UVar=5 VVar=6 WVar=7 ID1=\'Pressure\' Variable1=8 ID2=\'Density\' Variable2=4'
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'PITOTPRESSURE\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'STAGTEMPERATURE\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'MACHNUMBER\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'STAGPRESSURE\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'Extract Precise Line'
  COMMAND = 'XSTART = 0 YSTART = 0 ZSTART = 0 XEND = 1.82118 YEND = 0 ZEND = 0 NUMPTS = 1000 EXTRACTTHROUGHVOLUME = T EXTRACTTOFILE = T EXTRACTFILENAME = \'/home/sal/Desktop/CDNozzle1.47/ICDSV2/M2/p0-copy/post-proc/externalcenterline.dat\' '
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'Extract Precise Line'
  COMMAND = 'XSTART = 0 YSTART = 0.0145694 ZSTART = 0 XEND = 1.82118 YEND = 0.0145694 ZEND = 0 NUMPTS = 1000 EXTRACTTHROUGHVOLUME = T EXTRACTTOFILE = T EXTRACTFILENAME = \'/home/sal/Desktop/CDNozzle1.47/ICDSV2/M2/p0-copy/post-proc/external0point2D.dat\' '
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'Extract Precise Line'
  COMMAND = 'XSTART = 0 YSTART = 0.0291389 ZSTART = 0 XEND = 1.82118 YEND = 0.0291389 ZEND = 0 NUMPTS = 1000 EXTRACTTHROUGHVOLUME = T EXTRACTTOFILE = T EXTRACTFILENAME = \'/home/sal/Desktop/CDNozzle1.47/ICDSV2/M2/p0-copy/post-proc/external0point4D.dat\' '
$!RemoveVar |MFBD|
