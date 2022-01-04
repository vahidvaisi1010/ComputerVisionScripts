function [ lines1, lines ] = detect_spec_edge_in_roi( ip, c, r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%edge detection performed in a region of interet, roi described by vectors
%returns lines
%lines are now compared to a static value of theta, any lines that do not
%match the valueof theta are discarded. confirmed lines are plotted over
%the grayscale image and compared side by side to an image with all lines
%in the region.
%lines1 is meant to be the lines structure with the imporper values deleted
%while lines is the originalwith all lines in the region
%could also create profiles for different objects or locations, e.g a car
%or object in one location corresponds to these theta and rho values
%todo: make cleaner code for removing line structures that donot contain
%the correct values, research possible methods of matching houghlines to an
%arbitrary plane or line orientation, may include stereo
%find out why houghlines shows more lines in aspecific region if the area
%is restricted, thinking there is a static number oflines detected
%regardless of region
%why does not find hough line and How would you convert X,Y points to Rho,
%Theta for hough transform in C? on stack exchange
%12/16/15
%useful: function that calculates hough parameters of an aribtrary line drawn over an
%image. write a function that determines if a line is inside an roi
%can compute hough transform for limited range of theta
%      [H,T,R] = hough(BW,'Theta',44:0.5:46);
%rho resolution unit is pixles, theta in degrees. theta range +-90 and rho
%range +-D
%update to use theta instead of thetaResolution?
%   The function HOUGH changed in Image Processing Toolbox version 6.4
%   (R2009b) to include the 'Theta' parameter. Previous versions allowed
%   more limited control of THETA via the 'ThetaResolution' parameter.
%choosing a good resolution
%Choose a good grid / discretization
% -Too coarse: large votes obtained when too many different
% lines correspond to a single bucket
% -Too fine: miss lines because some points that are not
% exactly collinear cast votes for different buckets
%in houghpeaks function the second argument is numpeaks, or the number of
%peaks to identify - important parameter that was overlooked. hough
%transform peaks should correspond to lines/edges in the image
%   'Threshold' Nonnegative scalar.
%               Values of H below 'Threshold' will not be considered
%               to be peaks. Threshold can vary from 0 to Inf.
%   
%               Default: 0.5*max(H(:))
%how are peaks quantified? if the funtion is set to find 2 peaks will it
%return the first two peaks or the strongest two peaks?
%"The suppression neighborhood is the neighborhood around each peak that 
%is set to zero after the peak is identified." could be interesting to
%experiment with
%based on the houghpeaks code it seems to return any peak over the
%threshold and stop once the number of peaks has been detected, so the
%peaks returned may not necessarily be the strongest
%after a peak is found the function will not find the peak again, or any
%peak in the suppression region
%optimal value of NHoodSize? size(H)/50 (default)
% a given point of coordinates (x,y) happens to indeed be on a line, then
%the local direction of the gradient gives the ? parameter corresponding 
%to said line, and the r parameter is then immediately obtained. 
%(Shapiro and Stockman, 305) sounds useful in theory. how can it be
%implemented?
%radon transform? 
%updated research, updated code to test for start point location and theta
%within ranges. only displays "object detected" if a correct line is found
%next steps : further optimize houghline process to remove any undesired
%inconsistancies e.g. not detecting the top edge of the second car
%almost ready to start working on a prototype? how to deal with multiple
%regions with different conditions for occupancy?
%how to create more test cases?
%12/17/15
%transform lines of similar theta will end up in the same neighborhood
%default threshold value is too high? how can you tell?
%consideration: houghtransform and rounding, and how it relates to
%precision
%understand accumulator array and voting
%increasing resolution also significantly increases time complexity, each
%edge point is described by the line d = xcosine + ysine, accumulator
%stores adds a 1 to represent the existance of a d,theta pair, intersecting
%lines will have a maximum value in the accumulator array, assuming that a
%d,theta pair in the accumulator is a bin, and each 1 increment is a vote,
%helping to understand the importance of a resolution that is not too fine
%for the gradient technique, theta is equal to the gradient at the current
%x,y point
%look into optimization at the edge binary image level, smoothing to reduce
%the impact of noise (if edge detection relies on differentiation then
%noise is highly detremental)
%minimize number of local maximum around the true edge
%canny edge - large sigma detects large scale edges
%small sigma detects fine features
%updated code to use edge(image, 'Canny', [0.0563, 0.4]) instead of
%slx2edge. edge image looks much better. after running houghfromedge and
%looking at the transform plot, it appears that the current resolution may
%be too low (white squares ending up close together).
%after experimenting with the new canny edge image and different
%combinations of parameters for the houghline process results are more
%appealing but still inconsistent
%decreased resolution (to 0.75) minlength 3, fillgap 1, finer edges and key
%features of the car are detected more consistantly. back bumper is very
%inconsistant in detection, but seems reasonable due to the noise and lack
%of straight lines in that part of the bw image. the bottom and top of the
%car are detected very consistantly, however based on the noise in the
%image detecting the full edge may be difficult (it is currently composed 
%of several small segments in a staircase like fassion). going to try
%improving the edge filter
%interesting note: in the edge function, the direction of edges to be
%detected can be specified
%adding a sigma of 3 to the edge function improves the edge detection e.g.
%the bottom edge of the car is represented by three staircase segments
%rather than several. increasing fillgap should produce ideal results
%with .75,.75, 7, 3 for hough parameters and 'Canny', [0.0563, 0.4], 3); very good results were obtained in terms of detecting
%the top and bottom edge of the car
%next step is adding y coordinants to the decision making process and
%adjusting the x coordinants to find the bottom edge
%in one trial the top edge of the car returned two lines very close to
%eachother, I think this means a small increase in resolution is necessary
%(was 0.75 for both when it happened)
%note: i think that the y reference is at the top of the picture
%in one trial the bottom edge was returned as two separate segments,
%causing the second segment to not be detected due to being out of x range.
%increasing fillgap to fix the issue. increased from 7 to 9
%with two cars present, the top edge is not detected as well, increasing
%fillgap should help
%increasing fillgap from 9 to 11 allowed for proper detection of the top
%edge of the second car. the bottom edge of the first car is not being
%detected, but I think it is due to only 5 peaks being detected, going to
%increase number of peaks from 5 to 10 and observe results
%increasing the number of peaks allowed for detection of the bottom edge of
%the first car. code was also successfully updated to return lines1 that
%only contains the correct lines. next step is to include the bottom edge
%of car 1 in the proper criteria and for future work distinguish between
%the two cars, i.e if the bottom edge of car two is detected then car one
%must not be present, if the top of car two and the bottom of car 1 is
%detected then both cars are present.
%increasing x threshold to 300. y threshold to 130, y threshold is good, x
%needs to be lower, probably around 280
%still seeing multiple lines for the same edge, going to decrease the
%resolution from 0.75 to 1.25 - seemed to cause more lines, not sure why.
%will stick with 1 for now, but there is room for improvement.
%increased resolution to 2 and results look fine, makes sense in theory
%since bigger edges are being detected
%next up: more test cases, same process with different images? more
%useful/practical way of testing edges, research structures and array
%manipulation in matlab.
image = slx2gray(ip);
roi = roipoly(image, c, r);
edge1 = edge(image, 'Canny', [0.0563, 0.4], 3);

crop = edge1;
crop(~roi) = 0;
%I2 = I.*cast(R,class(I)); %multiply
imshow(crop)


lines = houghfromedge_np(crop);



% for k = 1:length(lines)
%     if lines(k).theta ~= 80
%         lines(k) = [];
%         k = (k-1);
%     end
% end


subplot(1,2,1);
imshow(edge1), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','Green')
    
end

%text position
position = [5 5];

%on this subplot only plot the lines with the correct theta value
detect = false;
subplot(1,2,2);
imshow(image); hold on;
n=1;%number of correct lines
for k = 1:length(lines)
    if ( (lines(k).theta < -79) && (lines(k).theta > -91) && (lines(k).point1(1,1) > 227) && (lines(k).point1(1,1) < 270) && (lines(k).point1(1,2) < 110) )%use more descriptors for the proper line, 
        %also possibly delete elements of lines structure that do not correspond to the correct orientation
        %use x~228 to 232, theta -80 to -90 
        %theta of 65 or 64 seems to corespond to shadows in the parking
        %spot
        detect = true;%if any correct lines are detected, set true
        lines1(k) = lines(k);%any lines that fall into the correct range, add them to an new array
        %n =+ 1;
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','Green')
    end
end
if detect
imshow(insertText(image, position, 'object located')), hold on%12/16/15 updated to onlyshow text when proper line is detected

for k = 1:length(lines)
    if ( (lines(k).theta < -79) && (lines(k).theta > -91) && (lines(k).point1(1,1) > 227) && (lines(k).point1(1,1) < 270) && (lines(k).point1(1,2) < 130) ) 

   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','Green')
    end
end
end

end

