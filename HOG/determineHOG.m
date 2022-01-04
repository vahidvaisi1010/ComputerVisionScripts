function [hogDeterminations, vacCounter, occCounter, frame] = determineHOG(frame, z, hogFeatureSize,...
    classifier, vacCounter, occCounter)
%Return the determination for each zone for occupancy within the VTOS
%application.
%Usage: 
%
%
%Dependencies:
    
    %% Preallocate all memory
    [testFeatures, ...
    cellSizeFrontZones, cellSizeBackZones, tempdir] = preallocateMemory();

    %Convert Frame to single image
    [~,~,num] = size(frame);
    if num==3
        I = im2single(rgb2gray(frame));
    elseif num == 1
        I = frame;
    end
        
    
    %Create an ImageSet structure using our single image
    imwrite(I, strcat(tempdir,'/temp.jpg'));
    I2 = imageSet(tempdir,'recursive');
    
    %Get hog features
    for h = 1:3
       csize =  cellSizeFrontZones;
       [testFeatures{h}, ~] = helperExtractHOGFeaturesFromImageSetMod2(z{:,h}, ...
                    I2, hogFeatureSize(h), csize);
    end
    
    %Predict the labels for each zone. 0 = vacant, 1 = occupied
    hogDeterminations = getPredictions(vacCounter, occCounter, ...
    classifier, testFeatures);


end

function occupied = getPredictions(vacCounter, occCounter, ...
    classifier, testFeatures)
    thresh = 0.30;
    occupied = cell(1,3);
    
    for q = 1:3
        [label, score] = predict(classifier{q}, testFeatures{q});
%         if strcmp(label,'0')
        if abs(score(1)) <= thresh
%             vacCounter{q} = vacCounter{q}+1;
%             if vacCounter{q} >= 5
                occupied{q} = false;
%                 occCounter{q} = 0;
%             else
%                 occupied{q} = true;
%             end
        else
%             occCounter{q} = occCounter{q} + 1;
%             if occCounter{q} >= 5 
                occupied{q} = true;
%                 vacCounter{q} = 0;
%             else
%                 vacCounter{q} = vacCounter{q}+1;
%                 if vacCounter{q} >= 5
%                     occupied{q} = false;
%                 end
%             end
        end
    end

end


function [testFeatures, ...
    cellSizeFrontZones, cellSizeBackZones, tempdir] = preallocateMemory()

%     occCounter = cell(1,9); %Used to count occupancy frames
%     vacCounter = cell(1,9);
%     for f=1:9
%        occCounter{f} = 0; 
%        vacCounter{f} = 0;
%     end

    testFeatures = cell(1,3); %Testing features for classifier

    tempdir = 'tempholdingforHOG';
    mkdir(tempdir);

    %Set up cell sizes for convolution for HOG
    cellSizeFrontZones = [8 8]; %Used for zone 1 on each track
    cellSizeBackZones = [4 4]; %Used for zones 2 and 3 on each track

end

