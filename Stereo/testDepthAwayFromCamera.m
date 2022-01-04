%Get images
leftImg = imread('\\ip\ServerShared\test1204\left\left_session.jpg');
rightImg = imread('\\ip\ServerShared\test1204\right\right_session.jpg');


%Get stereoParams
load('stereoParamsO1.mat');
stereoparams = stereoParamsO1;

%Rectify images and get disparity map
[leftImgRect, rightImgRect] = rectifyStereoImages(leftImg, rightImg, stereoparams);
disparityRange = [0 64];
dispMap = disparity(rgb2gray(leftImgRect),rgb2gray(rightImgRect), ...
    'Blocksize',5,'DisparityRange', disparityRange, 'DistanceThreshold', 5);

%Rebuild the 3D scene
point3D = reconstructScene(dispMap, stereoparams);

%Restrict scene to specific parameters
z = point3D(:,:,3);
z(z < 0 | z > 600) = NaN;
x = point3D(:,:,1);
x(x < -240 | x > 240) = NaN;
point3D(:,:,3) = z;
point3D(:,:,1) = x;

%Get a second point cloud and restrict it to our 3D ROI
zroi = point3D(:,:,3);
zroi(zroi < 300 | zroi > 450) = NaN;
xroi = point3D(:,:,1);
xroi(xroi < 0 | xroi > 75) = NaN;
yroi = point3D(:,:,2);
yroi(yroi < -0 | yroi > 100) = NaN;
point3Droi(:,:,2) = yroi;
point3Droi(:,:,3) = zroi;
point3Droi(:,:,1) = xroi;

%display both 3d sets
figure;
pcshow(point3Droi, leftImgRect, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
xlabel('X (In)');
ylabel('Y (In)');
zlabel('Z (In)');
% set(gca, 'CameraViewAngle',10, 'CameraUpVector',[0 -1 0],...
%     'CameraPosition',[16500 -13852 -49597], 'DataAspectRatio',[1 1 1]);
title('Reconstructed ROI 3D');

figure;
pcshow(point3D, leftImgRect, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
xlabel('X (In)');
ylabel('Y (In)');
zlabel('Z (In)');
% set(gca, 'CameraViewAngle',10, 'CameraUpVector',[0 -1 0],...
%     'CameraPosition',[16500 -13852 -49597], 'DataAspectRatio',[1 1 1]);
title('Reconstructed 3-D Scene');

%Extract useful information from 
sceneroi = [-240,240;-inf,inf;0,600];
roi = [0,75;0,100;300,450];

ptCloudScene = pointCloud(point3D);%roi
indiciesScene = findPointsInROI(ptCloudScene,sceneroi);
ptCloudOutScene = select(ptCloudScene, indiciesScene);

ptCloudROI = pointCloud(point3Droi);%roi
indicies = findPointsInROI(ptCloudROI,roi);
ptCloudOut = select(ptCloudROI, indicies);




%Display
figure;
pcshow(ptCloudOut.Location,'r');
hold on;
pcshow(ptCloudOutScene.Location);
xlabel('X (In)');
ylabel('Y (In)');
zlabel('Z (In)');
title('ROI pointcloud');
hold off;