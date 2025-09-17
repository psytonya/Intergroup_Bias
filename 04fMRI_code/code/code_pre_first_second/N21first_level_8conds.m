clear all;
pwd;
% cutoff=128;
cutoff=128;%滤波128/80
analysis_name='NO_slice_analysis_8conds_1noRT_dur0_f128';%最后会生成文件夹，里面会包含所有beta值

spm('defaults', 'FMRI');

img_path=['E:\no_slice_timing\data'];
img_folders=dir([img_path,'\sub*']);

for sub_num=1:length(img_folders)

    %%  initials
    % set up output folders
    path=[img_path, '\' img_folders(sub_num).name '\func'];
%     rmdir([img_path, '\' img_folders(sub_num).name '\' analysis_name],'s');
    mkdir([img_path, '\' img_folders(sub_num).name],analysis_name);
    out_path=[img_path, '\' img_folders(sub_num).name '\' analysis_name];
    
    %find the smoothed and normalized data, as well as motion
    %parameters.
    run_folder=dir([path, '\run*']);
    
    run1_file=spm_select ('FPList',[path '\' run_folder(1).name '\'], '^swuf.*\.nii');
    run1_file= cellstr(run1_file);
    
    run1_rp=spm_select ('FPList',[path '\' run_folder(1).name '\'], '^rp_f.*\.txt');%%%感觉需要改成rp_af.*\.txt
    run1_rp=cellstr(run1_rp);
    
    
    run2_file=spm_select ('FPList',[path '\' run_folder(2).name '\'], '^swuf.*\.nii');
    run2_file= cellstr(run2_file);
    
    run2_rp=spm_select ('FPList',[path '\' run_folder(2).name '\'], '^rp_f.*\.txt');
    run2_rp=cellstr(run2_rp);
    
    
    run1_vector=[path '\' run_folder(1).name '\cond8_newN11_run01.mat'];
    run1_vector=cellstr(run1_vector);
    
    run2_vector=[path '\' run_folder(2).name '\cond8_newN11_run02.mat'];
    run2_vector=cellstr(run2_vector);
    
    
    
    %prepare contrasts
   % eve_type={'in6','in7','in9','in12','out6','out7','out9','out12'};
    eve_type={'in6','in7','in9','in12','out6','out7','out9','out12','nores'};%9个event:nores是no response
    con_name={'in6','in7','in9','in12','out6','out7','out9','out12','all6','all7','all9','all12','in6_7','in_9','in_12','out6_7','out_9','out_12','all6_7','all_9','all_12','in_fair','in_unfair','out_fair','out_unfair','all_fair','all_unfair','UFvsF','InvsOut','IvsO_UFvsF','UFvsF_OvsI','unfair(out-in)','fair(out-in)','in(unfair-fair)','out(unfair-fair)'};
    
    con_weight=zeros(length(con_name),length(eve_type));
    
    con_weight(1,1)=1; %in6
    con_weight(2,2)=1; %in7
    con_weight(3,3)=1; %in9
    con_weight(4,4)=1; %in12
    
    con_weight(5,5)=1; %out6
    con_weight(6,6)=1; %out7
    con_weight(7,7)=1; %out9
    con_weight(8,8)=1; %out12
    
    con_weight(9,[1,5])=[1,1]; %all6
    con_weight(10,[2,6])=[1,1]; %all7
    con_weight(11,[3,7])=[1,1]; %all9
    con_weight(12,[4,8])=[1,1]; %all12
    
    
    con_weight(13,[1,2])=[1,1]; %in6-7
    con_weight(14,3)=1; %in9
    con_weight(15,4)=1; %in12
    
    con_weight(16,[5,6])=[1,1]; %out6-7
    con_weight(17,7)=1; %out9
    con_weight(18,8)=1; %out12
    
    con_weight(19,[1,2,5,6])=[1,1,1,1]; %all6-7
    con_weight(20,[3,7])=[1,1]; %all9
    con_weight(21,[4,8])=[1,1]; %all12
    
    con_weight(22,[1,2])=[1,1]; %infair
    con_weight(23,[3,4])=[1,1]; %inunfair
    
    con_weight(24,[5,6])=[1,1]; %outfair
    con_weight(25,[7,8])=[1,1]; %outunfair
    
    con_weight(26,[1,2,5,6])=[1,1,1,1]; %allfair
    con_weight(27,[3,4,7,8])=[1,1,1,1]; %allunfair
    
    con_weight(28,[3,4,7,8,1,2,5,6])=[1,1,1,1,-1,-1,-1,-1]; %allunfair vs. allfair
    con_weight(29,[1,2,3,4,5,6,7,8])=[1,1,1,1,-1,-1,-1,-1]; %in vs. out
    con_weight(30,[1,2,3,4,5,6,7,8])=[-1,-1,1,1,1,1,-1,-1]; %in(uf vs. f) vs. out(uf vs.f)
    con_weight(31,[1,2,3,4,5,6,7,8])=[1,1,-1,-1,-1,-1,1,1]; %uf(out vs.in) vs. fa(out vs.in) 
    con_weight(32,[3,4,7,8])=[-1,-1,1,1]; %unfair（out-in) 
    con_weight(33,[1,2,5,6])=[-1,-1,1,1]; %fair（out-in)         
    con_weight(34,[1,2,3,4])=[-1,-1,1,1]; %in(unfair-fair)
    con_weight(35,[5,6,7,8])=[-1,-1,1,1]; %out(unfair-fair) 
    %% 1.继续做specify -----------------------------------------------------------------------
    matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(out_path);
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';%要修改
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16; %要修改 %since we did not perform slice timing, we kept this to the default
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;%要修改 %same as above
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = run1_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi =run1_vector;%run1_vector就是上一步生成的.mat
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});%提取的是空值，后面可以一起提取
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = run1_rp;%直接把rp放进去
    %matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg =[''];%没有把rp放进regressor里面
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = cutoff;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = run2_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi =run2_vector;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg =run2_rp;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = cutoff;
    
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    %% 2. generate the SPM.mat file估计参数
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    %% 3. estimate contrasts
    
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    
    for con_len=1:length(con_name)
        matlabbatch{3}.spm.stats.con.consess{con_len}.tcon.name =con_name{con_len} ;
        matlabbatch{3}.spm.stats.con.consess{con_len}.tcon.weights = con_weight(con_len,:);
        matlabbatch{3}.spm.stats.con.consess{con_len}.tcon.sessrep = 'repl';
    end
    
    matlabbatch{3}.spm.stats.con.delete = 0;
    
    % %% 4. outputs the results.
    % matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    % matlabbatch{4}.spm.stats.results.conspec.titlestr = '';
    % matlabbatch{4}.spm.stats.results.conspec.contrasts = Inf;
    % matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'FWE';
    % matlabbatch{4}.spm.stats.results.conspec.thresh = 0.05;
    % matlabbatch{4}.spm.stats.results.conspec.extent = 0;
    % matlabbatch{4}.spm.stats.results.conspec.conjunction = 1;
    % matlabbatch{4}.spm.stats.results.conspec.mask.none = 1;
    % matlabbatch{4}.spm.stats.results.units = 1;
    % matlabbatch{4}.spm.stats.results.print = 'ps';
    % matlabbatch{4}.spm.stats.results.write.none = 1;
    
    
    %% do the job
    spm_jobman('serial', matlabbatch);
    clear matlabbatch;
    
end


