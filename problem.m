% Load images
boat = imread('boats.bmp');
baboon = imread('baboon.bmp');

% If the image is RGB, convert it to grayscale
if size(baboon, 3) == 3
    img_gray_baboon = rgb2gray(baboon);
else
    img_gray_baboon = baboon;
end

% Convert to double for SVD
boat = double(boat);
baboon = double(img_gray_baboon);

% Perform SVD
[U_boat, S_boat, V_boat] = svd(boat);
[U_baboon, S_baboon, V_baboon] = svd(baboon);
