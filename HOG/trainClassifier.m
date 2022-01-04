function [classifier, hogFeatureSize] = trainClassifier(z, trainingSetFolder)
%This function trains the SVM classifer used when implementing the HOG
%comparison algorithm
%Parameters: z => a cell array containing rectangle zones or ROIs
%Usage: classifier = trainClassifier(z);
%Written by: Vahid Vaisi

    %% Preallocate all memory to be used in the function
    [classifier, cellSizeFrontZones, cellSizeBackZones]  = preallocateMemory();

 %% Train the classifier using images in OccupiedPictures folder
    %Get Training sets from directories and hog features
    [trainingSet, hogFeatureSize] = getTrainingImages(cellSizeFrontZones, ...
        cellSizeBackZones,z);
    
    %Get classifier
    classifier = train(classifier, hogFeatureSize, ...
    z, trainingSet, cellSizeFrontZones, cellSizeBackZones);
end

function [trainingSet, hogFeatureSize]= getTrainingImages(cellSizeFrontZones, ...
    cellSizeBackZones, z)
    trainingSet = cell(1,3);
    for i = 1:3
        trainingSetDir = fullfile(strcat(trainingSetFolder,num2str(i)));      
        trainingSet{1,i} = imageSet(trainingSetDir, 'recursive');       
    end
    
    hog = cell(1,3);
    for i = 1:3
       
       csize =  cellSizeFrontZones;
       img = imcrop(read(trainingSet{i}(1), 4), z{:,i});
       hog{i} = extractHOGFeatures(img, 'CellSize', csize);
       hogFeatureSize(i) = length(hog{i});
    end

end

function [classifier, cellSizeFrontZones,...
    cellSizeBackZones] = preallocateMemory()
%Function used to preallocate memory used within the determineHOG function

    hogFeatureSize = zeros(1,3); %Size of hog features
    classifier = cell(1,3); %SVM classifier 

    %% Set up cell sizes for convolution for HOG
    cellSizeFrontZones = [8 8]; %Used for zone 1 on each track
    cellSizeBackZones = [4 4]; %Used for zones 2 and 3 on each track
    
    tempdir = 'tempholdingforHOG';
    mkdir(tempdir);

end

function classifier = train(classifier, hogFeatureSize, ...
    z, trainingSet, cellSizeFrontZones, cellSizeBackZones)
%Function used to train the SVM classifier to be used with determineHOG
%function

    %disp('Training Classifier');

    trainingFeatures = cell(1,3); %Training features for classifier
    trainingLabels = cell(1,3); %training labels for classifier
    for i = 1:3
        csize =  cellSizeFrontZones;
       
        zone = z{:,i};
        [trainingFeatures{i}, trainingLabels{i}] = helperExtractHOGFeaturesFromImageSetMod( zone, ...
            trainingSet{i}, hogFeatureSize(i), csize);
        classifier{i} = fitcecoc(trainingFeatures{i}, trainingLabels{i});
    end
    %disp('Trained HOG classifier');

end