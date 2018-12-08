clear all;
close all;
%% Finds and applies homography with RANSAC and RANSAC and normalization with all 
% four models and compare visually. Options for different visualizations

addpath('/Users/briannaburton/vlfeat-0.9.21/toolbox/demo');
% At the beginning of each session:
% run /Users/briannaburton/vlfeat-0.9.21/toolbox/vl_setup
% vl_version verbose

% Perform registration with all four models and compare visually
%% Import images and find matches

% Specify images to register
Ia = imread('./DataSet00/building1.jpg') ;
Ib = imread('./DataSet00/building2.jpg') ;

[fixed, moving] = get_matches(Ia, Ib);

%% Perfoms ransac and plots all four models with the same image

figure();
[outproj, mean_proj, Rfixed, Rregistered] = run_ransac(Ia, Ib, fixed, moving, 'Projective');
subplot(1,4,1);
C = imfuse(Ia,Rfixed, outproj, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('Projective');
[outaff, mean_aff, Rfixed, Rregistered] = run_ransac(Ia, Ib, fixed, moving, 'Affine');
subplot(1,4,2);
C = imfuse(Ia,Rfixed, outaff, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('Affine');
[outsim, mean_sim, Rfixed, Rregistered] = run_ransac(Ia, Ib, fixed, moving, 'Similarity');
subplot(1,4,3);
C = imfuse(Ia,Rfixed, outsim, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('Similarity');
[outeu, mean_eu, Rfixed, Rregistered] = run_ransac(Ia, Ib, fixed, moving, 'Euclidean');
subplot(1,4,4);
C = imfuse(Ia,Rfixed, outeu, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('Euclidean');

%% Performs ransac and ransac with norm and shows fixed, moving, and two results

figure();
subplot(1,4,1);
imshow(Ia);
title('Fixed Image');
subplot(1,4,2);
imshow(Ib);
title('Moving Image');
subplot(1,4,3);
[outproj, mean_proj, Rfixed, Rregistered] = run_ransac(Ia, Ib, fixed, moving, 'Projective');
C = imfuse(Ia,Rfixed, outproj, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('w/o Normalization');
subplot(1,4,4);
[outproj, mean_proj_norm, Rfixed, Rregistered] = run_ransac_norm(Ia, Ib, fixed, moving, 'Projective');
C = imfuse(Ia,Rfixed, outproj, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
title('w Normalization');

%% Perfom ransac w/o norm for a set of images

figure();
subplot(1,3,1);
Ia = imread('./DataSet00/building1.jpg') ;
Ib = imread('./DataSet00/building2.jpg') ;
[fixed, moving] = get_matches(Ia, Ib);
[outproj, mean_proj, Rfixed, Rregistered] = run_ransac(Ia, Ib, fixed, moving, 'Projective');
C = imfuse(Ia,Rfixed, outproj, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)

subplot(1,3,2);
Ia = imread('./DataSet00/tree1.jpg') ;
Ib = imread('./DataSet00/tree2.jpg') ;
[fixed, moving] = get_matches(Ia, Ib);
[outproj, mean_proj, Rfixed, Rregistered] = run_ransac(Ia, Ib, fixed, moving, 'Projective');
C = imfuse(Ia,Rfixed, outproj, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)

subplot(1,3,3);
Ia = imread('./DataSet00/oleh2.jpg') ;
Ib = imread('./DataSet00/oleh1.jpg') ;
[fixed, moving] = get_matches(Ia, Ib);
[outproj, mean_proj, Rfixed, Rregistered] = run_ransac_norm(Ia, Ib, fixed, moving, 'Projective');
C = imfuse(Ia,Rfixed, outproj, Rregistered,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
