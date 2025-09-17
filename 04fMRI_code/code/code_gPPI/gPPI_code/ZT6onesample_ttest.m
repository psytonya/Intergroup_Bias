clear all;clc
restoredefaultpath;
addpath(genpath('D:\TOOL\spm12')); 
addpath(genpath('D:\TOOL\xjview10')); 
path='E:\no_slice_timing\data\gPPI_result2'; % the aim folder.
analysisfolder=dir([path,'\Group_PPI_6mmsphere*']);
% analysisfolder=dir([path,'\Group_PPI_6mmsphere_dACC_-8_20_46_roi']);%需要改！
% analysisfolder=dir([path,'\Group_PPI_6mmsphere_mPFC_6_50_14_roi']);%需要改！
% analysisfolder=dir([path,'\Group_PPI_6mmsphere_dlPFC_-54_20_30_roi']);%需要改！
% analysisfolder=dir([path,'\Group_PPI_6mmsphere_PPC_26_-60_40_roi']);%需要改！


% initialize SPM and the batch mode
spm('defaults','fMRI');
spm_jobman('initcfg');
clear matlabbatch;

for i = 1:length(analysisfolder) 
    %analyspath=[path,'\Group_PPI_6mmsphere_PPC_26_-60_40_roi\' analysisfolder(i).name];%需要改
    analyspath=[path,'\' analysisfolder(i).name];
    % 查找以 0 开头的文件或文件夹
    conspath_0 = dir([analyspath '\0*']);
    % 查找以 1 开头的文件或文件夹
    conspath_1 = dir([analyspath '\1*']);
    %查找以 2 开头的文件或文件夹
    conspath_2 = dir([analyspath '\2*']);
    % 合并结果
    conspath = [conspath_0; conspath_1; conspath_2];
    %conspath = [conspath_0; conspath_1];
    %conspath = [conspath_2];
    for mm=1:length(conspath)
        confolder=[analyspath,'\' conspath(mm).name];
        
        fs = spm_select ('FPList',fullfile(confolder),'^con_PPI.*\.nii$');
        
        mkdir([confolder,'\Group']);
        
        %-----------------------------------------------------------------------
        matlabbatch{1}.spm.stats.factorial_design.dir = {[confolder,'\Group']};
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(fs);
        matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
        matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
        
        
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
        
        matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'pos';
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.delete = 0;
        
        %spm_jobman('serial', matlabbatch);
        spm_jobman('run', matlabbatch);
        clear matlabbatch;
        
    end
end