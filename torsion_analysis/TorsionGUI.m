function varargout = TorsionGUI(varargin)
% TORSIONGUI MATLAB code for TorsionGUI.fig
%      TORSIONGUI, by itself, creates a new TORSIONGUI or raises the existing
%      singleton*.
%
%      H = TORSIONGUI returns the handle to a new TORSIONGUI or the handle to
%      the existing singleton*.
%
%      TORSIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TORSIONGUI.M with the given input arguments.
%
%      TORSIONGUI('Property','Value',...) creates a new TORSIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TorsionGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TorsionGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TorsionGUI

% Last Modified by GUIDE v2.5 13-Mar-2012 22:55:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TorsionGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TorsionGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TorsionGUI is made visible.
function TorsionGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TorsionGUI (see VARARGIN)

% Choose default command line output for TorsionGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
% User Inits

handles.tr = [];            % Make place for future loaded handle
handles.color_apex = 'r';   % Colors to identify apex vs. base in plots
handles.color_base = 'b';   
guidata(hObject, handles);  % Store it


adjustAxesProperties(handles)   % Fix axis labels, ranges, etc.

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%



% UIWAIT makes TorsionGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TorsionGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function loadDirBox_Callback(hObject, eventdata, handles)
% hObject    handle to loadDirBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of loadDirBox as text
%        str2double(get(hObject,'String')) returns contents of loadDirBox as a double


% --- Executes during object creation, after setting all properties.
function loadDirBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadDirBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function saveDirBox_Callback(hObject, eventdata, handles)
% hObject    handle to saveDirBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of saveDirBox as text
%        str2double(get(hObject,'String')) returns contents of saveDirBox as a double


% --- Executes during object creation, after setting all properties.
function saveDirBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saveDirBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function animalNumBox_Callback(hObject, eventdata, handles)
% hObject    handle to animalNumBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of animalNumBox as text
%        str2double(get(hObject,'String')) returns contents of animalNumBox as a double

loadFile(hObject, handles, false)


% --- Executes during object creation, after setting all properties.
function animalNumBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animalNumBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ageGroupBox_Callback(hObject, eventdata, handles)
% hObject    handle to ageGroupBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ageGroupBox as text
%        str2double(get(hObject,'String')) returns contents of ageGroupBox as a double

loadFile(hObject, handles, false)


% --- Executes during object creation, after setting all properties.
function ageGroupBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ageGroupBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flippedCheckBox.
function flippedCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to flippedCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flippedCheckBox

flipflag = get(hObject, 'Value');
handles.tr.updateFlipFlag(flipflag);
updateGUIFromTorsionRecord(handles)


function offsetBox_Callback(hObject, eventdata, handles)
% hObject    handle to offsetBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offsetBox as text
%        str2double(get(hObject,'String')) returns contents of offsetBox as a double

offset = str2double(get(hObject, 'String'));
handles.tr.updateTimeOffset(offset);
updateGUIFromTorsionRecord(handles);


% --- Executes during object creation, after setting all properties.
function offsetBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offsetBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pointsListBox.
function pointsListBox_Callback(hObject, eventdata, handles)
% hObject    handle to pointsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pointsListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pointsListBox

handles.tr.updateTrackingPoints(get(hObject, 'Value'));

updateGUIFromTorsionRecord(handles)




% --- Executes during object creation, after setting all properties.
function pointsListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in animateButton.
function animateButton_Callback(hObject, eventdata, handles)
% hObject    handle to animateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

animatePoints(handles)


function pauseBetweenBox_Callback(hObject, eventdata, handles)
% hObject    handle to pauseBetweenBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pauseBetweenBox as text
%        str2double(get(hObject,'String')) returns contents of pauseBetweenBox as a double


% --- Executes during object creation, after setting all properties.
function pauseBetweenBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pauseBetweenBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reloadRawDataButton.
function reloadRawDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to reloadRawDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadFile(hObject, handles, true);   % Note force reload flag



% --- Executes on button press in loadFilesButton.
function loadFilesButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadFilesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadFile(hObject, handles, false)


function reportsDirBox_Callback(hObject, eventdata, handles)
% hObject    handle to reportsDirBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reportsDirBox as text
%        str2double(get(hObject,'String')) returns contents of reportsDirBox as a double


% --- Executes during object creation, after setting all properties.
function reportsDirBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reportsDirBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%-------------------------------------------------------------------------%
function loadFile(hObject, handles, force_reload)
% This function first attempts to load data from the results directory,
% which would represent a previously saved torsion record.  If none is
% found, it proceeds to load raw data into a TorsionRecord object.  After
% data is loaded, the GUI is updated.
% NOTE: force_reload will re-load from the original raw tracking files, but
% will preserve things like flipflag, time_offset_apex_from_base, and
% torsion_tracking_points by saving them in the GUI first, reloading, then
% re-setting these values.

% Retrieve box information from GUI
loadDir    = get(handles.loadDirBox, 'String');
reportsDir = get(handles.reportsDirBox, 'String');
saveDir    = get(handles.saveDirBox, 'String');
animalnum  = get(handles.animalNumBox, 'String');
agegroup   = get(handles.ageGroupBox, 'String');

% Attempt to load an existing record
result_load_fail = false;
if ~force_reload
    try
        tr = load(fullfile(saveDir, ['torsion_', animalnum, '.mat']));
        handles.tr = tr.TR;
        updateGUIFromTorsionRecord(handles)
    catch ferr
        disp(ferr.message)
        disp('No existing record found, assuming load from raw files is required...')
        result_load_fail = true;
        
    end
end

if force_reload || result_load_fail
    
    % Save current status of GUI elements to re-establish after raw reload
    flipflag = get(handles.flippedCheckBox, 'Value');
    timeoff  = str2double(get(handles.offsetBox, 'String'));
    selpts   = get(handles.pointsListBox, 'Value');
    
    % Create a new torsion record object (or attempt to)
    handles.tr = TorsionRecord(animalnum, agegroup, loadDir, reportsDir, saveDir);
    
    % Re-apply GUI selections to torsion record
    handles.tr.updateFlipFlag(flipflag)
    handles.tr.updateTimeOffset(timeoff)
    handles.tr.updateTrackingPoints(selpts)
    
    % Update the GUI
    updateGUIFromTorsionRecord(handles)
end

guidata(hObject, handles)   % Store handle


%-------------------------------------------------------------------------%
function updateGUIFromTorsionRecord(handles)
% This function updates all GUI elements from the stored TorsionRecord
% class, in handles.tr

set(handles.flippedCheckBox, 'Value', handles.tr.getFlipFlag()); % Flipflag
set(handles.offsetBox, 'String', handles.tr.getTimeOffset());    % Time offset

% Update pointsListBox
[selectedpts totalpts] = handles.tr.getTrackingPoints();
cpts         = vecToCellStrs(1:totalpts);
set(handles.pointsListBox, 'String', cpts)
set(handles.pointsListBox, 'Value', selectedpts)

% Call Plotting Updates
drawAvgRadii(handles)
drawTorsionTraces(handles)
drawPointTraces(handles)


%-------------------------------------------------------------------------%
function drawAvgRadii(handles)
% This function plots the normalized avg. radius for apex and base, and the
% same thing non-normalized (to get magnitude relations)

normaxh = handles.normAvgRadiusAxes;
avgaxh  = handles.avgRadiusAxes;

% Retrieve data
time     = handles.tr.cycle_time;
avg_apex = mean(handles.tr.r_apex);
avg_base = mean(handles.tr.r_base);

% Plot
cla(avgaxh, 'reset')
hold(avgaxh, 'on')
plot(avgaxh, time, avg_apex, 'r')
plot(avgaxh, time, avg_base, 'b')
hold(avgaxh, 'off')

cla(normaxh, 'reset')
hold(normaxh, 'on')
plot(normaxh, time, vnorm(avg_apex), handles.color_apex)
plot(normaxh, time, vnorm(avg_base), handles.color_base)
hold(normaxh, 'off')

adjustAxesProperties(handles)

%-------------------------------------------------------------------------%
function drawTorsionTraces(handles)
% This function draws torsion traces, with torsion for individual selected
% points plotted in green, the average of selected points plotted in heavy
% black, and all other lines plotted in gray.

axh = handles.torsionAxes;

% Retrieve data
time        = handles.tr.cycle_time;
torsion     = handles.tr.torsion;
avg_torsion = handles.tr.avg_torsion;

[selectedpts totalpts] = handles.tr.getTrackingPoints();


% Plot

cla(axh, 'reset')
hold(axh, 'on')

% Plot all torsion lines in gray
plot(axh, time, torsion, 'Color', graycolor(0.65))

% Plot selected point lines in green
plot(axh, time, torsion(selectedpts, :), 'g')

% Plot average torsion line in heavy black
plot(axh, time, avg_torsion, 'k', 'Linewidth', 2.5)

hold(axh, 'off')

adjustAxesProperties(handles)

%-------------------------------------------------------------------------%
function drawPointTraces(handles)
% This function draws traces of material points throughout the records.
% Non-selected points are plotted in gray, and selected points are plotted
% in their respective apex/base colors.

axh = handles.pointsAxes;

% Retrieve data
x_apex = handles.tr.x_apex;
y_apex = handles.tr.y_apex;
x_base = handles.tr.x_base;
y_base = handles.tr.y_base;

[selectedpts totalpts] = handles.tr.getTrackingPoints();


% Loop over points, plotting data
cla(axh, 'reset')
hold(axh, 'on')
for i = 1:totalpts
    plot(axh, x_apex(i,:), y_apex(i,:), 'Color', graycolor(0.65))
    plot(axh, x_base(i,:), y_base(i,:), 'Color', graycolor(0.65))
end

% Loop over selected points, plotting in color
for i = 1:length(selectedpts)
    ptdex = selectedpts(i);
    plot(axh, x_apex(ptdex,:), y_apex(ptdex,:), 'Color', handles.color_apex)
    plot(axh, x_base(ptdex,:), y_base(ptdex,:), 'Color', handles.color_base)
end
    
    
hold(axh, 'off')

adjustAxesProperties(handles)
    

%-------------------------------------------------------------------------%
function animatePoints(handles)
% This function animates the tracked material points, highlighting those
% that are selected and showing the rest in gray.

axh = handles.pointsAxes;

cla(axh, 'reset')   % Erase Axes
adjustAxesProperties(handles)

numFrames  = length(handles.tr.cycle_time);
pause_time = str2double(get(handles.pauseBetweenBox, 'String'));

% Retrieve data
x_apex = handles.tr.x_apex;
y_apex = handles.tr.y_apex;
x_base = handles.tr.x_base;
y_base = handles.tr.y_base;

[selectedpts ~] = handles.tr.getTrackingPoints();


% Loop over frames and plot
for i = 1:numFrames
    plot(axh, x_apex(:,i), y_apex(:,i), '.', 'Color', graycolor(0.65))
    hold(axh, 'on')
    plot(axh, x_apex(selectedpts,i), y_apex(selectedpts,i), '.', 'Color', handles.color_apex)
    plot(axh, x_base(:,i), y_base(:,i), '.', 'Color', graycolor(0.65))
    plot(axh, x_base(selectedpts,i), y_base(selectedpts,i), '.', 'Color', handles.color_base)
    hold(axh, 'off')
    xlim(axh, [-150 150])
    ylim(axh, [-150 150])
    drawnow()
    pause(pause_time)
end

cla(axh, 'reset')           % Erase Axes
drawPointTraces(handles)    % Return display to traces
adjustAxesProperties(handles)


%-------------------------------------------------------------------------%
function adjustAxesProperties(handles)

% Fix axes
set(handles.pointsAxes, 'XLim', [-150 150], ...
                        'YLim', [-150 150]);
ylabel(handles.pointsAxes, 'Y')
xlabel(handles.pointsAxes, 'X')

ylabel(handles.torsionAxes, 'Torsion (deg./cm)')
xlabel(handles.torsionAxes, 'Time (fract. R-R interval)')

set(handles.normAvgRadiusAxes, 'Xtick', [])
ylabel(handles.normAvgRadiusAxes, 'Normalized Avg. Radius')

ylabel(handles.avgRadiusAxes, 'Avg. Radius')
xlabel(handles.avgRadiusAxes, 'Time (fract. R-R interval)')

