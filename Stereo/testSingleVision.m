%% Example Title
% Summary of example objective
images = imageSet([pwd '\left\']);
imageFileNames = images.ImageLocation;

[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);

squareSizeInMM = 29;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);

params = estimateCameraParameters(imagePoints,worldPoints);

showReprojectionErrors(params);

figure;
imshow(imageFileNames{1});
hold on;
plot(imagePoints(:,1,1), imagePoints(:,2,1),'go');
plot(params.ReprojectedPoints(:,1,1), params.ReprojectedPoints(:,2,1),'r+');
legend('Detected Points','ReprojectedPoints');
hold off;



