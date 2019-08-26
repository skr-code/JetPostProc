#!/bin/bash

echo Please enter the directory for input1. Note: it is assumed that all the necessary files have been genereated for input1
read input1

echo Please enter the directory for input2
read input2

#Setting up the post-proc
echo Setting up the post-proc file
cd $input2
mkdir $input2/post-proc
echo Post-proc directory made

#Executing External Rake
echo Executing external rake
tec360 -b /home/sal/Desktop/tecplotStuff/macros/M2ExternalDataRakeWithPitot/ExternalRakeWithPitot.mcr
echo External rake complete

#Executing Internal Rake
echo Executing internal rake
tec360 -b /home/sal/Desktop/tecplotStuff/macros/M2InternalDataRakeWithTotal/InternalRakeWithPitot.mcr
echo Internal rake complete

#Positioning External rake data for matlab script
echo Positioning external rake data for matlab
cp $input1/post-proc/external* /home/sal/Desktop/JetPostProc/DataRakePlotter/External/input1
cp $input2/post-proc/external* /home/sal/Desktop/JetPostProc/DataRakePlotter/External/input2
echo External rake data positioned

#Positioning Internal rake data for matlab script
echo Positioning internal rake data
cp $input1/post-proc/internal* /home/sal/Desktop/JetPostProc/DataRakePlotter/Internal/input1
cp $input2/post-proc/internal* /home/sal/Desktop/JetPostProc/DataRakePlotter/Internal/input2
echo Internal rake data positioned
