%% Interface
clear; close all; clc;
folder = 'G:\Shared drives\EE6211_2024\Data\EIS_LLZO\txt';

filelist = dir([folder filesep '*.txt']);


output_RC = zeros([length(filelist),3]);
output_RCPE = zeros([length(filelist),4]);

for i = 1:length(filelist)

%% Data

% load
    % syntax: readtable / readmatrix / importdata / ...

    data = readmatrix([folder filesep filelist(i).name]);

% plot
% 
%     z_re = data(:,2);
%     z_im = -data(:,3);
%     f = data(:,1);
% 
%     figure(1)
%     plot(z_re,-z_im,'-o'); hold on
%     axis([0 1000 0 1000])

% trim
    data2 = data(data(:,2)>200,:);
    [min_value,min_idx] = min(data2(:,3));

    n_trim = find(data(:,3)==min_value);

    data_trim = data(1:n_trim,:);

    z_data_re = data_trim(:,2);
    z_data_im = -data_trim(:,3);
    f = data_trim(:,1);
    z_data = z_data_re+1i*z_data_im;

    figure(i)
    plot(z_data_re,-z_data_im,'o'); hold on



%% Model (initial guess)

   % parameters (rough)
   R0 = z_data_re(1);
   R1 = z_data_re(end) - z_data_re(1);

   % get RC time time scale
   [max_value,max_idx] = max(-z_data_im);
   f_RC = f(max_idx);
   t_RC = 1/f_RC; %[sec]
   C = t_RC/R1;

   z_model = func_z_model_RC(f,[R0,R1,C]);



   figure(i)
   plot(real(z_model),-imag(z_model),'-sq')
   

%% Fitting


   % model % done below

   % cost func % done below

   % minimization
    handle_func_cost = @(para)func_cost(f,para,z_data);

    options= optimset('display','iter','MaxIter',400,'MaxFunEvals',1e5,...
        'TolFun',eps,'TolX',eps,'FinDiffType','central');

   [para_hat,cost_hat] = fmincon(handle_func_cost,[R0,R1,C],[],[],[],[],[],[],[],options);
   


   z_model_hat = func_z_model_RC(f,para_hat);

   figure(i)
   plot(real(z_model_hat),-imag(z_model_hat),'-sq')



%% Fitting 2 CPE

   % minimization
    handle_func_cost = @(para)func_cost2(f,para,z_data);

    options= optimset('display','iter');

   [para_hat2,cost_hat2] = fmincon(handle_func_cost,[R0,R1,C, 1],[],[],[],[],[],[],[],options);
   


   z_model_hat2 = func_z_model_RCPE(f,para_hat2);

   figure(i)
   plot(real(z_model_hat2),-imag(z_model_hat2),'-sq')






%% Figure
figure(i)
title(filelist(i).name)
daspect([1 1 2])



% output structure
output_RC(i,:) = para_hat;
output_RCPE(i,:) = para_hat2;



end







   %% FUNCTIONS





   function cost = func_cost(f,para,z_data)

        z_model = func_z_model_RC(f,para);

        res_mag_vec = (real(z_model)-real(z_data)).^2 + (imag(z_model)-imag(z_data)).^2;

        cost = sum(res_mag_vec);

        % more to learn
        % weighting, RMSE


   end

   function z_model = func_z_model_RC(f,para)

R0=para(1);
R1=para(2);
C= para(3);

omega = f*2*pi; % vector

z_model = R0 + 1./(1i*omega*C + R1^-1);

   end





   %%

   function cost = func_cost2(f,para,z_data)

        z_model = func_z_model_RCPE(f,para);

        res_mag_vec = (real(z_model)-real(z_data)).^2 + (imag(z_model)-imag(z_data)).^2;

        cost = sum(res_mag_vec);

        % more to learn
        % weighting, RMSE


   end




   function z_model = func_z_model_RCPE(f,para)

R0=para(1);
R1=para(2);
C= para(3);
alpha = para(4);

omega = f*2*pi; % vector

z_model = R0 + 1./((1i*omega).^alpha*C + R1^-1);

end






