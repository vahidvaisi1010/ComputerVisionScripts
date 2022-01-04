

vidWriter = vision.VideoFileWriter('testMex1.avi', 'FrameRate', .8);
for i = 1:60

[im1, im2] = mexTest('http://ip/snap.jpg','http://ip/snap.jpg');


s = size(im1);
im1 = insertText(im1, [110,4], 'Left Camera');
im2 = insertText(im2, [110,4], 'Right Camera');
border_width = 5;
border = zeros(s(1),border_width,3);

border(:,:,1) = 255;
border(:,:,2) = 255;

drawnow;
dispImg = horzcat(im1, border, im2);
imshow(dispImg);

step(vidWriter, dispImg);

end
release(vidWriter);