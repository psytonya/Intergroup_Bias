clear all
path='E:\no_slice_timing\data\Group_analysis'; % the aim folder.
analysisfolder=dir([path,'\NO_slice_analysis_8conds_1noRT_dur0_f128']);%需要改！

% initialize SPM and the batch mode
spm('defaults','fMRI');
spm_jobman('initcfg');
clear matlabbatch;

for i = 1:length(analysisfolder)
    analyspath=[path,'\' analysisfolder(i).name];
    
    
    conspath = dir([analyspath '\con*']);
    
    for mm=1:length(conspath)
        confolder=[analyspath,'\' conspath(mm).name];
        
        fs = spm_select ('FPList',fullfile(confolder),'^sub.*\.nii$');
        
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
        
        
        spm_jobman('run', matlabbatch);
        clear matlabbatch;
        
    end
end