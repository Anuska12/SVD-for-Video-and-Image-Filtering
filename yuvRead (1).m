function I = yuvRead(fName,frameNumbers)
% function I = yuvRead(fName,frameNumbers)
% This function reads the file provided as the input in fName. The
% function reads the frameNumbers specified in the input and gives the
% individual framaes of the video as the output parameter I. If the
% frameNumbers are not specified, it used a default values from 1-20
% This code was written by Ashwin Swaminathan on Dec 8th, 2004
% For black and white videos

% set default inputs
if(nargin < 2)
    frameNumbers = 1: 20;
end

% Parameters defined here
LuCr_Ratio = 1; 
display_mode = 3;

% Open the file for reading
[fid, message]=fopen(fName,'r');

% Initialize the variables
frame_Len = 0;
width = 176; 
height = 144;
Y_size = width*height;

switch LuCr_Ratio
    case 1   % 4:2:0  
        U_size = Y_size/4;   V_size=Y_size/4;
    case 2   % 4:2:2
        U_size = Y_size/2;   V_size=Y_size/2;
end

% Check for frame length
if (frame_Len == 0)
    status = fseek(fid,0,'eof');
    Y_Len = ftell(fid);
    frame_Len = Y_Len/(Y_size+U_size+V_size);
    status = fseek(fid,0,'bof');
end 


% Read YUV and Display               
wait_H = waitbar(0,'Reading video file...');
imageIndex = 1;
I = zeros(height, width, length(frameNumbers));

% read individual frames and store it in I
for i = frameNumbers
    [temp_Y, count] = fread(fid, Y_size, 'uchar');
    temp_Y = reshape(temp_Y, width, height)';
    I(:,:,imageIndex) = temp_Y;
    waitbar(i/length(frameNumbers), wait_H);
    imshow(temp_Y,[0 255]);
    imageIndex = imageIndex + 1;
end
fprintf('Done reading file - %s',fName);