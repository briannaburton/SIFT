clear all;
close all;

% Finds and applies homography without RANSAC or normalization with all 
% four models and compare visually

addpath('/Users/briannaburton/vlfeat-0.9.21/toolbox/demo');
% At the beginning of each session:
% run /Users/briannaburton/vlfeat-0.9.21/toolbox/vl_setup
% vl_version verbose

Ia = imread('./DataSet00/skin1.jpg'); %fixed
Ib = imread('./DataSet00/skin2.jpg'); %moving
peak_thresh = 0; 
edge_thresh = 10;

[fa,da] = vl_sift(im2single(rgb2gray(Ia)), 'PeakThresh', peak_thresh) ;
[fb,db] = vl_sift(im2single(rgb2gray(Ib)), 'PeakThresh', peak_thresh) ;

[matches, scores] = vl_ubcmatch(da,db) ;

[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

fixed = [xa; ya]';
moving = [xb; yb]';

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