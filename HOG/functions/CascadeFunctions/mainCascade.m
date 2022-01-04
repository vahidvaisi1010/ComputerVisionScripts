%This script's purpose is to demonstrate, utilize, and test the functions
%associated with the cascade trainer and object finder.
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

% %Changeable variables
% posFolderName = 'C:\Users\Matt\Documents\VTOS\Scripts\HOG\LeftTrainingPictures';
% negFolderName = 'C:\Users\Matt\Documents\VTOS\Scripts\HOG\leftNegPics';
% xmlOutput = 'xmlZone';
% numTrainingStages = 7;
% falseAlarmRate = 0.20;
% 
% %Creating positive image directories, one for each classifier
% folder = dir(posFolderName);
% posDirs = cell(1,numZones);
% 
% %Name the negative image folders
% negFolder = dir(negFolderName);
% negDirs = cell(1,numZones);
% 
% %Name the XML output names
% xmlNames = cell(1,numZones);
% 
% %Populate the cell arrays with the correct string names
% for x=1:numZones
%     posDirs{1,x} = [posFolderName,'\',folder(x+2).name]; 
%     negDirs{1,x} = [negFolderName,'\',negFolder(x+2).name]; 
%     xmlNames{1,x} = [xmlOutput,num2str(x)];
% end
% 
% %Call our function to train the cascade objects
% for y=1:numZones
%     trainCascadingClassifier(z{1,y}, posDirs{1,y}, negDirs{1,y}, ...
%         numTrainingStages, falseAlarmRate, xmlNames{1,y});
% end

%% Demonstrate and test determineHOGWithCascade

%Changeable variables
vidName = 'C:\Users\Matt\Documents\VTOS\Scripts\HOG\Sept_28_left_pm.mp4';
xmlName = 'xmlZone';

%Create objects
vReader = vision.VideoFileReader(vidName);
vPlayer = vision.VideoPlayer('Name','Cascade Object Detection',...
    'Position',[400 50 700 700]);

%Create a cell array of cascade detectors using the previously trained XML
%files
detector = cell(1,numZones);
xmlFolder = dir();
xmlArray = cell(1,numZones);
for i=1:numZones
    xmlArray{1,i} = strcat(xmlName, ...
        num2str(i),'.xml');
    detector{1,i} = vision.CascadeObjectDetector(xmlArray{1,i},...
        'UseROI',true);
end

%Create objects that overlay the image for display purposes
sInserterRed = vision.ShapeInserter('Shape','Rectangles','Fill',true,...
    'FillColor','Custom','CustomFillColor',[255 0 0],'Opacity', 0.001);
sInserterGreen = vision.ShapeInserter('Shape','Rectangles','Fill',true,...
    'FillColor','Custom','CustomFillColor',[0 255 0],'Opacity', 0.001);
bboxInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor',...
        'Custom', 'CustomBorderColor', [0 0 255]);
    
%Create cell array to hold bounding boxes
bboxes = cell(1,numZones);

%Start loop to read frames
while ~isDone(vReader)
   
    %Read image from video
    frame = step(vReader);
    
    %Iterate over each zone and insert proper overlays based on detected
    %bounding boxes
    for i=1:numZones
        
%         bboxes{1,i} = step(detector{1,i},frame, z{:,i});
        [determinations, bboxes] = determineHOGWithCascade(frame, ...
            z{:,i}, xmlArray); 
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
