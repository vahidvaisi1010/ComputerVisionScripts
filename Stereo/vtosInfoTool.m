%{
function [ output_args ] = untitled( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


end
%}

%{%}
function vtosInfoTool(im)
% Create figure, setting up properties
hfig = figure('Toolbar','none',...
              'Menubar', 'none',...
              'Name','My Pixel Info Tool',...
              'NumberTitle','off',...
              'IntegerHandle','off');

% Create axes and reposition the axes
% to accommodate the Pixel Region tool panel
hax = axes('Units','normalized',...
           'Position',[0 .5 1 .5]);

% Display image in the axes and get a handle to the image
himage = imshow(im);

% Add Distance tool, specifying axes as parent
hdist = imdistline(hax);

% Add Pixel Information tool, specifying image as parent
hpixinfo = impixelinfo(himage);

% Add Display Range tool, specifying image as parent
hdrange = imdisplayrange(himage);

% Add Pixel Region tool panel, specifying figure as parent
% and image as target
hpixreg = impixelregionpanel(hfig,himage);

% Reposition the Pixel Region tool to fit in the figure
% window, leaving room for the Pixel Information and
% Display Range tools.
set(hpixreg, 'units','normalized','position',[0 .08 1 .4])


%{
function vtosInfoTool(im)

% Create a figure without toolbar and menubar.
hfig = figure('Toolbar','none',...
              'Menubar', 'none',...
              'Name','My Large Image Display Tool',...
              'NumberTitle','off',...
              'IntegerHandle','off');

% Display the image in a figure with imshow.
himage = imshow(im);

% Add the scroll panel.
hpanel = imscrollpanel(hfig,himage);

% Position the scroll panel to accommodate the other tools.
set(hpanel,'Units','normalized','Position',[0 .1 1 .9]);

% Add the Magnification box.
hMagBox = immagbox(hfig,himage);

% Position the Magnification box
pos = get(hMagBox,'Position');
set(hMagBox,'Position',[0 0 pos(3) pos(4)]);

% Add the Overview tool.
hovervw = imoverview(himage)
%}