%% 音频自动切割程序
clc;
clear;
close all;

%% ================== 参数设置 ==================
% 输入音频文件
inputFile = '2026年08月18日 09点00分.mp3';

% 每段音频长度（分钟）
segmentMinutes = 30;

% 输出文件夹
outputFolder = 'audio_segments';

%% ================== 创建输出文件夹 ==================
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

%% ================== 读取音频 ==================
[x, Fs] = audioread(inputFile);

% 音频总时长
totalSamples = size(x, 1);
totalTime = totalSamples / Fs;

fprintf('采样率：%d Hz\n', Fs);
fprintf('音频总时长：%.2f min\n', totalTime / 60);

%% ================== 计算切割参数 ==================
segmentSamples = round(segmentMinutes * 60 * Fs);

numSegments = ceil(totalSamples / segmentSamples);

fprintf('每段时长：%d min\n', segmentMinutes);
fprintf('预计生成：%d 个文件\n\n', numSegments);

%% ================== 开始切割 ==================
[~, baseName, ~] = fileparts(inputFile);

for i = 1:numSegments

    % 当前段起始位置
    startSample = (i - 1) * segmentSamples + 1;

    % 当前段结束位置
    endSample = min(i * segmentSamples, totalSamples);

    % 截取音频
    segment = x(startSample:endSample, :);

    % 文件名
    outputFile = fullfile(outputFolder, ...
        sprintf('%s_%03d.wav', baseName, i));

    % 保存
    audiowrite(outputFile, segment, Fs);

    % 时间信息
    startTime = (startSample - 1) / Fs;
    endTime = endSample / Fs;

    fprintf('第 %03d 段：%s ~ %s\n', ...
        i, ...
        datestr(seconds(startTime), 'HH:MM:SS'), ...
        datestr(seconds(endTime), 'HH:MM:SS'));
end

fprintf('\n音频切割完成！\n');
fprintf('文件保存在：%s\n', outputFolder);

%%
inputFile = 'C:\Users\11377\Downloads\audio_segments\2026年08月18日 09点00分_004.wav';
outputFile = 'C:\Users\11377\Downloads\audio_segments\2026年08月18日 09点00分_004.mp3';

cmd = sprintf( ...
    'ffmpeg -i "%s" -b:a 128k "%s" -y', ...
    inputFile, outputFile);

system(cmd);