img = imread('boats.bmp');

% Convert to grayscale if needed
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

img_gray = double(img_gray);
[U, S, V] = svd(img_gray);

singular_values = diag(S);
K = length(singular_values);

alphas = [0.5, 1, 1.2];

for a = 1:length(alphas)
    alpha = alphas(a);
    A_hat = zeros(size(img_gray));
    for i = 1:K
        rho_i = singular_values(i);
        A_hat = A_hat + (singular_values(1)^(1 - alpha)) * (rho_i^alpha) * (U(:, i) * V(:, i)');
    end
    
    figure;
    imshow(uint8(A_hat));
    title(['Non-linear filter reconstruction for \alpha = ', num2str(alpha)]);
end
