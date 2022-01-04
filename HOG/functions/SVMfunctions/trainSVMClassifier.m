function [classifier, hogFeatureSize] = trainSVMClassifier(z, trainingSetFolder)
%This function trains the SVM classifer used when implementing the HOG
%comparison algorithm
%
%Parameters: z: a cell array containing rectangle zones or ROIs
%            trainingSetFolder: Path to the images used to be trained,
%            where the file hierarchy should be constructed as follows.
%
%            trainingSetfolder: The folder name that contains the different
%            types of objects that will be trained. 
%               i.e. - 'TrainingImages/Track1' contains folders '0' and '1'
%               representing unoccupied and occupied
%               
%Usage:      classifier = trainClassifier(z);
%Author:     Vahid Vaisi

    %% Preallocate all memory to be used in the function
    try
       [classifier, cellSize, numZones]  = preallocateMemory(z);
    catch ME
        msg = ['Could not preallocate Memory.'];
        causeException = MException('MATLAB:trainSVMClassifier:allocation', ...
            msg);
        ME = addCause(ME, causeException);
        rethrow(ME);
    end

 %% Train the classifier using images in OccupiedPictures folder
    %Get Training sets from directories and hog features
    try
    [trainingSets, hogFeatureSize] = getTrainingImages(trainingSetFolder, ...
        cellSize,z, numZones);
    catch ME
        msg = ['Could not get training images.'];
        causeException = MException('MATLAB:trainSVMClassifier:images', ...
            msg);
        ME = addCause(ME, causeException);
        rethrow(ME);
    end
    
    %Get classifier
    try
        classifier = train(classifier, hogFeatureSize, ...
        z, trainingSets, cellSize);
    catch ME
        msg = ['Could not train the classifier.'];
        causeException = MException('MATLAB:trainSVMClassifier:training', ...
            msg);
        ME = addCause(ME, causeException);
        rethrow(ME);
    end
end

function [trainingSet, hogFeatureSize]= getTrainingImages(foldername, ...
    cellSize, z, numZones)

    %Create an imageSet for each zone using the given folder name
    trainingSet = cell(1,numZones);
    setFolders = dir(foldername);
    for i = 1:numZones
        trainingSetDir = fullfile(setFolders(i+2).name);      
        trainingSet{1,i} = imageSet(strcat(foldername,'\',trainingSetDir), 'recursive');       
    end
    
    % Get HOG feature size
    hog = cell(1,numZones);
    for i = 1:numZones
       img = imcrop(read(trainingSet{i}(1), 4), z{:,i});
       hog{i} = extractHOGFeatures(img, 'CellSize', cellSize);
       hogFeatureSize(i) = length(hog{i});
    end

end

function [classifier, cellSize, numZones] = preallocateMemory(z)
%Function used to preallocate memory used within the determineHOG function
    numZones = numel(z);
    classifier = cell(1,numZones); %SVM classifier 

    % Set up cell sizes for convolution for HOG
    cellSize = [8 8]; 
    
end

function classifier = train(classifier, hogFeatureSize, ...
    z, trainingSet, cellSize)
%Function used to train the SVM classifier to be used with determineHOG
%function
    numZones = numel(z);
    trainingFeatures = cell(1,numZones); %Training features for classifier
    trainingLabels = cell(1,numZones); %training labels for classifier
    
    for i = 1:numZones
        [trainingFeatures{i}, trainingLabels{i}] = helperExtractHOGFeaturesFromImageSetMod( z{:,i}, ...
            trainingSet{i}, hogFeatureSize(i), cellSize);
        classifier{i} = fitcecoc(trainingFeatures{i}, trainingLabels{i});
    end


end

function [featureVector, setLabels] = helperExtractHOGFeaturesFromImageSetMod(rect,...
    imgSet, hogFeatureSize, cellSize)
% Extract HOG features from an imageSet.

    featureVector = [];
    setLabels     = [];

    % Iterate over an array of imageSets
    for idx = 1:numel(imgSet)

        numImages = imgSet(idx).Count;
    %     numImages = length(imgSet);
        features  = zeros(numImages, hogFeatureSize, 'single');

        % Process each image and extract features
        for j = 1:numImages
    %         img = imcrop(read(imgSet(idx), j),rect);
            img = imcrop(read(imgSet(idx), j),rect);

            features(j, :) = extractHOGFeatures(img,'CellSize',cellSize);
        end

        % Use the Description from the imgSet as the labels
        labels = repmat(imgSet(idx).Description, numImages, 1);

        featureVector = [featureVector; features];
        setLabels     = [setLabels;     labels];

    end
end