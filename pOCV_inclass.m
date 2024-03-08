clear
clc; close all

%% Load DATA
path_folder = 'G:\Shared drives\EE6211_2024\Data\OCV_and_OCP\FCC_(5)_OCV_C100';
filename = 'HNE_FCC_01_OCV_022.txt';
savefilename = 'OCV_inclass.mat';

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
%yyaxis right
%plot(data1.t2, data1.step)

figure(2)
plot(data1.t2,data1.I)


%% TAKE OCV STEP (CHG) %% PARSING
ocv_chg_data(:,1) = seconds(data1.t2(data1.I>0));
ocv_chg_data(:,2) = data1.I(data1.I>0);
ocv_chg_data(:,3) = data1.V(data1.I>0);

ocv_dch_data(:,1) = seconds(data1.t2(data1.step == 6));
ocv_dch_data(:,2) = data1.I(data1.step == 6);
ocv_dch_data(:,3) = data1.V(data1.step == 6);

figure(2)
plot(ocv_chg_data(:,1),ocv_chg_data(:,3)); hold on
plot(ocv_dch_data(:,1),ocv_dch_data(:,3))

%% SOC CALCULTAION

ocv_chg_data(:,4) = cumtrapz(ocv_chg_data(:,1),ocv_chg_data(:,2)); % Q [A*sec]
ocv_chg_data(:,5) = ocv_chg_data(:,4)/(ocv_chg_data(end,4)); % SOC

ocv_dch_data(:,4) = cumtrapz(ocv_dch_data(:,1),ocv_dch_data(:,2)); % Q[A*sec]
ocv_dch_data(:,5) = 1-ocv_dch_data(:,4)/(ocv_dch_data(end,4));% SOC

figure(3)
plot(ocv_chg_data(:,5),ocv_chg_data(:,3))
hold on
plot(ocv_dch_data(:,5),ocv_dch_data(:,3))
legend('chg','dch')



%% SAVE OCV

OCV.chg = [ocv_chg_data(:,5), ocv_chg_data(:,3)]; %[SOC [1], OCV [V]]
OCV.dch = [ocv_dch_data(:,5), ocv_dch_data(:,3)];

save(savefilename,'OCV') 