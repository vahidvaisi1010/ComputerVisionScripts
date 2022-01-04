%Memory clean up
clear;
clc;
close all;

%Create zone array 
z = cell(1,3);
z{:,1} = [95.5 95.5 41 39];   
z{:,2} = [138.5 83.5 48 68]; 
z{:,3} = [191.5 109.5 55 78];    

%train the SVM classifier
trainingFolder = 'LeftTrainingPictures\Track';
[classifier, hogFeatureSize] = trainClassifier(z, trainingFolder);

%Create system objects
vReader = vision.VideoFileReader('0608_motion5.mp4');
vPlayer = vision.VideoPlayer();
sInserterRed = vision.ShapeInserter('Shape','Rectangles','Fill',true,...
    'FillColor','Custom','CustomFillColor',[255 0 0],'Opacity', 0.001);
sInserterGreen = vision.ShapeInserter('Shape','Rectangles','Fill',true,...
    'FillColor','Custom','CustomFillColor',[0 255 0],'Opacity', 0.001);

%Create counter variables for certainty
vacancyCounter = cell(1,3);
occupiedCounter = cell(1,3);

%Create array to hold hog determinations
determinations = cell (1,3);
for index=1:3
   determinations{1,index} = 0; 
end

x=1;
while ~isDone(vReader)
   
    %Read next frame from video player
    frame = step(vReader); 

    %Make a determination for each zone in this frame
    [determinations, vacancyCounter, occupiedCounter, frame] = determineHOG(...
        frame, z, hogFeatureSize, classifier, vacancyCounter, ...
        occupiedCounter);

    rgb = double(cat(3, edgePic, edgePic,edgePic));
    %Insert proper color rectangle for each zone dependent on the status of
    %each zone
    for i=1:3
       if determinations{i} == 0
           frame = step(sInserterGreen, frame, z{:,i});
           rgb = step(sInserterGreenEDGE, rgb, uint8(z{:,i}));
       else
           frame = step(sInserterRed, frame, z{:,i});
           rgb = step(sInserterRedEDGE, rgb, uint8(z{:,i}));
       end
    end
    
    %Display frame into the video player
    step(edgePlayer, rgb);
    step(bwPlayer, bw);
    step(vPlayer, frame);
    x=x+1;
end
disp('DONE');
