function ROISelection()
%ROI selection tool to select a region of interest in a pre-existing point
%cloud object. It will return two items, an affine3D transform object and a
%2x3 array for the ROI selection.
%
%Author: Vahid Vaisi


%% Create UI control buttons, handles, and figure.

    %Figure Creation
    fig = figure('Menubar', 'none', 'Name', ...
                            'Point Cloud ROI Selector', ...
                            'NumberTitle','off');
                        
    %Structure to hold variables
    handles = guihandles(fig);    
    
    %Panel holding buttons to import Scene Point Cloud
    handles.pnl_ptCloud = uipanel('Visible', 'off', ...
                            'Position',[0.02 0.05 0.1 0.40], ...
                            'units', 'normalized', ...
                            'Title', 'Control', ...
                            'TitlePosition', 'lefttop');
    %Button to select a pt cloud
    handles.btn_select = uicontrol(handles.pnl_ptCloud, ...
                            'style', 'pushbutton', ... 
                            'String', 'Select', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.70 0.9 0.25], ...
                            'callback', {@getPtCloud});
                        
    %Button to reset to original point cloud
    handles.btn_reset = uicontrol(handles.pnl_ptCloud, ...
                            'style', 'pushbutton', ... 
                            'String', 'Reset', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.41 0.9 0.25], ...
                            'callback', {@resetPtCloud});
                        
    handles.btn_export = uicontrol(handles.pnl_ptCloud, ...
                            'style', 'pushbutton', ... 
                            'String', 'Export', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.12 0.9 0.25], ...
                            'callback', {@exportVars});
    
                                     
    %Panel holding buttons to export the affine stransofmr
    handles.pnl_inputs = uipanel('Visible', 'off', ...
                            'Position',[0.13 0.05 0.37 0.40], ...
                            'units', 'normalized', ...
                            'Title', 'Inputs', ...
                            'TitlePosition', 'lefttop');
    
    %Panel holding buttons to do translations
    handles.pnl_translation = uipanel('Visible', 'off', ...
                            'Position',[0.51 0.05 0.15 0.40], ...
                            'units', 'normalized', ...
                            'Title', 'Translation', ...
                            'TitlePosition', 'lefttop');
                        
    %Panel holding buttons to do rotations
    handles.pnl_rotation = uipanel('Visible', 'off', ...
                            'Position',[0.67 0.05 0.15 0.40], ...
                            'units', 'normalized', ...
                            'Title', 'Rotation', ...
                            'TitlePosition', 'lefttop');
                        
    %Panel holding buttons to do scale
    handles.pnl_scale = uipanel('Visible', 'off', ...
                            'Position',[0.83 0.05 0.15 0.40], ...
                            'units', 'normalized', ...
                            'Title', 'Scale', ...
                            'TitlePosition', 'lefttop');
    
                        
    %Button to Slide left
    handles.btn_slideLeft = uicontrol(handles.pnl_translation,'style', 'pushbutton', ...
                            'String', 'Left', ...
                            'units', 'normalized', ...
                            'position',[0.05 0.82 0.9 0.12], ...
                            'callback', {@translate,1});
                        
    %Button to Slide right
    handles.btn_slideRight = uicontrol(handles.pnl_translation,'style', 'pushbutton', ...
                            'String', 'Right', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.66 0.9 0.12], ...
                            'callback', {@translate,2});
                        
    %Button to Slide forward
    handles.btn_slideForward = uicontrol(handles.pnl_translation,'style', 'pushbutton', ...
                            'String', 'Forward', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.51 0.9 0.12], ...
                            'callback', {@translate,3});
                        
    %Button to Slide backward
    handles.btn_slideBackward = uicontrol(handles.pnl_translation,'style', 'pushbutton', ...
                            'String', 'Backward', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.36 0.9 0.12], ...
                            'callback', {@translate,4});
                        
    %Button to Slide up
    handles.btn_slideUp = uicontrol(handles.pnl_translation,'style', 'pushbutton', ...
                            'String', 'Up', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.21 0.9 0.12], ...
                            'callback', {@translate,5});
                        
    %Button to Slide down
    handles.btn_slideDown = uicontrol(handles.pnl_translation,'style', 'pushbutton', ...
                            'String', 'Down', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.07 0.9 0.12], ...
                            'callback', {@translate,6});
            
    %Button to twist left
    handles.btn_twistLeft = uicontrol(handles.pnl_rotation,'style', 'pushbutton', ...
                            'String', 'Twist Left', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.82 0.9 0.12], ...
                            'callback', {@rotate,1});
                        
    %Button to twist right
    handles.btn_twistRight = uicontrol(handles.pnl_rotation,'style', 'pushbutton', ...
                            'String', 'Twist Right', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.66 0.9 0.12], ...
                            'callback', {@rotate,2});
                        
            
    %Button to tilt forward
    handles.btn_tiltForward = uicontrol(handles.pnl_rotation,'style', 'pushbutton', ...
                            'String', 'Tilt Forward', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.51 0.9 0.12], ...
                            'callback', {@rotate,3});
                        
    %Button to tilt Backward
    handles.btn_tiltBackward = uicontrol(handles.pnl_rotation,'style', 'pushbutton', ...
                            'String', 'Tilt Back', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.36 0.9 0.12], ...
                            'callback', {@rotate,4});
                                             
    %Button to roll left
    handles.btn_rollLeft = uicontrol(handles.pnl_rotation,'style', 'pushbutton', ...
                            'String', 'Roll Left', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.21 0.9 0.12], ...
                            'callback', {@rotate,5});
                        
    %Button to roll right
    handles.btn_rollRight = uicontrol(handles.pnl_rotation,'style', 'pushbutton', ...
                            'String', 'Roll Right', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.07 0.9 0.12], ...
                            'callback', {@rotate,6});
                        
    %Button to expand width
    handles.btn_expandWidth = uicontrol(handles.pnl_scale,'style', 'pushbutton', ...
                            'String', 'Expand Width', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.82 0.9 0.12], ...
                            'callback', {@scale,1});
                     
    %Button to shrink width
    handles.btn_shrinkWidth = uicontrol(handles.pnl_scale,'style', 'pushbutton', ...
                            'String', 'Shrink Width', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.66 0.9 0.12], ...
                            'callback', {@scale,2});
                        
    %Button to expand height
    handles.btn_expandHeight = uicontrol(handles.pnl_scale,'style', 'pushbutton', ...
                            'String', 'Expand Height', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.51 0.9 0.12], ...
                            'callback', {@scale,3});
                        
    %Button to shrink height
    handles.btn_shrinkHeight = uicontrol(handles.pnl_scale,'style', 'pushbutton', ...
                            'String', 'Shrink Height', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.36 0.9 0.12], ...
                            'callback', {@scale,4});
                       
    %Button to expand depth
    handles.btn_expandDepth = uicontrol(handles.pnl_scale,'style', 'pushbutton', ...
                            'String', 'Expand Depth', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.21 0.9 0.12], ...
                            'callback', {@scale,5});
                        
    %Button to shrink depth
    handles.btn_shrinkDepth = uicontrol(handles.pnl_scale,'style', 'pushbutton', ...
                            'String', 'Shrink Depth', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.07 0.9 0.12], ...
                            'callback', {@scale,6});
                        
    %Text for translation units
    handles.txt_translation = uicontrol(handles.pnl_inputs,'style', 'text', ...
                            'String', 'Translation (in Inches): ', ...
                            'units', 'normalized', ...
                            'position', [0.01 0.80 0.9 0.20]);
                        
    %Edit for translation units
    handles.edt_translation = uicontrol(handles.pnl_inputs,'style', 'edit', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.70 0.9 0.20]);
                        
    %Text for rotation units
    handles.txt_rotation = uicontrol(handles.pnl_inputs,'style', 'text', ...
                            'String', 'Rotation (in Degrees): ', ...
                            'units', 'normalized', ...
                            'position', [0.01 0.48 0.9 0.20]);
    %Edit for rotation units
    handles.edt_rotation = uicontrol(handles.pnl_inputs,'style', 'edit', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.36 0.9 0.20]);
                        
    %Text for scale units
    handles.txt_scale = uicontrol(handles.pnl_inputs,'style', 'text', ...
                            'String', 'Scale (in Inches): ', ...
                            'units', 'normalized', ...
                            'position', [0.01 0.15 0.9 0.20]);
    
    %Edit for scale units
    handles.edt_scale = uicontrol(handles.pnl_inputs,'style', 'edit', ...
                            'units', 'normalized', ...
                            'position', [0.05 0.05 0.9 0.20]);
    

    %Axes to hold pt cloud and ROI
    handles.frame = axes('Visible', 'off', ...
                            'Title', 'Scene',...
                            'Position',[0.05,0.50,0.4,0.4]);
    title('No Scene')
    set(gca,'xcolor',get(gcf,'color'));
    set(gca,'ycolor',get(gcf,'color'));
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);
    
    handles.roi = axes('Visible', 'off', ...
                            'Title', 'ROI', ...
                            'Position',[0.55,0.50,0.4,0.4]);
    title('No ROI')
    set(gca,'xcolor',get(gcf,'color'));
    set(gca,'ycolor',get(gcf,'color'));
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);
                           
    %Make all features visible
    handles.pnl_ptCloud.Visible = 'on';
    handles.pnl_inputs.Visible = 'on';
    handles.frame.Visible = 'on';
    handles.roi.Visible = 'on';
    handles.pnl_translation.Visible = 'on';
    handles.pnl_rotation.Visible = 'on';
    handles.pnl_scale.Visible = 'on';
    
    %Create variables for exporting
    handles.transform = [1 0 0 0 ;
                         0 1 0 0 ;
                         0 0 1 0 ;
                         0 0 0 1];
    
                     
    %Variables for display                 
    handles.xmin = -50; %default values
    handles.xmax = 50;
    handles.ymin = 0;
    handles.ymax = 180;
    handles.zmin = 270;
    handles.zmax = 320;
    handles.roirange = [handles.xmin, handles.xmax; ...
                        handles.ymin, handles.ymax; ...
                        handles.zmin, handles.zmax];
                    
    %Display the current ROI and Matrix on the GUI as static text
    handles.txt_roirange = uicontrol('style', 'text', ...
                            'String', strcat('ROI: ',mat2str(handles.roirange)), ...
                            'units', 'normalized', ...
                            'position', [0.01 0.95 0.3 0.05]);
    handles.txt_transform = uicontrol('style', 'text', ...
                            'String', strcat('Matrix: ',mat2str(handles.transform)), ...
                            'units', 'normalized', ...
                            'position', [0.35 0.95 0.6 0.05]);
    
                        
    
    guidata(fig, handles); %Saves data
    
    
%%  Callback functions

%Function that gets the point cloud structure from the workspace and shows
%it in the axes
function getPtCloud(object_handle, event)
    %Prompt user to select the point cloud
    out = uigetvariables('Select a point cloud: ');
    
    %Load handles and segment point clouds
    handles = guidata(gcbo); 
    handles.selectedCloud = out; %holds scene
    handles.originalCloud = out; %used for reset button
    
    indicesroi = findPointsInROI(out{1,1}, handles.roirange);

    handles.roiCloud = select(out{1,1}, indicesroi);
    handles.roiCloud = pcdenoise(handles.roiCloud);
    tform = affine3d(handles.transform);
    handles.roiCloud = pctransform(handles.roiCloud, tform);
    
    %Display the point clouds in the axes
    axes(handles.frame); %Scene
    handles.frame = pcshow(out{1,1}.Location,'VerticalAxis', 'Y', ...
                            'VerticalAxisDir', 'Down');
    hold on;
    handles.frame = pcshow(handles.roiCloud.Location, 'r', 'VerticalAxis', 'Y', ...
                            'VerticalAxisDir', 'Down');

    title('Point Cloud')
    xlabel('X (inches)');
    ylabel('Y (inches)');
    zlabel('Z (inches)');
    hold off;
    
    axes(handles.roi); %ROI
    handles.roi = pcshow(handles.roiCloud,'VerticalAxis', 'Y', ...
                            'VerticalAxisDir', 'Down');
    title('ROI Point Cloud')
    xlabel('X (inches)');
    ylabel('Y (inches)');
    zlabel('Z (inches)');
    
    
    guidata(gcbo, handles);
    
%Function that handles resetting to the original point cloud
function resetPtCloud(object_handle, event)
    %Load handles and segment point clouds
    handles = guidata(gcbo); 
    
    %Retrieve original point cloud and reset variables to default
    handles.selectedCloud = handles.originalCloud;
    
    %Update gui variables
    guidata(gcbo, handles); 
    resetVars();
    
    %Extract the ROI and display the point clouds
    extractROI();
    displayClouds();
    updateDisplay();
    
%Function that handles exporting the ROI and Matrix for tform
function exportVars(object_handle, event)
    %Load handles from GUI
    handles = guidata(gcbo);

    %Create prompt for variable names
    prompt = {'Enter ROI name: ','Enter Matrix name: '};
    title = 'Variable Names';
    lines = 1;
    def = {'roi','Matrix'};
    answer = inputdlg(prompt, title, lines, def);
    
    %Send variables to the current workspace
    assignin('base', answer{1}, handles.roirange);
    assignin('base', answer{2}, handles.transform);
    
%Function that handles translation
function translate(object_handle, event, direction)
    %Load handles and segment point clouds
    handles = guidata(gcbo);
    
    val = str2double(get(handles.edt_translation,'string'));
    
    %Check for empty value
    if isnan(val)
       msg = 'Please enter a value for input.';
       errordlg(msg)
       return;
    end
    
    switch direction
        case 1 %left
            handles.xmin = handles.xmin - val;
            handles.xmax = handles.xmax - val;
        case 2 %right
            handles.xmin = handles.xmin + val;
            handles.xmax = handles.xmax + val;
        case 3 %forward
            handles.zmin = handles.zmin + val;
            handles.zmax = handles.zmax + val;
        case 4 %backward
            handles.zmin = handles.zmin - val;
            handles.zmax = handles.zmax - val;
        case 5 %up
            handles.ymin = handles.ymin - val;
            handles.ymax = handles.ymax - val;
        case 6 %down
            handles.ymin = handles.ymin + val;
            handles.ymax = handles.ymax + val;
    end
    
    guidata(gcbo, handles);
    
    updateRoiRange();
    
    updateDisplay();
    
%Function that handles rotation
function rotate(object_handle, event, action)
    %Load handles
    handles = guidata(gcbo);
    
    %Get input from gui
    val = deg2rad(str2double(get(handles.edt_rotation,'string')));
    
    %Check for empty value
    if isnan(val)
       msg = 'Please enter a value for input.';
       errordlg(msg)
       return;
    end
    
    switch action
        case 1 %twist left
           Mat = [cos(val),0,sin(val),0;
                0,1,0,0;
                -sin(val),0, cos(val),0;
                0,0,0,1];
        case 2 %twist right
           Mat = [cos(-val),0,sin(-val),0;
                0,1,0,0;
                -sin(-val),0, cos(-val),0;
                0,0,0,1];
        case 3 %tilt forward
           Mat = [1,0,0,0;
                0,cos(-val),-sin(-val),0;
                0,sin(-val),cos(-val),0;
                0,0,0,1];
        case 4 %tilt backward
           Mat = [1,0,0,0;
                0,cos(val),-sin(val),0;
                0,sin(val),cos(val),0;
                0,0,0,1];
        case 5 %roll left
           Mat = [cos(-val),sin(-val),0,0;
                -sin(-val),cos(-val),0,0;
                0,0,1,0;
                0,0,0,1];
        case 6 %roll right
           Mat = [cos(val),sin(val),0,0;
                -sin(val),cos(val),0,0;
                0,0,1,0;
                0,0,0,1];
    end
    
    %Apply transform
    handles.transform = handles.transform * Mat;
    tform = affine3d(Mat);
    handles.selectedCloud{1,1} = pctransform(handles.selectedCloud{1,1}, tform);
    
    %Update the GUI variables 
    guidata(gcbo, handles);
    
    %Update the display
    updateDisplay();
    
%Function to handle Scales
function scale(object_handle, event, action)
    %Get GUI variables
    handles = guidata(gcbo);
    
    val = str2double(get(handles.edt_scale,'string'));
    
    %Check for empty value
    if isnan(val)
       msg = 'Please enter a value for input.';
       errordlg(msg)
       return;
    end
    
    switch action
        case 1 %Expand width
            handles.xmin = handles.xmin - (val/2);
            handles.xmax = handles.xmax + (val/2);
        case 2 %Shrink width
            handles.xmin = handles.xmin + (val/2);
            handles.xmax = handles.xmax - (val/2);
        case 3 %Expand Height
            handles.ymin = handles.ymin - (val/2);
            handles.ymax = handles.ymax + (val/2);
        case 4 %Shrink Height
            handles.ymin = handles.ymin + (val/2);
            handles.ymax = handles.ymax - (val/2);
        case 5 %Expand Depth
            handles.zmin = handles.zmin - (val/2);
            handles.zmax = handles.zmax + (val/2);
        case 6 %Shrink Depth
            handles.zmin = handles.zmin + (val/2);
            handles.zmax = handles.zmax - (val/2);          
    end
    
    %Update the GUI variables 
    guidata(gcbo, handles);
    
    %Update the ROI range
    updateRoiRange();
    
    %Update the display
    updateDisplay();
    
%% Helper Functions    
 
    
%Helper Function to update the roirange
function updateRoiRange()
    %Get GUI variables
    handles = guidata(gcbo);

    %Apply changes to the roirange variable
    handles.roirange(1,1) = handles.xmin;
    handles.roirange(1,2) = handles.xmax;
    
    handles.roirange(2,1) = handles.ymin;
    handles.roirange(2,2) = handles.ymax;
    
    handles.roirange(3,1) = handles.zmin;
    handles.roirange(3,2) = handles.zmax;
    
    %Update variables for GUI
    guidata(gcbo, handles);
    
%Helper Function to update the display
function updateDisplay()
    handles = guidata(gcbo);
    
    out = handles.selectedCloud{1,1};

    %Select the points in the ROI range
    indicesroi = findPointsInROI(out, handles.roirange);
    handles.roiCloud = select(out, indicesroi);
%     handles.roiCloud = pcdenoise(handles.roiCloud);
    
    %Update gui handles
    guidata(gcbo, handles);
    
    displayClouds();
    
    
%Helper Function to reset handles variables
function resetVars()
    handles = guidata(gcbo);

    %Create variables for exporting
    handles.transform = [1 0 0 0 ;
                         0 1 0 0 ;
                         0 0 1 0 ;
                         0 0 0 1];
                     
    %Variables for display                 
    handles.xmin = -50; %default values
    handles.xmax = 50;
    handles.ymin = 0;
    handles.ymax = 180;
    handles.zmin = 270;
    handles.zmax = 320;
    handles.roirange = [handles.xmin, handles.xmax; ...
                        handles.ymin, handles.ymax; ...
                        handles.zmin, handles.zmax];
    %Save the GUI values                
    guidata(gcbo, handles);
    
%Helper Function to extract the ROI from the point cloud
function extractROI()
    %update local handles  
    handles = guidata(gcbo);
    
    indicesroi = findPointsInROI(handles.selectedCloud{1,1}, handles.roirange);

    handles.roiCloud = select(handles.selectedCloud{1,1}, indicesroi);
    handles.roiCloud = pcdenoise(handles.roiCloud);
    tform = affine3d(handles.transform);
    handles.roiCloud = pctransform(handles.roiCloud, tform);
    
    guidata(gcbo, handles);
    
 %Helper Function to display point clouds
function displayClouds()
    handles = guidata(gcbo);
    
    %Display the point clouds in the axes
    axes(handles.frame); %Scene
    handles.frame = pcshow(handles.selectedCloud{1,1}.Location,'VerticalAxis', 'Y', ...
                            'VerticalAxisDir', 'Down');
    hold on;
    handles.frame = pcshow(handles.roiCloud.Location, 'r', 'VerticalAxis', 'Y', ...
                            'VerticalAxisDir', 'Down');

    title('Point Cloud')
    xlabel('X (inches)');
    ylabel('Y (inches)');
    zlabel('Z (inches)');
    hold off;
    
    axes(handles.roi); %ROI
    handles.roi = pcshow(handles.roiCloud,'VerticalAxis', 'Y', ...
                            'VerticalAxisDir', 'Down');
    title('ROI Point Cloud')
    xlabel('X (inches)');
    ylabel('Y (inches)');
    zlabel('Z (inches)');
    
    %Update the ROI and Matrix display
    handles.txt_roirange = uicontrol('style', 'text', ...
                            'String', strcat('ROI: ',mat2str(handles.roirange)), ...
                            'units', 'normalized', ...
                            'position', [0.01 0.95 0.3 0.05]);
                        
    handles.txt_transform = uicontrol('style', 'text', ...
                            'String', strcat('Matrix: ',mat2str(handles.transform)), ...
                            'units', 'normalized', ...
                            'position', [0.35 0.95 0.6 0.05]);
    
    guidata(gcbo, handles);

    
    

