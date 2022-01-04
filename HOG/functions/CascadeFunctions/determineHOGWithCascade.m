function [determinations, bboxes] = determineHOGWithCascade(frame,z,classifierArray)
%Return the determination of occupied/unoccupied for each zone in a given frame
%using the provided cell array of cascade classifiers.
%Usage:         [hogDeterminations, roiFrame] = determineHOGWithCascade(frame, z,
%                           classifierArray)    
%
%
%Inputs:        frame: Frame to be analyzed
%               z: Cell array of ROI zones
%               classifierArray: Cell array of cascade classifiers (.xml format)
%
%Outputs:       determinations: Cell array of determinations for each zone.
%               bboxes: Cell array of bounding boxes for each object
%               detected.
%
%Author:        Vahid Vaisi
    
    %% Preallocate all memory and create objects
    try
        [objectDetectors, numClassifiers] = preallocateMemory(classifierArray);
    catch ME
        msg = ['Could not preallocate Memory or read classifier file.'];
        causeException = MException('MATLAB:determineHOGWithCascade:allocation', ...
            msg);
        ME = addCause(ME, causeException);
        rethrow(ME);
    end

    
    %% Find objects and get determinations for each ROI
    try
        [determinations, bboxes] = findObjects(objectDetectors,frame,z,numClassifiers);
    catch ME
        msg = ['Could not try to find objects for some reason.'];
        causeException = MException('MATLAB:determineHOGWitchCascade:findObjects', ...
            msg);
        ME = addCause(ME, causeException);
        rethrow(ME);
    end

end


%Function that makes a prediction for each zone to be part of a label based
%on the classifier
function [occupied, bboxes] = findObjects(objectDetectors, frame, z, numClassifiers)
    %Create cell array to hold determinations
    occupied = cell(1,numClassifiers);
    bboxes = cell(1,numClassifiers);
    
    for i = 1:numClassifiers
        
        %Locate objects with the object detectors
        bboxes{1,i} = step(objectDetectors{1,i}, frame, z{:,i});
        
        %Set occupation true or false with found objects
        if isempty(bboxes{1,i}) 

                occupied{i} = false;
        else
                occupied{i} = true;

        end
    end

end

%Function to preallocate memory to hold cascade classifier object detectors
function [objectDetectors, numClassifiers] = preallocateMemory(classifierList)
    numClassifiers = numel(classifierList);
    
    objectDetectors = cell(1,numClassifiers);
    
    for i=1:numClassifiers
       objectDetectors{1,i} = vision.CascadeObjectDetector(classifierList{1,i}, ...
           'UseROI', true);
    end

end

