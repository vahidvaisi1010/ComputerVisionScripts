function renameFiles()
    for i=1:3
        % Get all JPG files in the current folder
        for j=1:2
            files = dir(strcat('TrainingPictures\Track',num2str(i),'\',num2str(j-1),'\*.jpg'));
            % Loop through each

            %Random number generation
            for k = 1:length(files)
                % Get the file name (minus the extension)
                [path, f] = fileparts(files(k).name);

                x = randn;
                movefile(strcat('TrainingPictures\Track',num2str(i),'\',num2str(j-1),'\',files(k).name),strcat('TrainingPictures\Track',num2str(i),'\',num2str(j-1),'\',num2str(x),'.jpg'));        
            end

            files = dir(strcat('TrainingPictures\Track',num2str(i),'\',num2str(j-1),'\*.jpg'));
            %Acrual number generation
            for k = 1:length(files)
                % Get the file name (minus the extension)
                [path, f] = fileparts(files(k).name);

                movefile(strcat('TrainingPictures\Track',num2str(i),'\',num2str(j-1),'\',files(k).name),strcat('TrainingPictures\Track',num2str(i),'\',num2str(j-1),'\',num2str(k),'.jpg'));        
            end
        end
    end

end