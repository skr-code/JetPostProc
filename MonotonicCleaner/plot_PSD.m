%% ------- Plot Power Spectral Denstiy for monitor points -------------------------
% Notes:
% 1. This script should be executed after extract_monitor_pts.m
% 2. The psd_L_set should be played with. It is better to be 2^n form
% 3. export_tag = 1 will export the figures in both .eps and .jpg formats
%-------------------------------------------------------------------------------
clear all;clc;close all;

%% input panel
psd_L_set = 16384;

save_name = 'example';
kollaw = 0;
% [1] p2-rk3
scheme_index = [1];

cat_list  = [1 2];

catSet = {'pt0','pt1','pt2','pt3','pt4','pt5'};

export_tag = 0;

indexMapByCat = {[1],...  % pt0
                 [2],...  % pt1
                 [3],...  % pt2
                 [4],...  % pt3
                 [5],...  % pt4
                 [6],...  % pt5
};
indexMap = containers.Map(catSet, indexMapByCat);

% cat_list  = [1 ];
% index_list = [1];
style = {'-k','--r','--b','-.m','--g','--r','-.b','--vc','-+g','-.c','--m','--k','-.b'};

% draw_slope_index = [8 9 15 16 22 23 29 30 36 37 43 44 50 51 57 58 64 65 78 79];
% use a map to determine the plot style6
SchemeSet   = [1,2,3,4,5,6];
StyleSet    = [1,2,3,4,5,6];
styleMap = containers.Map(SchemeSet, StyleSet);

figure(1)
file_head = {
    './extract_physical_data/cpr-p2-p-pt0.dat',... % 1
    './extract_physical_data/cpr-p2-p-pt1.dat',...  % 2
    './extract_physical_data/cpr-p2-p-pt2.dat',...   % 3
    './extract_physical_data/cpr-p2-p-pt3.dat',...   % 4
    './extract_physical_data/cpr-p2-p-pt4.dat',...   % 5
    './extract_physical_data/cpr-p2-p-pt5.dat',...   % 6
    };

legends = { 'RK3, dt=1e-8',...            % 1
            'RK3, dt=1e-8',...                    % 2
            'RK3, dt=1e-8',...                    % 3
            'RK3, dt=1e-8',...                    % 4
            'RK3, dt=1e-8',...                    % 5
            'RK3, dt=1e-8',...                    % 6
            };

%% start to plot
for cat = cat_list   % category 1:6
    
    category = catSet{cat};
    
    index_list = indexMap(category);
    
    index_list = index_list(scheme_index);
    
    size_list = length(index_list);
    
    n_data = size_list;
    
    phy_paths = cell(n_data,1);
    psd_paths = cell(n_data,1);
    
    for i = 1:n_data
        
        file_name = file_head{index_list(i)};

         psd_L = psd_L_set;
        
        data = dlmread(file_name,'',2);
        
        time     = data(:,1);
        pressure = data(:,2);
        
        loc = strfind(file_name, '/');
        rawname = file_name(loc(2)+1:end);
        loc2 = strfind(rawname, '.');
        name_noext = rawname(1:loc2-1);
        phy_name = strcat(name_noext,'.dat');
        
        phy_full_path = strcat('./extract_physical_data/',phy_name);
        phy_paths{i} = phy_full_path;
        
        phy_mat = [time, pressure];
        dlmwrite(phy_full_path, phy_mat,'delimiter',' ');
        
        loc = strfind(phy_name, '.dat');
        
        psd_full_path = strcat('./computed_spectral_data/',phy_name(1:loc-1),'_L',num2str(psd_L),'_psd.dat');
        psd_paths{i} = psd_full_path;
        
        psd_command = strcat('./dftavg -i',{' '}, phy_full_path,...
            ' -l ',{' '},num2str(psd_L),' -p ',{' '} ,psd_full_path);
        
        system(psd_command{1});
        
    end
    
    figure(cat*10);
    for i = 1:n_data
        index = index_list(i);
        
        phy_data = dlmread(phy_paths{i});
        time = phy_data(:,1);
        pressure = phy_data(:,2);
        
        h(i) = plot(time, pressure,style{scheme_index(i)},'linewidth',2); hold on;
        
    end
    xlabel('Physical time','fontsize',22,'FontWeight','bold');
    
    if ~isempty(strfind(phy_paths{i}, '-p-'))
        Y_label = 'Gage Pressure';
    else
        Y_label = 'Heat Flux';
    end
    
    ylabel(Y_label,'fontsize',22,'FontWeight','bold');
    title(category);
    legend(h(:), legends(index_list),'Location','best');
    set(gca,'FontSize',14);
    ax = gca;
    ax.LabelFontSizeMultiplier = 0.85; % modify the font size for strouhal number
    %     set(gca,'YTick',[-2 -1 0 1 2 3]*10^4);
    if export_tag == 1
        nametitle = strcat('Phy-',save_name,'-', category);
        print(nametitle,'-depsc2','-r300');
        command = strcat('gs -o -q -sDEVICE=png256 -dEPSCrop -r300 -o',nametitle,'_eps.png',{' '}, nametitle, '.eps');
        system(command{1});
    end
    
    
    
    % in frequency space
    
    figure(cat*10+1);
    for i = 1:n_data
        index = index_list(i);
        psd_data = dlmread(psd_paths{i});
        freq = psd_data(:,1);
        psd  = psd_data(:,2);
        
        h_freq(i) = loglog(freq, psd, style{scheme_index(i)},'linewidth',2); hold on;
       
    end
    
    % add the slope line for tewake and near wake points
    
%     if kollaw == 1 && (strcmp(category,'nss3')==1 || strcmp(category,'other')==1)
%         left_point_x = 0.4;
%         left_point_y = 20;
%         right_point_x = 2;
%         x = [left_point_x,right_point_x];
%         y = left_point_y/(left_point_x^(-5/3))*x.^(-5/3);
%         right_point_y = y(end);
%         loglog(x, y, '--k','linewidth',2); hold on;
%         txt2 = '$$-{\frac{5}{3}}$$';
%         text(1, 10, txt2, 'Interpreter','latex','FontWeight','bold'...
%             ,'VerticalAlignment','bottom','HorizontalAlignment','center');
%     end
    
    xlabel('Frequency','fontsize',18,'FontWeight','bold');
    ylabel('Power Spectral Density','fontsize',22,'FontWeight','bold');
    title(category);
    legend(h_freq(:), legends(index_list),'Location','best');
    set(gca,'FontSize',14);
    ax = gca;
    ax.LabelFontSizeMultiplier = 0.85; % modify the font size for strouhal number
    ax.TitleFontSizeMultiplier = 0.85;
%     axis([3e-2 10 1e-6 1e5]);
%     set(gca,'YTick',[1e-6 1e-4 1e-2 1 1e2 1e4]);
    
    if export_tag == 1
        nametitle = strcat('PSD-',save_name,'-', category);
        print(nametitle,'-depsc2','-r300');
        command = strcat('gs -o -q -sDEVICE=png256 -dEPSCrop -r300 -o',nametitle,'_eps.png',{' '}, nametitle, '.eps');
        system(command{1});
    end
end