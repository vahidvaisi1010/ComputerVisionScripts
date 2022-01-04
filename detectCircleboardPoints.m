function [imagePoints] = detectCircleboardPoints(...
    imageFilenames1, imageFilenames2, radiusRange, folder)

%% Create cell arrays containing file names 
    if isempty(imageFilenames1)
        disp('filenames1 is empty');
    elseif isempty(imageFilenames2)
        disp('filenames2 is empty');
    end
    
    %Check for the same number of images
    numImagePairs1 = numel(imageFilenames1);
    numImagePairs2 = numel(imageFilenames2);
    if ~(numImagePairs1 == numImagePairs2)
        disp('The number of images in the folders are not equal');
    end
    
    
%% Get centroids of circles
    numCircles = 15;
%     imagePoints = zeros(numCircles, 2, numImagePairs1, 2);
    left = 1;
    right = 2;
    xcoord = 1;
    ycoord = 2;
    usedImageCt = 0;
    
    for i=1:numImagePairs1
        
        %Get images and extract circle centroids
        imLeft = imread(strcat(folder,'\left\',imageFilenames1(i).name));
        imRight = imread(strcat(folder,'\right\',imageFilenames2(i).name));

        ptsLeft = imfindcircles(imLeft, radiusRange, 'ObjectPolarity', 'dark');
        ptsRight = imfindcircles(imRight, radiusRange, 'ObjectPolarity', 'dark');
        
        %For each detected circle, we add it to the imagePoints structure
        lefty = size(ptsLeft) == numCircles;
        righty = size(ptsRight) == numCircles;
        if lefty(1) && righty(1)
           usedImageCt = usedImageCt+1; 
           
           for j=1:numCircles
            
                    imagePoints(j, xcoord, usedImageCt, left) = ptsLeft(j,1);
                    imagePoints(j, ycoord, usedImageCt, left) = ptsLeft(j,2);

                    imagePoints(j, xcoord, usedImageCt, right) = ptsRight(j,1);
                    imagePoints(j, ycoord, usedImageCt, right) = ptsRight(j,2);
                
           end 
        else
            disp('All 15 circles were not found');
        end 
        
    end

end