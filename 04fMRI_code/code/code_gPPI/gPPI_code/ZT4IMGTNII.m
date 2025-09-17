%% 定义根路径
clear all;clc
restoredefaultpath;
rootPath = 'E:\no_slice_timing\data';
%rootPath = 'G:\no_slice_timing\data';
addpath(genpath('D:\TOOL\spm12')); 
% addpath(genpath("D:\TOOL\matlab_toolbox\spm12"));

% 获取根路径下所有以 sub 开头的文件夹
subFolders = dir(fullfile(rootPath, 'sub*'));
subFolders = subFolders([subFolders.isdir]); % 只保留文件夹

%% PPI_6mmsphere_PPC_26_-60_40_roi
for j = 1:length(subFolders)
    % 构建每个子文件夹下的特定路径
    subFolderPath = fullfile(rootPath, subFolders(j).name, 'NO_slice_analysis_8conds_1noRT_dur0_f128', 'PPI_6mmsphere_PPC_29_-58_41_roi');
    
    % 检查该路径是否存在
    if exist(subFolderPath, 'dir')
        % 定义输入和输出路径
        inputPath = subFolderPath;
        outputPath = subFolderPath;
        
        % 检查输出路径是否存在，如果不存在则创建
        if ~exist(outputPath, 'dir')
            mkdir(outputPath);
        end
        
        % 获取输入路径下所有以 .img 结尾的文件
        inputFiles = dir(fullfile(inputPath, '*.img'));
        
        % 遍历所有 .img 文件并进行转换
        for i = 1:length(inputFiles)
            % 获取当前 .img 文件的完整路径
            inputFile = fullfile(inputPath, inputFiles(i).name);
            
            % 提取文件名（不包含扩展名）
            [~, fname, ~] = fileparts(inputFile);
            
            % 构建输出 .nii 文件的完整路径
            outputFile = fullfile(outputPath, [fname, '.nii']);
            
            % 读取 .img 文件的头信息和图像数据
            V = spm_vol(inputFile);
            ima = spm_read_vols(V);
            
            % 修改结构体中的文件名
            V.fname = outputFile;
            
            % 写入 .nii 文件
            spm_write_vol(V, ima);
            
            % 显示转换信息
            %fprintf('已将 %s 转换为 %s\n', inputFile, outputFile);
        end
    end
end

%% PPI_6mmsphere_mPFC_6_50_14_roi
for k = 1:length(subFolders)
    
    % 构建每个子文件夹下的特定路径
    subFolderPath = fullfile(rootPath, subFolders(k).name,...
        'NO_slice_analysis_8conds_1noRT_dur0_f128','PPI_6mmsphere_mPFC_3_52_15_roi');
    
    % 检查该路径是否存在
    if exist(subFolderPath, 'dir')
        % 定义输入和输出路径
        inputPath = subFolderPath;
        outputPath = subFolderPath;
        
        % 检查输出路径是否存在，如果不存在则创建
        if ~exist(outputPath, 'dir')
            mkdir(outputPath);
        end
        
        % 获取输入路径下所有以 .img 结尾的文件
        inputFiles = dir(fullfile(inputPath, '*.img'));
        
        % 遍历所有 .img 文件并进行转换
        for i = 1:length(inputFiles)
            % 获取当前 .img 文件的完整路径
            inputFile = fullfile(inputPath, inputFiles(i).name);
            
            % 提取文件名（不包含扩展名）
            [~, fname, ~] = fileparts(inputFile);
            
            % 构建输出 .nii 文件的完整路径
            outputFile = fullfile(outputPath, [fname, '.nii']);
            
            % 读取 .img 文件的头信息和图像数据
            V = spm_vol(inputFile);
            ima = spm_read_vols(V);
            
            % 修改结构体中的文件名
            V.fname = outputFile;
            
            % 写入 .nii 文件
            spm_write_vol(V, ima);
            
            % 显示转换信息
            %fprintf('已将 %s 转换为 %s\n', inputFile, outputFile);
        end
    end
end

%% PPI_6mmsphere_dlPFC_-54_20_30_roi
for l = 1:length(subFolders)
    % 构建每个子文件夹下的特定路径
    subFolderPath = fullfile(rootPath, subFolders(l).name, 'NO_slice_analysis_8conds_1noRT_dur0_f128', 'PPI_6mmsphere_dlPFC_-39_10_35_roi');
    
    % 检查该路径是否存在
    if exist(subFolderPath, 'dir')
        % 定义输入和输出路径
        inputPath = subFolderPath;
        outputPath = subFolderPath;
        
        % 检查输出路径是否存在，如果不存在则创建
        if ~exist(outputPath, 'dir')
            mkdir(outputPath);
        end
        
        % 获取输入路径下所有以 .img 结尾的文件
        inputFiles = dir(fullfile(inputPath, '*.img'));
        
        % 遍历所有 .img 文件并进行转换
        for i = 1:length(inputFiles)
            % 获取当前 .img 文件的完整路径
            inputFile = fullfile(inputPath, inputFiles(i).name);
            
            % 提取文件名（不包含扩展名）
            [~, fname, ~] = fileparts(inputFile);
            
            % 构建输出 .nii 文件的完整路径
            outputFile = fullfile(outputPath, [fname, '.nii']);
            
            % 读取 .img 文件的头信息和图像数据
            V = spm_vol(inputFile);
            ima = spm_read_vols(V);
            
            % 修改结构体中的文件名
            V.fname = outputFile;
            
            % 写入 .nii 文件
            spm_write_vol(V, ima);
            
            % 显示转换信息
            %fprintf('已将 %s 转换为 %s\n', inputFile, outputFile);
        end
    end
end

%% PPI_6mmsphere_dACC_-8_20_46_roi
for m = 1:length(subFolders)
    % 构建每个子文件夹下的特定路径
    subFolderPath = fullfile(rootPath, subFolders(m).name, 'NO_slice_analysis_8conds_1noRT_dur0_f128', 'PPI_6mmsphere_dACC_-3_21_45_roi');
    
    % 检查该路径是否存在
    if exist(subFolderPath, 'dir')
        % 定义输入和输出路径
        inputPath = subFolderPath;
        outputPath = subFolderPath;
        
        % 检查输出路径是否存在，如果不存在则创建
        if ~exist(outputPath, 'dir')
            mkdir(outputPath);
        end
        
        % 获取输入路径下所有以 .img 结尾的文件
        inputFiles = dir(fullfile(inputPath, '*.img'));
        
        % 遍历所有 .img 文件并进行转换
        for i = 1:length(inputFiles)
            % 获取当前 .img 文件的完整路径
            inputFile = fullfile(inputPath, inputFiles(i).name);
            
            % 提取文件名（不包含扩展名）
            [~, fname, ~] = fileparts(inputFile);
            
            % 构建输出 .nii 文件的完整路径
            outputFile = fullfile(outputPath, [fname, '.nii']);
            
            % 读取 .img 文件的头信息和图像数据
            V = spm_vol(inputFile);
            ima = spm_read_vols(V);
            
            % 修改结构体中的文件名
            V.fname = outputFile;
            
            % 写入 .nii 文件
            spm_write_vol(V, ima);
            
            % 显示转换信息
            %fprintf('已将 %s 转换为 %s\n', inputFile, outputFile);
        end
    end
end