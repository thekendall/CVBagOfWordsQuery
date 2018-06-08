%% vizualize_vocabulary.m
% Copyright Kendall Lui
% June 07 2018

%   Description: Attempts to load 'kmeans.mat' file. If the file is not
%   found kmeans will be calculated using N=300 files from the sift
%   directory. Once the kmeans file is loaded or kmeans is generated two of
%   the words are vizualized.

% Setup
clc;
clear all;
close all;

addpath('./provided_code/');
framesdir = './frames/';
siftdir = './sift/';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);


%% Calculate or load kmeans
if exist('kmeans.mat', 'file') == 2
    % load kmeans.mat
    fprintf('kmeans.mat file found.\n')
    fprintf('*kmeans.mat loading kmeans.mat\n')
    load('kmeans.mat');
else
    % Calculate kmeans

    fprintf('kmeans.mat file not found.\n')

    % Loop through data files to create an array of descriptors with random
    % selection.
    
    siftMatrix = [];
    N = 300;  % Number of samples
    indices = randsample(length(fnames),N);
    for i=1:N
        fname = [siftdir '/' fnames(indices(i)).name];
        load(fname, 'descriptors');
        siftMatrix = horzcat(siftMatrix,descriptors');
    end
    fprintf('*Calculating kmeans\n');
    
    [membership,means,rms] = kmeansML(1500, siftMatrix);
    kmeans = means';
    fprintf("**kmeans k=1500 N=%d rms=%d\n",N,rms);
    clear means
end
%% Visualize kmeans words
fprintf('Begin Vizualizing Vocabulary\n');

word_count1 = 0;
patches1 = [];
patch_row1 = [];

word_count2 = 0;
patches2 = [];
patch_row2 = [];

% Loop through data files searching for words.
indices = randsample(length(fnames),length(fnames));

for i=1:length(fnames)
    if word_count1 == 25 && word_count2 == 25
        break
    end
    %fprintf('reading frame %d of %d\n', i, length(fnames));
    % load that file
    fname = [siftdir '/' fnames(indices(i)).name];
    load(fname);
    
    distances = dist2(descriptors,kmeans);
    [minDist1,minInd] = min(distances,[],2);
    word1 = find(minInd == 700,1);
    word2 = find(minInd == 587,1);
    imname = [framesdir '/' imname]; % add the full path
    im = imread(imname);
    im = rgb2gray(im);
    
    % Creates two images made up of 25 patches.
    
    % Check if word1 is in the current picture and add it to the image.
    for a=1:length(word1)
        if word_count1 == 25
            break
        end
        % Extract Patch and resize to standard size
        patch = getPatchFromSIFTParameters(positions(word1(a),:), scales(word1(a)), orients(word1(a)), im);
        patchResize = imresize(patch,[100,100]);
        
        % Add the patch to the current row.
        patch_row1 = horzcat(patch_row1, patchResize);
        word_count1 = word_count1+1;
        if size(patch_row1,2) == 500
            patches1 = [patches1; patch_row1];
            patch_row1 = [];
            break
        end
        %patch_row1 = horzcat(patch_row1,edges);
    end
    
    % Check if word2 is in the current picture and add it to the image.
    for a=1:length(word2)
        if word_count2 == 25
            break
        end
        % Extract Patch and resize to standard size
        patch = getPatchFromSIFTParameters(positions(word2(a),:), scales(word2(a)), orients(word2(a)), im);
        patchResize = imresize(patch,[100,100]);
        
        % Add the patch to the current row.
        patch_row2 = horzcat(patch_row2, patchResize);
        word_count2 = word_count2+1;
        if size(patch_row2,2) == 500
            patches2 = [patches2; patch_row2];
            patch_row2 = [];
            break
        end
    end
end

figure
subplot(1,2,1);
imshow(patches1);
title('Word 700');

subplot(1,2,2);
imshow(patches2)
title('Word 587')


