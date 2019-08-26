%Cleaning
clear
clc
clf

%Setting the format
format long

%User input------------------

%Name of simulation that first set of files is coming from
SimulationTitle1 = 'ICDB-M2-P1';

%Name of the simulation that the second set of files is coming from
IsSecondSimulation = 1;     %put to 1 to activate
SimulationTitle2 = 'ICDB-M2-P2';

%Strouhal Information
WantStrouhal = 1;
De = 0.0728472;
Uj = 425.8;

%Desired data reference to be plotted
Plot90 = 1;
Plot150 = 1;

%Waterfall Plot Setting
waterfall = 1;
offset = -40;
%Monitor point number that corresponds to Liu's 90deg
firstreferencedatamonpoint = 11;
%Monitor point number that corresponds to Liu's 150deg
secondreferencedatamonpoint = 15;
%Last Desired Simulation Monitoring Point Number
lastpointnum = 15;
%First Desired Simulation Monitoring Point Number
firstpointnum = 8;

%NonwaterfallSettings
%Desired monitor poiint to be plotted from simulation data
desiredmonitorpoint = 15;

%Plot Setting
%Overall Strouhal Range [0.1 10]
%Audible Strouhal Range [0.1710831 3.4216627]
%Overall Frequency Range [100 100000]
%Audible Frequency Range [1000 20000]

%Range For Point 1
xlimmin = 10^(-2);
xlimmax = 10^1;
ylimmin = -250;
ylimmax = 125;

%------------------------------
%% Importing the Reference Data
if Plot90 == 1 || Plot150 == 1
    disp('Extracting The Reference Data...');
    Y = importdata('../ReferenceData/Liu2017_SPL_phy90_47D_noslipwall.dat');
    Z = importdata('../ReferenceData/Liu2017_SPL_phy150_47D_noslipwall.dat');

    Liu2017_SPL_phy90_47D_noslipwall(:,1) = Y(1:end,1);
    Liu2017_SPL_phy90_47D_noslipwall(:,2) = Y(1:end,2);

    Liu2017_SPL_phy150_47D_noslipwall(:,1) = Z(1:end,1);
    Liu2017_SPL_phy150_47D_noslipwall(:,2) = Z(1:end,2);
    
    Y = importdata('../ReferenceData/Liu2017_SPL_phy90_47D.dat');
    Z = importdata('../ReferenceData/Liu2017_SPL_phy150_47D.dat');
    
    Liu2017_SPL_phy90_47D(:,1) = Y(1:end,1);
    Liu2017_SPL_phy90_47D(:,2) = Y(1:end,2);
    
    Liu2017_SPL_phy150_47D(:,1) = Z(1:end,1);
    Liu2017_SPL_phy150_47D(:,2) = Z(1:end,2);

    disp('Reference Data Extracted!');
end

%% Grabbing Data from First File
%Looping through all of the data files to extract the pressure data
disp('Extracting the Data From the First Simulation...');
currentcol = 1;
scalecount = 0;

%Scaling while importing if the waterfall plot is desired
if waterfall == 1 
    for currentpoint = firstpointnum:lastpointnum
        FileSet1 = strcat('../input1/fwh_spl_ob',num2str(currentpoint),'.dat');
        A = importdata(FileSet1);
        %importing the frequencies
        FWHSPLData1(:,currentcol) = A.data(1:end,1);
        %If there is a second simulation, grab its frequencies as well and
        %put it in a different data set
        if IsSecondSimulation == 1
            FileSet2 = strcat('../input2/fwh_spl_ob',num2str(currentpoint),'.dat');
            B = importdata(FileSet2);
            FWHSPLData2(:,currentcol) = B.data(1:end,1);
        end
        %Jump to the next column in the data set and grab the SPL
        currentcol = currentcol+1;
        FWHSPLData1(:,currentcol) = A.data(1:end,2);
        %If there is a second simulation, grab its SPL as well 
        if IsSecondSimulation == 1
            FWHSPLData2(:,currentcol) = B.data(1:end,2);
        end
        %If we are at a SPL column, scale it by the scale factor 
        if mod(currentcol,2) == 0
            FWHSPLData1(:,currentcol) = A.data(1:end,2)+(scalecount*offset);
            %If there is a second simulation, scale it's SPL as well
            if IsSecondSimulation == 1
                FWHSPLData2(:,currentcol) = B.data(1:end,2)+(scalecount*offset);
            end
            scalecount = scalecount + 1;
        end
        %Once we hit monitoring point data that corresponds to a reference
        %data point, scale the reference data so they match
        if currentpoint == firstreferencedatamonpoint && Plot90 == 1
            Liu2017_SPL_phy90_47D_noslipwall(:,2) = Liu2017_SPL_phy90_47D_noslipwall(:,2)+((scalecount-1)*offset);
            Liu2017_SPL_phy90_47D(:,2) = Liu2017_SPL_phy90_47D(:,2)+((scalecount-1)*offset);
        end
        if currentpoint == secondreferencedatamonpoint && Plot150 == 1
            Liu2017_SPL_phy150_47D_noslipwall(:,2) = Liu2017_SPL_phy150_47D_noslipwall(:,2)+((scalecount-1)*offset);
            Liu2017_SPL_phy150_47D(:,2) = Liu2017_SPL_phy150_47D(:,2)+((scalecount-1)*offset);
        end
        currentcol = currentcol+1;
    end
else
    %If waterfall is not turned on then grab only the desired monitor point
    FileSet1 = strcat('../input1/fwh_spl_ob',num2str(desiredmonitorpoint),'.dat');
    A = importdata(FileSet1);
    FWHSPLData1(:,currentcol) = A.data(1:end,1);
    if IsSecondSimulation == 1
        FileSet2 = strcat('../input2/fwh_spl_ob',num2str(desiredmonitorpoint),'.dat');
        B = importdata(FileSet2);
        FWHSPLData2(:,currentcol) = B.data(1:end,1);
    end
    currentcol = currentcol+1;
    FWHSPLData1(:,currentcol) = A.data(1:end,2);
    if IsSecondSimulation == 1
        FileSet2 = strcat('../input2/fwh_spl_ob',num2str(desiredmonitorpoint),'.dat');
        B = importdata(FileSet2);
        FWHSPLData2(:,currentcol) = B.data(1:end,2);
    end
end
DataSize = size(FWHSPLData1);
    disp('Data Extraction From First Simulation Complete!');

if WantStrouhal == 1;
    %Normalizing By Strouhal
    disp('Performing Strouhal Normalization...');
    for currentcol = 1:DataSize(1,2)
        %If we hit a column which has frequency values, scale it down to
        %strouhal
        if mod(currentcol,2) == 1
            FWHSPLData1(:,currentcol) = FWHSPLData1(:,currentcol).*(De/Uj);
            %scaling for the second simulation if there is any
            if IsSecondSimulation == 1
                FWHSPLData2(:,currentcol) = FWHSPLData2(:,currentcol).*(De/Uj);
            end
        end
    end
else
    %If we are using reference data but do not want strouhal, we have to
    %scale it up to frequencies
    if Plot90 == 1 || Plot150 == 1
        Liu2017_SPL_phy90_47D_noslipwall(:,1) = Liu2017_SPL_phy90_47D_noslipwall(:,1).*(Uj/De);
        Liu2017_SPL_phy150_47D_noslipwall(:,1) = Liu2017_SPL_phy150_47D_noslipwall(:,1).*(Uj/De);
    end
    disp('Strouhal Normalization Complete!');
end

%% Plotting
disp('Plotting...');

%Plotting the first point
hold on
if waterfall == 1
    if Plot90 == 1 || Plot150 == 1
        %Plotting the references
        if Plot90 == 1
            plot(Liu2017_SPL_phy90_47D_noslipwall(:,1),Liu2017_SPL_phy90_47D_noslipwall(:,2),'--k');
            plot(Liu2017_SPL_phy90_47D(:,1),Liu2017_SPL_phy90_47D(:,2),'--g');
        end
        if Plot150 == 1
            plot(Liu2017_SPL_phy150_47D_noslipwall(:,1),Liu2017_SPL_phy150_47D_noslipwall(:,2),'--k');
            plot(Liu2017_SPL_phy150_47D(:,1),Liu2017_SPL_phy150_47D(:,2),'--g');
        end
    end
    %Looping through to plot all of the data lines
    for currentcol = 1:2:DataSize(1,2)
        plot(FWHSPLData1(:,currentcol),FWHSPLData1(:,currentcol+1),'-b');
        if IsSecondSimulation == 1
            plot(FWHSPLData2(:,currentcol),FWHSPLData2(:,currentcol+1),'-r');
        end
    end
else
    %Plotting the references
    if Plot90 == 1
        plot(Liu2017_SPL_phy90_47D_noslipwall(:,1),Liu2017_SPL_phy90_47D_noslipwall(:,2),'--k');
        plot(Liu2017_SPL_phy90_47D(:,1),Liu2017_SPL_phy90_47D(:,2),'--g');
    end
    if Plot150 == 1
        plot(Liu2017_SPL_phy150_47D_noslipwall(:,1),Liu2017_SPL_phy150_47D_noslipwall(:,2),'--k');
        plot(Liu2017_SPL_phy150_47D(:,1),Liu2017_SPL_phy150_47D(:,2),'--g');
    end
    %Plotting only the desired simulation data point for the first
    %simulation
    plot(FWHSPLData1(:,1),FWHSPLData1(:,2),'-b');
    %Plotting only the desired simulation data point for the second
    %simulation
    if IsSecondSimulation == 1
        plot(FWHSPLData2(:,1),FWHSPLData2(:,2),'-r');
    end
end
hold off
title('SPL Spectrum Vs Frequency at R = 47De')
set(gca, 'XScale', 'log')
ylabel('SPL (dB)')
xlabel('Frequency (f)')
if WantStrouhal == 1;
    title('SPL Spectrum Vs Strouhal Number (De/Uj) at R = 47De')
    xlabel('Strouhal Number (fDe/Uj)')
end
axis([xlimmin xlimmax ylimmin ylimmax])
grid on
grid minor
if Plot90 == 1 && IsSecondSimulation == 1;
    legend('Liu-LES-90°-NoSlip','Liu-LES-90°-WallFunc',SimulationTitle1,'Location','best')
    if IsSecondSimulation == 1
    legend('Liu-LES-90°-NoSlip','Liu-LES-90°-WallFunc',SimulationTitle1,SimulationTitle2,'Location','best')
    end
end
if Plot150 == 1 && IsSecondSimulation == 1;
    legend('Liu-LES-150°-NoSlip','Liu-LES-150°-WallFunc',SimulationTitle1,'Location','best')
    if IsSecondSimulation == 1
    legend('Liu-LES-150°-NoSlip','Liu-LES-150°-WallFunc',SimulationTitle1,SimulationTitle2,'Location','best')
    end
end
if Plot90 == 1 && Plot150 == 1
    legend('Liu-LES-90°-NoSlip','Liu-LES-90°-WallFunc','Liu-LES-150°-NoSlip','Liu-LES-150°-WallFunc',SimulationTitle1,'Location','best')
    if IsSecondSimulation == 1
    legend('Liu-LES-90°-NoSlip','Liu-LES-90°-WallFunc','Liu-LES-150°-NoSlip','Liu-LES-150°-WallFunc',SimulationTitle1,SimulationTitle2,'Location','best')
    end
end
if Plot90 ~= 1 && Plot150 ~= 1
    legend(SimulationTitle1,'Location','best')
    if IsSecondSimulation == 1
    legend(SimulationTitle1,SimulationTitle2,'Location','best')
    end
end


