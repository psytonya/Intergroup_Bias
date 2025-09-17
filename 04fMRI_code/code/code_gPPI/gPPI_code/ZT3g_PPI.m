%% Add the path to the gPPPI toolbox. I'm assuming SPM8 is already in the path.添加 gPPPI 工具箱路径并初始化 SPM
clc;
clear all;
restoredefaultpath;
path='D:\TOOL\spm8-main';
addpath(genpath(path));
mmpath=('D:\TOOL\PPPIv13.1');
addpath(genpath(mmpath));
spm('defaults', 'FMRI'); 
path3='E:\no_slice_timing\code_gPPI';
addpath(genpath(path3));
%% path 设置数据处理路径
returnHere=pwd;
%pathx='/media/cfeng/Seagate Expansion Drive/2pp_3pp/new_data/SPM12/data';%where store your working data
pathx='E:\no_slice_timing\data';
root_dir=pathx;  %setup path
work_dir=[pathx,'\gPPI_result3'];  %working directory, where to store .psfiles /need to creat a new folder

returnHere=root_dir;  %% PPI is based on the first-level analysis of tranditional GLM
%mask_path='E:\no_slice_timing\code_gPPI\img'; %% where VOI/mask is stored 
mask_path='E:\no_slice_timing\data\gPPI_ROIs\mask';%要改 
subfiles=dir([returnHere,'\sub*']); %% filename of each subject's directory. start with 3.
ROIfiles=dir([mask_path,'\MASK*.nii']);%要改if you have different format,use prefix.or '\roi*.img'
 
 %% %%%%% performing the gPPI for each subject
 
 for x=1:length(subfiles)
     sub_name=subfiles(x).name;
     sub_path=fullfile(returnHere,[subfiles(x).name,'\NO_slice_analysis_8conds_1noRT_dur0_f128']);
     
     %      %Task files:set condition names
     %     taskfile=dir([path,'\',sub_name,'\functional\sess01\*.ons']);  %% Make sure that all runs have the same .ons files.
     %
     %     for n_events=1:length(taskfile)
     %        task_files(n_events)={taskfile(n_events).name(1:end-4)};
     %     end
     for ROI_num=1:length(ROIfiles)
         cd(returnHere);
         ROI_name=ROIfiles(ROI_num).name;
         
         P=gPPI_para_maker2(sub_name,sub_path,mask_path,work_dir,ROI_name);
         
         PPPI(P,[sub_path '\gPPI_' sub_name '_' ROI_name '.mat']);  %% set the parameter for each subject
         clear P;
         cd(pathx);
     end
 end
  
 