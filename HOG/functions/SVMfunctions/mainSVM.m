%This script's purpose is to demonstrate, utilize, and test the functions
%associated with the SVM Classifier using HOG features.
%
%
%Author:    Vahid Vaisi

%Create zones, this can be edited.
numZones = 4;
z = cell(1,numZones);
z{:,1} = [31.5 109.5 57 60];
z{:,2} = [102.5 110.5 57 60];
z{:,3} = [171.5 113.5 57 60];
z{:,4} = [236.5 112.5 67 60];

%% Demonstrate and test trainCascadingClassifier

%Changeable variables
folderName = 'C:\Users\John\Desktop\TryingClasifiers\research\HOG\functions\SVMfunctions';


%Train the svmClassifier
[classifier, hogFeatureSize] = trainSVMClassifier(z, folderName);


%% Demonstrate and test determineHOGWithSVM

%Changeable variables
vidName = '\\172.16.102.110\ServerShared\testCascade.mp4';

%Create system objects
vReader = vision.VideoFileReader(vidName);
vPlayer = vision.VideoPlayer();
sInserterRed = vision.ShapeInserter('Shape','Rectangles','Fill',true,...
    'FillColor','Custom','CustomFillColor',[255 0 0],'Opacity', 0.001);
sInserterGreen = vision.ShapeInserter('Shape','Rectangles','Fill',true,...
    'FillColor','Custom','CustomFillColor',[0 255 0],'Opacity', 0.001);

%Create array to hold hog determinations
determinations = cell (1,numZones);
for index=1:numZones
   determinations{1,index} = 0; 
end


while ~isDone(vReader)
   
    %Read next frame from video player
    frame = step(vReader); 

    %Make a determination for each zone in this frame
    [determinations, roiframe] = determineHOGWithSVM(...
        frame, z, classifier);

    %Insert proper color rectangle for each zone dependent on the status of
    %each zone
    for i=1:numZones
       if determinations{i} == 0
           frame = step(sInserterGreen, frame, z{:,i});

       else
           frame = step(sInserterRed, frame, z{:,i});
           
       end
    end
    
    %Display frame into the video player
    step(vPlayer, frame);
end
