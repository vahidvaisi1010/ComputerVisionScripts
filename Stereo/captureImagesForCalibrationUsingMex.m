
%% USE THIS BLOCK FOR SIGHTLOGIX CAMERAS


%% USE THIS BLOCK FOR BOSCH CAMERAS
leftIP = 'ip';
rightIP = 'ip';
folder = '';

endString = '/snap.jpg';
protocol = 'http://';
leftHTTP = strcat(protocol,leftIP,endString);
rightHTTP = strcat(protocol,rightIP,endString);

%% Not this stuff
leftFold = strcat(folder,'\left');
rightFold = strcat(folder,'\right');
mkdir(folder);
mkdir(leftFold);
mkdir(rightFold);


  

for x=1:100
pause(0);
    
%Capture images using our mex function    
% [imLeft, imRight] = mexCapture(leftHTTP,rightHTTP);
imLeft = webread(leftHTTP);
imRight = webread(rightHTTP);
ct = clock;
timestamp = datestr(now,'yyyy-dd-mm_HH-MM-SS');

drawnow;

% %Write Image
imwrite(imLeft, strcat(leftFold,'\left_session_', timestamp, '_', num2str(x), '.jpg'));
imwrite(imRight, strcat(rightFold,'\right_session_', timestamp, '_', num2str(x), '.jpg'));

end
