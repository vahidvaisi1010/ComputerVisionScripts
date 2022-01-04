function stressTestVTOS
    disp('This Application simultaneously captures images');
    disp(' from xxxcameras and displays them.')
    disp('Images are saved in C:\SavedImages');
    n = 'SavedImages';
    path = strcat('C:\CCI\',n);
    logpath = strcat('C:\CCI\logs\');
    logname = strcat(logpath,'log.txt');
    stereo1 = strcat(path,'stereo1\');
    stereo2 = strcat(path,'stereo2\');
    
    
    mkdir(path);
    mkdir(logpath);
    mkdir(stereo1);
    mkdir(stereo2); 
    
    auxString = 'http://'; 
    auxString2 = '/snap.jpg';
    ip_prompt1 = 'Please enter ip address 1: ';
    ip_prompt2 = 'Please enter ip address 2: ';
    
    ip1 = input(ip_prompt1, 's');
    ip2 = input(ip_prompt2, 's');
    disp('ctl+c to kill the application');
    ip1= strcat(auxString,ip1,auxString2);
    ip2= strcat(auxString,ip2,auxString2);
    
    while true
%         [im1, im2] = mexCapture(ip1, ip2);
%         [im3, im4] = mexCapture(ip1, ip2);
        timestamp = datestr(now,'yyyy/dd/mm HH:MM:SS');
        
        try
%             im1 = webread(ip1);
%             im2 = webread(ip2);
%             im3 = webread(ip1);
%             im4 = webread(ip2);
%         
%             image1 = horzcat(im1,im2);
%             image2 = horzcat(im3,im4);
%             finImage = horzcat(image1, image2);
%             imshow(finImage);
                
            
    %         image = testParallelToolBox(ip1,ip2);
            filename = datestr(now,'yyyy-dd-mm_HH-MM-SS');
%             compName1 = strcat(stereo1,filename,'.png');
%             compName2 = strcat(stereo2,filename,'.png');
% 
%     %         imshow(image); title(filename);
%             imwrite(image1, compName1);
%             imwrite(image2, compName2);

              
              websave(strcat(stereo1,filename,'_1.jpg'), ip1);
              websave(strcat(stereo2,filename,'_2.jpg'), ip2);
              websave(strcat(stereo1,filename,'_3.jpg'), ip1);
              websave(strcat(stereo2,filename,'_4.jpg'), ip2);
        catch ME
            logFile = fopen(logname, 'a+');
            fprintf(logFile, '%s\r\n %s %s\r\n\r\n', timestamp, ME.identifier, ME.message); 
            fclose('all');
            break;
        end
    end   
    fclose('all');
end