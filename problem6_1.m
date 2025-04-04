% Use truncated SVD with 20 most significant singular values
k = 20;  % Number of basis vectors

for i = 1:length(image_names)
    image = eval(image_names{i});  % Load the image
    [U, S, V] = svd(double(image));  % SVD of the image
    
    % Truncate the SVD by keeping only the top k singular values
    U_truncated = U(:, 1:k);
    S_truncated = S(1:k, 1:k);
    V_truncated = V(:, 1:k);
    
    % Reconstruct the image using the truncated SVD
    image_reconstructed = U_truncated * S_truncated * V_truncated';
    
    % Display the original and reconstructed images
    figure;
    subplot(1, 2, 1);
    imshow(image, []);
    title(['Original ' image_names{i}]);
    
    subplot(1, 2, 2);
    imshow(uint8(image_reconstructed), []);
    title(['Reconstructed ' image_names{i}]);
end
