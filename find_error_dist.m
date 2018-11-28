function sq_diff = find_error_dist(H, Features, Matches)
%find_error_dist returns distance between fixed (Features) and
%transformed moving (Matches) points
%   H is a homagrphy matrix
    % Apply homography 
    Homogeneous_Matches = [Matches'; ones(1,length(Matches))];
    Transformed_Matches = H * Homogeneous_Matches;

    % Calculate errors
    Transformed_Matches = Transformed_Matches(1:2,:)';
    sq_diff = (Features - Transformed_Matches).^2;
    sq_diff = sqrt(sum(sq_diff, 2));
end

