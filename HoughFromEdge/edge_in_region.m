%performs edge detection on a region of interest. only edges within the
%region of interest will be detected, usefull if a new region is desired
%each time the code is run
%update 12/15/15 to use roi defined by c and r vectorsi
ip = 'ip';
image = slx2gray(ip);
[c, r] = setroi(image);%12/16/15 removed roi image from output variable
roi = roipoly(image, c, r);
edge = slx2edge(ip);

crop = edge;
crop(~roi) = 0;
%I2 = I.*cast(R,class(I)); %multiply
imshow(crop)


houghfromedge(crop, edge);