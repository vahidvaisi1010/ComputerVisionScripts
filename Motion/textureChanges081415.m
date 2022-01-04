function textureChanges081415()
%%Motion detection and object tracking in grayscale videos based on
%%spatiotemporal texture changes
%http://www.cis.temple.edu/~latecki/Dissertations/RMiezianko_Dissertation.pdf

    vReader = vision.VideoFileReader('C:\Scripts\MotionUsingTextureChanges\t4_up.mp4');
    vPlayer = vision.VideoPlayer();

    BLOCKDIM = 16;
    NUMROWS = 15;
    NUMCOLS = 20;
    MAXFRAMES = 3;

    %Create structures to hold information
    blocks = cell(NUMROWS,NUMCOLS,MAXFRAMES); %3d cell array to hold blocks
    motionMeasures = zeros(NUMROWS, NUMCOLS, MAXFRAMES); 
    mu = zeros(NUMROWS,NUMCOLS,MAXFRAMES);
    dev = zeros(NUMROWS,NUMCOLS,MAXFRAMES);
    x=1; %holds frame count for building blocks

    while ~isDone(vReader)
            %obtain an image from the video
        frame = step(vReader);
        
        %break apart the image into smaller 8x8 squares
        temp = mat2cell(rgb2gray(frame),repmat(BLOCKDIM,NUMROWS,1),repmat(BLOCKDIM,NUMCOLS,1));

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
                    mu(rows,columns,pane) = mean2(motionMeasures(rows,columns,:));
                    dev(rows,columns,pane) = std2(motionMeasures(rows,columns,:));
                end
            end
            x=0; %reset x counter, it is increased to 1 later
        end
        x=x+1; %increase x counter
        step(vPlayer,frame);
        
        
    end
        
end

