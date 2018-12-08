function [fixed, moving] = get_matches(Ia, Ib)
    % Helper function to obtain matches using vlfeat with two images
    
    % Inputs:
    % Ia: fixed image
    % Ib: moving image
    
    % Returns:
    % fixed: Nx2 coordinates of correspondences in image Ia [x, y]
    % moving: Nx2 coorinates of correspondences in image Ib [x', y']
    
    peak_thresh = 0;

    [fa,da] = vl_sift(im2single(rgb2gray(Ia)), 'PeakThresh', peak_thresh) ;
    [fb,db] = vl_sift(im2single(rgb2gray(Ib)), 'PeakThresh', peak_thresh) ;

    [matches, scores] = vl_ubcmatch(da,db) ;

    [drop, perm] = sort(scores, 'descend') ;
    matches = matches(:, perm) ;


    xa = fa(1,matches(1,:)) ;
    xb = fb(1,matches(2,:)) ;
    ya = fa(2,matches(1,:)) ;
    yb = fb(2,matches(2,:)) ;
    fixed = [xa; ya]';
    moving = [xb; yb]';
end