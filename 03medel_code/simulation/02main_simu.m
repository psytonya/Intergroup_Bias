clear all;
clc;

path=pwd; %
load('lxdesign57.mat');

[par,~,~]=xlsread('57Nm3g0.6_parameters_posterior_mean.xlsx');
subs=par(:,1);%第一列
par=par(:,2:size(par,2));%第二列到最后一列
for n=1:length(subs)
    design57_sub=lxdesign57(find(lxdesign57(:,1)==subs(n)),:);%找到对应n的那一行
    if n==1
        sim57_data=simu57_fit_m102(par(n,:),design57_sub);
    else
        sim57_data=[sim57_data;simu57_fit_m102(par(n,:),design57_sub)];
    end
end

save sim57Nm3g0.6_data_m102.mat sim57_data
