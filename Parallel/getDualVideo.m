function getDualVideo(leftRTSP, rightRTSP, output_filename)

vidWriter = vision.VideoFileWriter(output_filename, 'FrameRate', 1);

for i = 1:60

[im1, im2] = mextestF(leftRTSP,rightRTSP);

s = size(im1);
im1 = insertText(im1, [110,4], 'Left Camera');
im2 = insertText(im2, [110,4], 'Right Camera');
border = zeros(s(1),5,3);
border(:,:,1) = 255;
border(:,:,2) = 255;

drawnow;
dispImg = horzcat(im1, border, im2);
imshow(dispImg);

step(vidWriter, dispImg);

end

release(vidWriter);













end