function textureChanges081015()
%%Motion detection and object tracking in grayscale videos based on
%%spatiotemporal texture changes
%http://www.cis.temple.edu/~latecki/Dissertations/RMiezianko_Dissertation.pdf

    %System Object constructors
    vReader = vision.VideoFileReader('t4_up.mp4');
    vPlayer = vision.VideoPlayer();

    %Constants
    BLOCKDIMS = 16;
    NUMROWS = 15;
    NUMCOLS = 20;
    MAXFRAMES = 3;

    %Create structures to hold information
    blocks = cell(NUMROWS,NUMCOLS,MAXFRAMES); %3d cell array to hold blocks
    motionMeasures = zeros(NUMROWS, NUMCOLS, MAXFRAMES); 
    mu = zeros(NUMROWS,NUMCOLS);
    dev = zeros(NUMROWS,NUMCOLS);
    x=1; %holds frame count for building blocks
    
    states = zeros(NUMROWS,NUMCOLS);

    while ~isDone(vReader)
            %NEED TO PUT A CONDITION HERE TO ONLY UPDATE WHEN THERE IS
            %CURRENTLY NO MOTION
        [bkgMu,bkgDev] = updateBackground(vReader,vPlayer,NUMROWS,NUMCOLS,...
            MAXFRAMES,BLOCKDIMS);

        [mu,dev,x,blocks,motionMeasures] = checkFrame(vReader,vPlayer,NUMROWS,NUMCOLS,MAXFRAMES,x, ...
            BLOCKDIMS,blocks,motionMeasures,mu,dev);
        
        for i=1:NUMROWS
            for j=1:NUMCOLS
                check = (mu(i,j)-bkgMu(i,j));
                if check > .1
                   states(i,j) = 1; %motion
                else
                   states(i,j) = 0; %no motion
                end
            end
        end
        
    end
        
end

function [mu,dev,x,blocks,motionMeasures]=checkFrame(readerObject,playerObject,...
    NUMROWS,NUMCOLS,MAXFRAMES,x,EIGHT,blocks,motionMeasures,mu,dev)
        %obtain an image from the video
        frame = step(readerObject);
        
        %break apart the image into smaller 8x8 squares
        temp = mat2cell(rgb2gray(frame),repmat(EIGHT,NUMROWS,1),repmat(EIGHT,NUMCOLS,1));

        %add temp cell array to block
        for rows=1:NUMROWS
           for columns = 1:NUMCOLS
               blocks{rows,columns,x} = temp{rows,columns};    
           end
        end

        %calculate the spaciotemporal vector using PCA, retrieve variances
        if x==MAXFRAMES
            for rows = 1:NUMROWS
                for columns = 1:NUMCOLS
                    for pane = 1:3
                        [~,~,variances] = pca_mod(blocks{rows,columns,pane});

                        %note: variances(1) retrieves the largest variance
                        %from all principal components per block pane
                        motionMeasures(rows,columns,pane) = variances(1);

                    end

                    %calculate mean and standard deviatin
                    mu(rows,columns) = mean2(motionMeasures(rows,columns,:));
                    dev(rows,columns) = std2(motionMeasures(rows,columns,:));
                end
            end
            x=0; %reset x counter, it is increased to 1 later
        end
        x=x+1; %increase x counter
        step(playerObject,frame);
end


function [mu,dev]=updateBackground(readerObject,playerObject,NUMROWS,...
    NUMCOLS,MAXFRAMES,DIM)
    NUMFRAMES = 12;
    blocks = cell(NUMROWS,NUMCOLS,MAXFRAMES);
    motionMeasures = zeros(NUMROWS, NUMCOLS, MAXFRAMES); 
    mu = zeros(NUMROWS,NUMCOLS);
    dev = zeros(NUMROWS,NUMCOLS);
    x=1;
    for i=1:NUMFRAMES
        %obtain an image from the video
        frame = step(readerObject);
        
        %break apart the image into smaller 8x8 squares
        temp = mat2cell(rgb2gray(frame),repmat(DIM,NUMROWS,1),repmat(DIM,NUMCOLS,1));

        %add temp cell array to block
        for rows=1:NUMROWS
           for columns = 1:NUMCOLS
               blocks{rows,columns,x} = temp{rows,columns};    
           end
        end

        %calculate the spaciotemporal vector using PCA, retrieve variances
        if x==MAXFRAMES
            for rows = 1:NUMROWS
                for columns = 1:NUMCOLS
                    for pane = 1:3
                        [~,~,variances] = pca_mod(blocks{rows,columns,pane});

                        %note: variances(1) retrieves the largest variance
                        %from all principal components per block pane
                        motionMeasures(rows,columns,pane) = variances(1);

                    end

                    %calculate mean and standard deviatin
                    mu(rows,columns) = mean2(motionMeasures(rows,columns,:));
                    dev(rows,columns) = std2(motionMeasures(rows,columns,:));
                end
            end
            x=0; %reset x counter, it is increased to 1 later
            step(playerObject,frame);
        end
        x=x+1; %increase x counter
        
    end
    step(playerObject,frame);
    
    
end

