function [hogDeterminations, roiFrame] = determineHOGWithSVM(frame,z,classifier)
%Return the determination of occupied/unoccupied for each zone in a given frame
%using the provided SVM classifier.
%Usage:         [hogDeterminations, roiFrame] = determineHOGWithSVM(frame, z, ...
%                           classifier)    
%
%
%Inputs:        frame: Frame to be analyzed
%               z: Cell array of ROI zones
%               classifier: Previously trained SVM classifier cell array
%
%Outputs:       hogDeterminations: cell array of determinations for each
%                                   roi
%               roiFrame: cropped image of the roi provided
%
%Author:        Vahid Vaisi
    
    %% Preallocate all memory
    try
        [testFeatures, cellSize, numZones] = preallocateMemory(z);
    catch ME
        msg = ['Could not preallocate Memory.'];
        causeException = MException('MATLAB:determineHOGWithSVM:allocation', ...
            msg);
        ME = addCause(ME, causeException);
        rethrow(ME);
    end

    %% Convert Frame to single image
    [~,~,num] = size(frame);
    if num==3
        I = im2single(rgb2gray(frame));
    elseif num == 1
        I = frame;
    end   
    
    %% Get hog features from each zone
    for h = 1:numZones
        try
            [testFeatures{h}, roiFrame] = getHogFeatures(I, z{:,h}, cellSize);     
        catch ME
            msg = ['Could not get HOG features from ROI.'];
            causeException = MException('MATLAB:determineHOGWithSVM:HOGfeatures', ...
                msg);
            ME = addCause(ME, causeException);
            rethrow(ME);
        end
    end
    
    %% Predict the labels for each zone. 0 = vacant, 1 = occupied
    try
        hogDeterminations = getPredictions(classifier, testFeatures, numZones);
    catch ME
        msg = ['Could not make a determination.'];
        causeException = MException('MATLAB:determineHOGWithSVM:getPredictions', ...
            msg);
        ME = addCause(ME, causeException);
        rethrow(ME);
    end


end

%Function to extract the hog features from a provided frame based on the
%provided zone ROI
function [features, roi] = getHogFeatures(frame, zone, cellSize)

    %Crop image to ROI
    roi = imcrop(frame, zone);
    
    %Get HOG features from ROI
    features = extractHOGFeatures(roi, 'CellSize', cellSize);
    
    
end

%Function that makes a prediction for each zone to be part of a label based
%on the classifier
function occupied = getPredictions(classifier, testFeatures, numZones)
    %Create threshold and cell array to hold determinations
    thresh = 0.30;
    occupied = cell(1,3);
    
    for q = 1:numZones
        
        %Predict with the SVM classifier
        [label, score] = predict(classifier{q}, testFeatures{q});
        
        %Set occupation true or false depending on the condition used
%         if strcmp(label,'0') %Alternative to select based on label
        if abs(score(1)) <= thresh %Alternative to select based on thresh

                occupied{q} = false;
        else
                occupied{q} = true;

        end
    end

end

%Function to preallocate memory to hold testFeatures and creates the
%cell size used for convolution when extracting HOG features
function [testFeatures, cellSize, numZones] = preallocateMemory(z)
    
    testFeatures = cell(1,3); %Testing features for classifier

    cellSize = [8 8]; %Used for Convolution
    
    numZones = numel(z); %number of zones
end

