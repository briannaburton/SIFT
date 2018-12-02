%addpath('/Users/briannaburton/vlfeat-0.9.21/toolbox/demo');


Ia = imread('retina1.png') ;
Ib = imread('retina2.png') ;

peak_thresh = 0.021;
edge_thresh = 10;

[fa,da] = vl_sift(im2single(rgb2gray(Ia)), 'PeakThresh', peak_thresh) ;
[fb,db] = vl_sift(im2single(rgb2gray(Ib)), 'PeakThresh', peak_thresh) ;

[matches, scores] = vl_ubcmatch(da,db) ;

[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;

figure(1) ; clf ;
imshow(cat(2, rgb2gray(Ia), rgb2gray(Ib))) ;
axis image off ;
vl_demo_print('sift_match_1', 1) ;

figure(2) ; clf ;
imshow(cat(2, rgb2gray(Ia), rgb2gray(Ib))) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(Ia,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(Ia,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis image off ;

vl_demo_print('sift_match_2', 1) ;