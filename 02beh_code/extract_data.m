%% final data description
%1=ID;
%2=gender;1=male;2=female;
%3=trial number;
%4=run number;
%5=choice_raw;0,2,4,6;degree of punishment 
%6=offer to proposers;
%7=conds;1=ingroup_fair(6:6/7:5);2=ingroup_unfair(9:3/12:0);3=outgroup_fair(6:6/7:5);4=outgroup_unfair(9:3/12:0);
%8=RT
%9=choice(0246) inverse to 1234
%10=in outgroup:1=ingroup;2=outgroup
%% step01: load and transfer data
rpath = fileparts(mfilename('fullpath'));
path = fullfile(rpath, '..', '01raw_beh_data');
nTXT = dir(fullfile(path, '*fMRI.txt'));

nTXT1=dir(fullfile(path, '*sub1*MSfMRI.txt'));%查找该目录中所有文件名包含“sub1”并以“MSfMRI.txt”结尾的文件，并将这些文件的信息存储在 nTXT1 中。
nTXT2=dir(fullfile(path, '*sub2*MSfMRI.txt'));
all_data1=[];%空数组 用于后续的数据处理或存储。
all_data2=[];

%% step02: Loop through all the files in the nTXT1 file list
for o=1:length(nTXT1)
    %整理格式
    rData=textread([path '\' nTXT1(o).name],'%s');%textread 函数读取文件内容，并将其存储在 rData 中。
    [m,n]=size(rData);%得到rData的大小，m行n列
    nData=reshape(rData,16,m*n/16);%reshape 函数将 rData 重塑为 16 列的矩阵。
    nData=nData';%转置
    nData=nData(2:end,[3:9,15]);%选择并重排 nData 的列 删去标题行，选第3~9列＋第15列
    [m,n]=size(nData);%得到nData的大小，m行n列

    %转换数据类型
    for j=1:m
        for k=1:n
            nData3(j,k)=str2num(nData{j,k});%字符串转换成数值
        end
    end
    nData=nData3;
    
    %修改第一列的数据
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

    %根据第6列(OfferType_分配给A的钱)的值来修改或添加第9列(分配给你的钱)的值
    nData(nData(:,6)==6,9)=6; %add the offer_recipt column 6 第6列为6的所有行对应的第9列数值设置为6
    nData(nData(:,6)==7,9)=5; %add the offer_recipt column 5
    nData(nData(:,6)==9,9)=3; %add the offer_recipt column 3
    nData(nData(:,6)==12,9)=0; %add the offer_recipt column 0
    
    %根据第5列(Decision_你施加的惩罚)的值来修改或添加第10列(惩罚类型)的值
    nData(nData(:,5)==0,10)=1;%re-coding the choice;0 TO 1 第5列为0的所有行对应的第10列数值设置为1
    nData(nData(:,5)==2,10)=2;%re-coding the choice;2 TO 2
    nData(nData(:,5)==4,10)=3;%re-coding the choice;4 TO 3
    nData(nData(:,5)==6,10)=4;%re-coding the choice;6 TO 4
    
    %根据第7列(Condition)的值来修改或添加第11列(内外群体条件)的值
    nData(nData(:,7)==1,11)=1; %re-coding the ingroup ;1 TO 1第7列为1的所有行对应的第11列数值设置为1
    nData(nData(:,7)==2,11)=1; %re-coding the ingroup ;2 TO 1
    nData(nData(:,7)==3,11)=2; %re-coding the outgroup;3 TO 2
    nData(nData(:,7)==4,11)=2; %re-coding the outgroup;4 TO 2
    
    %nData(nData(:,8)==0,:)=[]; %excluding the non-response trials (RT=0).
    
    %汇总数据
    %1=ID;2=gender;3=trial number;4=run number;5=choice_raw;6=offer to proposers;7=conds;8=RT;9=offers to recipt;10=choice(1234);11=in_outgroup
    all_data1=[all_data1;nData];%将处理后的数据 nData 添加到 all_data1 中   
end

%% step03: Loop through all the files in the nTXT2 file list
for i=1:length(nTXT2)
    rData=textread([path '\' nTXT2(i).name],'%s');
    [m,n]=size(rData);
    nData=reshape(rData,16,m*n/16);
    nData=nData';
    nData=nData(2:end,[3:9,15]);
    [m,n]=size(nData);
    
    for j=1:m
        for k=1:n
            nData3(j,k)=str2num(nData{j,k});
        end
    end
    nData=nData3;

    if nData(:,1)==902
        nData(:,1)=9021
    elseif nData(:,1)==903
        nData(:,1)=9031
    elseif nData(:,1)==906
        nData(:,1)=9061
    elseif nData(:,1)==907
        nData(:,1)=9071
    elseif nData(:,1)==910
        nData(:,1)=9101
    elseif nData(:,1)==911
        nData(:,1)=9111
    elseif nData(:,1)==914
        nData(:,1)=9141
    elseif nData(:,1)==915
        nData(:,1)=9151
    elseif nData(:,1)==915
        nData(:,1)=9151
    elseif nData(:,1)==918
        nData(:,1)=9181
    elseif nData(:,1)==919
        nData(:,1)=9191
    elseif nData(:,1)==922
        nData(:,1)=9221
    elseif nData(:,1)==923
        nData(:,1)=9231
    elseif nData(:,1)==926
        nData(:,1)=9261
    elseif nData(:,1)==927
        nData(:,1)=9271
    elseif nData(:,1)==930
        nData(:,1)=9301
    elseif nData(:,1)==931
        nData(:,1)=9311
    elseif nData(:,1)==934
        nData(:,1)=9341
    elseif nData(:,1)==935
        nData(:,1)=9351
    elseif nData(:,1)==938
        nData(:,1)=9381
    elseif nData(:,1)==939
        nData(:,1)=9391
    end

    nData(nData(:,6)==6,9)=6; %add the offer_recipt column 6
    nData(nData(:,6)==7,9)=5; %add the offer_recipt column 5
    nData(nData(:,6)==9,9)=3; %add the offer_recipt column 3
    nData(nData(:,6)==12,9)=0; %add the offer_recipt column 0
    
    nData(nData(:,5)==0,10)=1;%re-coding the choice;0 TO 1
    nData(nData(:,5)==2,10)=2;%re-coding the choice;2 TO 2
    nData(nData(:,5)==4,10)=3;%re-coding the choice;4 TO 3
    nData(nData(:,5)==6,10)=4;%re-coding the choice;6 TO 4
    
    nData(nData(:,7)==1,11)=1; %re-coding the ingroup ;1 TO 1
    nData(nData(:,7)==2,11)=1; %re-coding the ingroup ;2 TO 1
    nData(nData(:,7)==3,11)=2; %re-coding the outgroup;3 TO 2
    nData(nData(:,7)==4,11)=2; %re-coding the outgroup;4 TO 2
    
    %nData(nData(:,8)==0,:)=[]; %excluding the non-response trials (RT=0).
    
    %1=ID;2=gender;3=trial number;4=run number;5=choice_raw;6=offer to proposers;7=conds;8=RT;9=choice(1234);10=in_outgroup
    all_data2=[all_data2;nData];
end
%% SUM
all_data=[all_data2; all_data1]%行拼接:将all_data2的行放在all_data1的行之前

%% export data
%定义列名:包含所有列标题的单元数组
names={'subid','gender','trial','run','choice_raw','offer_propoer','conds','RT','offer_recipt','choice','in_outgroup'};
%创建逗号分隔符:将names和逗号数组按行进行拼接,形成一个 2 行的单元数组,第一行是列标题,第二行是逗号
commaheader = [names;repmat({','},1,numel(names))];%repmat({','}, 1, numel(names)) 创建一个包含与 names 数量相同的逗号的单元数组
%展开单元数组
commaheader=commaheader(:)';%首先commaheader(:)将commaheader展开为一个列向量。随后转置。
% 将单元数组commaheader转换为字符矩阵，形成一个字符串。
textheader=cell2mat(commaheader);

%% save data
%以写入模式打开文件，如果文件已存在则清空文件内容
fid = fopen('alldata_female_male_inoutgroup1.csv','w');
%fprintf函数用于将格式化数据写入文件。
fprintf(fid,'%s\n',textheader);% '%s\n' 格式化字符串表示写入一个字符串，并在末尾添加一个换行符;textheader 是包含列标题的字符串，在之前的代码中生成。
%fclose 函数用于关闭文件，确保之前的写入操作完成并将文件保存。
fclose('all');
%write out data to end of file
dlmwrite('alldata_female_male_inoutgroup1.csv',all_data,'-append');%dlmwrite 函数用于将数组写入一个文本文件；'alldata_female_male_inoutgroup1.csv' 是文件名；all_data 是要写入的数据矩阵。;'-append' 选项表示将数据附加到文件的末尾，而不是覆盖文件内容
