function M = playMovie(I)
% function M = playMovie(I)
% This function takes the input video (which is a three dimensional matrix)
% and displays the video. The function returns a video object M. You can
% then play the video object anytime using the command movie(M)

% create video object
for i = 1: size(I,3)
    imshow(I(:,:,i)/255);
    M(i) = getframe;
end

% Play movie
movie(M);