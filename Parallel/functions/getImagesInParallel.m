function images = getImagesInParallel(varargin)
%Pull two images in parallel. 
%
%Inputs:    ip1 => IP input of left camera
%           ip2 => IP input of the right camera

%
%Outputs:   images => A cell array of the two images pulled.
%
%Author:    Vahid Vaisi

    %Parse inputs to handle variable number of inputs
    switch nargin
        case 2
            ips{1,1} = varargin{1,1};
            ips{1,2} = varargin{1,2};
            type = '';
        case 3
            ips{1,1} = varargin{1,1};
            ips{1,2} = varargin{1,2};
            type = varargin{1,3};
        otherwise
            msgID = 'getImagesInParallel:inputValidation';
            msg = 'There was an improper number of inputs.';
            exception = MException(msgID, msg);
            throw(exception)
    end

    %Create parallel pool and set up ip images
    p = gcp();
    numImages = 2;
    
    %Execute everything in parallel  
    parfor i=1:numImages
        images{1,i} = grabImage(ips{1,i}, type);   
    end
end

%Function to grab the image from the camera based on the type manufacturer
%of camera.
function img = grabImage(ip, type)
    %Build string to send via http request
    protocol = 'http://';
    if strcmp(type, 'bosch') || strcmp(type, 'Bosch') || strcmp(type, 'BOSCH')
        str = '/snap.jpg';
    else
        str = '/axis-cgi/jpg/image.cgi';
    end
    
    finString = strcat(protocol, ip, str);
    
    %Send request to get image from camera
    try
        img = imread(finString);
    catch ME
        msg = ['Could not get image from camera.'];
        causeException = MException('MATLAB:grabImage:GetImage', ...
            msg);
        ME = addCause(ME, causeException);
        rethrow(ME);
    end
        
end
