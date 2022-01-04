%% Stereo Camera Calibration
% Specify calibration images
imageDir = fullfile([pwd '\OfficeCalibrationImages']);
leftImages = imageSet(fullfile(imageDir,'left'));
rightImages = imageSet(fullfile(imageDir,'right'));
images1 = leftImages.ImageLocation;
images2 = rightImages.ImageLocation;

% Detect the checkerboards.
[imagePoints, boardSize] = detectCheckerboardPoints(images1,images2);

% Specify the world coordinates of the checkerboard keypoints.
squareSizeInMM = 76;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);

%Calibrate the stereo camera system.
im = read(leftImages,1);
params = estimateCameraParameters(imagePoints,worldPoints);

%Visualize the calibration accuracy.
showReprojectionErrors(params);

% figure;
% imshow(imageFileNames{1});
% hold on;
% plot(imagePoints(:,1,1), imagePoints(:,2,1),'go');
% plot(params.ReprojectedPoints(:,1,1), params.ReprojectedPoints(:,2,1),'r+');
% legend('Detected Points','ReprojectedPoints');
% hold off;