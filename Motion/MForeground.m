%% Clear Workspace
clear;
close all
clc;

%% Read Video
videoReader = vision.VideoFileReader('t5_up.mp4');
% videoReader = vision.VideoFileReader('TR4700-Video-Road-Near-2010.avi');

%% Create Video Player
videoPlayer = vision.VideoPlayer('Position', [5 5 600 800]);
fgPlayer = vision.VideoPlayer('Position', [600 100 600 800]);

%% Create Foreground Detector 
foregroundDetector = vision.ForegroundDetector('NumGaussians',2, ...
    'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.5, ...
    'LearningRate',.005);
%Run on first 500 frames to learn background
% for i = 1:10
%     videoFrame = step(videoReader);
% %     small = imresize(videoFrame, .5); %Cut the image size in half for quicker processing
%     foreground = step(foregroundDetector, videoFrame);
% end

%% Create blob analysis object

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', true, 'CentroidOutputPort', true, ...
    'MinimumBlobArea', 800);
x=1;
%% Loop through video
while ~isDone(videoReader)
    %% get next frame
    videoFrame = step(videoReader);
%     small = imresize(videoFrame, .5);    
    
    %% Video Processing Code Goes Here
    if x == 1
        foreground = step(foregroundDetector, videoFrame);
%         cleanForeground = imopen(foreground, strel('rectangle',[1 2]));
%         cleanForeground = imclose(cleanForeground, strel('Disk',12));
%         cleanForeground = imfill(cleanForeground, 'holes');

        cleanForeground = imopen(foreground, strel('rectangle', [5,5]));
        cleanForeground = imclose(cleanForeground, strel('rectangle', [2,2])); 
        cleanForeground = imopen(cleanForeground, strel('rectangle',[8,8]));
        cleanForeground = imfill(cleanForeground, 'holes');
%         cleanForeground = imdilate(cleanForeground, strel('disk',3,4));

        %Detect connected components with the specified minimum area, and
        %compute their bounding boxes
        [area, centroid, bbox] = step(blobAnalysis, cleanForeground);

        %Draw bounding boxes around the detected cars
        result = insertShape(videoFrame,'Rectangle', bbox, 'Color', 'red');

        %% Display output
        step(videoPlayer, result); 
        step(fgPlayer, cleanForeground);
        x=0;
    end

    x=x+1;
end

%% release video reader and writer
release(videoPlayer);
release(fgPlayer);
release(videoReader);
delete(fgPlayer);
delete(videoPlayer); %Delete will cause the viewer to close