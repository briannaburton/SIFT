clear all;
close all;

% At the beginning of each session:
% run /Users/briannaburton/vlfeat-0.9.21/toolbox/vl_setup
% vl_version verbose

addpath('/Users/briannaburton/vlfeat-0.9.21/toolbox/demo');

% we need to normalize our input data to make it look better
% we can do histogram equalization or normalize image values to be in the
% same range

% Specify images to register
Ia = imread('./DataSet00/retina1.png') ;
Ib = imread('./DataSet00/retina2.png') ;

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

Model = "Projective";
Normalization = true;

if Normalization == true
    % Extend the algorithm with a normalization and a denormalization step
    [fixed_norm, moving_norm, T_Features, T_Matches] = normalize_DLT(fixed, moving);
    H = computeHomography(fixed_norm, moving_norm, Model);
    Hran = computeHomographyRANSAC(fixed_norm, moving_norm, Model);
    % Denormalization
    H = inv(T_Features)*H*T_Matches
    Hran = inv(T_Features)*Hran*T_Matches
    
elseif Normalization == false
    H = computeHomography(fixed, moving, Model);
    Hran = computeHomographyRANSAC(fixed, moving, Model);
end

img = Ib; % image to transform
H_imwarp = transpose(H); %transpose for imwarp
Hran_imwarp = transpose(Hran); %transpose for imwarp
tform1 = projective2d(H_imwarp);
tform2 = projective2d(Hran_imwarp);
Rfixed = imref2d(size(Ia));
[out1, Rregistered1] = imwarp(Ib,tform1,'FillValues', 255,'OutputView',Rfixed);
[out2, Rregistered2] = imwarp(Ib,tform2,'FillValues', 255,'OutputView',Rfixed);

subplot(2,2,1);
imshow(Ia);
title('Fixed Image');

subplot(2,2,2);
imshow(Ib);
title('Moving Image');

subplot(2,2,3);
imshow(out1);
title('Transformed Moving Image H');

subplot(2,2,4);
imshow(out2);
title('Transformed Moving Image H Ransac');

figure();
C = imfuse(Ia,Rfixed, out2, Rregistered1,'blend','Scaling','joint');
imshow(C)
title('Overlay of RANSAC moving and fixed images');

err = find_error_dist(H, fixed, moving);
err_ran = find_error_dist(Hran, fixed, moving);

figure();
% 'All matches', 'RANSAC'
plot([1:length(err)], err, 'o', [1:length(err_ran)], err_ran, 'o');
legend('No RANSAC', 'With RANSAC');
