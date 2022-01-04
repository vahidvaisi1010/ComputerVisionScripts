%% Build LocalCalibration Library Given 2 Stereo Cameras

% Cameras
leftURL = 'http:/ip/axis-cgi/jpg/image.cgi';
rightURL = 'http:/ip/axis-cgi/jpg/image.cgi';
%Grab images n times and write to file
mkdir('OfficeCalibrationImages77');
for i = 1:30
    pause(1);
    ct = clock;
    timestamp = datestr(now,'yyyy-dd-mm_HH-MM-SS');
    [imLeft, imRight] = mexCapture(leftURL,rightURL);
    imwrite(imLeft, ...
        [pwd '\OfficeCalibrationImages77\left\left' '_session_' timestamp '_' num2str(i) '.jpg']);
    imwrite(imRight, ...
        [pwd '\OfficeCalibrationImages77\right\right' '_session_' timestamp '_' num2str(i) '.jpg']);    
end

