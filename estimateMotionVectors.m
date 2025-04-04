function motionVectors = estimateMotionVectors(currentFrame, referenceFrames)
    % This function estimates motion vectors by block matching between the current frame
    % and reference frames. It returns the motion vectors for each block in the frame.
    %
    % Parameters:
    %   currentFrame: The frame to estimate motion for (N x N blocks).
    %   referenceFrames: A 3D matrix of reference frames (height x width x numFrames).
    %
    % Returns:
    %   motionVectors: A matrix containing motion vectors for each block.

    blockSize = 16;  % Block size for motion estimation (e.g., 16x16 blocks)
    [height, width] = size(currentFrame);  % Frame dimensions
    
    motionVectors = zeros(floor(height / blockSize), floor(width / blockSize), 2);  % Initialize motion vectors (u, v)

    for i = 1:floor(height / blockSize)
        for j = 1:floor(width / blockSize)
            % Extract current block
            currBlock = currentFrame((i-1)*blockSize + 1:i*blockSize, (j-1)*blockSize + 1:j*blockSize);

            % Initialize variables for best match
            bestMatch = [0, 0];  % Motion vector (u, v)
            minSAD = Inf;  % Minimum SAD (Sum of Absolute Differences)

            % Search for the best matching block in the reference frames
            searchRange = 7;  % Search window size (7x7 = 49 possible positions)
            
            % Loop through reference frames (assuming there are multiple reference frames)
            for k = 1:size(referenceFrames, 3)  % Loop through the reference frames
                refFrame = referenceFrames(:, :, k);  % Select the k-th reference frame

                for m = -searchRange:searchRange
                    for n = -searchRange:searchRange
                        % Calculate reference block position (ensure within bounds)
                        refX = (i-1)*blockSize + m;
                        refY = (j-1)*blockSize + n;
                        
                        % Ensure the reference block fits within the reference frame
                        if refX > 0 && refY > 0 && refX + blockSize <= height && refY + blockSize <= width
                            % Extract reference block
                            refBlock = refFrame(refX:refX+blockSize-1, refY:refY+blockSize-1);

                            % Compute Sum of Absolute Differences (SAD) between current block and reference block
                            SAD = sum(sum(abs(currBlock - refBlock)));
                            
                            % Update the best match if the current SAD is lower
                            if SAD < minSAD
                                minSAD = SAD;
                                bestMatch = [m, n];  % Motion vector (u, v)
                            end
                        end
                    end
                end
            end

            % Store the motion vector for the current block
            motionVectors(i, j, :) = bestMatch;  % (uij, vij)
        end
    end
end
