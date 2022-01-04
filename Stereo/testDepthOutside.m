% player1 = pcplayer([0 75],[0 175],[270 315],'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
% xlabel(player1.Axes,'X (in)');
% ylabel(player1.Axes,'Y (in)');
% zlabel(player1.Axes,'Z (in)');
% 
% 
% player2 = pcplayer([0 75],[0 175],[325 380],'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down');
% xlabel(player2.Axes,'X (in)');
% ylabel(player2.Axes,'Y (in)');
% zlabel(player2.Axes,'Z (in)');

% leftReader = vision.VideoFileReader('\\ip\ServerShared\Left\1.mp4');
% rightReader = vision.VideoFileReader('\\ip\ServerShared\Right\2.mp4');
% leftReader = vision.VideoFileReader('C:\Users\_left.avi');
% rightReader = vision.VideoFileReader('C:\Users\_right.avi');
leftPlayer = vision.DeployableVideoPlayer('Name','Left Camera');
leftRectFront = [160,168,50,24];
leftRectBack = [160,147,50,21];
vWriter = vision.VideoFileWriter('Filename','ThreeDVid.avi',...
                                'FileFormat','AVI',...
                                'FrameRate',7);

%Get stereoParams
load('stereoParamsO1.mat');
stereoparams = stereoParamsO1;

%Try affine transformation
    A = [1 0 0 0; ...
         0 cos(-(0.279253)) sin(-(0.279253)) 0; ...
         0 -sin(-(0.279253)) cos(-(0.279253)) 0; ...
         0 0 0 1];
     tform = affine3d(A);

frontCounter = 0;
frontCounter2 = 0;
backCounter = 0;

occF = false;
occFZ = false;
occBZ = false;
occB = false;
first = true;
while true


    try
        leftImg = imread('http://ip/axis-cgi/jpg/image.cgi');
        rightImg = imread('http://ip/axis-cgi/jpg/image.cgi');
%         leftImg = step(leftReader);
%         rightImg = step(rightReader);
    catch
       continue;
    end

    %Rectify images and get disparity map
    [leftImgRect, rightImgRect] = rectifyStereoImages(leftImg, rightImg, stereoparams);
    disparityRange = [0 64];
    dispMap = disparity(rgb2gray(leftImgRect),rgb2gray(rightImgRect), ...
        'Blocksize',5,'DisparityRange', disparityRange, 'DistanceThreshold', 5);

    %Rebuild the 3D scene
    point3D = reconstructScene(dispMap, stereoparams);

    %Extract useful information from pointcloud
    sceneroi = [-240,240;0,600;0,600];

    ptCloudScene = pointCloud(point3D);
    indiciesScene = findPointsInROI(ptCloudScene,sceneroi);
    ptCloudOutScene = select(ptCloudScene, indiciesScene);
    ptCloudOutScene = pcdenoise(ptCloudOutScene);
    ptCloudTrans = pctransform(ptCloudOutScene, tform);

    %Build ROI for the scene, and each zone
    roiFront = [0,75;0,175;270,320];
    roiBack = [0,75;0,175;320,380];
  
    indices = findPointsInROI(ptCloudTrans, roiFront);
    ptCloudTransROIFront = select(ptCloudTrans,indices);
    indices = findPointsInROI(ptCloudTrans, roiBack);
    ptCloudTransROIBack = select(ptCloudTrans,indices);
    
    %Grab y values for each zone
    yvaluesFront = ptCloudTransROIFront.Location(:,2);
    yvaluesBack = ptCloudTransROIBack.Location(:,2);

    %Bin the values for our 3D dimensional area of concern
    bin1Front = yvaluesFront(yvaluesFront < 145 & yvaluesFront > 0);
    bin1Back = yvaluesBack(yvaluesBack < 145 & yvaluesBack > 0);
    
    zvalues = [];
    xvalues = [];
    yvalues = [];
    for i=1:ptCloudTransROIFront.Count
        if(ptCloudTransROIFront.Location(i,2) < 145 && ptCloudTransROIFront.Location(i,2) > 0)
            zvalues = [zvalues; (ptCloudTransROIFront.Location(i,3))];
            yvalues = [yvalues; (ptCloudTransROIFront.Location(i,2))]; 
            xvalues = [xvalues; (ptCloudTransROIFront.Location(i,1))]; 
        end
    end
    
    zvalues2 = [];
    yvalues2 = []; 
    xvalues2 = [];
    for i=1:ptCloudTransROIBack.Count
        if(ptCloudTransROIBack.Location(i,2) < 145 && ptCloudTransROIBack.Location(i,2) > 0)
            zvalues2 = [zvalues2; (ptCloudTransROIBack.Location(i,3))];
            yvalues2 = [yvalues2; (ptCloudTransROIBack.Location(i,2))]; 
            xvalues2 = [xvalues2; (ptCloudTransROIBack.Location(i,1))]; 
        end
    end
    
    xLimit = 75/5; %inchestotal/sizeBins
    
    %Bin X
    tempF = zeros(xLimit,1);
    for x=1:length(xvalues)
        num = ceil(xvalues(x)/5);
        tempF(num) = tempF(num)+1;
    end
    
    count = 0;
    for m=1:length(tempF)
        if tempF(m) > 2
            count = count + 1;
            if count > 4
               occF=true; 
               break;
            else 
               occF = false;
            end
        else
            count = 0;
        end
    end
    
    disp(tempF);
    
    tempB = zeros(xLimit,1);
    for x=1:length(xvalues2)
        num = ceil(xvalues2(x)/5);
        tempB(num) = tempB(num)+1;
    end
    
    count = 0;

    for m=1:length(tempB)
        if tempB(m) > 2
            count = count + 1;
            if count > 4
               occB=true; 
               break;
            else 
               occB = false;
            end
        else
            count = 0;
        end
    end 
    disp(tempB);
    
%     %Bin Z
%     zLimitF = 50/5;
%     zLimitB = 60/5;
%     tempFZ = zeros(zLimitF,1);
%     for z=1:length(zvalues)
%         num = ceil(zvalues(z)/5);
%         tempFZ(num) = tempFZ(num)+1;
%     end
%     
%     count = 0;
%     for m=1:length(tempFZ)
%         if tempFZ(m) > 2
%             count = count + 1;
%             if count > 1
%                occFZ=true; 
%                break;
%             else 
%                occFZ = false;
%             end
%         else
%             count = 0;
%         end
%     end
%     
%     disp(tempFZ);
%     
%     tempBZ = zeros(zLimitB,1);
%     for z=1:length(zvalues2)
%         num = ceil(zvalues2(z)/5);
%         tempBZ(num) = tempBZ(num)+1;
%     end
%     
%     count = 0;
% 
%     for m=1:length(tempBZ)
%         if tempBZ(m) > 2
%             count = count + 1;
%             if count > 1
%                occBZ=true; 
%                break;
%             else 
%                occBZ = false;
%             end
%         else
%             count = 0;
%         end
%     end 
%     disp(tempBZ);
    
    
    
    %Display information based on location determined.
    threshold = 325;
    num=10;
    
    if length(bin1Front) > threshold
%         disp(strcat('Front occupied: ',num2str(length(bin1Front))));
        if occF %&& occFZ
            disp('front occ')
            leftImg = insertShape(leftImg, 'FilledRectangle', leftRectFront, 'Opacity', .1, 'Color','red');
        else
            disp('front empty')
            leftImg = insertShape(leftImg, 'FilledRectangle', leftRectFront, 'Opacity', .1, 'Color','green');
        end


    else
%         disp(strcat('Front vacant: ',num2str(length(bin1Front))));
        leftImg = insertShape(leftImg, 'FilledRectangle', leftRectFront, 'Opacity', .1, 'Color','green');
        dec = size(xvalues)>num & size(yvalues)>num & size(zvalues)>num;
        if dec(1) == 1
            disp('front empty');
        end
    end
    
    if length(bin1Back) > threshold
        
%         disp(strcat('Back occupied: ',num2str(length(bin1Back))));
        if occB %&& occBZ
            disp('back occ');
            leftImg = insertShape(leftImg, 'FilledRectangle', leftRectBack, 'Opacity', .1, 'Color','red');
        else
            disp('back empty');
            leftImg = insertShape(leftImg, 'FilledRectangle', leftRectBack, 'Opacity', .1, 'Color','blue');
        end

    else
%         disp(strcat('Back vacant: ',num2str(length(bin1Back))));
        leftImg = insertShape(leftImg, 'FilledRectangle', leftRectBack, 'Opacity', .1, 'Color','blue');
        dec = size(xvalues2)>num & size(yvalues2)>num & size(zvalues2)>num;
        if dec(1) == 1
            disp('back empty');
        end
    end
    
    %Display to players
%     view(player1, ptCloudTransROIFront);
%     view(player2, ptCloudTransROIBack);
    step(leftPlayer,leftImg);
    step(vWriter, leftImg);

end

release(leftReader);
release(rightReader);
release(vWriter);
release(leftPlayer);
