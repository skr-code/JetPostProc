%% ------- Extract pressure history for monitor points -------------------------
% Notes:
% 1. This script should be executed before plot_PSD.m
% 2. User should change the start_time, end_time, sol_dir, output_name
% 3. This script will generate the pressure history in physical time space
% 4. Will dump results in the extract_physical_data folder
% 5. Specify what data (by column) we want to output in the WriteDataPressureFile
%-------------------------------------------------------------------------------
clear all;clc;close all;
% extract all monitoring points 0 -> 5
%% input
n_pts = 1; % do not change this

index = {2}; %Monitor point number that you would like to be read in 
names = {'pt2'}; %Monitor point number that you would like to be outputted
nameMap = containers.Map(index, names);

for index_pt = 2;   %Monitor point number that you would like to be read in
    
    start_time = 0; %the start time
    end_time = 30;  % the end time
    sol_dir = strcat('./monitor_data/monitor_points_',num2str(index_pt),'.dat');
    output_name = strcat('./extract_physical_data/cpr-p2-p-', nameMap(index_pt),'.dat');
    interval = 1;

    %% Read in data
    data = cell(1,n_pts);
    for pt_id = 1:n_pts
        cprintf('black', ['Reading in the point ',num2str(index_pt),' ...']);
        data{pt_id} = dlmread(sol_dir,'',3,0);
        cprintf('green',[' success! \n']);
    end
    
    cprintf('*black',['All the data are already read in. \n']);
    
    %% format the data
    for pt_id = 1:n_pts
        data_mat = data{pt_id};
        start_row = 1;
        end_row   = 1;
        [row,col] = size(data_mat);
        for i = row:-1:1
            phy_time = data_mat(i,1);
            if phy_time >= end_time || i == row
                end_row = i;
            elseif phy_time <= start_time
                start_row = i;
                break;
            else
                continue;
            end
        end
        % throw the last time data
        data{pt_id} = data_mat(start_row+1:end_row-1, :);
    end
    
    %% delete the duplicated rows and make mono
    data = MonoData(data, n_pts);
    
    %% Check data cell
    
    % Check_data(data, n_pts, true);
    Check_data(data, n_pts);
    % Check_data(data, n_pts);
    
    %% save the entire raw data
    data_raw = data;
    for pt_id = 1:n_pts
        data_raw{pt_id} = data_raw{pt_id}(1:end-1,:);
    end
    %% extract the interval
    for pt_id = 1:n_pts
        data{pt_id} = data{pt_id}(1:interval:end,:);
        data{pt_id} = data{pt_id}(1:end-1,:);
    end
    
    Check_data(data, n_pts);
    Check_data(data_raw,n_pts);
    
    %% Write out the data
    Write_data_pressure(output_name, index_pt, data{1});
    
end


