clear
clc; close all


path_folder = 'G:\Shared drives\EE6211_2024\Data\FCC_(5)_OCV_C20';
filename = 'HNE_FCC_06_OCV_027.txt';

data_now = readtable([path_folder filesep filename],'FileType','text','NumHeaderLines',14, ...
    'readVariableNames',0); % load the data

    data1.I = data_now.Var7;
    data1.V= data_now.Var8;
    data1.t2 = data_now.Var2; % experiment time, format in duration
    data1.t1 = data_now.Var4; % step time, format in duration
    data1.cycle = data_now.Var3; 
    data1.step = data_now.Var5;
    data1.T = data_now.Var13;


figure(1)
yyaxis left
plot(data1.t2, data1.V); hold on
yyaxis right
plot(data1.t2, data1.step)

%% TAKE OCV STEP (CHG)
ocv_chg_data(:,1) = seconds(data1.t2(data1.step ==4));
ocv_chg_data(:,2) = data1.I(data1.step ==4);
ocv_chg_data(:,3) = data1.V(data1.step ==4);

figure(2)
plot(ocv_chg_data(:,1),ocv_chg_data(:,3))


%% SOC CALCULTAION

ocv_chg_data(:,4) = cumtrapz(ocv_chg_data(:,1),ocv_chg_data(:,2)); % [A*sec]
ocv_chg_data(:,5) = ocv_chg_data(:,4)/(ocv_chg_data(end,4));

figure(3)
plot(ocv_chg_data(:,5),ocv_chg_data(:,3))


%% SAVE OCV

OCV = [ocv_chg_data(:,5), ocv_chg_data(:,3)]; %[SOC [1], OCV [V]]

save OCV_inclass_C20.mat OCV