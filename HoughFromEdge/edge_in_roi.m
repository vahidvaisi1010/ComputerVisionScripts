function [ lines ] = edge_in_roi( ip, c, r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%edge detection performed in a region of interet, roi described by vectors
%returns lines
image = slx2gray(ip);
roi = roipoly(image, c, r);
edge = slx2edge(ip);

crop = edge;
crop(~roi) = 0;
%I2 = I.*cast(R,class(I)); %multiply
imshow(crop)


lines = houghfromedge(crop, edge);

end

