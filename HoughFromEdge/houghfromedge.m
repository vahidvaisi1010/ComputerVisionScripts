function [ lines ] = houghfromedge( edge, image )
%UNTITLED5 Summary of this function goes here
%binary image input, plots hough lines, returns lines
%lines are overlayed on "image"
%region size impacts results of houghline function
%   Detailed explanation goes here
%12/16/15 modify function to display hough transform on side, experimented
%with different values of resolution, threshold, gap and length, nothing
%looked convincingly better so the default values were restored.
%number of peaks increased to be more compatible with the number of lines
%in the image
[H, theta, rho] = hough(edge,'RhoResolution',0.75,'ThetaResolution',0.75);%hough transform
P = houghpeaks(H, 15, 'threshold', ceil(0.3*max(H(:))));%peaks of hough matrix
lines = houghlines(edge, theta, rho, P, 'FillGap', 7, 'MinLength', 1);


subplot(1,2,1);
imshow(image), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','Green')
    
end

subplot(1,2,2);
imshow(H,[],'XData',theta,'YData',rho,...
            'InitialMagnification',150);
        hold on;
x = theta(P(:,2)); y = rho(P(:,1));
plot(x,y,'s','color','white');

end

