#!/bin/bash

echo Please enter the directory for input1. Note: it is assumed that all the necessary files have been genereated for input1
read input1

echo Please enter the directory for input2
read input2

#External Rake Processing
echo Starting the external rake data processing
cd /home/sal/Desktop/JetPostProc/DataRakePlotter/External/src
'/home/sal/softwares/MATLAB/bin/matlab' -nodisplay -nosplash -nodesktop -r 'ExternalRakePlotter;exit;'

chmod u+x /home/sal/Desktop/JetPostProc/DataRakePlotter/External/FiguresOutput
echo Moving external rake figures to post-proc directory
cp -r /home/sal/Desktop/JetPostProc/DataRakePlotter/External/FiguresOutput $input2/post-proc

echo External rake figures moved to post-proc

#Internal Rake Processing
echo Starting internal rake data processing
cd /home/sal/Desktop/JetPostProc/DataRakePlotter/Internal/src
"/home/sal/softwares/MATLAB/bin/matlab" -nodisplay -nosplash -nodesktop -r "InternalRakePlotter;exit;"

chmod u+x /home/sal/Desktop/JetPostProc/DataRakePlotter/Internal/FiguresOutput*
echo Moving internal rake figures to post-proc directory
cp -r /home/sal/Desktop/JetPostProc/DataRakePlotter/Internal/FiguresOutput* $input2/post-proc

echo Internal rake figures moved to post-proc

#Cleaning Near-Field Data
#Have to modify to do each monitor point
chmod u+x $input2/sol/monitor_points_*.dat

echo Moving monitorpoint file to post-proc
cp -r $input2/sol/monitor_points_*.dat $input2/post-proc

echo Cleaning near-field data
cp -r $input2/post-proc/monitor_points_*.dat /home/sal/Desktop/JetPostProc/MonotonicCleaner/monitor_data
cd /home/sal/Desktop/JetPostProc/MonotonicCleaner
"/home/sal/softwares/MATLAB/bin/matlab" -nodisplay -nosplash -nodesktop -r "extract_mon_pts_pt0;exit;"
"/home/sal/softwares/MATLAB/bin/matlab" -nodisplay -nosplash -nodesktop -r "extract_mon_pts_pt1;exit;"

echo Moving the cleaned monitor point data to post-proc directory
cp /home/sal/Desktop/JetPostProc/MonotonicCleaner/extract_physical_data/* $input2/post-proc/

#Converting Monitor Point Data to SPL
echo Converting monitor point data to spl
cd $input2/post-proc
fftpsd -dft -i cpr-p2-p-pt0.dat -o ./ -l 0.0171083137623 -c 2 -w hann -variance -spl
fftpsd -dft -i cpr-p2-p-pt1.dat -o ./ -l 0.0171083137623 -c 2 -w hann -variance -spl
echo Monitor point data conversion complete

#Saving Plots of Near-Field Data
echo Creating and Storing Near-Field Data Plots
cp $input1/post-proc/SPL_cpr-p2-p-pt*.dat /home/sal/Desktop/JetPostProc/SPLPlotter/MonitorPointPlotter/input1
cp $input2/post-proc/SPL_cpr-p2-p-pt*.dat /home/sal/Desktop/JetPostProc/SPLPlotter/MonitorPointPlotter/input2
cd /home/sal/Desktop/JetPostProc/SPLPlotter/MonitorPointPlotter/src
"/home/sal/softwares/MATLAB/bin/matlab" -nodisplay -nosplash -nodesktop -r "SPLPlotter;exit;"
cp /home/sal/Desktop/JetPostProc/SPLPlotter/MonitorPointPlotter/FiguresOutput/* $input2/post-proc
echo Near-Field Data Plots Created

#Saving Plots of Far-Field Data
echo Creating Far-Field Waterfall Plot
cd /home/sal/Desktop/JetPostProc/SPLPlotter/FWHPlotter/src
cp $input1/sol/fwh_spl_ob* /home/sal/Desktop/JetPostProc/SPLPlotter/FWHPlotter/input1
cp $input2/sol/fwh_spl_ob* /home/sal/Desktop/JetPostProc/SPLPlotter/FWHPlotter/input2
"/home/sal/softwares/MATLAB/bin/matlab" -nodisplay -nosplash -nodesktop -r "FWHPlotter_waterfall;exit;"

echo Creating Individual Far-Field Plots
"/home/sal/softwares/MATLAB/bin/matlab" -nodisplay -nosplash -nodesktop -r "FWHPlotter_90;exit;"
"/home/sal/softwares/MATLAB/bin/matlab" -nodisplay -nosplash -nodesktop -r "FWHPlotter_120;exit;"
"/home/sal/softwares/MATLAB/bin/matlab" -nodisplay -nosplash -nodesktop -r "FWHPlotter_150;exit;"
cp /home/sal/Desktop/JetPostProc/SPLPlotter/FWHPlotter/FiguresOutput/* $input2/post-proc/
echo Far-Field Plots Created


