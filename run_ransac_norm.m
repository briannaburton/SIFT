function [output, mean_sq, Rfixed, Rregistered] = run_ransac_norm(Ia, Ib, fixed, moving, Model)
    % Helper function to compute a homography with RANSAC with normalized 
    % data and apply it to the moving image. It is not necessary to provide
    % normalized data
    
    % Inputs:
    % Ia: fixed image
    % Ib: moving image
    % fixed: Nx2 matrices storing the features [x, y] FIXED
    % moving: Nx2 matrices storing the correspondences [x', y'] MOVING
    % Model: string specifying a transformation model
    
    % Returns:
    % output: moving image transformed to fixed frame
    % mean_sq: mean of projection error
    % Rfixed: reference to fixed image in 2d space
    % Rregistered: reference to transformed moving image relative to fixed
    
    [fixed_norm, moving_norm, T_Features, T_Matches] = normalize_DLT(fixed, moving);
    H = computeHomographyRANSACnorm(fixed_norm, moving_norm, Model);
    % Denormalization
    H = inv(T_Features)*H*T_Matches;
    tform = projective2d(transpose(H));
    
    sq_diff = find_error_dist(H, fixed, moving);
    mean_sq = mean(sq_diff);
    Rfixed = imref2d(size(Ia));
    [output, Rregistered] = imwarp(Ib,tform,'FillValues', 255,'OutputView',Rfixed);

end