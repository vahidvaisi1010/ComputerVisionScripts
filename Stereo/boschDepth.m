% pause(10);

%% Get images
% leftImg = webread('http://172.16.102.129/snap.jpg');
% rightImg = webread('http://172.16.102.128/snap.jpg');
leftImg = left_session_2015_04_12_09_45_48_22;
rightImg = right_session_2015_04_12_09_45_48_22;
%  load('jorgePicLeft.mat');
% load('jorgePicRight.mat');

% load('stereoParamsMat1.mat');
load('stereoParamsO3');
stereoparams = stereoParamsO3;

%% Rectify images and plot disparity map
[leftImgRect, rightImgRect] = rectifyStereoImages(leftImg, rightImg, stereoparams);
% figure; imshowpair(leftImgRect, rightImgRect,'falsecolor','ColorChannels','red-cyan');
disparityRange = [0 64];
dispMap = disparity(rgb2gray(leftImgRect),rgb2gray(rightImgRect), ...
    'Blocksize',5,'DisparityRange', disparityRange, 'DistanceThreshold', 5);

% figure; imshowpair(leftImg, rightImg, 'montage');
% figure; imshowpair(leftImgRect, rightImgRect,'falsecolor','ColorChannels','red-cyan');
figure; imshow(dispMap, disparityRange); colormap jet; colorbar;

%% Scene Reconstruction (still being worked on)
point3D = reconstructScene(dispMap, stereoparams);

% Convert from millimeters to meters.
z = point3D(:,:,3);
z(z < 0 | z > 360) = NaN;
x = point3D(:,:,1);
x(x < -120 | x > 120) = NaN;
point3D(:,:,3) = z;
point3D(:,:,1) = x;

figure;
pcshow(point3D, leftImgRect, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
xlabel('X (Ft)');
ylabel('Y (Ft)');
zlabel('Z (Ft)');
% set(gca, 'CameraViewAngle',10, 'CameraUpVector',[0 -1 0],...
%     'CameraPosition',[16500 -13852 -49597], 'DataAspectRatio',[1 1 1]);
title('Reconstructed 3-D Scene');

% pointCloud = reconstructScene(dispMap, stereoParamsMat1);
% 
% 
% Z = pointCloud(:, :, 3)
% mask = repmat(Z > 1000 & Z < 4000, [1, 1, 3]);
% leftImgRect(~mask) = 0;
% figure,
% imshow(leftImgRect, 'InitialMagnification', 50);

%% Find depth 

% Create the people detector object. Limit the minimum object size for
% speed.
peopleDetector = vision.PeopleDetector('ClassificationModel', 'UprightPeople_96x48');

% Detect people.
bboxes = peopleDetector.step(leftImgRect);

% Find the centroids of detected people.
centroids = [round(bboxes(:, 1) + bboxes(:, 3) / 2), ...
    round(bboxes(:, 2) + bboxes(:, 4) / 2)];

% Find the 3-D world coordinates of the centroids.
centroidsIdx = sub2ind(size(dispMap), centroids(:, 2), centroids(:, 1));
X = point3D(:, :, 1);
Y = point3D(:, :, 2);
Z = point3D(:, :, 3);
centroids3D = [X(centroidsIdx)'; Y(centroidsIdx)'; Z(centroidsIdx)'];

% Find the distances from the camera in meters.
dists = sqrt(sum(centroids3D .^ 2)) / 12;

%% Display the detected people and their distances.
labels = cell(1, numel(dists));
for i = 1:numel(dists)
    labels{i} = sprintf('%0.2f Feet', dists(i));
end
figure;
imshow(insertObjectAnnotation(leftImgRect, 'rectangle', bboxes, labels));
title('Detected People');
