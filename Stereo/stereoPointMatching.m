%% Clean up
clear;
close all;
clc;

%% Create system objects 


% load('leftImg.mat');
% load('rightImg.mat');
% leftImg = rgb2gray(l1);
% rightImg = rgb2gray(r1);
leftImg = rgb2gray(imread('1103_left\100.png'));
rightImg = rgb2gray(imread('1103_right\100.png'));

% x=1;
% while true
% %% Get images
% disp(x)
% leftImg = rgb2gray(step(vReaderL));
% rightImg = rgb2gray(step(vReaderR));





%% Extract the SURF features
leftPts = detectSURFFeatures(leftImg, 'MetricThreshold', 1000, 'NumOctaves',3);
rightPts = detectSURFFeatures(rightImg, 'MetricThreshold', 1000, 'NumOctaves',3);

figure;
imshow(leftImg);
title('Left Image');
hold on;
plot(selectStrongest(leftPts, 30));
title('Thirty strongest SURF features in Left Image');

figure;
imshow(rightImg);
title('Right Image');
hold on;
plot(selectStrongest(rightPts, 30));
title('Thirty strongest SURF features in Right Image');

[leftFts, leftValidPts] = extractFeatures(leftImg, leftPts);
[rightFts, rightValidPts] = extractFeatures(rightImg, rightPts);

indexPairs = matchFeatures(leftFts, rightFts, 'Metric', 'SSD', 'MatchThreshold', 10);

matchedLeft = leftValidPts(indexPairs(:,1),:);
matchedRight = rightValidPts(indexPairs(:,2),:);

figure;
showMatchedFeatures(leftImg, rightImg, matchedLeft, matchedRight);
legend('Matched points in Left Image', 'Matched points in Right image');

% Get the fundamental matrix and the inliers
[fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
  matchedLeft, matchedRight, 'DistanceType','Algebraic','Method', 'RANSAC', ...
  'NumTrials', 10000, 'DistanceThreshold', 0.001, 'Confidence', 99.99);

% [fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
%   matchedLeft, matchedRight, 'Method', 'Norm8Point');

if status ~= 0 || isEpipoleInImage(fMatrix, size(leftImg)) ...
  || isEpipoleInImage(fMatrix', size(rightImg))
  error(['Either not enough matching points were found or '...
         'the epipoles are inside the images. You may need to '...
         'inspect and improve the quality of detected features ',...
         'and/or improve the quality of your images.']);
end

inlierLeft = matchedLeft(epipolarInliers, :);
inlierRight = matchedRight(epipolarInliers, :);

% Rectify the images using the extracted features
[tLeft, tRight] = estimateUncalibratedRectification(fMatrix,inlierLeft,inlierRight,size(leftImg));

% imagePoints = cat(2, matchedLeft.Location, matchedright.Loction);
% [stereoParams, pairsUsed, estimationErrors] = estimatecameraParameters(...
%     imagePoints, ~);

[jLeft, jRight] = rectifyStereoImages(leftImg, rightImg, tLeft, tRight);

figure;
imshowpair(jLeft, jRight,'falsecolor', 'ColorChannels','red-cyan');
title('Rectified Image without using calibration tools');

%% Get disparity map
disparityMap = disparity(jLeft, jRight);
figure;
imshow(disparityMap, [0,8]);
title('Disparity Map');
colormap jet
colorbar

% x = x+1;
% end % Forever loop