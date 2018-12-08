clear all;
close all;
% Finds a homography from data only with all four models and compare visually

addpath('/Users/briannaburton/vlfeat-0.9.21/toolbox/demo');
% At the beginning of each session:
% run /Users/briannaburton/vlfeat-0.9.21/toolbox/vl_setup
% vl_version verbose


data = load('./DataSet01/Features.mat');
Ia = imread('./DataSet01/00.png');
Ib = imread('./DataSet01/01.png');

im00 = data.Features(1).xy;
im01 = data.Features(2).xy;
im02 = data.Features(3).xy;
im03 = data.Features(4).xy;

fixed = im00;
moving = im01;

figure();
[outproj, mean_proj, Rfixed, Rregistered] = compute_apply_H(Ia, Ib, fixed, moving, 'Projective');
subplot(1,4,1);
C = imfuse(Ia,Rfixed, outproj, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('Projective');
[outaff, mean_aff, Rfixed, Rregistered] = compute_apply_H(Ia, Ib, fixed, moving, 'Affine');
subplot(1,4,2);
C = imfuse(Ia,Rfixed, outaff, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('Affine');
[outsim, mean_sim, Rfixed, Rregistered] = compute_apply_H(Ia, Ib, fixed, moving, 'Similarity');
subplot(1,4,3);
C = imfuse(Ia,Rfixed, outsim, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('Similarity');
[outeu, mean_eu, Rfixed, Rregistered] = compute_apply_H(Ia, Ib, fixed, moving, 'Euclidean');
subplot(1,4,4);
C = imfuse(Ia,Rfixed, outeu, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('Euclidean');


function [output, mean_sq, Rfixed, Rregistered] = compute_apply_H(Ia, Ib, fixed, moving, Model)
    H = computeHomography(fixed, moving, Model);
    tform = projective2d(transpose(H));
    sq_diff = find_error_dist(H, fixed, moving);
    mean_sq = mean(sq_diff);
    Rfixed = imref2d(size(Ia));
    [output, Rregistered] = imwarp(Ib,tform,'FillValues', 255,'OutputView',Rfixed);
    
end