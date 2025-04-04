% Step 1: Load the noisy images and ensure they are grayscale (2D)
boat_noise = imread('boatNoise.bmp');
baboon_noise = imread('baboonNoise.bmp');

% If the images are colored (RGB), convert them to grayscale
if size(boat_noise, 3) == 3
    boat_noise = rgb2gray(boat_noise);
end
if size(baboon_noise, 3) == 3
    baboon_noise = rgb2gray(baboon_noise);
end

% Step 2: Convert images to double precision for SVD
boat_noise = double(boat_noise);
baboon_noise = double(baboon_noise);

% Step 3: Apply SVD to each noisy image
[U_boat, S_boat, V_boat] = svd(boat_noise);
[U_baboon, S_baboon, V_baboon] = svd(baboon_noise);

% Step 4: Initialize parameters
threshold_SNR = 20;  % Desired SNR threshold
sigma_noise = 20;  % Assume noise standard deviation

% Function to calculate the SNR
calculate_SNR = @(S, R) 20 * log10(sum(diag(S(1:R, 1:R)).^2 - sigma_noise^2) / ((size(S, 1) - R) * sigma_noise^2));

% Step 5: Find optimal R for each image
R_opt_boat = 0; R_opt_baboon = 0;
min_diff_boat = inf; min_diff_baboon = inf;
SNR_boat = 0; SNR_baboon = 0;

% Check the SNR for various values of R
for R = 1:min(size(S_boat, 1), size(S_baboon, 1))
    % Calculate SNR for boat image
    SNR_temp_boat = calculate_SNR(S_boat, R);
    if abs(SNR_temp_boat - threshold_SNR) < min_diff_boat
        min_diff_boat = abs(SNR_temp_boat - threshold_SNR);
        R_opt_boat = R;
        SNR_boat = SNR_temp_boat;
    end
    
    % Calculate SNR for baboon image
    SNR_temp_baboon = calculate_SNR(S_baboon, R);
    if abs(SNR_temp_baboon - threshold_SNR) < min_diff_baboon
        min_diff_baboon = abs(SNR_temp_baboon - threshold_SNR);
        R_opt_baboon = R;
        SNR_baboon = SNR_temp_baboon;
    end
end

% Step 6: Truncate the SVD for the optimal R values
X_boat_truncated = U_boat(:, 1:R_opt_boat) * S_boat(1:R_opt_boat, 1:R_opt_boat) * V_boat(:, 1:R_opt_boat)';
X_baboon_truncated = U_baboon(:, 1:R_opt_baboon) * S_baboon(1:R_opt_baboon, 1:R_opt_baboon) * V_baboon(:, 1:R_opt_baboon)';

% Step 7: Display the results
figure;
subplot(2,2,1), imshow(boat_noise, []), title('Noisy Boat Image');
subplot(2,2,2), imshow(X_boat_truncated, []), title(['Truncated Boat Image (R = ' num2str(R_opt_boat) ')']);
subplot(2,2,3), imshow(baboon_noise, []), title('Noisy Baboon Image');
subplot(2,2,4), imshow(X_baboon_truncated, []), title(['Truncated Baboon Image (R = ' num2str(R_opt_baboon) ')']);

% Output the optimal R values
fprintf('Optimal R for boatNoise.bmp: %d\n', R_opt_boat);
fprintf('Optimal R for baboonNoise.bmp: %d\n', R_opt_baboon);
fprintf('SNR for boatNoise.bmp with optimal R: %.2f\n', SNR_boat);
fprintf('SNR for baboonNoise.bmp with optimal R: %.2f\n', SNR_baboon);
