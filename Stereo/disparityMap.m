%% Load StereoParams previously found
% load('stereoparams.mat');

%% Capture images from cameras
leftImg = imread('C:\stereo\vtos_11_left\175.png');
rightImg = imread('C:\stereo\vtos_11_right\175.png');

%% Rectify the images
[leftImgRect, rightImgRect] = ...
    rectifyStereoImages(leftImg, rightImg, stereoParams);

%% Get the disparity map
dispMap = disparity(leftImgRect(:,:,1), rightImgRect(:,:,1));

%% Show the disparity map
figure; imshow(dispMap, [0,16]);
title('Disparity Map');
colormap jet
colorbar



