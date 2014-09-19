function varargout = Moth_GUI(varargin)
% MOTH_GUI MATLAB code for Moth_GUI.fig
%      MOTH_GUI, by itself, creates a new MOTH_GUI or raises the existing
%      singleton*.
%
%      H = MOTH_GUI returns the handle to a new MOTH_GUI or the handle to
%      the existing singleton*.
%
%      MOTH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTH_GUI.M with the given input arguments.
%
%      MOTH_GUI('Property','Value',...) creates a new MOTH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Moth_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Moth_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Moth_GUI

% Last Modified by GUIDE v2.5 19-Sep-2014 16:58:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Moth_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Moth_GUI_OutputFcn, ...
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


% --- Executes just before Moth_GUI is made visible.
function Moth_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Moth_GUI (see VARARGIN)

% Choose default command line output for Moth_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Moth_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Moth_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Go.
function Go_Callback(hObject, eventdata, handles)
% hObject    handle to Go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stim1.
function stim1_Callback(hObject, eventdata, handles)
% hObject    handle to stim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stim1


% --- Executes on button press in stimleft2.
function stimleft2_Callback(hObject, eventdata, handles)
% hObject    handle to stimleft2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stimleft2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in stimright2.
function stimright2_Callback(hObject, eventdata, handles)
% hObject    handle to stimright2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stimright2


% --- Executes on button press in stimbutton.
function stimbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stimbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
