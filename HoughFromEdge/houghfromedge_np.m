function [ lines ] = houghfromedge_np( edge )
%UNTITLED5 Summary of this function goes here
%binary image input, returns lines
%region size impacts results of houghline function
%   Detailed explanation goes here
%12/15/15 version that does not plot the lines, only returns them
% [H, theta, rho] = hough(edge,'RhoResolution',1,'ThetaResolution',1);%hough transform
% P = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:))));%peaks of hough matrix
% lines = houghlines(edge, theta, rho, P, 'FillGap', 10, 'MinLength', 12);

[H, theta, rho] = hough(edge,'RhoResolution',2.00,'ThetaResolution',2.00);%hough transform
P = houghpeaks(H, 10, 'threshold', ceil(0.3*max(H(:))));%peaks of hough matrix
lines = houghlines(edge, theta, rho, P, 'FillGap', 11, 'MinLength', 3);

% imshow(image), hold on
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','Green')
%     
% end

end

