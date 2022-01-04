function trainCascadingClassifier(zone, positiveImageDir, negativeImageDir,...
    numStages, falseAlarm, xmlOutput)
%Create a single cascading classifiers given a specified ROI. This script can be
%used rather than the "Classification Learner" application provided with
%Matlab, but only if the ROI exactly contains the object of interest.
%
%Inputs:        z: Cell array of ROI's we are getting images from.
%               positiveImageDir: Directory containing positive images for
%               training(not including ending slash).
%               negativeImageDir: Directory containing negative images for
%               training (not including ending slash).
%               numStages: The number of cascade stages used to train the
%               detector.
%               falseAlarm: The false alarm rate used to train the detector
%               (usually between 0 and 1 in decimal form, i.e. 0.20)
%               xmlOutput: The name of the xmlfile to save the xml trainer
%               to. (Does not need '.xml' extension)
%
%Outputs:       An XML file is saved directly to the xmlOutput name
%               provided.
%
%Author:        Vahid Vaisi
    %% Create the positive array
    temp = dir([positiveImageDir,'\*']);
    numPics = length(temp(not([temp.isdir])));
    for i=1:numPics
        disp(i)
        posArray(i).imageFilename = [positiveImageDir,'\',temp(i+2).name];
        posArray(i).objectBoundingBoxes = zone;
    end
    
    %% Train the cascade classifier
    trainCascadeObjectDetector([xmlOutput,'.xml'], posArray, negativeImageDir,...
        'NumCascadeStages', numStages, ...
        'FalseAlarmRate', falseAlarm, ...
        'FeatureType', 'HOG');
    
    
end