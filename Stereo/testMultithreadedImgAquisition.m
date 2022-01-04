%% Test Multithreaded Image Aquisition
% Setup System Obj
vp = vision.VideoPlayer();
vp1 = vision.VideoPlayer();
vp2 = vision.VideoPlayer();

thermal = 'rtsp://root:push2edg@/mpeg4/1/media.amp';
bosch1 = 'rtsp://ip/';
bosch2 = 'rtsp://ip/';


% Grab snaps from from 2 cameras concurrently and store in im1, im2, place
% these next to eachother in a new image im3
while(1)
    [im1, im2] = mextestF(bosch1,bosch2);
    im3 = horzcat(im1, im2);
    %step(vp, im3);
    step(vp1, im1);
    step(vp2, im2);
end
