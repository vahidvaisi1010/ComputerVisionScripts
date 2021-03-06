function occupied = get3DPointsForROI(frameLeft,frameRight,stereoparams,ROI, ...
    sceneROI,tform,yrestrictions, pointThreshold)
%Function to get occupation decision based on3D Points located in an ROI
%
%Inputs:    frameLeft => Left Image.
%           frameRight => Right Image.
%           stereparams => stereo parameters structure from calibrated
%               cameras.
%           ROI => 3x2 array specifying limits for ROI. 
%               i.e. -> [xmin, xmax; ymin, ymax; zmin, zmax]
%           sceneROI => 3x2 array specifying limits for the scene itself
%               i.e. -> [xmin, xmax; ymin, ymax; zmin, zmax]
%           tform => affine transformation structure that specifies how to
%               manipulate the scene in order to allow the extraction of the
%               proper ROI.
%           yrestrictions => 1x2 Array specifying the height restrictions
%               in our ROI. This is used to avoid counting ground pixels.
%           pointThreshold => Number used to threshold the number of points
%               that are returned in the bin.
%
%Outputs:   occupied => Returns true if the area is occupied or false if
%               the area is unoccupied.
%
%Author:    Vahid Vaisi

    %Rectify images and get disparity map
    [leftImgRect, rightImgRect] = rectifyStereoImages(leftImg, rightImg, stereoparams);
    disparityRange = [0 64];
    dispMap = disparity(rgb2gray(leftImgRect),rgb2gray(rightImgRect), ...
        'Blocksize',5,'DisparityRange', disparityRange, 'DistanceThreshold', 5);
    
    %Rebuild the 3D scene into a 3D array
    point3D = reconstructScene(dispMap, stereoparams);
    
    %Create a point cloud and apply transformation to level out the ROIs
    ptCloudScene = pointCloud(point3D);
    indiciesScene = findPointsInROI(ptCloudScene,sceneROI);
    ptCloudOutScene = select(ptCloudScene, indiciesScene);
    ptCloudOutScene = pcdenoise(ptCloudOutScene);
    ptCloudTrans = pctransform(ptCloudOutScene, tform);
    
    %Build 3D regions
    indices = findPointsInROI(ptCloudTrans, ROI);
    ptCloudROI = select(ptCloudTrans,indices);
    
    %Grab y values to represent height of points in ROI
    yvalues = ptCloudROI.Location(:,2);
    
    %Restrict ourselves to our vertical area of interest inside the ROI
    bin = yvalues(yvalues < yrestrictions(2) & yvalues > yrestrictions(1));
    
    if length(bin) > threshold
        occupied = true;
    else
        occupied = false;
    
end