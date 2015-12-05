function varargout = streamer(varargin)
% STREAMER MATLAB code for streamer.fig
%      STREAMER, by itself, creates a new STREAMER or raises the existing
%      singleton*.
%
%      H = STREAMER returns the handle to a new STREAMER or the handle to
%      the existing singleton*.
%
%      STREAMER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STREAMER.M with the given input arguments.
%
%      STREAMER('Property','Value',...) creates a new STREAMER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before streamer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to streamer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help streamer

% Last Modified by GUIDE v2.5 30-Jun-2014 15:14:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @streamer_OpeningFcn, ...
                   'gui_OutputFcn',  @streamer_OutputFcn, ...
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


% --- Executes just before streamer is made visible.
function streamer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to streamer (see VARARGIN)

% Choose default command line output for streamer
handles.output = hObject;


% UIWAIT makes streamer wait for user response (see UIRESUME)
% uiwait(handles.streamer);

% Put a layout in the panel 
if (exist('uitab'))

    group = uitabgroup( 'Parent', handles.layout_panel);
    tab1 = uitab('Parent', group, 'Title', 'Signal');
    tab2 = uitab('Parent', group, 'Title', 'Avg');
    tab3 = uitab('Parent', group, 'Title', 'Power');
    tab4 = uitab('Parent', group, 'Title', 'Strongest');
    tab1 = uipanel('Parent', tab1);
    tab2 = uipanel('Parent', tab2);
    tab3 = uipanel('Parent', tab3);
    tab4 = uipanel('Parent', tab4);
else
    g = uiextras.Grid( 'Parent', handles.layout_panel, ...
    'Units', 'Normalized', 'Position', [0 0 1 1], ...
    'Spacing', 5 );
    panel = uiextras.TabPanel( 'Parent', g, 'Padding', 5 );
    tab1 = uipanel('Parent', panel);
    tab2 = uipanel('Parent', panel);
    tab3 = uipanel('Parent', panel);
    tab4 = uipanel('Parent', panel);
    panel.TabNames = {'Signal', 'Avg', 'Power','Strongest'};
    g.RowSizes = [-1];
end
handles.tab1 = tab1;
handles.tab2 = tab2;
handles.tab3 = tab3;
handles.tab4 = tab4;

panel.SelectedChild = 1;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = streamer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function combox_Callback(hObject, eventdata, handles)
% hObject    handle to combox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function combox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to combox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

a = instrhwinfo('serial');
set(hObject, 'String', a.AvailableSerialPorts);


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
strings = get(handles.combox, 'string');
curval = get(handles.combox, 'value');
if iscell(strings)
  curstring = strings{curval};
else
  curstring = strings(curval, :);  %char array
end
transmitADC('0200') % MUS TX 4 DIGITS 0100
numMics = str2num(get(handles.num, 'String'));
plotMics(curstring, handles, numMics);


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global status fullData
status.close_flag = 1;
assignin('base','data',fullData);
fullData = [];

% --- Executes when user attempts to close streamer.
function streamer_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to streamer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global status
status.close_flag = 1;

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on mouse press over figure background.
function streamer_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to streamer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% % --- Executes on button press in calibrate.
% function calibrate_Callback(hObject, eventdata, handles)
% % hObject    handle to calibrate (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global status
% status.calib_flag = 1;



function num_Callback(hObject, eventdata, handles)
% hObject    handle to num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num as text
%        str2double(get(hObject,'String')) returns contents of num as a double


% --- Executes during object creation, after setting all properties.
function num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in sweep.
% function sweep_Callback(hObject, eventdata, handles)
% % hObject    handle to sweep (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global status
% status.motor_flag = 1;
