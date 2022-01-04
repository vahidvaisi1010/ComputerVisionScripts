%Read all images from old files
trainingSetDir{1} = fullfile('C:\MATLAB\Occupied pictures\Track3\Zone1');
trainingSetDir{2} = fullfile('C:\MATLAB\Occupied pictures\Track4\Zone1');
trainingSetDir{3} = fullfile('C:\MATLAB\Occupied pictures\Track5\Zone1');

for j=1:3
   trainingSet{j} = imageSet(trainingSetDir{j}, 'recursive');
end

mkdir('C:\Scripts\HOG\singleTrainingPictures\0');
mkdir('C:\Scripts\HOG\singleTrainingPictures\1');

%Cut the images out
z = cell(1,3);
z{:,1} = [95.5 95.5 41 39];   
z{:,2} = [138.5 83.5 48 68]; 
z{:,3} = [191.5 109.5 55 78];  
filename = '';
x=1;

for h=1:3 %move through imagesets
    for idx = 1:numel(trainingSet{h})% 0 or 1 folders
        numImages = trainingSet{h}(idx).Count; %Get num images in folder

        for i=1:numImages %for each image
            img = imcrop(read(trainingSet{h}(idx), i), z{:,1}); %read it, crop it
            if idx == 1
                filename = strcat('C:\Scripts\HOG\singleTrainingPictures\0\',num2str(x),'.png');
            elseif idx == 2
                filename = strcat('C:\Scripts\HOG\singleTrainingPictures\1\',num2str(x),'.png');
            end
            x=x+1;
            imwrite(img,filename);
        end

    end
end

