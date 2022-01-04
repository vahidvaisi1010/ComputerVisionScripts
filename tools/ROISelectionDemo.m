%This Script is to demonstrate how to utilize the ROI Selection tool to
%select an ROI for a point cloud and incorporate it into our code.
%
%Author: Matt McDermott, Communication Concepts, Inc.

%% Get Images.

leftImg = imread('C:\stereo\outsideImages\left\left_session_2015-17-12_15-06-42_13.jpg');
rightImg = imread('C:\stereo\outsideImages\right\right_session_2015-17-12_15-06-42_13.jpg');

%% Load Stereo Parameters.

load('C:\stereo\stereoParamsO1.mat');
stereoparams = stereoParamsO1;

%% Rectify Images, get disparity map, and reconstruct the 3D scene.

[leftImgRect, rightImgRect] = rectifyStereoImages(leftImg, rightImg, stereoparams);
disparityRange = [0 64];
dispMap = disparity(rgb2gray(leftImgRect),rgb2gray(rightImgRect), ...
    'Blocksize',5,'DisparityRange', disparityRange, 'DistanceThreshold', 5);

point3D = reconstructScene(dispMap, stereoparams);

%% Create Point Cloud object from 3D array.
%Note: We limit the scene to a specific ROI, mostly for visual purposes

sceneLimits = [-240,240;0,600;0,600];
sceneCloud = pointCloud(point3D);
indices = findPointsInROI(sceneCloud, sceneLimits);
sceneCloud = select(sceneCloud, indices);

%% Here is where we utilize the ROISelection tool.
%The tool produces the ROI info and the Matrix for the transform

%Load information found from the tool.
load('demoMatrix.mat');
load('demoROI');

%% Create a transform object and then create ROI point cloud.

tform = affine3d(demoMatrix);
sceneCloud = pctransform(sceneCloud, tform);

indices = findPointsInROI(sceneCloud, demoROI);
roiCloud = select(sceneCloud, indices);

%% Display the results
figure; 
pcshow(sceneCloud,'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
xlabel('X (In)');
ylabel('Y (In)');
zlabel('Z (In)');
% title('Scene'); hold off;
figure;  
pcshow(roiCloud,'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
xlabel('X (In)');
ylabel('Y (In)');
zlabel('Z (In)');
% title('ROI'); hold off;