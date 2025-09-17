
%nTXT1=dir(fullfile(path, '*sub1*MSfMRI.txt'));
%nTXT2=dir(fullfile(path, '*sub2*MSfMRI.txt'));
clear all;
clc;
path=pwd; %
%% female
nTXT=dir(fullfile([path,filesep,'57behavior_data',filesep], '*sub1*fMRI*.txt'));
%nTXT=dir(fullfile([path,filesep,'behavior_data',filesep], '*fMRI*.txt'));
all_data57female=[];

for i=1:length(nTXT)
    rData=textread([path,filesep,'57behavior_data',filesep,nTXT(i).name],'%s');%textread 函数读取文件内容，并将其存储在 rData 中。
    [m,n]=size(rData);%得到rData的大小，m行n列
    nData=reshape(rData,16,m*n/16);%reshape 函数将 rData 重塑为 16 列的矩阵。
    nData=nData';%转置
    nData=nData(2:end,3:end-1);%选择并重排 nData 的列 删去标题行，选第2~末行 第3至倒数第二列
    [m,n]=size(nData);%得到nData的大小，m行n列
    nData3=zeros(m,n);
    
       %转换数据类型
    for j=1:m
        for k=1:n
            nData3(j,k)=str2num(nData{j,k});%字符串转换成数值
        end
    end
    nData=nData3;
%    nData(:,1)=str2num(nData(:,1));%字符串转换成数值
%    class(nData(:,1))
%   nData = cellfun(@str2double,nData);
    if nData(:,1)==915
        nData(:,1)=9151
    elseif nData(:,1)==910
        nData(:,1)=9101
    elseif nData(:,1)==914
        nData(:,1)=9141
    elseif nData(:,1)==911
        nData(:,1)=9111
    elseif nData(:,1)==923
        nData(:,1)=9231
    elseif nData(:,1)==918
        nData(:,1)=9181
    elseif nData(:,1)==922
        nData(:,1)=9221
    elseif nData(:,1)==919
        nData(:,1)=9191
    elseif nData(:,1)==931
        nData(:,1)=9311
    elseif nData(:,1)==926
        nData(:,1)=9261
    elseif nData(:,1)==930
        nData(:,1)=9301
    elseif nData(:,1)==907
        nData(:,1)=9071
    elseif nData(:,1)==927
        nData(:,1)=9271
    elseif nData(:,1)==939
        nData(:,1)=9391
    elseif nData(:,1)==935
        nData(:,1)=9351
    elseif nData(:,1)==934
        nData(:,1)=9341
    elseif nData(:,1)==938
        nData(:,1)=9381
    elseif nData(:,1)==902
        nData(:,1)=9021
    elseif nData(:,1)==906
        nData(:,1)=9061
    elseif nData(:,1)==903
        nData(:,1)=9031
    end
    
%     nData3=zeros(m,n);
%     %i;
   nData3=nData;
   for j=1:m
         for k=1:n
             nData3(j,k)=str2num(nData{j,k});
         end
        
        if nData3(j,4)==2 %run2
            nData3(j,3)= nData3(j,3)+72; %add up
        end
    end
    new_col1=12-nData3(:,6);%new_col1 分给自己的钱
    nData3 = horzcat(nData3, new_col1);
    new_col2=nData3(:,7);
    nData3 = horzcat(nData3, new_col2);
    nData=nData3(:,[1,6,14,5,7,15,3]);%subjid;Xother;Xself;Punish;cond;in_outgroup;trial
    nData(:,6)=2-(nData(:,6)<=2); %1=ingroup;2=outgroup
   
    if i==1
        all_data57female=nData;
    else
        all_data57female=[all_data57female;nData];
    end
    clear nData nData3
end

%% male
nTXT2=dir(fullfile([path,filesep,'57behavior_data',filesep], '*sub2*fMRI*.txt'));

all_data57male=[];

for i=1:length(nTXT2)
    rData=textread([path,filesep,'57behavior_data',filesep,nTXT2(i).name],'%s');%textread 函数读取文件内容，并将其存储在 rData 中。
    [m,n]=size(rData);%得到rData的大小，m行n列
    nData=reshape(rData,16,m*n/16);%reshape 函数将 rData 重塑为 16 列的矩阵。
    nData=nData';%转置
    nData=nData(2:end,3:end-1);%选择并重排 nData 的列 删去标题行，选第2~末行 第3至倒数第二列
    [m,n]=size(nData);%得到nData的大小，m行n列
    nData3=zeros(m,n);
    %i;
    for j=1:m
        for k=1:n
            nData3(j,k)=str2num(nData{j,k});
        end
        if nData3(j,4)==2 %run2
            nData3(j,3)= nData3(j,3)+72; %add up
        end
    end
    new_col1=12-nData3(:,6);
    nData3 = horzcat(nData3, new_col1);
    new_col2=nData3(:,7);
    nData3 = horzcat(nData3, new_col2);
    nData=nData3(:,[1,6,14,5,7,15,3]);%subjid;Xother;Xself;Punish;cond;in_outgroup;trial
    nData(:,6)=2-(nData(:,6)<=2); %1=ingroup;2=outgroup
   
    if i==1
        all_data57male=nData;
    else
        all_data57male=[all_data57male;nData];
    end
    clear nData nData3
end



design57 = [all_data57female;all_data57male];
save design57.mat design57