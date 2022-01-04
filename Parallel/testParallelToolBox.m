function images = testParallelToolBox(ip1,ip2)
    p = gcp();
    numImages = 2;
    f = cell(numImages);
    ips{1,1} = ip1;
    ips{1,2} = ip2;
    
     
    f(1) = parfeval(p, @grabImage,1,ips{1,1});
    f(2) = parfeval(p, @grabImage,1,ips{1,2});  
    
    images{1,1} = fetchOutputs(f(1));
    images{1,2} = fetchOutputs(f(2));
end

function img = grabImage(ip)
    protocol = 'http://';
    str = '/snap.jpg';
    
    finString = strcat(protocol, ip, str);
    img = webread(finString);
end