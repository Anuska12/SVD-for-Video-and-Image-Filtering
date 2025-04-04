% Read the image files
boat_image = imread('boatNoise.bmp');
baboon_image = imread('baboonNoise.bmp');

% Convert to grayscale if images are RGB
if size(boat_image, 3) == 3
    boat_image = rgb2gray(boat_image);
end
if size(baboon_image, 3) == 3
    baboon_image = rgb2gray(baboon_image);
end

% Set parameters
R = 8; % Number of singular values to keep
step_size = 5; % Rotation step size
max_angle = 360; % Maximum angle for rotation

% Function to perform truncated SVD and rotate back
function A_rec = truncated_SVD_rotation(image, R, step_size, max_angle)
    [height, width] = size(image);
    A_rec_avg = zeros(height, width); % Initialize the averaged result

    % Perform rotations and truncated SVD
    for t = 0:step_size:max_angle
        % Rotate image by angle t
        A_t = imrotate(image, t, 'bilinear', 'crop');
        
        % Perform SVD on the rotated image
        [U, S, V] = svd(double(A_t));
        
        % Keep the first R singular values (truncated SVD)
        U_R = U(:, 1:R);
        S_R = S(1:R, 1:R);
        V_R = V(:, 1:R);
        
        % Reconstruct the image using truncated SVD
        A_rec_t = U_R * S_R * V_R';
        
        % Rotate the reconstructed image back
        A_rec_t = imrotate(A_rec_t, -t, 'bilinear', 'crop');
        
        % Accumulate the results for averaging
        A_rec_avg = A_rec_avg + A_rec_t;
    end
    
    % Average the rotated and reconstructed images
    A_rec = A_rec_avg / ((max_angle / step_size) + 1);
end

% Apply the truncated SVD method to both images
boat_rec = truncated_SVD_rotation(boat_image, R, step_size, max_angle);
baboon_rec = truncated_SVD_rotation(baboon_image, R, step_size, max_angle);

% Display the results
figure;
subplot(1, 2, 1);
imshow(boat_rec, []);
title('Reconstructed Boat Image');

subplot(1, 2, 2);
imshow(baboon_rec, []);
title('Reconstructed Baboon Image');

% Save the results
imwrite(boat_rec, 'boat_rec.bmp');
imwrite(baboon_rec, 'baboon_rec.bmp');
