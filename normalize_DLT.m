% Normalized Direct Linear Transform

function [norm_Features, norm_Matches, T_Features, T_Matches] = normalize_DLT(Features, Matches)
    % Features: Nx2 matrices storing the features [x, y] FIXED
    % Matches: Nx2 matrices storing the correspondences [x', y'] MOVING
    
    
    % Move features and Matches centered on origin
    mean_Features = mean(Features)
    mean_Matches = mean(Matches)
    norm_Features = Features - mean_Features;
    norm_Matches = Matches - mean_Matches;
    
    % Find mean distance to origin
    sd_Features = std(norm_Features)
    sd_Matches = std(norm_Matches)
    
    dist_Features = mean(sqrt(sum(Features.^2)));
    dist_Matches = mean(sqrt(sum(Matches.^2)));
    
    % Change average distance to sqrt(2)
    norm_Features = sqrt(2) * norm_Features/dist_Features;
    norm_Matches = sqrt(2) * norm_Matches/dist_Matches;
    
%     T_Features = [sqrt(2)/sd_Features(1), 0, -mean_Features(1);
%                   0, sqrt(2)/sd_Features(2), -mean_Features(2);
%                   0, 0, 1];
%     
%     T_Matches = [sqrt(2)/sd_Matches(1), 0, -mean_Matches(1);
%                   0, sqrt(2)/sd_Matches(2), -mean_Matches(2);
%                   0, 0, 1];
    T_Features = computeHomography(norm_Features, Features, "Similarity");
    T_Matches = computeHomography(norm_Matches, Matches, "Similarity");
    
end