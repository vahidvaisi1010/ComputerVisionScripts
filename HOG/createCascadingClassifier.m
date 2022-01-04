clear;
close all;
clc;

%Straighten out file names
%renameFilesCascade('leftNegPics');
%disp('Renamed Files... Starting First Classifier');

numTracks = 4;

%Read images from folder for each track, then create an array of structs
%with the format struct(imageFileName, objectBoundingBoxes) where the
%imageFileName is the number of each image inside each separate track
%folder for 0, and the bounding boxes being the proper zone array.
% posArrayHolder = cell(1,numTracks); %holds each array of structs for positive image training
% negStrings = cell(1,numTracks);
% xmlOutput = cell(1,numTracks);

%Create zone array 
z = cell(1,numTracks);
z{:,1} = [31.5 109.5 57 60];   
z{:,2} = [102.5 110.5 57 60]; 
z{:,3} = [171.5 113.5 57 60]; 
z{:,4} = [236.5 112.5 67 60];

for i=1:numTracks 
    directory = strcat('C:\Scripts\HOG\LeftTrainingPictures\Track',num2str(i));
    
    %Create positive array
    folder = directory;
    temp = dir([folder, '\*.png']);
    numPics = length(temp(not([temp.isdir])));
    for k=1:numPics %loop through pictures
        posArray(k).imageFilename = strcat(folder,'\', num2str(k),'.png');
        posArray(k).objectBoundingBoxes = z{:,i};
    end    
   %Train the cascade classifier 
    %     negStrings = 'C:\Users\CCI-Remote\Documents\BNSFDemo\sunDB\someImages';
   negStrings = strcat('C:\Scripts\HOG\leftNegPics\Track', num2str(i));
   xmlOutput = strcat('xmlTrainer',num2str(i),'.xml'); 
   trainCascadeObjectDetector(xmlOutput,posArray,negStrings,...
        'NumCascadeStages',7,'FalseAlarmRate',0.20,'FeatureType','HOG');
   clear posArray;
   disp('Classifier object completed.');
end
disp('All classifiers trained');