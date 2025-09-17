%% Batch process behavioral data
% condition:1-ingroup_fair;2-ingroup_unfair; 3-outgroup_fair;4-outgroup_unfair
clear all 

rpath = fileparts(mfilename('fullpath'));
path = fullfile(rpath, '..', '01raw_beh_data');
nTXT = dir(fullfile(path, '*fMRI.txt'));
%path=pwd;
%nTXT=dir(fullfile([path], '*fMRI.txt'));%��ָ����·���������ļ����а���'fMRI.txt'�������ļ�����������洢�ڱ���nTXT�С�����fullfile��������·�����ļ�����[path]��ʾ·����'*fMRI.txt'������ƥ���ļ�����ͨ���ģʽ����ʾƥ�����fMRI.txt�������ļ���dir�������ڻ�ȡ�����������ļ��б���������洢��nTXT�����С�   
nTXT.name%��ȡnTXT�а������ļ����б�������һ���������з����������ļ��������顣

avgpoint=zeros(length(nTXT),8);   %�ͷ�����
avgrate=zeros(length(nTXT),8);  %�ͷ���Ƶ��
avgcount=zeros(length(nTXT),4);   %����
RT=zeros(length(nTXT),8);  %��Ӧʱ
%% loop
for i=1:length(nTXT)
    rData=textread([path '\' nTXT(i).name],'%s');  %145��16�У���һ����label
    [m,n]=size(rData);%m��������n����
    nData=reshape(rData,16,m*n/16);  %��һά����rData�������γ�һ��16�У�mn/16�еĶ�ά����nData
    nData=nData';  %ת��mn/16�У�16��
    nData=nData(2:end,3:end);%����ID��Gameon,ɾ����label
    [m,n]=size(nData);
    nData3=zeros(m,n);%144��16�е������
    for j=1:m
        for k=1:n
            nData3(j,k)=str2num(nData{j,k});
        end
    end
    nData=nData3;%����ndata����Ԫ�ض����ַ��������������ĳ���ֵ��
    
    nData(find(nData(:,:)<0))=0;   %����û�з�Ӧ�Ĺ�Ϊ0����ʵֵΪ-1��
    nData2=nData;
    nData2(find(nData2(:,5)>0),5)=1;  %ֻҪ�������з�Ӧ��2.4.6��ֵ)�͹��1.������������ͷ�Ƶ�ʵ�
    
    %ͳ��ָ�����
    avgcount(i,1)=size(nData2(find(nData2(:,5)==1 & nData2(:,7)<=2),5),1);  %ingroup(1&2)�ͷ�������  �ͷ�������
    avgcount(i,2)=size(nData2(find(nData2(:,5)==0 & nData2(:,7)<=2),5),1); %ingroup(1&2)���ͷ�������  ���ͷ�������
    avgcount(i,3)=size(nData2(find(nData2(:,5)==1 & nData2(:,7)>2),5),1);  %outgroup(3&4)�ͷ�������  �ͷ�������
    avgcount(i,4)=size(nData2(find(nData2(:,5)==0 & nData2(:,7)>2),5),1); %outgroup(3&4)���ͷ������� �ͷ�������
    
    %inG 12:0
    avgpoint(i,1)=mean(nData(find(nData(:,6)==12 & nData(:,7)==2),5));    %avgpoint(i,1)��ingroup(2)����ƽ��12��0  �������ڲ���ƽ������12��0�����decision��ֵ��ƽ��
    avgrate(i,1)=mean(nData2(find(nData2(:,6)==12 & nData2(:,7)==2),5));   %���������Ҳ���ƽ������12��0������Ƿ�ʩ�ӳͷ�(1/0)��ֵ��ƽ��
    RT(i,1)=mean(nData2(find(nData2(:,6)==12 & nData2(:,7)==2),13));
    
    le_in_12=length(nData(find(nData(:,6)==12 & nData(:,7)==2),5));%�������ڲ���ƽ������12��0�����trail���Դ��� ͳ���������� nData(:,6)==12 �� nData(:,7)==2 ���е�����
    his(i,1)=size(nData(find(nData(:,6)==12 & nData(:,7)==2 & nData(:,5)==0),5),1)/ le_in_12;  %����ѡ0�ı���
    his(i,2)=size(nData(find(nData(:,6)==12 & nData(:,7)==2 & nData(:,5)==2),5),1)/ le_in_12;  %����ѡ2�ı���
    his(i,3)=size(nData(find(nData(:,6)==12 & nData(:,7)==2 & nData(:,5)==4),5),1)/ le_in_12;  %����ѡ4�ı���
    his(i,4)=size(nData(find(nData(:,6)==12 & nData(:,7)==2 & nData(:,5)==6),5),1)/ le_in_12;  %����ѡ6�ı���
    
    %inG 9:3   
    avgpoint(i,2)=mean(nData(find(nData(:,6)==9 & nData(:,7)==2),5));    %avgpoint(i,2)��ingroup(2)����ƽ��9:3
    avgrate(i,2)=mean(nData2(find(nData2(:,6)==9 & nData2(:,7)==2),5));
    RT(i,2)=mean(nData2(find(nData2(:,6)==9 & nData2(:,7)==2),13));
    
    le_in_9=length(nData(find(nData(:,6)==9 & nData(:,7)==2),5));
    his(i,5)=size(nData(find(nData(:,6)==9 & nData(:,7)==2 & nData(:,5)==0),5),1)/le_in_9;  %����ѡ0�ı���
    his(i,6)=size(nData(find(nData(:,6)==9 & nData(:,7)==2 & nData(:,5)==2),5),1)/le_in_9;  %����ѡ2�ı���
    his(i,7)=size(nData(find(nData(:,6)==9 & nData(:,7)==2 & nData(:,5)==4),5),1)/le_in_9;  %����ѡ4�ı���
    his(i,8)=size(nData(find(nData(:,6)==9 & nData(:,7)==2 & nData(:,5)==6),5),1)/le_in_9;  %����ѡ6�ı���
    
    %inG 7:5
    avgpoint(i,3)=mean(nData(find(nData(:,6)==7 & nData(:,7)==1),5));    %avgpoint(i,3)��ingroup(1)��ƽ��7:5
    avgrate(i,3)=mean(nData2(find(nData2(:,6)==7 & nData2(:,7)==1),5));
    RT(i,3)=mean(nData2(find(nData2(:,6)==7 & nData2(:,7)==1),13));
    
    le_in_7=length(nData(find(nData(:,6)==7 & nData(:,7)==1),5));
    his(i,9)=size(nData(find(nData(:,6)==7 & nData(:,7)==1 & nData(:,5)==0),5),1)/le_in_7;  %����ѡ0�ı���
    his(i,10)=size(nData(find(nData(:,6)==7 & nData(:,7)==1 & nData(:,5)==2),5),1)/le_in_7;  %����ѡ2�ı���
    his(i,11)=size(nData(find(nData(:,6)==7 & nData(:,7)==1 & nData(:,5)==4),5),1)/le_in_7;  %����ѡ4�ı���
    his(i,12)=size(nData(find(nData(:,6)==7 & nData(:,7)==1 & nData(:,5)==6),5),1)/le_in_7;  %����ѡ6�ı���
    
    %inG 6:6
    avgpoint(i,4)=mean(nData(find(nData(:,6)==6 & nData(:,7)==1),5));%avgpoint(i,4)��ingroup(1)��ƽ��6:6
    avgrate(i,4)=mean(nData2(find(nData2(:,6)==6 & nData2(:,7)==1),5));
    RT(i,4)=mean(nData2(find(nData2(:,6)==6 & nData2(:,7)==1),13));
    
    le_in_6=length(nData(find(nData(:,6)==6 & nData(:,7)==1),5));
    his(i,13)=size(nData(find(nData(:,6)==6 & nData(:,7)==1 & nData(:,5)==0),5),1)/le_in_6;  %����ѡ0�ı���
    his(i,14)=size(nData(find(nData(:,6)==6 & nData(:,7)==1 & nData(:,5)==2),5),1)/le_in_6;  %����ѡ2�ı���
    his(i,15)=size(nData(find(nData(:,6)==6 & nData(:,7)==1 & nData(:,5)==4),5),1)/le_in_6;  %����ѡ4�ı���
    his(i,16)=size(nData(find(nData(:,6)==6 & nData(:,7)==1 & nData(:,5)==6),5),1)/le_in_6;  %����ѡ6�ı���
    
    %outG 12:0
    avgpoint(i,5)=mean(nData(find(nData(:,6)==12 & nData(:,7)==4),5)); %avgpoint(i,5)��outgroup(4)��ƽ��12:0
    avgrate(i,5)=mean(nData2(find(nData2(:,6)==12 & nData2(:,7)==4),5));
    RT(i,5)=mean(nData2(find(nData2(:,6)==12 & nData2(:,7)==4),13));
    
    le_out_12=length(nData(find(nData(:,6)==12 & nData(:,7)==4),5));
    his(i,17)=size(nData(find(nData(:,6)==12 & nData(:,7)==4 & nData(:,5)==0),5),1)/le_out_12;  %����ѡ0�ı���
    his(i,18)=size(nData(find(nData(:,6)==12 & nData(:,7)==4 & nData(:,5)==2),5),1)/le_out_12;  %����ѡ2�ı���
    his(i,19)=size(nData(find(nData(:,6)==12 & nData(:,7)==4 & nData(:,5)==4),5),1)/le_out_12;  %����ѡ4�ı���
    his(i,20)=size(nData(find(nData(:,6)==12 & nData(:,7)==4 & nData(:,5)==6),5),1)/le_out_12;  %����ѡ6�ı���
    
    %outG 9:3
    avgpoint(i,6)=mean(nData(find(nData(:,6)==9 & nData(:,7)==4),5));%avgpoint(i,6)��outgroup(4)��ƽ��9:3
    avgrate(i,6)=mean(nData2(find(nData2(:,6)==9 & nData2(:,7)==4),5));
    RT(i,6)=mean(nData2(find(nData2(:,6)==9 & nData2(:,7)==4),13));
    
    le_out_9=length(nData(find(nData(:,6)==9 & nData(:,7)==4),5));
    his(i,21)=size(nData(find(nData(:,6)==9 & nData(:,7)==4 & nData(:,5)==0),5),1)/le_out_9;  %����ѡ0�ı���
    his(i,22)=size(nData(find(nData(:,6)==9 & nData(:,7)==4 & nData(:,5)==2),5),1)/le_out_9;  %����ѡ2�ı���
    his(i,23)=size(nData(find(nData(:,6)==9 & nData(:,7)==4 & nData(:,5)==4),5),1)/le_out_9;  %����ѡ4�ı���
    his(i,24)=size(nData(find(nData(:,6)==9 & nData(:,7)==4 & nData(:,5)==6),5),1)/le_out_9;  %����ѡ6�ı���
    
    %outG 7:5
    avgpoint(i,7)=mean(nData(find(nData(:,6)==7 & nData(:,7)==3),5)); %avgpoint(i,7)��outgroup(3)��ƽ��7:5
    avgrate(i,7)=mean(nData2(find(nData2(:,6)==7 & nData2(:,7)==3),5));
    RT(i,7)=mean(nData2(find(nData2(:,6)==7 & nData2(:,7)==3),13));
    
    le_out_7=length(nData(find(nData(:,6)==7 & nData(:,7)==3),5));
    his(i,25)=size(nData(find(nData(:,6)==7 & nData(:,7)==3 & nData(:,5)==0),5),1)/le_out_7;  %����ѡ0�ı���
    his(i,26)=size(nData(find(nData(:,6)==7 & nData(:,7)==3 & nData(:,5)==2),5),1)/le_out_7;  %����ѡ2�ı���
    his(i,27)=size(nData(find(nData(:,6)==7 & nData(:,7)==3 & nData(:,5)==4),5),1)/le_out_7;  %����ѡ4�ı���
    his(i,28)=size(nData(find(nData(:,6)==7 & nData(:,7)==3 & nData(:,5)==6),5),1)/le_out_7;  %����ѡ6�ı���
    
    %outG 6:6
    avgpoint(i,8)=mean(nData(find(nData(:,6)==6 & nData(:,7)==3),5));%avgpoint(i,8)��outgroup(3)��ƽ��6:6
    avgrate(i,8)=mean(nData2(find(nData2(:,6)==6 & nData2(:,7)==3),5));
    RT(i,8)=mean(nData2(find(nData2(:,6)==6 & nData2(:,7)==3),13));
    
    le_out_6=length(nData(find(nData(:,6)==6 & nData(:,7)==3),5));
    his(i,29)=size(nData(find(nData(:,6)==6 & nData(:,7)==3 & nData(:,5)==0),5),1)/le_out_6;  %����ѡ0�ı���
    his(i,30)=size(nData(find(nData(:,6)==6 & nData(:,7)==3 & nData(:,5)==2),5),1)/le_out_6;  %����ѡ2�ı���
    his(i,31)=size(nData(find(nData(:,6)==6 & nData(:,7)==3 & nData(:,5)==4),5),1)/le_out_6;  %����ѡ4�ı���
    his(i,32)=size(nData(find(nData(:,6)==6 & nData(:,7)==3 & nData(:,5)==6),5),1)/le_out_6;  %����ѡ6�ı���
    
end

%% output
%Avgcount
fidraw=fopen([path '\Avgcount.txt'],'a');
fprintf(fidraw,'Sub \t Ingroup_punish \t Ingroup_nonpunish \t Outgroup_punish \t Outgroup_nonpunish \t \n');  %�ڵ�һ�У���label�����ϡ�
for i=1:length(nTXT)
    fprintf(fidraw,'%s\t',nTXT(i).name(1:9));
    for j=1:4
        fprintf(fidraw,'%5.4f\t',avgcount(i,j));
    end
    fprintf(fidraw,'\n');
end
status= fclose(fidraw);

%Avgpoint
fidraw=fopen([path '\Avgpoint.txt'],'a');
fprintf(fidraw,'Sub \t Ingroup-120 \t Ingroup-93 \t Ingroup-75 \t Ingroup-66 \t Outgroup-120 \t Outgroup-93 \t Outgroup-75 \t Outgroup-66 \t \n');  %�ڵ�һ�У���label�����ϡ�
for i=1:length(nTXT)
    fprintf(fidraw,'%s\t',nTXT(i).name(1:9));
    for j=1:8
        fprintf(fidraw,'%5.4f\t',avgpoint(i,j));
    end
    fprintf(fidraw,'\n');
end
status= fclose(fidraw);

%Avgrate
fidraw=fopen([path '\Avgrate.txt'],'a');
fprintf(fidraw,'Sub \t Ingroup-120 \t Ingroup-93 \t Ingroup-75 \t Ingroup-66 \t Outgroup-120 \t Outgroup-93 \t Outgroup-75 \t Outgroup-66 \t \n');  %�ڵ�һ�У���label�����ϡ�
for i=1:length(nTXT)
    fprintf(fidraw,'%s\t',nTXT(i).name(1:9));
    for j=1:8
        fprintf(fidraw,'%5.4f\t',avgrate(i,j));
    end
    fprintf(fidraw,'\n');
end
status= fclose(fidraw);

%RT
fidraw=fopen([path '\RT.txt'],'a');
fprintf(fidraw,'Sub \t Ingroup-120 \t Ingroup-93 \t Ingroup-75 \t Ingroup-66 \t Outgroup-120 \t Outgroup-93 \t Outgroup-75 \t Outgroup-66 \t \n');  %�ڵ�һ�У���label�����ϡ�
for i=1:length(nTXT)
    fprintf(fidraw,'%s\t',nTXT(i).name(1:9));
    for j=1:8
        fprintf(fidraw,'%5.4f\t',RT(i,j));
    end
    fprintf(fidraw,'\n');2
end
status= fclose(fidraw);

%punish0246
fidraw=fopen([path '\punish0246.txt'],'a');
fprintf(fidraw,'Sub \t in_12_0 \t  in_12_2 \t  in_12_4 \t  in_12_6  \t in_9_0 \t  in_9_2 \t  in_9_4 \t  in_9_6 \t in_7_0 \t  in_7_2 \t  in_7_4 \t  in_7_6 \t in_6_0 \t  in_6_2 \t  in_6_4 \t  in_6_6 \t  out_12_0 \t  out_12_2 \t  out_12_4 \t  out_12_6  \t out_9_0 \t  out_9_2 \t  out_9_4 \t  out_9_6 \t out_7_0 \t  out_7_2 \t  out_7_4 \t  out_7_6 \t out_6_0 \t  out_6_2 \t  out_6_4 \t  out_6_6  \n');  %�ڵ�һ�У���label�����ϡ�
for i=1:length(nTXT)
    fprintf(fidraw,'%s\t',nTXT(i).name(1:6));
    for j=1:32
        fprintf(fidraw,'%5.4f\t',his(i,j));
    end
    fprintf(fidraw,'\n');
end
status= fclose(fidraw);
