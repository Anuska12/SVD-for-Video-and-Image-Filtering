% --- Step 1: Read the noisy video ---
fName = 'carphoneNoise.yuv';
% Specify a large enough finite number of frames to attempt to read
numExpectedFrames = 300;
frameNumbers = 1:numExpectedFrames; % Attempt to read up to this many frames

noisyVideo = yuvRead(fName, frameNumbers);

% Get the actual number of frames read by yuvRead
numFramesRead = size(noisyVideo, 3);
fprintf('Successfully read %d frames from the video.\n', numFramesRead);

% --- Step 2: Initialize variables for filtered videos ---
filteredVideo1 = zeros(size(noisyVideo), 'uint8'); % For Scheme 1
filteredVideo2 = zeros(size(noisyVideo), 'uint8'); % For Scheme 2
numFrames = numFramesRead; % Use the actual number of frames read

% --- Step 3: Apply Filtering Schemes frame by frame ---
h_avg = fspecial('average', [3 3]);
wait_avg = waitbar(0, 'Applying Averaging Filter...');
for i = 1:numFrames
    noisyFrame = double(noisyVideo(:,:,i));
    filteredFrame1 = imfilter(noisyFrame, h_avg, 'replicate');
    filteredVideo1(:,:,i) = uint8(filteredFrame1);
    waitbar(i / numFrames, wait_avg);
end
close(wait_avg);

wait_med = waitbar(0, 'Applying Median Filter...');
for i = 1:numFrames
    noisyFrame = noisyVideo(:,:,i);
    filteredFrame2 = medfilt2(noisyFrame, [3 3]);
    filteredVideo2(:,:,i) = filteredFrame2;
    waitbar(i / numFrames, wait_med);
end
close(wait_med);

% --- Step 4: Observe the filtered videos (using playMovie) ---
disp('Playing Noisy Video...');
playMovie(noisyVideo);
disp('Playing Filtered Video (Scheme 1 - Averaging)...');
playMovie(filteredVideo1);
disp('Playing Filtered Video (Scheme 2 - Median)...');
playMovie(filteredVideo2);

% --- Step 5: Determine the better scheme (visual inspection) ---
% Based on your observation of the played videos, decide which scheme
% provides better noise reduction while preserving important details.
% Let's assume for this example that Scheme 2 (Median Filter) looks better.

% --- Step 6: Write the better filtered video to a YUV file ---
betterFilteredVideo = filteredVideo2;
outputFName = 'carphoneFiltered.yuv';
writeSuccess = yuvWrite(betterFilteredVideo, outputFName);
if writeSuccess
    disp(['Filtered video written successfully to: ', outputFName]);
else
    disp(['Error writing filtered video to: ', outputFName]);
end

% --- Step 7: Play the written filtered video (optional) ---
disp('Playing the written Filtered Video...');
playMovie(betterFilteredVideo);