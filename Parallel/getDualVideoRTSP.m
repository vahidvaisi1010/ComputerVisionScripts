
%CHANGE THIS STUFF
leftIP = 'ip';
rightIP = 'ip';
output_filename = fullfile(pwd,'rtspOutput.avi');

% %System Object
% vidWriter = vision.VideoFileWriter(output_filename, 'FrameRate', 1);
vPlayer = vision.VideoPlayer();

%Build Strings for capture
protocol = 'rtsp://admin:admin@';
endString = '/mpeg4/1/media.amp';
leftRTSP = strcat(protocol,leftIP,endString);
rightRTSP = strcat(protocol,rightIP,endString);
    

for i = 1:100
    
%Capture images using our mex function    
[im1, im2] = mexCapture(leftRTSP,rightRTSP);

%Create middle yellow bar and insert text to images
s = size(im1);
im1 = insertText(im1, [110,4], 'Left Camera');
im2 = insertText(im2, [110,4], 'Right Camera');
border = zeros(s(1),5,3);
border(:,:,1) = 255;
border(:,:,2) = 255;
border(:,:,3) = 255;
drawnow;

%concatenate all images together side by side
dispImg = horzcat(im1, border, im2);

%Show image
step(vPlayer, dispImg);

% %Write Image
% step(vidWriter, dispImg);

end

% %Release system object
% release(vidWriter);