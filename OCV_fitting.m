
clear; clc; close all

folder = 'G:\Shared drives\EE6211_2024\Data\pOCV_and_pOCP';
filename_ocpn = 'AHC_(5)_OCV_C20.mat';
filename_ocpp = 'CHC_(5)_OCV_C20.mat';
filename_ocv = 'FCC_(5)_OCV_C20.mat';



ocpn = load([folder filesep filename_ocpn]);
ocpp = load([folder filesep filename_ocpp]);

ocpn = ocpn.OCV_golden.OCVdis;
ocpp = ocpp.OCV_golden.OCVchg;

ocv = load([folder filesep filename_ocv]);
ocv = ocv.OCV_golden.OCVchg;

figure(1)
subplot(3,1,1)
plot(ocpp(:,1),ocpp(:,2));
subplot(3,1,2)
plot(ocpn(:,1),ocpn(:,2))
subplot(3,1,3)
plot(ocv(:,1),ocv(:,2))


%% From last class

para_now =[0.02, 0.925, 0.9867, 0.2060];

SOC = 0:0.01:1;

% explicit calculation is replaced by a function
ocv_soc01 = func_ocv_model(SOC,para_now,ocpp,ocpn);

figure()
plot(SOC, ocv_soc01,'k'); hold on
plot(ocv(:,1),ocv(:,2))
legend({'model','data'})



%% Today: fitting


% initial guess, lower/upper bounds
para_0 = para_now;
para_lb = zeros(size(para_0));
para_ub = ones(size(para_0));


% cost function handle and options
para_hat = para_0;

for n = 1:100
options = optimoptions(@fmincon,'Display','iter','MaxIterations',1);

fhandle_cost = @(para)func_cost(ocv(:,1),para,ocpp,ocpn,ocv(:,2));

para_hat = fmincon(fhandle_cost,para_hat,[],[],[],[],para_lb,para_ub,[],options);



% explicit calculation is replaced by a function
ocv_hat = func_ocv_model(SOC,para_hat,ocpp,ocpn);

figure(5)
plot(SOC, ocv_soc01); hold on
plot(SOC, ocv_hat); hold on
plot(ocv(1:100:end,1),ocv(1:100:end,2),'o')
legend({'initial gues','model fit','data'})
pause(0.1)
hold off

set(gcf,'position',[100 100 600 600])

end




%% Function

function cost = func_cost(soc,para,ocpp,ocpn,ocv_data)

ocv_model = func_ocv_model(soc,para,ocpp,ocpn);

cost = sum((ocv_data - ocv_model).^2);

end



function ocv_model = func_ocv_model(soc,para,ocpp,ocpn)

x0 =para(1);
x1 = para(2);
y0 = para(3);
y1= para(4);

x_soc01 = x0 + (x1-x0)*soc;
y_soc01 = y0 + (y1-y0)*soc;

ocpp_soc01 = interp1(ocpp(:,1),ocpp(:,2),y_soc01,'linear','extrap');
ocpn_soc01 = interp1(ocpn(:,1),ocpn(:,2),x_soc01,'linear','extrap');

ocv_model = ocpp_soc01 - ocpn_soc01;


end







