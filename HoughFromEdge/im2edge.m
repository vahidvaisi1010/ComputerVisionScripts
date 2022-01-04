function [ edge ] = im2edge( image )
% Summary of this function goes here
%given grayscale image outputs binary edge detected image
%   Detailed explanation goes here
%modify to work with grayscale
hedge = vision.EdgeDetector;
hcsc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');
typeconv = vision.ImageDataTypeConverter('OutputDataType', 'single');

step1 = step(hcsc, image);
step2 = step(typeconv, step1);

edge = step(hedge, step2);





end

