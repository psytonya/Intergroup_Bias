%%  This script is used to copy files; From each subject's folder to a  group folder.
clear all;clc;
path='E:\no_slice_timing\data';
outpath='E:\no_slice_timing\data\gPPI_result2';  %Group_PPI_left_MedialFrontalGyrus�FGroup_PPI_Right_MedialFrontalGyrus
folders=dir([path,'\sub*']);
% 通过逻辑判断筛选出符合要求的文件夹信息，剔除sub26、sub234、sub215
idxToKeep = true(length(folders),1); % 初始化一个逻辑数组，默认全为true，表示都保留
namesToSkip = {'sub26','sub234','sub215'}; % 定义要跳过的文件夹名称
for i = 1:length(folders)
    for j = 1:length(namesToSkip)
        if strcmp(folders(i).name,namesToSkip{j}) % 如果当前文件夹名称与要跳过的名称匹配
            idxToKeep(i) = false; % 对应的逻辑值设为false，表示要剔除该文件夹
            break; % 找到匹配的就不用继续在要跳过的名称里对比了，跳出内层循环
        end
    end
end
folders = folders(idxToKeep); % 根据逻辑索引提取出要保留的文件夹信息
outputs=dir([outpath,'\Group_PPI_6mmsphere*']);

for i=1:length(folders)
    path2=[path '\' folders(i).name '\NO_slice_analysis_8conds_1noRT_dur0_f128'];%PPI_left_MedialFrontalGyrus_from_spmF_0004�F PPI_Right_MedialFrontalGyrus_from_spmF_0004
    
    for j=1:length(outputs)
        
        outp2={'01_in6','02_in7','03_in9','04_in12',...
               '05_out6','06_out7','07_out9','08_out12',...
               '09_in_fairvsunfair','10_out_fairvsunfair'...
               '11_fair_invsout','12_unfair_invsout','13_unfairvsfair_invsout',...
               '14_infair','15_inunfair','16_outfair','17_outunfair',...
               '18_ingroup','19_outgroup','20_fair','21_unfair'};%dir([outpath '/' outputs(j).name  '/1*']);
        
        for k=1:length(outp2)
            real_input=[path2 '\' outputs(j).name(7:end)  '\con_PPI_' outp2{k} '_' folders(i).name '.nii'];
            
            if i==1
                mkdir([outpath '\' outputs(j).name '\' outp2{k}]);
            end
            
            real_output=[outpath '\' outputs(j).name '\' outp2{k} '\con_PPI_' outp2{k} '_' folders(i).name '.nii'];
            copyfile(real_input,real_output);
        end
    end
end