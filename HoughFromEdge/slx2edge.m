function [ edge ] = slx2edge( ip_address )
% Summary of this function goes here
%   Detailed explanation goes here
URL = ['http://' ip_address '/axis-cgi/jpg/image.cgi'];
hedge = vision.EdgeDetector;
hcsc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');
typeconv = vision.ImageDataTypeConverter('OutputDataType', 'single');
image = imread(URL);

step1 = step(hcsc, image);
step2 = step(typeconv, step1);

edge = step(hedge, step2);





end

