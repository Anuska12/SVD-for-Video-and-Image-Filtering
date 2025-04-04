function flag = yuvWrite(I, fName)
% function I = yuvWrite(I,fName)
% This function writes the video I into the file provided as the input in fName.
% This code was written by Ashwin Swaminathan on Dec 8th, 2004
% This function outputs a flag on completion. If the flag = 1, the write
% operation is sucessful, else it is not sucessful.

% initialize flag
flag = 0;

% set default inputs
if(nargin < 2)
    frameNumbers = 1: 20;
end

% Parameters defined here
LuCr_Ratio = 1; 
display_mode = 3;

% Open the file for reading
[fid, message]=fopen(fName,'w');

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
wait_H = waitbar(0,'Writing video file...');
imageIndex = 1;
count = 0;
L = size(I,3);

counts = 0;
% read individual frames and store it in I
for i = 1: L
    counts = counts + fwrite(fid, reshape(I(:,:,i)', width*height,1), 'uchar');
    waitbar(i/L, wait_H);
end
fprintf('Done reading file - %s',fName);
fclose(fid);

% IF the number of bits written is same as the size of the video... return 1
if(counts == prod(size(I)))
    flag = 1;
else
    flag = 0;
end