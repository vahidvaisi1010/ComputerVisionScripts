function [featureVector, setLabels] = helperExtractHOGFeaturesFromImageSetMod2(rect, imgSet, hogFeatureSize, cellSize)
% Extract HOG features from an imageSet.

featureVector = [];
setLabels     = [];

% Iterate over an array of imageSets
for idx = 1:numel(imgSet)
    
    numImages = imgSet(idx).Count;
%     numImages = length(imgSet);
    features = zeros(numImages, hogFeatureSize, 'single');
    
    % Process each image and extract features
    for j = 1:numImages
%         img = imcrop(read(imgSet(idx), j),rect);
        img = imcrop(read(imgSet(1), j),rect);
        
%         feat = extractHOGFeatures(img,'CellSize', cellSize);
%         size = length(feat); 
        
        features(j, :) = extractHOGFeatures(img,'CellSize',cellSize);
    end
    
    % Use the Description from the imgSet as the labels
    labels = repmat(imgSet(idx).Description, numImages, 1);
    
    featureVector = [featureVector; features];
    setLabels     = [setLabels;     labels];
    
end