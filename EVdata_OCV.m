clear; clc; close all

%% Config

folder = 'G:\Shared drives\EE6211_2024\Data\EV_Drive';


filelist = dir([folder filesep '*.csv']);
L = size(filelist,1);

n_parallel = 2;
n_series = 191.3;



for i = 1:1
    %% LOAD
    
    % update filename
    filename = filelist(i).name;

    % table
    data_now = readtable([folder filesep filename]);
    
    % struct
    data.t = data_now.time; % datetime;
    data.I_pack = data_now.pack_current;
    data.V_pack = data_now.pack_volt;
    data.I_cell = data.I_pack/n_parallel;
    data.V_cell = data.V_pack/n_series;
    data.soc_bms = data_now.soc;
    
    % check by plotting
    figure(1)

    yyaxis left
    plot(data.t,data.V_pack)
    yyaxis right
    plot(data.t,data.I_pack)
    
    legend('Pack V [V]','Pack I [A]')
    
    

    figure(2)
    plot(data.t,data.soc_bms)

    % Calculate OCV by SOC
    ocv_load = load('OCV_inclass_C100.mat');
    ocv_data = ocv_load.OCV;

    data.ocv = interp1(ocv_data(:,1),ocv_data(:,2),data.soc_bms/100);

    figure(3)
    plot(data.t,data.ocv); hold on
    plot(data.t,data.V_cell)

    % Calculate SOC

    %% 추가예정
    

    data.soc_cc(1) = interp1(ocv_data(:,2),ocv_data(:,1),data.V_cell(1));

        for j = 2:length(data.t)

            data.soc_cc(j) =  data.soc_cc(j-1) + data.I_cell(j)*(data.t(j)-data.t(j-1))/3600/(55.6); 

        end

   figure(4)
   plot(data.t,data.soc_bms); hold on
   plot(data.t,data.soc_cc)

end