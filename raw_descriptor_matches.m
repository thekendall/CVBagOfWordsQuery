%% raw_descriptor_matches.m
% Copyright Kendall Lui
% June 6 2018

% Setup
clear all
close all

addpath('./provided_code/');
load('twoFrameData.mat');

%% Parameters

threshold = 0.7; % d1/d2


%% Select Region
imshow(im1);
oninds = selectRegion(im1,positions1);


%% Finds nearest Euclidean distances

regionalDescriptors = descriptors1(oninds,:);
distances = dist2(regionalDescriptors,descriptors2);
[minDist1,minInd] = min(distances,[],2);
distances(:,minInd) = inf;
minDist2 = min(distances,[],2);

%% Distance Threshold Ratio
minDist1 = sqrt(minDist1);
minDist2 = sqrt(minDist2);

% Remove
a = find(minDist1./minDist2 < threshold)
minInd = minInd(a);
%%
figure;
subplot(1,2,1);
imshow(im1);
displaySIFTPatches(positions1(oninds,:), scales1(oninds), orients1(oninds), im1); 
strTitle = strcat('im1 and selected descriptors');
title(strTitle);


subplot(1,2,2);
imshow(im2);
displaySIFTPatches(positions2(minInd,:), scales2(minInd), orients2(minInd), im2); 
strTitle = strcat('im2 matched features with d1/d2<', num2str(threshold));
title(strTitle);

