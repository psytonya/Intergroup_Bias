%生成基于指定 MNI 坐标的球形区域ROI并保存为Marsbar和MRIcron可用的.mat和.img格式文件。
% This script loads MNI coordinates specified in a user-created file,
% spherelist.txt, and generates .mat and .img ROI files for use with
% Marsbar, MRIcron etc.  spherelist.txt should list the centres of
% desired spheres, one-per-row, with coordinates in the format:
% X1 Y1 Z1
% X2 Y2 Z2 etc
% .mat sphere ROIs will be saved in the script-created \mat\ directory.
% .img sphere ROIs will be saved in the script-created \img\ directory.
% SPM Toolbox Marsbar should be installed and started before running script.
clc;
clear all;
%虽然我不知道为什么但是我的必须有这几个路径设置步骤
restoredefaultpath;
addpath(genpath('D:\TOOL\MATLAB\r2020b_CN_x64\MATLAB2020b\toolbox\spm12'));
path='D:\TOOL\spm8-main';
addpath(genpath(path));
marsbarpath=('D:\TOOL\Marsbar\marsbar-0.45');
addpath(genpath(marsbarpath));
spm('defaults', 'FMRI'); 

% specify radius of spheres to build in mm
radiusmm = 6;%设置球形区域的半径为 6 毫米

load('E:\no_slice_timing\code_gPPI\spherelist_center.txt');%从文件 spherelist.txt 中加载 MNI 坐标数据，文件中每一行包含一个球体中心的 X, Y, Z 坐标。
ROInames = textread('E:\no_slice_timing\code_gPPI\labellist_center.txt', '%s'); %�@names of each ROI;读取文件 labellist.txt，该文件包含每个 ROI 的名称。
% Specify Output Folders for two sets of images (.img format and .mat format)
mkdir('img_6mm_center');%在当前工作目录下创建一个名为 img 的文件夹（目录）
mkdir('mat_6mm_center');
roi_dir_img = 'img_6mm_center/';%创建输出文件夹
roi_dir_mat = 'mat_6mm_center/';

% Make an img and an mat directory to save resulting ROIs

% Go through each set of coordinates from the specified file (line 2)
spherelistrows = length(spherelist_center(:,1));
for spherenumbers = 1:spherelistrows
    % maximum is specified as the centre of the sphere in mm in MNI space
    maximum = spherelist_center(spherenumbers,1:3);
    sphere_centre = maximum;
    sphere_radius = radiusmm;
    sphere_roi = maroi_sphere(struct('centre', sphere_centre, ...
        'radius', sphere_radius));
    
    % Define sphere name using coordinates生成球形区域的标签，格式为 X_Y_Z，并为每个球形 ROI 添加标签。
    coordsx = num2str(maximum(1));
    coordsy = num2str(maximum(2));
    coordsz = num2str(maximum(3));
    spherelabel = sprintf('%s_%s_%s', coordsx, coordsy, coordsz);
    sphere_roi = label(sphere_roi, spherelabel);
    
    nam=[num2str(radiusmm) 'mmsphere_' ROInames{spherenumbers} '_roi.mat'];
    % % save ROI as MarsBaR ROI file
    saveroi(sphere_roi, fullfile(roi_dir_mat, nam));
    % Save as image
    nam2=[num2str(radiusmm) 'mmsphere_' ROInames{spherenumbers} '_roi.img'];
    save_as_image(sphere_roi, fullfile(roi_dir_img, nam2));
end


