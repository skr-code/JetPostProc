%Cleaning
clear
clc

%Setting the format
format long

%User input------------------

%Number of Rake Lines
NumberOfRakeLines = 3;

%Name of simulation that first set of files is coming from
SimulationTitle1 = 'ICDB-M2-P2';
File1 = '/home/sal/Desktop/temp/externalcenterline.dat';
File2 = '/home/sal/Desktop/temp/external0point2D.dat';
File3 = '/home/sal/Desktop/temp/external0point4D.dat';

%Name of the simulation that the second set of files is coming from
IsSecondSimulation = 0;
SimulationTitle2 = 'ICDB-M2-P2';
File4 = '../input2/externalcenterline.dat';
File5 = '../input2/external0point2D.dat';
File6 = '../input2/external0point4D.dat';

%Desired Data Columns to be plotted
DesiredData1 = 15; %PitotPressure
DesiredData2 = 16;  %Total Temperature
DesiredData3 = 8;   %Static Pressure
DesiredData4 = 17;   %Mach Number
DesiredData5 = 18;  %Stagnation Pressure

%Normalization Pitot Pressure
Pitotnorm = 0;

%Normalization Temperature
Tnorm = 0;

%Normalization Static Pressure
StaticPnorm = 0;

%Normalization Mach Number
Mnorm = 0;

%Normalization Total Pressure
Totalpnorm = 0;

%Nozzle Exit Offset From X = 0
Sim1Offset = 0;
Sim2Offset = 0;

%Pitot Pressure Graph Plotting
pitotpresxlimmin = 0;
pitotpresxlimmax = 12;
pitotpresylimmin = 0.5;
pitotpresylimmax = 1.2;

%Static Pressure Graph Plotting
staticpresxlimmin = 0;
staticpresxlimmax = 10;
staticpresylimmin = 0.5;
staticpresylimmax = 1.5;

%Temperature Graph Plotting
tempxlimmin = 0;
tempxlimmax = 12;
tempylimmin = 0.5;
tempylimmax = 1.5;

%Mach Graph Plotting
machxlimmin = 0;
machxlimmax = 12;
machylimmin = 0.5;
machylimmax = 1.5;

%Total Pressure Graph Plotting
totpxlimmin = 0;
totpxlimmax = 12;
totpylimmin = 0.5;
totpylimmax = 1.5;

%------------------------------
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
MachNumberSet1(:,:) = A.data(1:end,DesiredData4);
StagnationPressureSet1(:,:) = A.data(1:end,DesiredData5);

if NumberOfRakeLines >= 2
    B = importdata(File2);
    PitotPressureSet1(:,2) = B.data(1:end,DesiredData1);
    TemperatureSet1(:,2) = B.data(1:end,DesiredData2);
    StaticPressureSet1(:,2) = B.data(1:end,DesiredData3);
    MachNumberSet1(:,2) = B.data(1:end,DesiredData4);
    StagnationPressureSet1(:,2) = B.data(1:end,DesiredData5);
end
   
if NumberOfRakeLines == 3
    C = importdata(File3);
    PitotPressureSet1(:,3) = C.data(1:end,DesiredData1);
    TemperatureSet1(:,3) = C.data(1:end,DesiredData2);
    StaticPressureSet1(:,3) = C.data(1:end,DesiredData3);
    MachNumberSet1(:,3) = C.data(1:end,DesiredData4);
    StagnationPressureSet1(:,3) = C.data(1:end,DesiredData5);
end
disp('First Simulation Data Extraction Complete!');
   
disp('Normalizing Pressure Data From The First Simulation...');
if Pitotnorm == 0
    PitotPressureSet1 = PitotPressureSet1./PitotPressureSet1(1,1);
else
    PitotPressureSet1 = PitotPressureSet1./Pitotnorm;
end

if Tnorm == 0
    TemperatureSet1 = TemperatureSet1./TemperatureSet1(1,1);
else
    TemperatureSet1 = TemperatureSet1./Tnorm;
end

if StaticPnorm == 0
    StaticPressureSet1 = StaticPressureSet1./StaticPressureSet1(1,1);
else
    StaticPressureSet1 = StaticPressureSet1./StaticPnorm;
end

if Mnorm == 0 
    MachNumberSet1 = MachNumberSet1./MachNumberSet1(1,1);
else
    MachNumberSet1 = MachNumberSet1./Mnorm;
end

if Totalpnorm == 0
   StagnationPressureSet1 = StagnationPressureSet1./StagnationPressureSet1(1,1);
else
    StagnationPressureSet1 = StagnationPressureSet1./StaticPnorm;
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
    PitotPressureSet2(:,:) = D.data(1:end,DesiredData1);
    TemperatureSet2(:,:) = D.data(1:end,DesiredData2);
    StaticPressureSet2(:,:) = D.data(1:end,DesiredData3);
    MachNumberSet2(:,:) = D.data(1:end,DesiredData4);
    StagnationPressureSet2(:,:) = D.data(1:end,DesiredData5);
    
    if NumberOfRakeLines >= 2
        E = importdata(File5);
        PitotPressureSet2(:,2) = E.data(1:end,DesiredData1);
        TemperatureSet2(:,2) = E.data(1:end,DesiredData2);
        StaticPressureSet2(:,2) = E.data(1:end,DesiredData3);
        MachNumberSet2(:,2) = E.data(1:end,DesiredData4);
        StagnationPressureSet2(:,2) = E.data(1:end,DesiredData5);
    end

    if NumberOfRakeLines == 3
        F = importdata(File6);
        PitotPressureSet2(:,3) = F.data(1:end,DesiredData1);
        TemperatureSet2(:,3) = F.data(1:end,DesiredData2);
        StaticPressureSet2(:,3) = F.data(1:end,DesiredData3);
        MachNumberSet2(:,3) = F.data(1:end,DesiredData4);
        StagnationPressureSet2(:,3) = F.data(1:end,DesiredData5);
    end
    disp('Second Simulation Data Extraction Complete!');
    
disp('Normalizing Pressure Data From The Second Simulation...');
    if Pitotnorm == 0
        PitotPressureSet2 = PitotPressureSet2./PitotPressureSet1(1,1);
    else
        PitotPressureSet2 = PitotPressureSet2./Pitotnorm;
    end

    if Tnorm == 0
        TemperatureSet2 = TemperatureSet2./TemperatureSet1(1,1);
    else
        TemperatureSet2 = TemperatureSet2./Tnorm;
    end

    if StaticPnorm == 0
        StaticPressureSet2 = StaticPressureSet2./StaticPressureSet1(1,1);
    else
        StaticPressureSet2 = StaticPressureSet2./StaticPnorm;
    end
    
    if Mnorm == 0 
        MachNumberSet2 = MachNumberSet2./MachNumberSet1(1,1);
    else
        MachNumberSet2 = MachNumberSet2./Mnorm;
    end
    
    if Totalpnorm == 0
       StagnationPressureSet2 = StagnationPressureSet2./StagnationPressureSet1(1,1);
    else
        StagnationPressureSet2 = StagnationPressureSet2./StaticPnorm;
    end
disp('Data Normalization of Second Simulation Complete!');
end
%% Pitot Pressure Plotting
disp('Plotting...');
f1 = figure;
%Plotting the Centerline Pressure Values
if NumberOfRakeLines == 2
    subplot(2,1,2)
end
if NumberOfRakeLines == 3
    subplot(3,1,3)
end
hold on
plot(XOverD1(:,1),PitotPressureSet1(:,1));
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),PitotPressureSet2(:,1));
end
hold off
title('Centerline Pitot Pressure Ratio Vs X/D')
axis([pitotpresxlimmin pitotpresxlimmax pitotpresylimmin pitotpresylimmax])
xlabel('X/De')
ylabel('Pitot Pressure/Pinf')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.2D Pressure Values
if NumberOfRakeLines >= 2
    subplot(3,1,2)
    hold on
    plot(XOverD1(:,1),PitotPressureSet1(:,2));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),PitotPressureSet2(:,2));
    end
    hold off
    title('Y = 0.2D Pitot Pressure RatioVs X/D')
    axis([pitotpresxlimmin pitotpresxlimmax pitotpresylimmin pitotpresylimmax])
    xlabel('X/De')
    ylabel('Pitot Pressure/Pinf')
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Plotting the Y = 0.4D Pressure Values
if NumberOfRakeLines >=3
    subplot(3,1,1)
    hold on
    plot(XOverD1(:,1),PitotPressureSet1(:,3));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),PitotPressureSet2(:,3));
    end
    hold off
    title('Y = 0.4D Pitot Pressure Ratio Vs X/D')
    axis([pitotpresxlimmin pitotpresxlimmax pitotpresylimmin pitotpresylimmax])
    xlabel('X/De')
    ylabel('Pitot Pressure/Pinf')
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Saving Pitot Pressure chart
saveas(f1,'../output/PitotPressure.png');

%% Total Temperature Plotting

%Plotting the Centerline Temperature Values
f2 = figure;
if NumberOfRakeLines == 2
    subplot(2,1,2)
end
if NumberOfRakeLines == 3
    subplot(3,1,3)
end
hold on
plot(XOverD1(:,1),TemperatureSet1(:,1));
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),TemperatureSet2(:,1));
end
hold off
title('Centerline Total Temperature Ratio Vs X/D')
axis([tempxlimmin tempxlimmax tempylimmin tempylimmax])
xlabel('X/De')
ylabel('Tt/Inlet Tt')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.2D Temperature Values
if NumberOfRakeLines >= 2
    subplot(3,1,2)
    hold on
    plot(XOverD1(:,1),TemperatureSet1(:,2));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),TemperatureSet2(:,2));
    end
    hold off
    title('Y = 0.2D Total Temperature Ratio Vs X/D')
    axis([tempxlimmin tempxlimmax tempylimmin tempylimmax])
    xlabel('X/De')
    ylabel('Tt/Inlet Tt')
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Plotting the Y = 0.4D Temperature Values
if NumberOfRakeLines >= 3
    subplot(3,1,1)
    hold on
    plot(XOverD1(:,1),TemperatureSet1(:,3));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),TemperatureSet2(:,3));
    end
    hold off
    title('Y = 0.4D Total Temperature Ratio Vs X/D')
    xlabel('X/De')
    ylabel('Tt/Inlet Tt')
    axis([tempxlimmin tempxlimmax tempylimmin tempylimmax])
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Saving Total Temperature chart
saveas(f2,'../output/TotalTemperature.png');

%% Static Pressure Plotting
f3 = figure; 
if NumberOfRakeLines == 2
    subplot(2,1,2)
end
if NumberOfRakeLines == 3
    subplot(3,1,3)
end
hold on
plot(XOverD1(:,1),StaticPressureSet1(:,1));
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),StaticPressureSet2(:,1));
end
hold off
title('Centerline Static Pressure Ratio Vs X/D')
axis([staticpresxlimmin staticpresxlimmax staticpresylimmin staticpresylimmax])
xlabel('X/De')
ylabel('P/Pamb')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.2D Static Pressure Values
if NumberOfRakeLines >= 2
    subplot(3,1,2)
    hold on
    plot(XOverD1(:,1),StaticPressureSet1(:,2));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),StaticPressureSet2(:,2));
    end
    hold off
    title('Y = 0.2D Static Pressure Ratio Vs X/D')
    axis([staticpresxlimmin staticpresxlimmax staticpresylimmin staticpresylimmax])
    xlabel('X/De')
    ylabel('P/Pamb')
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Plotting the Y = 0.4D Static Pressure Values
if NumberOfRakeLines >= 3
    subplot(3,1,1)
    hold on
    plot(XOverD1(:,1),StaticPressureSet1(:,3));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),StaticPressureSet2(:,3));
    end
    hold off
    title('Y = 0.4D Static Pressure Ratio Vs X/D')
    xlabel('X/De')
    ylabel('P/Pamb')
    axis([staticpresxlimmin staticpresxlimmax staticpresylimmin staticpresylimmax])
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Saving Static Pressure chart
saveas(f3,'../output/StaticPressure.png');

%% Mach Number Plotting
%Plotting the Centerline Mach Values
f4 = figure;
if NumberOfRakeLines == 2
    subplot(2,1,2)
end
if NumberOfRakeLines == 3
    subplot(3,1,3)
end
hold on
plot(XOverD1(:,1),MachNumberSet1(:,1));
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),MachNumberSet2(:,1));
end
hold off
title('Centerline Mach Number Vs X/D')
axis([machxlimmin machxlimmax machylimmin machylimmax])
xlabel('X/De')
ylabel('Mach Number')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.2D Mach Values
if NumberOfRakeLines >= 2
    subplot(3,1,2)
    hold on
    plot(XOverD1(:,1),MachNumberSet1(:,2));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),MachNumberSet2(:,2));
    end
    hold off
    title('Y = 0.2D Mach Number Vs X/D')
    axis([machxlimmin machxlimmax machylimmin machylimmax])
    xlabel('X/De')
    ylabel('Mach Number')
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Plotting the Y = 0.4D Mach Values
if NumberOfRakeLines >=3
    subplot(3,1,1)
    hold on
    plot(XOverD1(:,1),MachNumberSet1(:,3));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),MachNumberSet2(:,3));
    end
    hold off
    title('Y = 0.4D Mach Number Vs X/D')
    axis([machxlimmin machxlimmax machylimmin machylimmax])
    xlabel('X/De')
    ylabel('Mach Number')
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Saving Mach chart
saveas(f4,'../output/Mach.png');

%% Total Pressure Plotting
%Plotting the Centerline Mach Values
f5 = figure;
if NumberOfRakeLines == 2
    subplot(2,1,2)
end
if NumberOfRakeLines == 3
    subplot(3,1,3)
end
hold on
plot(XOverD1(:,1),StagnationPressureSet1(:,1));
if IsSecondSimulation == 1 
    plot(XOverD2(:,1),StagnationPressureSet2(:,1));
end
hold off
title('Centerline Total Pressure Vs X/D')
axis([totpxlimmin totpxlimmax totpylimmin totpylimmax])
xlabel('X/De')
ylabel('Total Pressure')
grid on
grid minor
legend(SimulationTitle1,SimulationTitle2,'Location','best')

%Plotting the Y = 0.2D Mach Values
if NumberOfRakeLines >= 2
    subplot(3,1,2)
    hold on
    plot(XOverD1(:,1),StagnationPressureSet1(:,2));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),StagnationPressureSet2(:,2));
    end
    hold off
    title('Y = 0.2D Total Pressure Vs X/D')
    axis([totpxlimmin totpxlimmax totpylimmin totpylimmax])
    xlabel('X/De')
    ylabel('Total Pressure')
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Plotting the Y = 0.4D Mach Values
if NumberOfRakeLines >=3
    subplot(3,1,1)
    hold on
    plot(XOverD1(:,1),StagnationPressureSet1(:,3));
    if IsSecondSimulation == 1 
        plot(XOverD2(:,1),StagnationPressureSet2(:,3));
    end
    hold off
    title('Y = 0.4D Total Pressure Vs X/D')
    axis([totpxlimmin totpxlimmax totpylimmin totpylimmax])
    xlabel('X/De')
    ylabel('Total Pressure')
    grid on
    grid minor
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
end

%Saving Total Pressure chart
saveas(f5,'../output/TotalPressure.png');