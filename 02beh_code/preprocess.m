%% Batch process behavioral data
% condition:1-ingroup_fair;2-ingroup_unfair; 3-outgroup_fair;4-outgroup_unfair
clear all 

rpath = fileparts(mfilename('fullpath'));
path = fullfile(rpath, '..', '01raw_beh_data');
nTXT = dir(fullfile(path, '*fMRI.txt'));
%path=pwd;
%nTXT=dir(fullfile([path], '*fMRI.txt'));%在指定的路径下搜索文件名中包含'fMRI.txt'的所有文件，并将结果存储在变量nTXT中。函数fullfile用于连接路径和文件名，[path]表示路径，'*fMRI.txt'是用于匹配文件名的通配符模式，表示匹配包含fMRI.txt的所有文件。dir函数用于获取符合条件的文件列表，并将结果存储在nTXT变量中。   
nTXT.name%获取nTXT中包含的文件名列表，将返回一个包含所有符合条件的文件名的数组。

avgpoint=zeros(length(nTXT),8);   %惩罚的量
avgrate=zeros(length(nTXT),8);  %惩罚的频率
avgcount=zeros(length(nTXT),4);   %计数
RT=zeros(length(nTXT),8);  %反应时
%% loop
for i=1:length(nTXT)
    rData=textread([path '\' nTXT(i).name],'%s');  %145行16列，第一行是label
    [m,n]=size(rData);%m是行数，n列数
    nData=reshape(rData,16,m*n/16);  %将一维数组rData重新整形成一个16行，mn/16列的二维数组nData
    nData=nData';  %转置mn/16行，16列
    nData=nData(2:end,3:end);%保留ID到Gameon,删首行label
    [m,n]=size(nData);
    nData3=zeros(m,n);%144行16列的零矩阵
    for j=1:m
        for k=1:n
            nData3(j,k)=str2num(nData{j,k});
        end
    end
    nData=nData3;%本来ndata里面元素都是字符串，现在整个改成数值型
    
    nData(find(nData(:,:)<0))=0;   %被试没有反应的归为0（真实值为-1）
    nData2=nData;
    nData2(find(nData2(:,5)>0),5)=1;  %只要第七列有反应（2.4.6的值)就归成1.这是用来计算惩罚频率的
    
    %统计指标计算
    avgcount(i,1)=size(nData2(find(nData2(:,5)==1 & nData2(:,7)<=2),5),1);  %ingroup(1&2)惩罚的数量  惩罚，组内
    avgcount(i,2)=size(nData2(find(nData2(:,5)==0 & nData2(:,7)<=2),5),1); %ingroup(1&2)不惩罚的数量  不惩罚，组内
    avgcount(i,3)=size(nData2(find(nData2(:,5)==1 & nData2(:,7)>2),5),1);  %outgroup(3&4)惩罚的数量  惩罚，组外
    avgcount(i,4)=size(nData2(find(nData2(:,5)==0 & nData2(:,7)>2),5),1); %outgroup(3&4)不惩罚的数量 惩罚，组外
    
    %inG 12:0
    avgpoint(i,1)=mean(nData(find(nData(:,6)==12 & nData(:,7)==2),5));    %avgpoint(i,1)是ingroup(2)不公平：12：0  满足组内不公平分配是12：0情况下decision的值求平均
    avgrate(i,1)=mean(nData2(find(nData2(:,6)==12 & nData2(:,7)==2),5));   %满足组内且不公平分配是12：0情况下是否施加惩罚(1/0)的值求平均
    RT(i,1)=mean(nData2(find(nData2(:,6)==12 & nData2(:,7)==2),13));
    
    le_in_12=length(nData(find(nData(:,6)==12 & nData(:,7)==2),5));%满足组内不公平分配是12：0情况的trail总试次数 统计满足条件 nData(:,6)==12 且 nData(:,7)==2 的行的数量
    his(i,1)=size(nData(find(nData(:,6)==12 & nData(:,7)==2 & nData(:,5)==0),5),1)/ le_in_12;  %被试选0的比例
    his(i,2)=size(nData(find(nData(:,6)==12 & nData(:,7)==2 & nData(:,5)==2),5),1)/ le_in_12;  %被试选2的比例
    his(i,3)=size(nData(find(nData(:,6)==12 & nData(:,7)==2 & nData(:,5)==4),5),1)/ le_in_12;  %被试选4的比例
    his(i,4)=size(nData(find(nData(:,6)==12 & nData(:,7)==2 & nData(:,5)==6),5),1)/ le_in_12;  %被试选6的比例
    
    %inG 9:3   
    avgpoint(i,2)=mean(nData(find(nData(:,6)==9 & nData(:,7)==2),5));    %avgpoint(i,2)是ingroup(2)不公平：9:3
    avgrate(i,2)=mean(nData2(find(nData2(:,6)==9 & nData2(:,7)==2),5));
    RT(i,2)=mean(nData2(find(nData2(:,6)==9 & nData2(:,7)==2),13));
    
    le_in_9=length(nData(find(nData(:,6)==9 & nData(:,7)==2),5));
    his(i,5)=size(nData(find(nData(:,6)==9 & nData(:,7)==2 & nData(:,5)==0),5),1)/le_in_9;  %被试选0的比例
    his(i,6)=size(nData(find(nData(:,6)==9 & nData(:,7)==2 & nData(:,5)==2),5),1)/le_in_9;  %被试选2的比例
    his(i,7)=size(nData(find(nData(:,6)==9 & nData(:,7)==2 & nData(:,5)==4),5),1)/le_in_9;  %被试选4的比例
    his(i,8)=size(nData(find(nData(:,6)==9 & nData(:,7)==2 & nData(:,5)==6),5),1)/le_in_9;  %被试选6的比例
    
    %inG 7:5
    avgpoint(i,3)=mean(nData(find(nData(:,6)==7 & nData(:,7)==1),5));    %avgpoint(i,3)是ingroup(1)公平：7:5
    avgrate(i,3)=mean(nData2(find(nData2(:,6)==7 & nData2(:,7)==1),5));
    RT(i,3)=mean(nData2(find(nData2(:,6)==7 & nData2(:,7)==1),13));
    
    le_in_7=length(nData(find(nData(:,6)==7 & nData(:,7)==1),5));
    his(i,9)=size(nData(find(nData(:,6)==7 & nData(:,7)==1 & nData(:,5)==0),5),1)/le_in_7;  %被试选0的比例
    his(i,10)=size(nData(find(nData(:,6)==7 & nData(:,7)==1 & nData(:,5)==2),5),1)/le_in_7;  %被试选2的比例
    his(i,11)=size(nData(find(nData(:,6)==7 & nData(:,7)==1 & nData(:,5)==4),5),1)/le_in_7;  %被试选4的比例
    his(i,12)=size(nData(find(nData(:,6)==7 & nData(:,7)==1 & nData(:,5)==6),5),1)/le_in_7;  %被试选6的比例
    
    %inG 6:6
    avgpoint(i,4)=mean(nData(find(nData(:,6)==6 & nData(:,7)==1),5));%avgpoint(i,4)是ingroup(1)公平：6:6
    avgrate(i,4)=mean(nData2(find(nData2(:,6)==6 & nData2(:,7)==1),5));
    RT(i,4)=mean(nData2(find(nData2(:,6)==6 & nData2(:,7)==1),13));
    
    le_in_6=length(nData(find(nData(:,6)==6 & nData(:,7)==1),5));
    his(i,13)=size(nData(find(nData(:,6)==6 & nData(:,7)==1 & nData(:,5)==0),5),1)/le_in_6;  %被试选0的比例
    his(i,14)=size(nData(find(nData(:,6)==6 & nData(:,7)==1 & nData(:,5)==2),5),1)/le_in_6;  %被试选2的比例
    his(i,15)=size(nData(find(nData(:,6)==6 & nData(:,7)==1 & nData(:,5)==4),5),1)/le_in_6;  %被试选4的比例
    his(i,16)=size(nData(find(nData(:,6)==6 & nData(:,7)==1 & nData(:,5)==6),5),1)/le_in_6;  %被试选6的比例
    
    %outG 12:0
    avgpoint(i,5)=mean(nData(find(nData(:,6)==12 & nData(:,7)==4),5)); %avgpoint(i,5)是outgroup(4)公平：12:0
    avgrate(i,5)=mean(nData2(find(nData2(:,6)==12 & nData2(:,7)==4),5));
    RT(i,5)=mean(nData2(find(nData2(:,6)==12 & nData2(:,7)==4),13));
    
    le_out_12=length(nData(find(nData(:,6)==12 & nData(:,7)==4),5));
    his(i,17)=size(nData(find(nData(:,6)==12 & nData(:,7)==4 & nData(:,5)==0),5),1)/le_out_12;  %被试选0的比例
    his(i,18)=size(nData(find(nData(:,6)==12 & nData(:,7)==4 & nData(:,5)==2),5),1)/le_out_12;  %被试选2的比例
    his(i,19)=size(nData(find(nData(:,6)==12 & nData(:,7)==4 & nData(:,5)==4),5),1)/le_out_12;  %被试选4的比例
    his(i,20)=size(nData(find(nData(:,6)==12 & nData(:,7)==4 & nData(:,5)==6),5),1)/le_out_12;  %被试选6的比例
    
    %outG 9:3
    avgpoint(i,6)=mean(nData(find(nData(:,6)==9 & nData(:,7)==4),5));%avgpoint(i,6)是outgroup(4)公平：9:3
    avgrate(i,6)=mean(nData2(find(nData2(:,6)==9 & nData2(:,7)==4),5));
    RT(i,6)=mean(nData2(find(nData2(:,6)==9 & nData2(:,7)==4),13));
    
    le_out_9=length(nData(find(nData(:,6)==9 & nData(:,7)==4),5));
    his(i,21)=size(nData(find(nData(:,6)==9 & nData(:,7)==4 & nData(:,5)==0),5),1)/le_out_9;  %被试选0的比例
    his(i,22)=size(nData(find(nData(:,6)==9 & nData(:,7)==4 & nData(:,5)==2),5),1)/le_out_9;  %被试选2的比例
    his(i,23)=size(nData(find(nData(:,6)==9 & nData(:,7)==4 & nData(:,5)==4),5),1)/le_out_9;  %被试选4的比例
    his(i,24)=size(nData(find(nData(:,6)==9 & nData(:,7)==4 & nData(:,5)==6),5),1)/le_out_9;  %被试选6的比例
    
    %outG 7:5
    avgpoint(i,7)=mean(nData(find(nData(:,6)==7 & nData(:,7)==3),5)); %avgpoint(i,7)是outgroup(3)公平：7:5
    avgrate(i,7)=mean(nData2(find(nData2(:,6)==7 & nData2(:,7)==3),5));
    RT(i,7)=mean(nData2(find(nData2(:,6)==7 & nData2(:,7)==3),13));
    
    le_out_7=length(nData(find(nData(:,6)==7 & nData(:,7)==3),5));
    his(i,25)=size(nData(find(nData(:,6)==7 & nData(:,7)==3 & nData(:,5)==0),5),1)/le_out_7;  %被试选0的比例
    his(i,26)=size(nData(find(nData(:,6)==7 & nData(:,7)==3 & nData(:,5)==2),5),1)/le_out_7;  %被试选2的比例
    his(i,27)=size(nData(find(nData(:,6)==7 & nData(:,7)==3 & nData(:,5)==4),5),1)/le_out_7;  %被试选4的比例
    his(i,28)=size(nData(find(nData(:,6)==7 & nData(:,7)==3 & nData(:,5)==6),5),1)/le_out_7;  %被试选6的比例
    
    %outG 6:6
    avgpoint(i,8)=mean(nData(find(nData(:,6)==6 & nData(:,7)==3),5));%avgpoint(i,8)是outgroup(3)公平：6:6
    avgrate(i,8)=mean(nData2(find(nData2(:,6)==6 & nData2(:,7)==3),5));
    RT(i,8)=mean(nData2(find(nData2(:,6)==6 & nData2(:,7)==3),13));
    
    le_out_6=length(nData(find(nData(:,6)==6 & nData(:,7)==3),5));
    his(i,29)=size(nData(find(nData(:,6)==6 & nData(:,7)==3 & nData(:,5)==0),5),1)/le_out_6;  %被试选0的比例
    his(i,30)=size(nData(find(nData(:,6)==6 & nData(:,7)==3 & nData(:,5)==2),5),1)/le_out_6;  %被试选2的比例
    his(i,31)=size(nData(find(nData(:,6)==6 & nData(:,7)==3 & nData(:,5)==4),5),1)/le_out_6;  %被试选4的比例
    his(i,32)=size(nData(find(nData(:,6)==6 & nData(:,7)==3 & nData(:,5)==6),5),1)/le_out_6;  %被试选6的比例
    
end

%% output
%Avgcount
fidraw=fopen([path '\Avgcount.txt'],'a');
fprintf(fidraw,'Sub \t Ingroup_punish \t Ingroup_nonpunish \t Outgroup_punish \t Outgroup_nonpunish \t \n');  %在第一行，把label给标上。
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
fprintf(fidraw,'Sub \t Ingroup-120 \t Ingroup-93 \t Ingroup-75 \t Ingroup-66 \t Outgroup-120 \t Outgroup-93 \t Outgroup-75 \t Outgroup-66 \t \n');  %在第一行，把label给标上。
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
fprintf(fidraw,'Sub \t Ingroup-120 \t Ingroup-93 \t Ingroup-75 \t Ingroup-66 \t Outgroup-120 \t Outgroup-93 \t Outgroup-75 \t Outgroup-66 \t \n');  %在第一行，把label给标上。
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
fprintf(fidraw,'Sub \t Ingroup-120 \t Ingroup-93 \t Ingroup-75 \t Ingroup-66 \t Outgroup-120 \t Outgroup-93 \t Outgroup-75 \t Outgroup-66 \t \n');  %在第一行，把label给标上。
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
fprintf(fidraw,'Sub \t in_12_0 \t  in_12_2 \t  in_12_4 \t  in_12_6  \t in_9_0 \t  in_9_2 \t  in_9_4 \t  in_9_6 \t in_7_0 \t  in_7_2 \t  in_7_4 \t  in_7_6 \t in_6_0 \t  in_6_2 \t  in_6_4 \t  in_6_6 \t  out_12_0 \t  out_12_2 \t  out_12_4 \t  out_12_6  \t out_9_0 \t  out_9_2 \t  out_9_4 \t  out_9_6 \t out_7_0 \t  out_7_2 \t  out_7_4 \t  out_7_6 \t out_6_0 \t  out_6_2 \t  out_6_4 \t  out_6_6  \n');  %在第一行，把label给标上。
for i=1:length(nTXT)
    fprintf(fidraw,'%s\t',nTXT(i).name(1:6));
    for j=1:32
        fprintf(fidraw,'%5.4f\t',his(i,j));
    end
    fprintf(fidraw,'\n');
end
status= fclose(fidraw);
