function [dists, labels, point3D] = getObjectDistance(leftFrame, ...
    rightFrame, xmlfile, stereoParams)
%Find an object in the scene and return its distance and 3D location.
%
%
%Inputs:    leftFrame-> The left image to analyze.
%           rightFrame-> The right image to analyze.
%           xmlfile-> The XML file previously created for the cascade
%           detection.
%           stereoParams-> Previously created stereo parameters for the
%           calibrated cameras. Used in depth calculation.
%
%Outputs:   dists-> distance to each object found.
%           labels-> string for each distance found (ft).
%           point3D-> 3D point cloud containing x,y,z for each point.
%
%Author:    Vahid Vaisi

%% Rectify images and get disparity map
disparityRange = [0 64];

[leftImgRect, rightImgRect] = rectifyStereoImages(leftFrame, rightFrame, ...
    stereoParams);

dispMap = disparity(rgb2gray(leftImgRect),rgb2gray(rightImgRect), ...
    'Blocksize',5,'DisparityRange', disparityRange, 'DistanceThreshold', 5);

%% Find objects, calculate centroids, and find Z distance.
objDetector = vision.cascadeObjectDetector(xmlfile);

bboxes = objDetector.step(leftImgRect);

centroids = [round(bboxes(:, 1) + bboxes(:, 3) / 2), ...
    round(bboxes(:, 2) + bboxes(:, 4) / 2)];

centroidsIdx = sub2ind(size(dispMap), centroids(:, 2), centroids(:, 1));
X = point3D(:, :, 1);
Y = point3D(:, :, 2);
Z = point3D(:, :, 3);
centroids3D = [X(centroidsIdx)'; Y(centroidsIdx)'; Z(centroidsIdx)'];

dists = sqrt(sum(centroids3D .^ 2)) / 12;

labels = cell(1, numel(dists));
for i = 1:numel(dists)
    labels{i} = sprintf('%0.2f Feet', dists(i));
end

%% Create 3D cloud
point3D = reconstructScene(dispMap, stereoParams);

% Convert from millimeters to meters.
z = point3D(:,:,3);
z(z < 0 | z > 360) = NaN;
x = point3D(:,:,1);
x(x < -120 | x > 120) = NaN;
point3D(:,:,3) = z;
point3D(:,:,1) = x;

end