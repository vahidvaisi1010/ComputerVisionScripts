%Detect people in stereo cameras

%Create system object
ldetector = vision.PeopleDetector('UprightPeople_96x48', 'ClassificationThreshold',2, ...
    'MergeDetections',true,'WindowStride', [4 4], 'UseROI', false);
rdetector = vision.PeopleDetector('UprightPeople_96x48', 'ClassificationThreshold',2, ...
    'MergeDetections',true,'WindowStride', [4 4], 'UseROI', false);
vPlayer = vision.VideoPlayer();
dispPlayer = vision.VideoPlayer();
lreader = vision.VideoFileReader('1106_low\Left\1106_low_left.mp4');
rreader = vision.VideoFileReader('1106_low\Right\1106_low_right.mp4');

roi = [1.5 103.5 319 137];
% load('stereoParams1103.mat');

% while true
while ~isDone(lreader);
   %Read images 
%    leftImg =  webread('http://ip/axis-cgi/jpg/image.cgi');
%    rightImg = webread('http://ip/axis-cgi/jpg/image.cgi');
   leftImg = step(lreader);
   rightImg = step(rreader);
   
   %Rectify images
    [leftImgRect, rightImgRect] = rectifyStereoImages(leftImg, rightImg, stereoParams1106_low_2);%,'OutputView','valid');

%     leftPts = detectSURFFeatures(leftImg(:,:,1), 'Metricthreshold', 700, 'NumOctaves', 3);
%     rightPts = detectSURFFeatures(rightImg(:,:,1), 'Metricthreshold', 700, 'NumOctaves', 3);
%     [leftFts, leftValidPts] = extractFeatures(leftImg(:,:,1), leftPts);
%     [rightFts, rightValidPts] = extractFeatures(rightImg(:,:,1), rightPts);
%     indexPairs = matchFeatures(leftFts, rightFts, 'Metric', 'SSD', 'MatchThreshold', 20);
%     matchedLeft = leftValidPts(indexPairs(:,1),:);
%     matchedRight = rightValidPts(indexPairs(:,2),:);
%     [fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
%         matchedLeft, matchedRight, 'Method', 'Norm8Point');
%     
%     if status ~= 0 || isEpipoleInImage(fMatrix, size(leftImg)) ...
%             || isEpipoleInImage(fMatrix', size(rightImg))
%         error(['Not Working']);
%     end
%     inlierLeft = matchedLeft(epipolarInliers, :);
%     inlierRight = matchedRight(epipolarInliers, :);
%     [tLeft, tRight] = estimateUncalibratedRectification(fMatrix, inlierLeft,...
%         inlierRight, size(leftImg));
%     [jLeft, jRight] = rectifyStereoImages(leftImg, rightImg, tLeft, tRight);
%     
%    dispMap = disparity(jLeft(:,:,1), jRight(:,:,1));
    dispMap = disparity(leftImgRect(:,:,1),rightImgRect(:,:,1), 'DisparityRange', [0 32]);
   
   %grab bounding boxes of people
   [boxesLeft,scoresLeft] = step(ldetector, leftImgRect(:,:,1));
   [boxesRight, scoresRight] = step(rdetector, rightImgRect(:,:,1));
   
   %Insert boxes around people
   if ~isempty(boxesLeft)
    leftI = insertObjectAnnotation(leftImgRect, 'rectangle', boxesLeft, scoresLeft);
   else
    leftI = leftImgRect;
   end
   if ~isempty(boxesRight)
    rightI = insertObjectAnnotation(rightImgRect, 'rectangle', boxesRight, scoresRight);
   else
    rightI = rightImgRect;
   end
   
   %display The images next to each other
    finalImg = horzcat(leftI(:,:,1),rightI(:,:,1));
%     finalImg = horzcat(leftI,rightI);
   step(vPlayer, finalImg);
   step(dispPlayer, dispMap);
   
end