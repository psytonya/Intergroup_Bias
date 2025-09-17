clear all;
path=['E:\no_slice_timing\data'];
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

%analysis_name={'analysis_stage1_128s_univariate_STafter_dur0','analysis_stage1_128s_univariate_STafter_dur4','analysis_stage2_128s_univariate_STafter_dur0','analysis_stage2_128s_univariate_STafter_dur6'};
analysis_name='NO_slice_analysis_8conds_1noRT_dur0_f128';

for mm=1:1
    outpath=[path '\Group_analysis\' analysis_name]; % the aim folder.
    
%     contrast_names={'in6','in7','in9','in12','out6','out7','out9','out12','all6','all7','all9','all12','in6_7','in_9','in_12','out6_7','out_9','out_12','all6_7','all_9','all_12','in_fair','in_unfair','out_fair','out_unfair','all_fair','all_unfair','UFvsF','InvsOut','IvsO_UFvsF','UFvsF_IvsO'};;
     
    contrast_names={'in6','in7','in9','in12','out6','out7','out9','out12','all6','all7','all9','all12','in6_7','in_9','in_12','out6_7','out_9','out_12','all6_7','all_9','all_12','in_fair','in_unfair','out_fair','out_unfair','all_fair','all_unfair','UFvsF','InvsOut','IvsO_UFvsF','UFvsF_OvsI','unfair(out-in)','fair(out-in)','in(unfair-fair)','out(unfair-fair)'};

    %end
    
    for i=1:length(folders)
        
        filepath=[path,'\',folders(i).name, '\' analysis_name]; % contrast files are in "analysis" folder
        
        confiles=dir([filepath,'\con*.nii']); % find all the contrast files
        
        for conNum=1:length(confiles)
            
            if conNum<22 %only need the last 3 contrasts.
                continue;
            end
            
            if i==1  %only making the output folders once
                mkdir([outpath '\'],[confiles(conNum).name(1:end-4) '_' contrast_names{conNum}]); %making some output folders in the aim folder
            end
            %
            real_input=[filepath '\' confiles(conNum).name(1:end-4) '.nii']; %
            real_output=[outpath '\' [confiles(conNum).name(1:end-4) '_' contrast_names{conNum}] '\' [folders(i).name '_' confiles(conNum).name(1:end-4) '.nii']];
            
            copyfile(real_input, real_output);
            
        end
    end
end
