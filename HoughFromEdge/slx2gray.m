function [ grayim ] = slx2gray( ip_address )
% Summary of this function goes here
%   Detailed explanation goes here
URL = ['http://' ip_address '/axis-cgi/jpg/image.cgi'];
image = imread(URL);
grayim = rgb2gray(image);



end

