%% Memory clean up
clear;
clc;
close all;

%% Create static variables

%Variable that indicates the number of tracks/zones we are using
numTracks = 4;

%Create zone array 
z = cell(1,numTracks);
z{:,1} = [31.5 109.5 57 60];   
z{:,2} = [102.5 110.5 57 60]; 
z{:,3} = [171.5 113.5 57 60]; 
z{:,4} = [236.5 112.5 67 60]; 

%% Create system objects
vReader = vision.VideoFileReader('Sept_28_left_pm.mp4');
% vReader = vision.VideoFileReader('left2.mp4');
vPlayer = vision.VideoPlayer('Name','Cascade Object Detection','Position',[400 50 700 700]);

%Create a cell array of cascade detectors using the previously trained XML
%files
detector = cell(1,numTracks);
for i=1:numTracks
    detector{1,i} = vision.CascadeObjectDetector(strcat('xmlTrainer',num2str(i),'.xml'),'UseROI',true);
end

%Create objects that overlay the image for display purposes
sInserterRed = vision.ShapeInserter('Shape','Rectangles','Fill',true,...
    'FillColor','Custom','CustomFillColor',[255 0 0],'Opacity', 0.001);
sInserterGreen = vision.ShapeInserter('Shape','Rectangles','Fill',true,...
    'FillColor','Custom','CustomFillColor',[0 255 0],'Opacity', 0.001);
bboxInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor',...
        'Custom', 'CustomBorderColor', [0 0 255]);

%Create cell array to hold bounding boxes
bboxes = cell(1,numTracks);

%% Start loop to read frames
while ~isDone(vReader)
   
    %Read image from video
    frame = step(vReader);
    
    %Iterate over each zone and insert proper overlays based on detected
    %bounding boxes
    for i=1:numTracks
        
        bboxes{1,i} = step(detector{1,i},frame, z{:,i});
        if ~(isempty(bboxes{1,i}))
            frame = step(sInserterRed, frame, z{:,i});
            frame = step(bboxInserter, frame, bboxes{1,i});
        else
            frame = step(sInserterGreen, frame, z{:,i});
        end
    end
    
    %Display to video player
    step(vPlayer, frame);
    drawnow;
    
end

%% Release all system objects
release(vPlayer);
release(vReader);
release(sInserterRed);
release(sInserterGreen);
release(bboxInserter);
