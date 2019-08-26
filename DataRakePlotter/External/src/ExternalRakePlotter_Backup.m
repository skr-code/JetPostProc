%Cleaning
clear
clc
clf

%Setting the format
format long

%User input------------------
%If you want to use the reference data
useref = 0;

%Number of Rake Lines
NumberOfRakeLines = 3;

%Name of simulation that first set of files is coming from
SimulationTitle1 = 'ICDSV1-M2-P1';
File1 = '../input1/externalcenterline.dat';
File2 = '../input1/external0point2D.dat';
File3 = '../input1/external0point4D.dat';

%Name of the simulation that the second set of files is coming from
IsSecondSimulation = 1;
SimulationTitle2 = 'ICDSV2-M2-P1';
File4 = '../input2/externalcenterline.dat';
File5 = '../input2/external0point2D.dat';
File6 = '../input2/external0point4D.dat';

%Desired Data Columns
DesiredData1 = 15; %PitotPressure
DesiredData2 = 16;  %Total Temperature
DesiredData3 = 8;   %Static Pressure

%Once all solutions start using prms version, need to fix this
MohammadCodeCorrection1 = 17; %PitotPressure
MohammadCodeCorrection2 = 18; %TotaTemp

%Normalization Pitot Pressure
Pitotnorm = 101325;

%Normalization Temperature
Tnorm = 300;

%Normalization Static Pressure
StaticPnorm = 101325;

%Nozzle Exit Offset From X = 0
Sim1Offset = 0;
Sim2Offset = 0;

%PLotting stuff
linewidth = 2;
fontsize = 12;

%Pitot Pressure Graph Plotting
pitotpresxlimmin = 0;
pitotpresxlimmax = 12;
pitotpresylimmin = 1.5;
pitotpresylimmax = 3.5;

%Static Pressure Graph Plotting
staticpresxlimmin = 0;
staticpresxlimmax = 10;
staticpresylimmin = 0.6;
staticpresylimmax = 1.6;

%Temperature Graph Plotting
tempxlimmin = 0;
tempxlimmax = 12;
tempylimmin = 0.9;
tempylimmax = 1.1;

%------------------------------
%% Importing the Reference Data
if useref == 1
    disp('Extracting The Reference Data...');
    Z = importdata('../ReferenceData/ReferenceData.txt');
    LiuLESPitotPressure(:,1) = Z.data(1:end,1);
    LiuLESPitotPressure(:,2) = Z.data(1:end,2);
    LiuProbePitotPressure(:,1) = Z.data(1:end,4);
    LiuProbePitotPressure(:,2) = Z.data(1:end,5);
    LiuLESStaticPressure(:,1) = Z.data(1:end,10);
    LiuLESStaticPressure(:,2) = Z.data(1:end,11);
    disp('Reference Data Extracted!');
end

%% Grabbing Data from First File
%Looping through all of the data files to extract the pressure data
disp('Extracting the Coordinate Points...'); 
A = importdata(File1);
Xcoor1(:,:) = A.data(1:end,1);

%Calculating the the X/D as defined by the nozzle exit diameter
XOverD1 = Xcoor1-Sim1Offset;
XOverD1 = XOverD1./0.0728472;
disp('Coordinate Point Extraction Complete!');

%Extracting the data from the first simulation
disp('Extracting Desired Data For The First Simulation...');
PitotPressureSet1(:,:) = A.data(1:end,DesiredData1);
TemperatureSet1(:,:) = A.data(1:end,DesiredData2);
StaticPressureSet1(:,:) = A.data(1:end,DesiredData3);

if NumberOfRakeLines >= 2
    B = importdata(File2);
    PitotPressureSet1(:,2) = B.data(1:end,DesiredData1);
    TemperatureSet1(:,2) = B.data(1:end,DesiredData2);
    StaticPressureSet1(:,2) = B.data(1:end,DesiredData3);
end
   
if NumberOfRakeLines == 3
    C = importdata(File3);
    PitotPressureSet1(:,3) = C.data(1:end,DesiredData1);
    TemperatureSet1(:,3) = C.data(1:end,DesiredData2);
    StaticPressureSet1(:,3) = C.data(1:end,DesiredData3);
end
disp('First Simulation Data Extraction Complete!');
   
disp('Normalizing Pressure Data From The First Simulation...');
if Pitotnorm ~= 0
    PitotPressureSet1 = PitotPressureSet1./Pitotnorm;
end

if Tnorm ~= 0
    TemperatureSet1 = TemperatureSet1./Tnorm;
end

if StaticPnorm ~= 0
    StaticPressureSet1 = StaticPressureSet1./StaticPnorm;
end
disp('Data Normalization of First Simulation Complete!');

%% Grabbing from Second File
if IsSecondSimulation == 1
    disp('Extracting the Coordinate Points From The Second Simulation...'); 
    G = importdata(File4);
    Xcoor2(:,:) = G.data(1:end,1);

    %Calculating the the X/D as defined by the nozzle exit diameter
    XOverD2 = Xcoor2-Sim2Offset;
    XOverD2 = XOverD2./0.0728472;
    disp('Coordinate Point Extraction For The Second Simulation Complete!');
    
    disp('Extracting Desired Data For The Second Simulation...');
    D = importdata(File4);
    PitotPressureSet2(:,:) = D.data(1:end,MohammadCodeCorrection1);
    TemperatureSet2(:,:) = D.data(1:end,MohammadCodeCorrection2);
    StaticPressureSet2(:,:) = D.data(1:end,DesiredData3);
    
    if NumberOfRakeLines >= 2
        E = importdata(File5);
        PitotPressureSet2(:,2) = E.data(1:end,MohammadCodeCorrection1);
        TemperatureSet2(:,2) = E.data(1:end,MohammadCodeCorrection2);
        StaticPressureSet2(:,2) = E.data(1:end,DesiredData3);
    end

    if NumberOfRakeLines == 3
        F = importdata(File6);
        PitotPressureSet2(:,3) = F.data(1:end,MohammadCodeCorrection1);
        TemperatureSet2(:,3) = F.data(1:end,MohammadCodeCorrection2);
        StaticPressureSet2(:,3) = F.data(1:end,DesiredData3);
    end
    disp('Second Simulation Data Extraction Complete!');
    
disp('Normalizing Pressure Data From The Second Simulation...');
    if Pitotnorm ~= 0
        PitotPressureSet2 = PitotPressureSet2./Pitotnorm;
    end
    
    if Tnorm ~= 0
        TemperatureSet2 = TemperatureSet2./Tnorm;
    end
    
    if StaticPnorm ~= 0
        StaticPressureSet2 = StaticPressureSet2./StaticPnorm;
    end
disp('Data Normalization of Second Simulation Complete!');
end
%% Pitot Pressure Plotting
disp('Plotting...');

%Plotting the Centerline Pressure Values
subplot(3,1,3)
hold on
plot(XOverD1(:,1),PitotPressureSet1(:,1),'-k','LineWidth',linewidth);
if useref == 1
    plot(LiuLESPitotPressure(:,1),LiuLESPitotPressure(:,2));
    plot(LiuProbePitotPressure(:,1),LiuProbePitotPressure(:,2),'ks');
end
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),PitotPressureSet2(:,1),'--k','LineWidth',linewidth);
end
hold off
title('Centerline Pitot Pressure Ratio Vs X/D')
axis([pitotpresxlimmin pitotpresxlimmax pitotpresylimmin pitotpresylimmax])
xlabel('X/De','FontWeight', 'bold')
ylabel('Pitot Pressure/Pinf','FontWeight', 'bold')
grid on
grid minor
if useref == 1 
    legend(SimulationTitle1,'Liu-LES','Liu-Probe',SimulationTitle2,'Location','best')
else
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Plotting the Y = 0.2D Pressure Values
subplot(3,1,2)
hold on
plot(XOverD1(:,1),PitotPressureSet1(:,2),'-k','LineWidth',linewidth);
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),PitotPressureSet2(:,2),'--k','LineWidth',linewidth);
end
hold off
title('Y = 0.2D Pitot Pressure RatioVs X/D')
axis([pitotpresxlimmin pitotpresxlimmax pitotpresylimmin pitotpresylimmax])
xlabel('X/De','FontWeight', 'bold')
ylabel('Pitot Pressure/Pinf','FontWeight', 'bold')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.4D Pressure Values
subplot(3,1,1)
hold on
plot(XOverD1(:,1),PitotPressureSet1(:,3),'-k','LineWidth',linewidth);
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),PitotPressureSet2(:,3),'--k','LineWidth',linewidth);
end
hold off
title('Y = 0.4D Pitot Pressure Ratio Vs X/D')
axis([pitotpresxlimmin pitotpresxlimmax pitotpresylimmin pitotpresylimmax])
xlabel('X/De','FontWeight', 'bold')
ylabel('Pitot Pressure/Pinf','FontWeight', 'bold')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')
if IsSecondSimulation == 1
    pressurefile = strcat('../FiguresOutput/ExternalPitotPress_',SimulationTitle1,'Vs',SimulationTitle2,'.png');
else
    pressurefile = strcat('../FiguresOutput/ExternalPitotPress_',SimulationTitle1,'.png');
end
saveas(gcf,pressurefile)

%% Total Temperature Plotting

%Plotting the Centerline Temperature Values
figure 
subplot(3,1,3)
hold on
plot(XOverD1(:,1),TemperatureSet1(:,1),'-k','LineWidth',linewidth);
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),TemperatureSet2(:,1),'--k','LineWidth',linewidth);
end
hold off
title('Centerline Total Temperature Ratio Vs X/D')
axis([tempxlimmin tempxlimmax tempylimmin tempylimmax])
xlabel('X/De','FontWeight', 'bold')
ylabel('Tt/Inlet Tt','FontWeight', 'bold')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.2D Temperature Values
subplot(3,1,2)
hold on
plot(XOverD1(:,1),TemperatureSet1(:,2),'-k','LineWidth',linewidth);
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),TemperatureSet2(:,2),'--k','LineWidth',linewidth);
end
hold off
title('Y = 0.2D Total Temperature Ratio Vs X/D')
axis([tempxlimmin tempxlimmax tempylimmin tempylimmax])
xlabel('X/De','FontWeight', 'bold')
ylabel('Tt/Inlet Tt','FontWeight', 'bold')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.4D Pressure Values
subplot(3,1,1)
hold on
plot(XOverD1(:,1),TemperatureSet1(:,3),'-k','LineWidth',linewidth);
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),TemperatureSet2(:,3),'--k','LineWidth',linewidth);
end
hold off
title('Y = 0.4D Total Temperature Ratio Vs X/D')
xlabel('X/De','FontWeight', 'bold')
ylabel('Tt/Inlet Tt','FontWeight', 'bold')
axis([tempxlimmin tempxlimmax tempylimmin tempylimmax])
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')
if IsSecondSimulation == 1
    temperaturefile = strcat('../FiguresOutput/ExternalTotalTemp_',SimulationTitle1,'Vs',SimulationTitle2,'.png');
else
    temperaturefile = strcat('../FiguresOutput/ExternalTotalTemp_',SimulationTitle1,'.png');
end
saveas(gcf,temperaturefile)

%% Static Pressure Plotting
figure 
subplot(3,1,3)
hold on
plot(XOverD1(:,1),StaticPressureSet1(:,1),'-k','LineWidth',linewidth);
if useref == 1
    plot(LiuLESStaticPressure(:,1),LiuLESStaticPressure(:,2));
end
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),StaticPressureSet2(:,1),'--k','LineWidth',linewidth);
end
hold off
title('Centerline Static Pressure Ratio Vs X/D')
axis([staticpresxlimmin staticpresxlimmax staticpresylimmin staticpresylimmax])
xlabel('X/De','FontWeight', 'bold')
ylabel('P/Pamb','FontWeight', 'bold')
grid on
grid minor
if useref == 1
    legend(SimulationTitle1,'Liu-LES',SimulationTitle2,'Location','best')
else
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end
%Plotting the Y = 0.2D Temperature Values
subplot(3,1,2)
hold on
plot(XOverD1(:,1),StaticPressureSet1(:,2),'-k','LineWidth',linewidth);
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),StaticPressureSet2(:,2),'--k','LineWidth',linewidth);
end
hold off
title('Y = 0.2D Static Pressure Ratio Vs X/D')
axis([staticpresxlimmin staticpresxlimmax staticpresylimmin staticpresylimmax])
xlabel('X/De','FontWeight', 'bold')
ylabel('P/Pamb','FontWeight', 'bold')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.4D Pressure Values
subplot(3,1,1)
hold on
plot(XOverD1(:,1),StaticPressureSet1(:,3),'-k','LineWidth',linewidth);
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),StaticPressureSet2(:,3),'--k','LineWidth',linewidth);
end
hold off
title('Y = 0.4D Static Pressure Ratio Vs X/D')
xlabel('X/De','FontWeight', 'bold')
ylabel('P/Pamb','FontWeight', 'bold')
axis([staticpresxlimmin staticpresxlimmax staticpresylimmin staticpresylimmax])
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')
%Setting up the data export
if IsSecondSimulation == 1
    spressurefile = strcat('../FiguresOutput/ExternalStaticPress_',SimulationTitle1,'Vs',SimulationTitle2,'.png');
else
    spressurefile = strcat('../FiguresOutput/ExternalStaticPress_',SimulationTitle1,'.png');
end
saveas(gcf,spressurefile)