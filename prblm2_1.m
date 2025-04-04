boat_img = imread('boats.bmp');
boat_img = double(boat_img);  % Convert image to double for calculation

[U_boat, S_boat, V_boat] = svd(boat_img);

alpha_values = [0.5, 1, 1.2];

% Prepare the figure for displaying the images
figure;

for idx = 1:length(alpha_values)
    alpha = alpha_values(idx);
    
    % Reconstruct the image with non-linear filtering
    S_boat_weighted = S_boat .^ alpha;  % Apply non-linear weighting to singular values
    A_hat = U_boat * S_boat_weighted * V_boat';  % Reconstruct the image
    
    % Display the reconstructed image
    subplot(1, 3, idx);
    imshow(A_hat, []);
    title(['Alpha = ', num2str(alpha)]);
end
