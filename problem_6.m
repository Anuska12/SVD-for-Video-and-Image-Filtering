load('Prob6data.mat');
whos
% List of image variables
image_names = {'Hor', 'Ver', 'Diag1', 'Diag2', 'HorNoise', 'VerNoise', 'Diag1Noise', 'Diag2Noise'};

% Loop through each image
for i = 1:length(image_names)
    image = eval(image_names{i});  % Load the image
    
    % Perform SVD
    [U, S, V] = svd(double(image));
    
    % Plot the singular values on a logarithmic scale
    figure;
    semilogy(diag(S));  % Plot singular values on log scale
    title(['Singular Values for ' image_names{i}]);
    xlabel('Index');
    ylabel('Singular Value (log scale)');
end
