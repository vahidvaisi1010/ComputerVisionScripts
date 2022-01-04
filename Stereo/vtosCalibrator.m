leftURL = 'http:///axis-cgi/jpg/image.cgi';
rightURL = 'http:///axis-cgi/jpg/image.cgi';

filename1 = 'l1.jpg';
filename2 = 'r1.jpg';

l1 = imread(leftURL);
r1 = imread(rightURL);

imwrite(l1,filename1);
imwrite(r1,filename2);

subplot(1,2,1); imshow(l1); hold on

subplot(1,2,2); imshow(r1); hold on