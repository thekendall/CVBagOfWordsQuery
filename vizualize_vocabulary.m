%% vizualize_vocabulary.m
% Copyright Kendall Lui
% June 07 2018

% Setup
clear all;
close all;

addpath('./provided_code/');


%% Parameters
framesdir = './frames/';
siftdir = './sift/';


% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);

fprintf('reading %d total files...\n', length(fnames));


N = 50;  % to visualize a sparser set of the features
indices = randsample(length(fnames),N)

%% SIFT Description Matrix

siftMatrix = [];
% Loop through data files to create an array of descriptors.
for i=1:N

    %fprintf('reading frame %d of %d\n', i, length(fnames));
    % load that file
    fname = [siftdir '/' fnames(indices(i)).name];
    load(fname, 'descriptors');
    siftMatrix = horzcat(siftMatrix,descriptors');
end
fprintf('Calculating kmeans');

[membership,means,rms] = kmeansML(1500, siftMatrix);


