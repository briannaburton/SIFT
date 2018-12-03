clear all;
close all;

addpath('/Users/briannaburton/vlfeat-0.9.21/toolbox/demo');

% Perform registration with all four models and compare visually

% Specify images to register
Ia = imread('./DataSet00/skin1.jpg') ;
Ib = imread('./DataSet00/skin2.jpg') ;

peak_thresh = 0;
edge_thresh = 10;

[fa,da] = vl_sift(im2single(rgb2gray(Ia)), 'PeakThresh', peak_thresh) ;
[fb,db] = vl_sift(im2single(rgb2gray(Ib)), 'PeakThresh', peak_thresh) ;

[matches, scores] = vl_ubcmatch(da,db) ;

[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(Ia,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;
fixed = [xa; ya]';
moving = [xb; yb]';

figure();
[outproj, mean_proj, Rfixed, Rregistered] = perform_ransac(Ia, Ib, fixed, moving, 'Projective');
subplot(1,4,1);
C = imfuse(Ia,Rfixed, outproj, Rregistered,'blend','Scaling','joint');
imshow(C)
title('Projective');
[outaff, mean_aff, Rfixed, Rregistered] = perform_ransac(Ia, Ib, fixed, moving, 'Affine');
subplot(1,4,2);
C = imfuse(Ia,Rfixed, outaff, Rregistered,'blend','Scaling','joint');
imshow(C)
title('Affine');
[outsim, mean_sim, Rfixed, Rregistered] = perform_ransac(Ia, Ib, fixed, moving, 'Similarity');
subplot(1,4,3);
C = imfuse(Ia,Rfixed, outsim, Rregistered,'blend','Scaling','joint');
imshow(C)
title('Similarity');
[outeu, mean_eu, Rfixed, Rregistered] = perform_ransac(Ia, Ib, fixed, moving, 'Euclidean');
subplot(1,4,4);
C = imfuse(Ia,Rfixed, outeu, Rregistered,'blend','Scaling','joint');
imshow(C)
title('Euclidean');

function [output, mean_sq, Rfixed, Rregistered] = perform_ransac(Ia, Ib, fixed, moving, Model)
    [fixed_norm, moving_norm, T_Features, T_Matches] = normalize_DLT(fixed, moving);
    H = computeHomographyRANSAC(fixed_norm, moving_norm, Model);
    % Denormalization
    H = inv(T_Features)*H*T_Matches
    tform = projective2d(transpose(H));
    
    sq_diff = find_error_dist(H, fixed, moving);
    mean_sq = mean(sq_diff);
    Rfixed = imref2d(size(Ia));
    [output, Rregistered] = imwarp(Ib,tform,'FillValues', 255,'OutputView',Rfixed);

end