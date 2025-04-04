% Problem 5: Truncated SVD for Denoising
% Target SNR threshold
snr_target = 20;

% Read the noisy images
boat = im2double(imread('boatNoise.bmp'));
baboon = im2double(imread('baboonNoise.bmp'));

% Apply method to both images
[boat_Ropt, boat_SNR, boat_denoised] = truncated_svd_opt(boat, snr_target);
[baboon_Ropt, baboon_SNR, baboon_denoised] = truncated_svd_opt(baboon, snr_target);

% Display results
fprintf('Boat Image:\nOptimal R = %d, Estimated SNR = %.2f dB\n\n', boat_Ropt, boat_SNR);
fprintf('Baboon Image:\nOptimal R = %d, Estimated SNR = %.2f dB\n\n', baboon_Ropt, baboon_SNR);

% Show images
figure;
subplot(2,2,1), imshow(boat), title('Original Boat Noise');
subplot(2,2,2), imshow(boat_denoised), title(['Denoised Boat (R = ' num2str(boat_Ropt) ')']);
subplot(2,2,3), imshow(baboon), title('Original Baboon Noise');
subplot(2,2,4), imshow(baboon_denoised), title(['Denoised Baboon (R = ' num2str(baboon_Ropt) ')']);

% ---- Subfunction ----
function [R_opt, best_snr, X_denoised] = truncated_svd_opt(Y, snr_target)
    [U, S, V] = svd(Y);
    s = diag(S);
    N = length(s);
    sigma2 = mean(s(end-20:end).^2); % Noise variance estimate

    best_snr = 0;
    min_diff = inf;
    R_opt = 1;

    for R = 1:N
        signal_power = sum(s(1:R).^2 - sigma2);
        noise_power = (N - R) * sigma2;
        snr_est = 20 * log10(signal_power / noise_power);

        if abs(snr_est - snr_target) < min_diff
            min_diff = abs(snr_est - snr_target);
            best_snr = snr_est;
            R_opt = R;
        end
    end

    % Truncate and reconstruct the image
    S_trunc = diag([s(1:R_opt); zeros(N - R_opt, 1)]);
    X_denoised = U * S_trunc * V';
end
