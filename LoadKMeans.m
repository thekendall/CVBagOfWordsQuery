%% LoadKMeans.m
% Copyright Kendall Lui
% June 07 2018

% Setup
clc;
clear all;
close all;

addpath('./provided_code/');

load('kmeans200.mat');

%% Parameters
framesdir = './frames/';
siftdir = './sift/';


% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);

N = 300;  % to visualize a sparser set of the features
indices = randsample(length(fnames),N);

%% SIFT Description Matrix
fprintf('Generating SiftMatrix')
N = 100;  % to visualize a sparser set of the features
indices = randsample(length(fnames),N)
means = means';

word_count = 0;
patches1 = [] 
edges = uint8(ones(100,5));
patch_row = [];

% Loop through data files to create an array of descriptors.
for i=1:N

    %fprintf('reading frame %d of %d\n', i, length(fnames));
    % load that file
    fname = [siftdir '/' fnames(indices(i)).name];
    load(fname);
    
    distances = dist2(descriptors,means);
    [minDist1,minInd] = min(distances,[],2);
    word1 = find(minInd == 600);
    words2 = find(minInd == 587);
    imname = [framesdir '/' imname]; % add the full path
    im = imread(imname);
    im = rgb2gray(im);
    
    for a=1:(length(word1) > 1)
        if word_count == 25
            break
        end

        patch = getPatchFromSIFTParameters(positions(word1(a),:), scales(word1(a)), orients(word1(a)), im);
        patchResize = imresize(patch,[100,100]);
        patch_row = horzcat(patch_row, patchResize);
        
        word_count = word_count+1;
        if size(patch_row,2) == 520;
            patches1 = [patches1; patch_row];
            patch_row = []
            break
        end
        patch_row = horzcat(patch_row,edges);

    end
    imshow(patches1)
end

%% histogram 587,352


