function showZones(frame)
    
    %Create zone array 
    z = cell(1,3);
    z{:,1} = [95.5 95.5 41 39];   
    z{:,2} = [138.5 83.5 48 68]; 
    z{:,3} = [191.5 109.5 55 78]; 
    
    zone = cell(1,3);
    
    for i=1:3
       zone{:,i} = imcrop(frame, z{:,i}); 
       figure, imshow(zone{:,i});
    end
    
    


end