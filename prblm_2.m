basis_indices = [1, 10, 100, 200];
figure('Position', [100, 100, 1200, 600]);  % Increase figure size
for i = 1:length(basis_indices)
    idx = basis_indices(i);
    basis_img_boat = U_boat(:,idx) * S_boat(idx,idx) * V_boat(:,idx)';
    subplot(2,4,i); imshow(basis_img_boat, []);
    title(['Boat Basis Image ', num2str(idx)]);
    
    basis_img_baboon = U_baboon(:,idx) * S_baboon(idx,idx) * V_baboon(:,idx)';
    subplot(2,4,i+4); imshow(basis_img_baboon, []);
    title(['Baboon Basis Image ', num2str(idx)]);
end
