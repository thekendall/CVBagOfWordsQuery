%% full_frame_queries.m
%  Copyright Kendall Lui
% June 07 2018

clear all;
clc;
close all;

addpath('./provided_code/');

framesdir = './frames/';
siftdir = './sift/';

load('bag_matrix.mat');

queryFrames=[5400,900,5000]; %18,900,5000

%% Compute Similarity - Normalized Scalar Product

for a=1:length(queryFrames)
    queryFrame = queryFrames(a);
    
    fnames = dir([siftdir '/*.mat']);
    fname = [siftdir '/' fnames(queryFrame).name];
    load(fname);
    imname = [framesdir '/' imname]; % add the full path
    im = imread(imname);
    im = rgb2gray(im);
    
    % Select Corresponding Bag of Words
    queryBOW = bag_matrix(queryFrame,:);
    queryMatrix = repmat(queryBOW', 1, length(bag_matrix));
    
    dot_prod = dot(queryMatrix, bag_matrix');
    vec_norm  = vecnorm(bag_matrix');
    query_norm = norm(queryBOW);
    norm_prod = vec_norm*query_norm;
    
    similarity = dot_prod./norm_prod;
    similarity(isnan(similarity)) = 0;
    
    [sortedDistances,similarImages] = sort(similarity,'descend');
    figure
    
    subplot(2,3,1);
    fnames = dir([siftdir '/*.mat']);
    fname = [siftdir '/' fnames(similarImages(1)).name];
    load(fname);
    name  = strrep(imname,'_','\_');
    imname = [framesdir '/' imname]; % add the full path
    im = imread(imname);
    imshow(im);
    title(strcat('Query Image: ',name));
    
    for i=2:6
        subplot(2,3,i);
        
        fname = [siftdir '/' fnames(similarImages(i)).name];
        load(fname);
        name  = strrep(imname,'_','\_');
        imname = [framesdir '/' imname]; % add the full path
        im = imread(imname);
        imshow(im);
        title({strcat('Result: ', num2str(i-1)),name,strcat('Distance: ',num2str(sortedDistances(i)))});
    end
end
