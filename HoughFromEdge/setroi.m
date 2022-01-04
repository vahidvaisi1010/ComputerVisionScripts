function [ xi, yi ] = setroi( image )
%setroi Summary of this function goes here
%sets roi by drawing a region. input is image
%   Detailed explanation goes here
%12/15/15 updated to return vectors of the polygon boundaries
imshow(image);
[roi, xi, yi] = roipoly(image); %can filter based on roi using roifilt2 (can specify type of filter)
imshow(roi);

end

