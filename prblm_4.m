boat_image = imread('boats.bmp');
baboon_image = imread('baboon.bmp');

if size(boat_image, 3) == 3
    boat_image = rgb2gray(boat_image);
end
if size(baboon_image, 3) == 3
    baboon_image = rgb2gray(baboon_image);
end

% Perform SVD decomposition for both images
[U_boat, S_boat, V_boat] = svd(double(boat_image), 'econ');
[U_baboon, S_baboon, V_baboon] = svd(double(baboon_image), 'econ');

K_boat = min(size(S_boat)); 
K_baboon = min(size(S_baboon));

% (a) βi = i (simple linear weighting)
beta_a_boat = (1:K_boat)';  % βi = i for boat image
beta_a_baboon = (1:K_baboon)';  % βi = i for baboon image

% (b) βi = (K - i + 1) / K (reverse weighting)
beta_b_boat = (K_boat - (1:K_boat) + 1) / K_boat;  % βi = (K - i + 1) / K for boat image
beta_b_baboon = (K_baboon - (1:K_baboon) + 1) / K_baboon;  % βi = (K - i + 1) / K for baboon image


% For boat image
A_hat_a_boat = zeros(size(boat_image));  % Initialize the reconstructed image for boat
for i = 1:K_boat
    A_hat_a_boat = A_hat_a_boat + S_boat(i,i) * beta_a_boat(i) * U_boat(:,i) * V_boat(:,i)';  
end

% For baboon image
A_hat_a_baboon = zeros(size(baboon_image));  % Initialize the reconstructed image for baboon
for i = 1:K_baboon
    A_hat_a_baboon = A_hat_a_baboon + S_baboon(i,i) * beta_a_baboon(i) * U_baboon(:,i) * V_baboon(:,i)';  
end

% (b) βi = (K - i + 1) / K

% For boat image
A_hat_b_boat = zeros(size(boat_image));  % Initialize the reconstructed image for boat
for i = 1:K_boat
    A_hat_b_boat = A_hat_b_boat + S_boat(i,i) * beta_b_boat(i) * U_boat(:,i) * V_boat(:,i)';  
end

% For baboon image
A_hat_b_baboon = zeros(size(baboon_image));  % Initialize the reconstructed image for baboon
for i = 1:K_baboon
    A_hat_b_baboon = A_hat_b_baboon + S_baboon(i,i) * beta_b_baboon(i) * U_baboon(:,i) * V_baboon(:,i)';  
end

% Display results
figure;

subplot(2,3,1);
imshow(boat_image, []);  % Original boat image
title('Original Boat Image');

subplot(2,3,2);
imshow(A_hat_a_boat, []);  % Reconstructed boat image using βi = i
title('Reconstructed Boat Image (βi = i)');

subplot(2,3,3);
imshow(A_hat_b_boat, []);  % Reconstructed boat image using βi = (K - i + 1) / K
title('Reconstructed Boat Image (βi = (K - i + 1) / K)');

subplot(2,3,4);
imshow(baboon_image, []);  % Original baboon image
title('Original Baboon Image');

subplot(2,3,5);
imshow(A_hat_a_baboon, []);  % Reconstructed baboon image using βi = i
title('Reconstructed Baboon Image (βi = i)');

subplot(2,3,6);
imshow(A_hat_b_baboon, []);  % Reconstructed baboon image using βi = (K - i + 1) / K
title('Reconstructed Baboon Image (βi = (K - i + 1) / K)');
