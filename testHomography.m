clear all;
close all;

data = load('./DataSet01/Features.mat');

im00 = data.Features(1).xy;
im01 = data.Features(2).xy;
im02 = data.Features(3).xy;
im03 = data.Features(4).xy;

Model = "Euclidean";

%H = computeHomography(im03, im00, Model)
H = computeHomography(im03, im00, Model)

% [0.86 -0.5 0; 0.5 0.86 0; 0 0 1]

% tform2 = fitgeotrans(im01,im00,'nonreflectivesimilarity');
% tform2.T

img = imread('./DataSet01/00.png');
H = transpose(H); %transpose for imwarp
tform1 = projective2d(H);
out = imwarp(img, tform1);
imshow(out);
