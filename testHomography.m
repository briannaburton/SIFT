clear all;
close all;

data = load('./DataSet01/Features.mat');

im00 = data.Features(1).xy;
im01 = data.Features(2).xy;
im02 = data.Features(3).xy;
im03 = data.Features(4).xy;

Model = "Euclidean";

% [0.86 -0.5 0; 0.5 0.86 0; 0 0 1]

% tform2 = fitgeotrans(im01,im00,'nonreflectivesimilarity');
% tform2.T

img = imread('./DataSet01/00.png');
H = transpose(H); %transpose for imwarp
tform1 = projective2d(H);
out = imwarp(img, tform1);
imshow(out);

[outproj, mean_proj] = perform_ransac(Ib, fixed, moving, 'Projective');
[outaff, mean_aff] = perform_ransac(Ib, fixed, moving, 'Affine');
[outsim, mean_sim] = perform_ransac(Ib, fixed, moving, 'Similarity');
[outeu, mean_eu] = perform_ransac(Ib, fixed, moving, 'Euclidean');

subplot(1,4,1);
imshow(outproj);
title('Projective');

subplot(1,4,2);
imshow(outaff);
title('Affine');

subplot(1,4,3);
imshow(outsim);
title('Similarity');

subplot(1,4,4);
imshow(outeu);
title('Euclidean');

function [output, mean_sq] = find_apply_homography(img_moving, img_fixed, fixed, moving, Model)
    H = computeHomography(fixed, moving, Model);
    tform = projective2d(transpose(H));
    output = imwarp(img_moving, tform);
    
    sq_diff = find_error_dist(H, fixed, moving);
    mean_sq = mean(sq_diff);

end