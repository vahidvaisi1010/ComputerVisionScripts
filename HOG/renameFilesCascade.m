function renameFilesCascade(folder)

        % Get all JPG files in the current folder
        for j=1:4
            files = dir(strcat(folder,'\Track',num2str(j),'\*.png'));
            % Loop through each

            %Random number generation
            for k = 1:length(files)
                % Get the file name (minus the extension)
%                 [path, f] = fileparts(files(k).name);

                x = randn;
                movefile(strcat(folder,'\Track',num2str(j),'\',files(k).name),strcat(folder,'\Track',num2str(j),'\',num2str(x),'.png'));        
            end

            files = dir(strcat(folder,'\Track',num2str(j),'\*.png'));
            %Acrual number generation
            for k = 1:length(files)
                % Get the file name (minus the extension)
%                 [path, f] = fileparts(files(k).name);

                movefile(strcat(folder,'\Track',num2str(j),'\',files(k).name),strcat(folder,'\Track',num2str(j),'\',num2str(k),'.png'));        
            end
        end


end