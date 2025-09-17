%% 初始化
spm('defaults', 'FMRI');
spm_jobman('initcfg');

% Excel文件路径
%xls_path = 'E:\no_slice_timing\code_wholeRegression\ZTparameter_cov.xlsx';
xls_path = 'E:\no_slice_timing\code_wholeRegression\parameter_cov.xlsx';
% 协变量设定：sheet名、列范围、协变量名称、输出子文件夹名
cov_info = {
    'behavior', 'C2:C58', 'UFout_in',        'Group_cov_UFT';
    'parameter','B2:B58', 'alphaOUT_IN',    'Group_cov_alphaT';
    'parameter','D2:D58', 'betaOUT_IN',     'Group_cov_betaT';
};

% 读取数据路径
img_path = 'E:\no_slice_timing\data\Group_analysis\NO_slice_analysis_8conds_1noRT_dur0_f128\con_0032_unfair(out-in)';
con_file = spm_select('FPList', img_path, '.*sub.*\.nii');
con_file = cellstr(con_file);

%% 遍历每个协变量
for i = 1:size(cov_info, 1)
    
    sheet = cov_info{i,1};
    data_range = cov_info{i,2};
    cov_name = cov_info{i,3};
    out_folder = cov_info{i,4};
    
    % 读取协变量数据
    [cov_data,~,~] = xlsread(xls_path, sheet, data_range);
    cov_used = cov_data(:,1); % 保证是一列
    
    % 创建输出目录
    out_path = fullfile(img_path, out_folder);
    if ~exist(out_path, 'dir')
        mkdir(out_path);
    end
    
    % 构建 matlabbatch
    clear matlabbatch;
    matlabbatch{1}.spm.stats.factorial_design.dir = {out_path};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = con_file;
    matlabbatch{1}.spm.stats.factorial_design.cov.c = cov_used;
    matlabbatch{1}.spm.stats.factorial_design.cov.cname = cov_name;
    matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep(...
        'fMRI model specification: SPM.mat File', ...
        substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
        substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep(...
        'Model estimation: SPM.mat File', ...
        substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
        substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = cov_name;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    % 运行批处理
    spm_jobman('run', matlabbatch);
    
    fprintf('>>> 已完成协变量: %s\n', cov_name);
end


