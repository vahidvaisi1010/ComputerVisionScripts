function [ B ] = slx2bound( ip_address )
% Summary of this function goes here
%captures image from ip, outputs boundry cellfor that image
%   Detailed explanation goes here
%what can you do with the boundry cell?
URL = ['http://' ip_address '/axis-cgi/jpg/image.cgi'];
image = imread(URL);
grayim = rgb2gray(image);

hedge = vision.EdgeDetector;
hcsc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');
typeconv = vision.ImageDataTypeConverter('OutputDataType', 'single');

step1 = step(hcsc, image);
step2 = step(typeconv, step1);

edge = step(hedge, step2);


B = bwboundaries(edge);%returns cell that coresponds to boundaries

end

