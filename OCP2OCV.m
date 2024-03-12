
clear; clc; close all


folder = 'G:\Shared drives\EE6211_2024\Data\pOCV_and_pOCP';
filename_ocpn = 'AHC_(5)_OCV_C20.mat';
filename_ocpp = 'CHC_(5)_OCV_C20.mat';


ocpn = load([folder filesep filename_ocpn]);
ocpp = load([folder filesep filename_ocpp]);


ocpn = ocpn.OCV_golden.OCVchg;
ocpp = ocpp.OCV_golden.OCVdis;

figure(1)
plot(ocpn(:,1),ocpn(:,2))
figure(2)
plot(ocpp(:,1),ocpp(:,2))



x0 = 0.02;
x1 = 0.925;
y0 = 0.9867;
y1 = 0.2060;




SOC = 0:0.01:1;

x_soc01 = x0 + (x1-x0)*SOC;
y_soc01 = y0 + (y1-y0)*SOC;

ocpp_soc01 = interp1(ocpp(:,1),ocpp(:,2),y_soc01);
ocpn_soc01 = interp1(ocpn(:,1),ocpn(:,2),x_soc01);

ocv_soc01 = ocpp_soc01 - ocpn_soc01;

figure(3)
yyaxis left
plot(SOC, ocv_soc01,'k'); hold on
plot(SOC, ocpp_soc01,'b')
yyaxis right
plot(SOC, ocpn_soc01,'r'); 







SOC = -0.1:0.01:1.2;

x_vec = x0 + (x1-x0)*SOC;
y_vec = y0 + (y1-y0)*SOC;

ocpp_vec = interp1(ocpp(:,1),ocpp(:,2),y_vec);
ocpn_vec = interp1(ocpn(:,1),ocpn(:,2),x_vec);

ocv_vec = ocpp_vec - ocpn_vec;

figure(4)
yyaxis left
plot(SOC, ocv_vec,'k'); hold on
plot(SOC, ocpp_vec,'b')
yyaxis right
plot(SOC, ocpn_vec,'r'); 
xline(1)
xline(0)