
%CHANGE THIS STUFF
leftIP = 'ip';
rightIP = 'ip';
output_filename = fullfile(pwd,'httpOutput.avi');

% %VideoWriter System Object
% vidWriter = vision.VideoFileWriter(output_filename, 'FrameRate', 1);
vPlayer = vision.VideoPlayer();

%Build Strings for capture
protocol = 'http://';
endString = '/axis-cgi/jpg/image.cgi';
dummy = '?dummy=fake.jpg';
leftHTTP = strcat(protocol,leftIP,endString,dummy);
rightHTTP = strcat(protocol,rightIP,endString,dummy);
    

while true
    
%Capture images using our mex function    
[im1, im2] = mexCapture(leftHTTP,rightHTTP);

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