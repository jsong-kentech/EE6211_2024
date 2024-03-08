clear; clc; close all 
%% Configration

folder = 'G:\Shared drives\EE6211_2024\Data\rOCV';
filename ='NE_SOC-OCV_0.05C_Raw data.csv';




%% Load data
data_now = readtable([folder filesep filename]);

t_vec = data_now.TotTime_sec_;
V_vec = data_now.Voltage_V_;
I_vec = data_now.Current_A_;

figure(1)
yyaxis left
plot(t_vec,V_vec)
yyaxis right
plot(t_vec,I_vec)


