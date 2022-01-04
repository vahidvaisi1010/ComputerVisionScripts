%performs edge detection on multpiple successive frames of a video feed and
%plots the hough lines overlayed on the original image and binary image
%video = vision.VideoPlayer;
ip = 'ip';
for i=1:100
   slx2edgeiva(ip); 
   %step(video, slx2edge(ip)); 
   
   
% max_len = 0;
% [edge, lines] = slx2edgeiva(ip);
% figure(2);
% imshow(edge), hold on
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','Green')
% end
drawnow;
hold on;
    
end