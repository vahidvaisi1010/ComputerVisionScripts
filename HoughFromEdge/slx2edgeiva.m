function [ edge, lines ] = slx2edgeiva( ip_address )
% Summary of this function goes here
%given ip address plots hough lines on edge and bw image
%   Detailed explanation goes here
%12/14/15 updated rho and theta resolution, fillgap and minlength to
%produce more appealing lines
URL = ['http://' ip_address '/axis-cgi/jpg/image.cgi'];
hedge = vision.EdgeDetector;
hcsc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');
typeconv = vision.ImageDataTypeConverter('OutputDataType', 'single');
image = imread(URL);

step1 = step(hcsc, image);
step2 = step(typeconv, step1);

edge = step(hedge, step2);


[H, theta, rho] = hough(edge,'RhoResolution',1,'ThetaResolution',1);%hough transform
P = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:))));%peaks of hough matrix
lines = houghlines(edge, theta, rho, P, 'FillGap', 10, 'MinLength', 12);

max_len = 0;

figure(1);
subplot(1,2,1);
imshow(image), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','Green')
    
end

subplot(1,2,2);
imshow(edge), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','Green')
    
end



end

