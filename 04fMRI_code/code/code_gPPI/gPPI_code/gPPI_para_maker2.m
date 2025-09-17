function P=gPPI_para_maker2(sub_name,sub_path,mask_path,work_dir,ROI_name)
P.subject=sub_name;  %% set the subject names
P.directory=sub_path;%% set the path where SPM.mat file is stored for each subject
P.VOI= [mask_path filesep ROI_name]; %[mask_path filesep 'R_insula_from_spmF_0004.img']; %% this need to be changed for different studies
P.Region=ROI_name(1:end-4);  %% this is the base name of the output directory去除“.img”后缀
P.analysis='psy';%if doing physiophysiological interaction-phys;if psychophysiophysiological-psyphy
P.method='cond';% traditional SPM PPI-'trad';generalized condition-specific PPI-cond(recommend)
P.Estimate=1;% whether or not to estimate the PPI design(0 1 2)
P.contrast=0;%0:Not to adjust for the effect of the null space % if taks F test we can use 'eff_of_interest'
P.extract='mean'; %% you can try 'eig' here.specifies the method of ROI extraction:mean or eig(default eigenvariate)
%P.Tasks={'0','O2_IGOF','O2_IGOU','O2_IBOF','O2_IBOU','O1_PA','O1_all'};%put 0 or 1 in front of them to specify;a cell array
%P.Tasks={'0','1','2','3','4'};% confirm to specify改
P.Tasks={'0','in6','in7','in9','in12','out6','out7','out9','out12'};

P.Weights=[]; % no need for weights for gPPI; this need to be set for SPM PPI-traditional PPI
P.CompContrasts=1;%0-not to estimate any contrasts;1-estimate the design(recommended)
P.Weighted=0;
P.GroupDir=[work_dir filesep 'Group_PPI_' ROI_name(1:end-4)];
P.ConcatR=0;  %%�@can be used to concat sessions to reduce collineaity between task and PPI regressors
P.preservevarcorr=0; %preserves the variance correction estimated from the first level model. This will save time and also means all regions will have the same correction applied

%% This is only set to sub 22 in order to correct errors. For more detials,
% refer to: http://www.nitrc.org/forum/forum.php?thread_id=5152&forum_id=1970
% this will lead to missing of one voxel of RdlPFC (515 voxels to 514) for subject 22, so it is fine
P.equalroi=0;%default:1-roi must be the same size in all subjects, set 0 to lift the restriction
P.FLmask=1;%default:0-restricted using the mask.img from first-level statistics;1- remove the restriction
%other parameters
%VOI2-define the second seed region for physiophysiological interaction
%%
P.Contrasts(1).left={P.Tasks{2}};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
%P.Contrasts(1).right={P.Tasks{2}};
P.Contrasts(1).right={'none'};
P.Contrasts(1).STAT='T';% or F
P.Contrasts(1).Weighted=0;
P.Contrasts(1).MinEvents=1;
P.Contrasts(1).name='01_in6';

P.Contrasts(2).left={P.Tasks{3}};
%P.Contrasts(2).right={P.Tasks{2}};
P.Contrasts(2).right={'none'};
P.Contrasts(2).STAT='T';
P.Contrasts(2).Weighted=0;
P.Contrasts(2).MinEvents=1;
P.Contrasts(2).name='02_in7';

P.Contrasts(3).left={P.Tasks{4}};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
%P.Contrasts(3).right={P.Tasks{2}};
P.Contrasts(3).right={'none'};
P.Contrasts(3).STAT='T';% or F
P.Contrasts(3).Weighted=0;
P.Contrasts(3).MinEvents=1;
P.Contrasts(3).name='03_in9';

P.Contrasts(4).left={P.Tasks{5}};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
%P.Contrasts(4).right={P.Tasks{2}};
P.Contrasts(4).right={'none'};
P.Contrasts(4).STAT='T';% or F
P.Contrasts(4).Weighted=0;
P.Contrasts(4).MinEvents=1;
P.Contrasts(4).name='04_in12';

P.Contrasts(5).left={P.Tasks{6}};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
%P.Contrasts(4).right={P.Tasks{2}};
P.Contrasts(5).right={'none'};
P.Contrasts(5).STAT='T';% or F
P.Contrasts(5).Weighted=0;
P.Contrasts(5).MinEvents=1;
P.Contrasts(5).name='05_out6';

P.Contrasts(6).left={P.Tasks{7}};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
%P.Contrasts(4).right={P.Tasks{2}};
P.Contrasts(6).right={'none'};
P.Contrasts(6).STAT='T';% or F
P.Contrasts(6).Weighted=0;
P.Contrasts(6).MinEvents=1;
P.Contrasts(6).name='06_out7';

P.Contrasts(7).left={P.Tasks{8}};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
%P.Contrasts(4).right={P.Tasks{2}};
P.Contrasts(7).right={'none'};
P.Contrasts(7).STAT='T';% or F
P.Contrasts(7).Weighted=0;
P.Contrasts(7).MinEvents=1;
P.Contrasts(7).name='07_out9';

P.Contrasts(8).left={P.Tasks{9}};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
%P.Contrasts(4).right={P.Tasks{2}};
P.Contrasts(8).right={'none'};
P.Contrasts(8).STAT='T';% or F
P.Contrasts(8).Weighted=0;
P.Contrasts(8).MinEvents=1;
P.Contrasts(8).name='08_out12';

P.Contrasts(9).left={'in6' 'in7'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(9).right={'in9' 'in12'};
P.Contrasts(9).STAT='T';% or F
P.Contrasts(9).Weighted=0;
P.Contrasts(9).MinEvents=1;
P.Contrasts(9).name='09_in_fairvsunfair';

P.Contrasts(10).left={'out6' 'out7'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(10).right={'out9' 'out12'};
P.Contrasts(10).STAT='T';% or F
P.Contrasts(10).Weighted=0;
P.Contrasts(10).MinEvents=1;
P.Contrasts(10).name='10_out_fairvsunfair';

P.Contrasts(11).left={'in6' 'in7'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(11).right={'out6' 'out7'};
P.Contrasts(11).STAT='T';% or F
P.Contrasts(11).Weighted=0;
P.Contrasts(11).MinEvents=1;
P.Contrasts(11).name='11_fair_invsout';

P.Contrasts(12).left={'in9' 'in12'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(12).right={'out9' 'out12'};
P.Contrasts(12).STAT='T';% or F
P.Contrasts(12).Weighted=0;
P.Contrasts(12).MinEvents=1;
P.Contrasts(12).name='12_unfair_invsout';

P.Contrasts(13).left={'in9' 'in12' 'out6' 'out7'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(13).right={'out9' 'out12' 'in6' 'in7'};
P.Contrasts(13).STAT='T';% or F
P.Contrasts(13).Weighted=0;
P.Contrasts(13).MinEvents=1;
P.Contrasts(13).name='13_unfairvsfair_invsout';

P.Contrasts(14).left={'in6' 'in7'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(14).right={'none'};
P.Contrasts(14).STAT='T';% or F
P.Contrasts(14).Weighted=0;
P.Contrasts(14).MinEvents=1;
P.Contrasts(14).name='14_infair';

P.Contrasts(15).left={'in9' 'in12'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(15).right={'none'};
P.Contrasts(15).STAT='T';% or F
P.Contrasts(15).Weighted=0;
P.Contrasts(15).MinEvents=1;
P.Contrasts(15).name='15_inunfair';

P.Contrasts(16).left={'out6' 'out7'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(16).right={'none'};
P.Contrasts(16).STAT='T';% or F
P.Contrasts(16).Weighted=0;
P.Contrasts(16).MinEvents=1;
P.Contrasts(16).name='16_outfair';

P.Contrasts(17).left={'out9' 'out12'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(17).right={'none'};
P.Contrasts(17).STAT='T';% or F
P.Contrasts(17).Weighted=0;
P.Contrasts(17).MinEvents=1;
P.Contrasts(17).name='17_outunfair';

P.Contrasts(18).left={'in6' 'in7' 'in9' 'in12'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(18).right={'none'};
P.Contrasts(18).STAT='T';% or F
P.Contrasts(18).Weighted=0;
P.Contrasts(18).MinEvents=1;
P.Contrasts(18).name='18_ingroup';

P.Contrasts(19).left={'out6' 'out7' 'out9' 'out12'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(19).right={'none'};
P.Contrasts(19).STAT='T';% or F
P.Contrasts(19).Weighted=0;
P.Contrasts(19).MinEvents=1;
P.Contrasts(19).name='19_outgroup';

P.Contrasts(20).left={'out6' 'out7' 'in6' 'in7'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(20).right={'none'};
P.Contrasts(20).STAT='T';% or F
P.Contrasts(20).Weighted=0;
P.Contrasts(20).MinEvents=1;
P.Contrasts(20).name='20_fair';

P.Contrasts(21).left={'out9' 'out12' 'in9' 'in12'};%this is only feasible with less then 4 tasks if left blank and compcontrasts=1, defines all possible T contrasts
P.Contrasts(21).right={'none'};
P.Contrasts(21).STAT='T';% or F
P.Contrasts(21).Weighted=0;
P.Contrasts(21).MinEvents=1;
P.Contrasts(21).name='21_unfair';
return;





