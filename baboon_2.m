% Load image
baboon = imread('baboon.bmp');
if size(baboon, 3) == 3
    baboon = rgb2gray(baboon);  % convert to grayscale if RGB
end
baboon = double(baboon);

% Perform SVD
[U, S, V] = svd(baboon);

% Choose a rank R for approximation
R = 50;  % You can try R = 10, 50, 100, etc.

% Truncated SVD reconstruction
A_hat = U(:,1:R) * S(1:R,1:R) * V(:,1:R)';

% Display original and reconstructed images
figure;
subplot(1,2,1);
imshow(baboon, []);
title('Original Baboon Image');

subplot(1,2,2);
imshow(A_hat, []);
title(['Rank-' num2str(R) ' Approximation']);

% Compute Frobenius norm of error
E = baboon - A_hat;
reconstruction_error = norm(E, 'fro');
disp(['Frobenius norm of reconstruction error: ', num2str(reconstruction_error)]);
