function varargout = first(varargin)
% FIRST MATLAB code for first.fig
%      FIRST, by itself, creates a new FIRST or raises the existing
%      singleton*.
%
%      H = FIRST returns the handle to a new FIRST or the handle to
%      the existing singleton*.
%
%      FIRST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRST.M with the given input arguments.
%
%      FIRST('Property','Value',...) creates a new FIRST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before first_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to first_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help first

% Last Modified by GUIDE v2.5 11-Jun-2014 17:30:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @first_OpeningFcn, ...
                   'gui_OutputFcn',  @first_OutputFcn, ...
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

% --- Executes just before first is made visible.
function first_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to first (see VARARGIN)

% Choose default command line output for first
handles.output = hObject;

% GainMap - Maps ina radio buttons -> selected gain value from gain listbox
% active_radiobtn - holds value of current selected radio btn from GUI
%                 on initialization, ina0 is selected first
k = {handles.ina0, handles.ina1, handles.ina2, handles.ina3, ...
handles.ina4, handles.ina5};
v = [1,2,3,4,5,6];
handles.inaGainMap = containers.Map(k,v);



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes first wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = first_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% debug edit text box
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
axes(hObject), imshow('electrodes.jpg');

% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = serial('COM5', 'BaudRate', 115200);
fopen(s);
fwrite(s, '*');
fclose(s);
delete(instrfind);
    

% --- Executes on button press in send_record.
function send_record_Callback(hObject, eventdata, handles)
% hObject    handle to send_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Uij = [get(handles.elect5, 'Value') get(handles.elect11, 'Value') ... 
       get(handles.elect16, 'Value') get(handles.elect21, 'Value') ...
       get(handles.elect27, 'Value') get(handles.elect32, 'Value');

       get(handles.elect2, 'Value') get(handles.elect7, 'Value') ...
       get(handles.elect12, 'Value') get(handles.elect17, 'Value') ...
       get(handles.elect23, 'Value') get(handles.elect28, 'Value');

       get(handles.elect4, 'Value') get(handles.elect9, 'Value') ...
       get(handles.elect14, 'Value') get(handles.elect20, 'Value') ...
       get(handles.elect26, 'Value') get(handles.elect31, 'Value');

       get(handles.elect3, 'Value') get(handles.elect8, 'Value') ...
       get(handles.elect13, 'Value') get(handles.elect18, 'Value') ...
       get(handles.elect24, 'Value') get(handles.elect29, 'Value')
       ];
if ~Uij
    set(handles.edit2, 'String', 'Cannot send record event');
else
    cmd = send_record_event(Uij);
    for i = 1:length(cmd(:,1))        
        set(handles.edit2, 'String', cmd(i,:));
        plot_record(cmd(i,:));
    end
end

% --- Executes on button press in current_stim.
function current_stim_Callback(hObject, eventdata, handles)
% hObject    handle to current_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getdir = [get(handles.radiobutton1, 'Value');
          get(handles.radiobutton2, 'Value');
          get(handles.radiobutton3, 'Value');
          get(handles.radiobutton4, 'Value')];
content = cellstr(get(handles.list_curr_amp, 'String'));
getAmp = content{get(handles.list_curr_amp, 'Value')};
getHold = get(handles.edit_hold_time, 'String');
getPeriod = get(handles.edit_period, 'String');
cmd = send_current_event(getAmp, getHold, getPeriod);
sent = send_message(cmd);
if ~sent
    set(handles.edit2, 'String', 'Error-Did not send');
else
    set(handles.edit2, 'String', cmd);
end

% --- Executes on button press in set_ina_gains.
function set_ina_gains_Callback(hObject, eventdata, handles)
% hObject    handle to set_ina_gains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uitable1, 'Data');
gainVals = data(:,1);
cmd = send_gain_event(gainVals);
if ~cmd
    set(handles.edit2, 'String', 'Set gain values for all INAs');
else
    sent = send_message(cmd(1,:));
    if ~sent
        set(handles.edit2, 'String', 'Error - Message not sent');
    else
        set(handles.edit2, 'String', cmd(1,:));
    end
end
% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function uipanel6_CreateFcn(hObject, eventdata, handles)


function uipanel6_SelectionChangeFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function list_curr_amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_curr_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
content  = get_amp_vals(); % Changed for MATLAB R2012a
%content = cellstr(get_amp_vals());
set(hObject, 'String', content);

% --- Executes on selection change in list_curr_amp.
function list_curr_amp_Callback(hObject, eventdata, handles)
% hObject    handle to list_curr_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_curr_amp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_curr_amp

% --- Executes during object creation, after setting all properties.
function edit_hold_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_hold_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_hold_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_hold_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_hold_time as text
%        str2double(get(hObject,'String')) returns contents of edit_hold_time as a double

% --- Executes during object creation, after setting all properties.
function current_img_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in current_img.
function current_img_Callback(hObject, eventdata, handles)
% hObject    handle to current_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1), 
I = imread('stim_pads.jpg');
I = imresize(I, 0.3); imshow(I, 'Border', 'tight');

% --- Executes during object creation, after setting all properties.
function uipanel8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes when selected object is changed in uipanel8.
function uipanel8_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel8 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
activeBtn = handles.inaGainMap(hObject);
vals = get(handles.gains_list,'String');
selected = vals(get(handles.gains_list,'Value'));

data = get(handles.uitable1, 'Data');
data(activeBtn,1) = selected;
set(handles.uitable1, 'Data', data);

function gains_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gains_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
content = get_gain_vals(); 
%content = cellstr(get_gain_vals());
set(hObject, 'String', content);

% --- Executes on selection change in gains_list.
function gains_list_Callback(hObject, eventdata, handles)
% hObject    handle to gains_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns gains_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gains_list

% --- Executes during object creation, after setting all properties.
btns = [get(handles.ina0, 'Value'), get(handles.ina1, 'Value'),...
    get(handles.ina2, 'Value'), get(handles.ina3, 'Value'), ...
    get(handles.ina4, 'Value'), get(handles.ina5, 'Value')];
idx = 1;
while(idx < 6)
    if(btns(idx))
        break;
    else
        idx=idx+1;
    end
end
vals = get(hObject,'String');
selected = vals(get(hObject,'Value'));

data = get(handles.uitable1, 'Data');
data(idx,1) = selected;
set(handles.uitable1,'Data',data);

% --- Executes during object creation, after setting all properties.
function ina0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ina0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ina1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ina1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ina2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ina2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ina3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ina2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function ina4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ina2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function ina5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ina2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in elect2.
function elect2_Callback(hObject, eventdata, handles)
% hObject    handle to elect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect2

% --- Executes on button press in elect3.
function elect3_Callback(hObject, eventdata, handles)
% hObject    handle to elect3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect3

% --- Executes on button press in elect4.
function elect4_Callback(hObject, eventdata, handles)
% hObject    handle to elect4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect4

% --- Executes on button press in elect5.
function elect5_Callback(hObject, eventdata, handles)
% hObject    handle to elect5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect5

% --- Executes on button press in elect7.
function elect7_Callback(hObject, eventdata, handles)
% hObject    handle to elect7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect7

% --- Executes on button press in elect8.
function elect8_Callback(hObject, eventdata, handles)
% hObject    handle to elect8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect8

% --- Executes on button press in elect9.
function elect9_Callback(hObject, eventdata, handles)
% hObject    handle to elect9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect9

% --- Executes on button press in elect11.
function elect11_Callback(hObject, eventdata, handles)
% hObject    handle to elect11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect11

% --- Executes on button press in elect12.
function elect12_Callback(hObject, eventdata, handles)
% hObject    handle to elect12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect12

% --- Executes on button press in elect13.
function elect13_Callback(hObject, eventdata, handles)
% hObject    handle to elect13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect13

% --- Executes on button press in elect14.
function elect14_Callback(hObject, eventdata, handles)
% hObject    handle to elect14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect14

% --- Executes on button press in elect16.
function elect16_Callback(hObject, eventdata, handles)
% hObject    handle to elect16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect16

% --- Executes on button press in elect17.
function elect17_Callback(hObject, eventdata, handles)
% hObject    handle to elect17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect17

% --- Executes on button press in elect18.
function elect18_Callback(hObject, eventdata, handles)
% hObject    handle to elect18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect18

% --- Executes on button press in elect21.
function elect21_Callback(hObject, eventdata, handles)
% hObject    handle to elect21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect21

% --- Executes on button press in elect20.
function elect20_Callback(hObject, eventdata, handles)
% hObject    handle to elect20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect20

% --- Executes on button press in elect23.
function elect23_Callback(hObject, eventdata, handles)
% hObject    handle to elect23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect23

% --- Executes on button press in elect24.
function elect24_Callback(hObject, eventdata, handles)
% hObject    handle to elect24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect24

% --- Executes on button press in elect26.
function elect26_Callback(hObject, eventdata, handles)
% hObject    handle to elect26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect26

% --- Executes on button press in elect27.
function elect27_Callback(hObject, eventdata, handles)
% hObject    handle to elect27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect27

% --- Executes on button press in elect28.
function elect28_Callback(hObject, eventdata, handles)
% hObject    handle to elect28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect28

% --- Executes on button press in elect29.
function elect29_Callback(hObject, eventdata, handles)
% hObject    handle to elect29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect29

% --- Executes on button press in elect32.
function elect32_Callback(hObject, eventdata, handles)
% hObject    handle to elect32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect32

% --- Executes on button press in elect31.
function elect31_Callback(hObject, eventdata, handles)
% hObject    handle to elect31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of elect31


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function go_CreateFcn(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_period_Callback(hObject, eventdata, handles)
% hObject    handle to edit_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_period as text
%        str2double(get(hObject,'String')) returns contents of edit_period as a double


% --- Executes during object creation, after setting all properties.
function edit_period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
