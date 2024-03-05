clear; clc; close all

data_c100 = load('OCV_inclass_C100.mat');
data_c20 = load('OCV_inclass_C20.mat');



figure(1)
plot(data_c20.OCV(:,1),data_c20.OCV(:,2)); hold on
plot(data_c100.OCV(:,1),data_c100.OCV(:,2))
legend('C/20','C/100')