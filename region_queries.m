%% Region Queries
%  Copyright Kendall Lui
%  June 07 2018

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
load('kmeans.mat');

queryFrames=[1600]; %18,900,5000
fnames = dir([siftdir '/*.mat']);

%% Compute Similarity - Normalized Scalar Product

for a=1:length(queryFrames)
    queryFrame = queryFrames(a);
    
    fname = [siftdir '/' fnames(queryFrame).name];
    load(fname);
    imname = [framesdir '/' imname]; % add the full path
    im = imread(imname);
    
    oninds = selectRegion(im,positions);
        im = rgb2gray(im);

    distances = dist2(descriptors(oninds,:),kmeans);
    [~,minInd] = min(distances,[],2);

    
    % Select Corresponding Bag of Words
    queryBOW = histc(minInd,1:1500)';
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
    
    for i=1:5
        subplot(2,3,i+1);
        
        fname = [siftdir '/' fnames(similarImages(i)).name];
        load(fname);
        name  = strrep(imname,'_','\_');
        imname = [framesdir '/' imname]; % add the full path
        im = imread(imname);
        imshow(im);
        title({strcat('Result: ', num2str(i)),name,strcat('Distance: ',num2str(sortedDistances(i)))});
    end
end
