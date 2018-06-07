%% bag_of_words.m
% Copyright Kendall Lui
% June 07 2018
clear all;
clc;

addpath('./provided_code/');

framesdir = './frames/';
siftdir = './sift/';
load('kmeans200.mat');
means = means';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);

fprintf('reading %d total files...\n', length(fnames));

N = 100;  % to visualize a sparser set of the features

bag_matrix = zeros(length(fnames),1500);    
% Loop through all the data files found
for i=1:length(fnames)

    fprintf('reading frame %d of %d\n', i, length(fnames));
    
    % load that file
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'descriptors');
    
    distances = dist2(descriptors,means);
    [minDist1,minInd] = min(distances,[],2);
    bag_matrix(i,:) = histc(minInd,1:1500);
    
end
