% ����ɸѡ
%% ģ������trial by trial��ȡ��1-160trial��ֵ�Լ�30�����Ե�ƽ����
%%
clc;clear;
%% ����������trial by trial sub by sub
 load('57Nm3g0.6_simdata_m102.mat');
 data=zeros(57,144);
 data1=zeros(57,1);
 
 for j= 1:57
   data1(j,:)=sim57_data(1+144*(j-1),1)  
 end
for i=1:57
  data(i,:)=sim57_data(1+144*(i-1):144*i,4) %��ȡ����160�γͷ�ѡ��
end
  data_sim=[data1 data]%������ͬ����������ƴ��
  data3=zeros(1,145);
  datasim=[data_sim;data3]

for n=1:144
datasim(58,n+1)=mean(datasim(1:57,n+1));
end
for m=1:57
datasim(m,146)=mean(datasim(m,2:145));
end

save simdata_144trial_57sub_mean.mat datasim
  csvwrite('sim_data_m3g0.6_57trialsubmean.csv', datasim);
  
%% ������Ϊ�����ɿ�����ģ�͵�����
 load('57Nm3g0.6_simdata_m102.mat');
 %titlename=["subid" "offer_propoer" "offer_recipt" "c_r/punish"
 %"condition" "inoutgroup" "c/choice" "trial"]
for q=1:8208
    if sim57_data(q,6)==1;
       sim57_data(q,6)=1;
    elseif sim57_data(q,6)==2;
        sim57_data(q,6)=2;
    end
end
for w=1:8208
    if sim57_data(w,4)==0;
       sim57_data(w,4)=1;
    elseif sim57_data(w,4)==2;
       sim57_data(w,4)=2;
     elseif sim57_data(w,4)==4;
       sim57_data(w,4)=3;    
     elseif sim57_data(w,4)==6;
       sim57_data(w,4)=4;          
    end
end

 save m3g0.6_57_sim_data_144trial(mean57sub).mat  sim57_data
 csvwrite('57simulate_bestmodel_data.csv', sim57_data);
 
