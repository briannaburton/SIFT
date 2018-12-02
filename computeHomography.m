function H = computeHomography(Features, Matches, Model)
    % Features: Nx2 matrices storing the features [x, y] FIXED
    % Matches: Nx2 matrices storing the correspondences [x', y'] MOVING
    % Model: string specifying a transformation model
    
    N = length(Features);
    if length(Features) ~= length(Matches)
        error('Length of features does not match length of matches');
    end

    % Format features array 
    Features_x = Features(:,1);
    Features_y = Features(:,2);
    Features_x = reshape([Features_x'; zeros(size(Features_x'))],[],1);
    Features_y = reshape([Features_y'; zeros(size(Features_y'))],[],1);
    Features_y = padarray(Features_y,1,0,'pre');
    Features_y(end)=[];
    Features_reform = Features_x + Features_y;
    
    if Model == "Projective"
        % Case 8 DOF
        M = zeros(2*N,8);
        for i=1:N
            x_prime = Matches(i,1);
            y_prime = Matches(i,2);
            x = Features(i,1);
            y = Features(i,2);
            M((2*i)-1,:) = [x_prime y_prime 1 0 0 0 -x*x_prime -x*y_prime];
            M((2*i),:) = [0 0 0 x_prime y_prime 1 -y*x_prime -y*y_prime];
        end
        
        % Least squares solution approximation
        H = M \ Features_reform;
        H = padarray(H,1,1,'post');
        H = [H(1) H(2) H(3); H(4) H(5) H(6); H(7) H(8) H(9)];
        
    elseif Model == "Euclidean"
        % Case 3 DOF
        % Solve as similarity
        M = zeros(2*N,4);
        for i=1:N
            x_prime = Matches(i,1);
            y_prime = Matches(i,2);
            M((2*i)-1,:) = [x_prime -y_prime 1 0];
            M((2*i),:)= [y_prime x_prime 0 1];
        end
        % Least squares solution approximation
        H = M \ Features_reform;
        a = H(1);
        b = H(2);
        c = H(3);
        d = H(4);
        
        % Solve for scaling factor
        s = sqrt(a^2 + b^2);
        a = a/s;
        b = b/s;
        
        H = [a -b c; b a d; 0 0 1];
        
    elseif Model == "Similarity"
        % Case 4 DOF
        M = zeros(2*N,4);
        for i=1:N
            x_prime = Matches(i,1);
            y_prime = Matches(i,2);
            M((2*i)-1,:) = [x_prime -y_prime 1 0];
            M((2*i),:)= [y_prime x_prime 0 1];
        end
        
        % Least squares solution approximation
        H = M \ Features_reform;
        H = [H(1) -H(2) H(3); H(2) H(1) H(4); 0 0 1];
        
        
    elseif Model == "Affine"
        % Case 6 DOF
        M = zeros(2*N,6);
        for i=1:N
            x_prime = Matches(i,1);
            y_prime = Matches(i,2);
            M((2*i)-1,:) = [x_prime y_prime 1 0 0 0];
            M((2*i),:) = [0 0 0 x_prime y_prime 1];
        end
        
        % Least squares solution approximation
        H = M \ Features_reform;
        H = [H(1) H(2) H(3); H(4) H(5) H(6); 0 0 1];
    end


end