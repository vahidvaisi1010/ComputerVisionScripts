%%Do not mess with this file!
clear; 
clc;

%  while true 
%     
    I = imread('C:\.png');
    I = rgb2gray(I);
%     I = adapthisteq(I,'clipLimit',0.08,'Distribution','uniform',...
%         'NBins', 512, 'NumTiles', [25 25]);

    I = imsharpen(I, 'Threshold', .7, 'Amount', .8);
    J = I;
    I = edge(I, 'canny', .035);
    
    I = imcrop(I,[170.5 104.5 54 53]); %33
    J = imcrop(J,[170.5 104.5 54 53]);
    %Hough Lines
    
    [H,T,R] = hough(I, 'Theta', -17:0);
    imshow(H,[],'XData',T,'YData',R,...
                'InitialMagnification','fit');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;
    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    plot(x,y,'s','color','white');

    % Find lines and plot them
    lines = houghlines(I,T,R,P,'FillGap',10,'MinLength',50);
    figure;
    imshow(J); hold on
    
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

%        % Plot beginnings and ends of lines
%        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%        % Determine the endpoints of the longest line segment
%        len = norm(lines(k).point1 - lines(k).point2);
%        if ( len > max_len)
%           max_len = len;
%           xy_long = xy;
%        end
    end
    
%  end

% highlight the longest line segment
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');