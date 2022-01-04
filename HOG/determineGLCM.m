function [determinations, e] = determineGLCM(frame, z)
%Determine the difference in the GLCM properties and determine if an
%object is in the zone
%Parameters:    

numZones = 9;
glcm = cell(1,9);
props = cell(1,9);
determinations = cell(1,9);
e = cell(1,9);
zones = cell(1,9);

    for i = 1:numZones
        zones{i} = imcrop(rgb2gray(frame), z(i,:));
        glcm{i} = graycomatrix(zones{i},'Offset',[2 0]);
        props{i} = graycoprops(glcm{i});
        e{i} = entropy(zones{i});
        if props{i}.Correlation < 0
           determinations{i} = false;
        else
            determinations{i} = true;
        end
    end
    
end