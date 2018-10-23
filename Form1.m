function varargout = Form1(varargin)

% FORM1 MATLAB code for Form1.fig
%      FORM1, by itself, creates a new FORM1 or raises the existing
%      singleton*.
%
%      H = FORM1 returns the handle to a new FORM1 or the handle to
%      the existing singleton*.
%
%      FORM1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM1.M with the given input arguments.
%
%      FORM1('Property','Value',...) creates a new FORM1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form1

% Last Modified by GUIDE v2.5 15-Oct-2018 11:46:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Form1_OpeningFcn, ...
                   'gui_OutputFcn',  @Form1_OutputFcn, ...
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

% --- Executes just before Form1 is made visible.
function Form1_OpeningFcn(hObject, eventdata, handles, varargin)
clc;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form1 (see VARARGIN)

%---------------- CONSTANT DEFINITION ----------------

% CORNEA - SPHERO-CYLINDRICAL PARAMETER
global s_cornea
    s_cornea = [41;4;145];  %(p,c,theta)

% ANTERIOR CHAMBER - THICKNESS | REFRACTIVE INDEX
global t_anteriorc
                    t_anteriorc = [3.6E-3; 1.366];  %(t,v)

% LENS_AS - SPHERO-CYLINDRICAL PARAMETER
global s_lens_as
                    s_lens_as = [8;3;180];  %(p,c,theta)

% LENS - THICKNESS | REFRACTIVE INDEX
global t_lens
                    t_lens = [3.6E-3; 1.413];  %(t,v)

% LENS_PS - SPHERO-CYLINDRICAL PARAMETER
global s_lens_ps
                    s_lens_ps = [13;2;30];  %(p,c,theta)

% POSTERIOR CHAMBER - THICKNESS | REFRACTIVE INDEX
global t_posteriorc
                    t_posteriorc = [14E-3; 1.336];  %(t,v)

%-----------------------------------------------------

%---------------- FORM 1 ON LOAD ----------------
set(handles.txtCornea_p_value,'String',num2str(s_cornea(1)));
set(handles.txtCornea_c_value,'String',num2str(s_cornea(2)));
set(handles.txtCornea_th_value,'String',num2str(s_cornea(3)));

set(handles.txtAC_t_value,'String',num2str(t_anteriorc(1)));
set(handles.txtAC_v_value,'String',num2str(t_anteriorc(2)));

set(handles.txtAC_rt_value,'String',num2str(t_anteriorc(1)/t_anteriorc(2)));


set(handles.txtLensAS_p_value,'String',num2str(s_lens_as(1)));
set(handles.txtLensAS_c_value,'String',num2str(s_lens_as(2)));
set(handles.txtLensAS_th_value,'String',num2str(s_lens_as(3)));

set(handles.txtLens_t_value,'String',num2str(t_lens(1)));
set(handles.txtLens_v_value,'String',num2str(t_lens(2)));

set(handles.txtLens_rt_value,'String',num2str(t_lens(1)/t_lens(2)));


set(handles.txtLensPS_p_value,'String',num2str(s_lens_ps(1)));
set(handles.txtLensPS_c_value,'String',num2str(s_lens_ps(2)));
set(handles.txtLensPS_th_value,'String',num2str(s_lens_ps(3)));

set(handles.txtPc_t_value,'String',num2str(t_posteriorc(1)));
set(handles.txtPC_v_value,'String',num2str(t_posteriorc(2)));

set(handles.txtPC_rt_value,'String',num2str(t_posteriorc(1)/t_posteriorc(2)));

% Choose default command line output for Form1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Form1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%------------ TAU MATRIX CALC -----------
function tau1 = tau1_calc(handles)
z = zeros(4,1); % Vettore nullo 4 x 1
R = inline('[1 0 -(S+C*sin(pi*theta/180)^2) C*sin(pi*theta/90)/2;0 1 C*sin(pi*theta/90)/2 -(S+C*cos(pi*theta/180)^2);0 0 1 0; 0 0 0 1]','S','C','theta'); % Thin lens

p = str2double(get(handles.txtCornea_p_value,'String'));
c = str2double(get(handles.txtCornea_c_value,'String'));
th = str2double(get(handles.txtCornea_th_value,'String'));

% Cornea
S1=R(p,c,th); delta1=z; tau1=[S1 delta1;z' 1]; 

function tau2 = tau2_calc(handles)
z = zeros(4,1); % Vettore nullo 4 x 1
T = inline('[1 0 0 0;0 1 0 0;t 0 1 0; 0 t 0 1]','t'); % Thin system

t = str2double(get(handles.txtAC_t_value,'String'));
v = str2double(get(handles.txtAC_v_value,'String'));

% Camera anteriore
S2=T(t/v); delta2=z; tau2=[S2 delta2;z' 1];

function tau3 = tau3_calc(handles)
z = zeros(4,1); % Vettore nullo 4 x 1
R = inline('[1 0 -(S+C*sin(pi*theta/180)^2) C*sin(pi*theta/90)/2;0 1 C*sin(pi*theta/90)/2 -(S+C*cos(pi*theta/180)^2);0 0 1 0; 0 0 0 1]','S','C','theta'); % Thin lens

p = str2double(get(handles.txtLensAS_p_value,'String'));
c = str2double(get(handles.txtLensAS_c_value,'String'));
th = str2double(get(handles.txtLensAS_th_value,'String'));

o = str2double(get(handles.txt_Offset,'String'))/1000;
d = str2double(get(handles.txt_Degree,'String'));

% Decentramento del cristallino causata da trauma
m = [o*cos(pi*d/180);o*sin(pi*d/180)];

% Superficie anteriore del cristallino
S3=R(p,c,th); delta3=[-S3(1:2,3:4)*m;zeros(2,1)]; tau3=[S3 delta3;z' 1];

function tau4 = tau4_calc(handles)
z = zeros(4,1); % Vettore nullo 4 x 1
T = inline('[1 0 0 0;0 1 0 0;t 0 1 0; 0 t 0 1]','t'); % Thin system

t = str2double(get(handles.txtLens_t_value,'String'));
v = str2double(get(handles.txtLens_v_value,'String'));

% Cristallino
S4=T(t/v); delta4=z; tau4=[S4 delta4;z' 1];

function tau5 = tau5_calc(handles)
z = zeros(4,1); % Vettore nullo 4 x 1
R = inline('[1 0 -(S+C*sin(pi*theta/180)^2) C*sin(pi*theta/90)/2;0 1 C*sin(pi*theta/90)/2 -(S+C*cos(pi*theta/180)^2);0 0 1 0; 0 0 0 1]','S','C','theta'); % Thin lens

p = str2double(get(handles.txtLensPS_p_value,'String'));
c = str2double(get(handles.txtLensPS_c_value,'String'));
th = str2double(get(handles.txtLensPS_th_value,'String'));

o = str2double(get(handles.txt_Offset,'String'))/1000;
d = str2double(get(handles.txt_Degree,'String'));

% Decentramento del cristallino causata da trauma
m = [o*cos(pi*d/180);o*sin(pi*d/180)];

% Superficie posteriore del cristallino
S5=R(p,c,th); delta5=[-S5(1:2,3:4)*m;zeros(2,1)]; tau5=[S5 delta5;z' 1];

function tau6 = tau6_calc(handles)
z = zeros(4,1); % Vettore nullo 4 x 1
T = inline('[1 0 0 0;0 1 0 0;t 0 1 0; 0 t 0 1]','t'); % Thin system

t = str2double(get(handles.txtPc_t_value,'String'));
v = str2double(get(handles.txtPC_v_value,'String'));

% Spazio tra la superficie posteriore del cristallino e la retina
S6=T(t/v); delta6=z; tau6=[S6 delta6;z' 1];

function calculate(handles)

    r_in = [str2double(get(handles.txt_a1,'String')); str2double(get(handles.txt_a2,'String')); str2double(get(handles.txt_y1,'String')); str2double(get(handles.txt_y2,'String')); 1]

    tau1 = tau1_calc(handles);
    r2 = tau1 * r_in
    tau2 = tau2_calc(handles);
    r3 = tau2 * r2
    tau3 = tau3_calc(handles);
    r4 = tau3 * r3
    tau4 = tau4_calc(handles);
    r5 = tau4 * r4
    tau5 = tau5_calc(handles);
    r6 = tau5 * r5
    tau6 = tau6_calc(handles);
    r_out = tau6 * r6



% --- Outputs from this function are returned to the command line.
function varargout = Form1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider18_Callback(hObject, eventdata, handles)
% hObject    handle to slider18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider19_Callback(hObject, eventdata, handles)
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



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


% --- Executes on slider movement.
function slider16_Callback(hObject, eventdata, handles)
% hObject    handle to slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider17_Callback(hObject, eventdata, handles)
% hObject    handle to slider17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider12_Callback(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider13_Callback(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider14_Callback(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider15_Callback(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sldCornea_p_value_Callback(hObject, eventdata, handles)

% CORNEA - SPHERO-CYLINDRICAL PARAMETER
s_cornea = [41;4;145];  %(p,c,theta)

q = get(hObject,'Value');
q = (q-3)/20;
value = (q * s_cornea(1)) + s_cornea(1);
set(handles.txtCornea_p_value,'String',num2str(value));

%tau1_calc(handles);
calculate(handles);


% hObject    handle to sldCornea_p_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sldCornea_p_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldCornea_p_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider24_Callback(hObject, eventdata, handles)
% hObject    handle to slider24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider25_Callback(hObject, eventdata, handles)
% hObject    handle to slider25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider26_Callback(hObject, eventdata, handles)
% hObject    handle to slider26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider27_Callback(hObject, eventdata, handles)
% hObject    handle to slider27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to txtPC_rt_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPC_rt_value as text
%        str2double(get(hObject,'String')) returns contents of txtPC_rt_value as a double


% --- Executes during object creation, after setting all properties.
function txtPC_rt_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPC_rt_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider41_Callback(hObject, eventdata, handles)
% POSTERIOR CHAMBER - THICKNESS | REFRACTIVE INDEX
t_posteriorc = [14E-3; 1.336];  %(t,v)
 
q = get(hObject,'Value');
q = (q-3)/20;
ticknes = (q * t_posteriorc(1)) + t_posteriorc(1);
set(handles.txtPc_t_value,'String',num2str(ticknes));
 
refractive_idx = str2double(get(handles.txtPC_v_value,'String'));
set(handles.txtPC_rt_value,'String',num2str(ticknes/refractive_idx));

%tau6_calc(handles);
calculate(handles);



% --- Executes during object creation, after setting all properties.
function slider41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to txtPc_t_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPc_t_value as text
%        str2double(get(hObject,'String')) returns contents of txtPc_t_value as a double


% --- Executes during object creation, after setting all properties.
function txtPc_t_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPc_t_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider42_Callback(hObject, eventdata, handles)
% POSTERIOR CHAMBER - THICKNESS | REFRACTIVE INDEX
t_posteriorc = [14E-3; 1.336];  %(t,v)
 
q = get(hObject,'Value');
q = (q-3)/20;
refractive_idx = (q * t_posteriorc(2)) + t_posteriorc(2);
set(handles.txtPC_v_value,'String',num2str(refractive_idx));
 
ticknes = str2double(get(handles.txtPc_t_value,'String'));
set(handles.txtPC_rt_value,'String',num2str(ticknes/refractive_idx));

%tau6_calc(handles);
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to txtPC_v_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPC_v_value as text
%        str2double(get(hObject,'String')) returns contents of txtPC_v_value as a double


% --- Executes during object creation, after setting all properties.
function txtPC_v_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPC_v_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider38_Callback(hObject, eventdata, handles)
% LENS_PS - SPHERO-CYLINDRICAL PARAMETER
s_lens_ps = [13;2;30];  %(p,c,theta)
 
q = get(hObject,'Value');
q = (q-3)/20;
set(handles.txtLensPS_p_value,'String',num2str((q * s_lens_ps(1)) + s_lens_ps(1)));

%tau5_calc(handles);
calculate(handles);


% --- Executes during object creation, after setting all properties.
function slider38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to txtLensPS_p_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLensPS_p_value as text
%        str2double(get(hObject,'String')) returns contents of txtLensPS_p_value as a double


% --- Executes during object creation, after setting all properties.
function txtLensPS_p_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLensPS_p_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider39_Callback(hObject, eventdata, handles)
% LENS_PS - SPHERO-CYLINDRICAL PARAMETER
s_lens_ps = [13;2;30];  %(p,c,theta)
 
q = get(hObject,'Value');
q = (q-3)/20;
set(handles.txtLensPS_c_value,'String',num2str((q * s_lens_ps(2)) + s_lens_ps(2)));

%tau5_calc(handles);
calculate(handles);


% --- Executes during object creation, after setting all properties.
function slider39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to txtLensPS_c_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLensPS_c_value as text
%        str2double(get(hObject,'String')) returns contents of txtLensPS_c_value as a double


% --- Executes during object creation, after setting all properties.
function txtLensPS_c_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLensPS_c_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider40_Callback(hObject, eventdata, handles)
% LENS_PS - SPHERO-CYLINDRICAL PARAMETER
s_lens_ps = [13;2;30];  %(p,c,theta)
 
q = get(hObject,'Value');
q = (q-3)/20;
set(handles.txtLensPS_th_value,'String',num2str((q * s_lens_ps(3)) + s_lens_ps(3)));

%tau5_calc(handles);
calculate(handles);



% --- Executes during object creation, after setting all properties.
function slider40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to txtLensPS_th_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLensPS_th_value as text
%        str2double(get(hObject,'String')) returns contents of txtLensPS_th_value as a double


% --- Executes during object creation, after setting all properties.
function txtLensPS_th_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLensPS_th_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to txtLens_rt_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLens_rt_value as text
%        str2double(get(hObject,'String')) returns contents of txtLens_rt_value as a double


% --- Executes during object creation, after setting all properties.
function txtLens_rt_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLens_rt_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider36_Callback(hObject, eventdata, handles)
% LENS - THICKNESS | REFRACTIVE INDEX
t_lens = [3.6E-3; 1.413];  %(t,v)
 
q = get(hObject,'Value');
q = (q-3)/20;
ticknes = (q * t_lens(1)) + t_lens(1);
set(handles.txtLens_t_value,'String',num2str(ticknes));
 
refractive_idx = str2double(get(handles.txtLens_v_value,'String'));
set(handles.txtLens_rt_value,'String',num2str(ticknes/refractive_idx));

%tau4_calc(handles);
calculate(handles);


% hObject    handle to slider36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to txtLens_t_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLens_t_value as text
%        str2double(get(hObject,'String')) returns contents of txtLens_t_value as a double


% --- Executes during object creation, after setting all properties.
function txtLens_t_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLens_t_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider37_Callback(hObject, eventdata, handles)
% LENS - THICKNESS | REFRACTIVE INDEX
t_lens = [3.6E-3; 1.413];  %(t,v)
 
q = get(hObject,'Value');
q = (q-3)/20;
refractive_idx = (q * t_lens(2)) + t_lens(2);
set(handles.txtLens_v_value,'String',num2str(refractive_idx));
 
ticknes = str2double(get(handles.txtLens_t_value,'String'));
set(handles.txtLens_rt_value,'String',num2str(ticknes/refractive_idx));

%tau4_calc(handles);
calculate(handles);


% hObject    handle to slider37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to txtLens_v_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLens_v_value as text
%        str2double(get(hObject,'String')) returns contents of txtLens_v_value as a double


% --- Executes during object creation, after setting all properties.
function txtLens_v_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLens_v_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider33_Callback(hObject, eventdata, handles)
% LENS_AS - SPHERO-CYLINDRICAL PARAMETER
s_lens_as = [8;3;180];  %(p,c,theta)

q = get(hObject,'Value');
q = (q-3)/20;
set(handles.txtLensAS_p_value,'String',num2str((q * s_lens_as(1)) + s_lens_as(1)));

%tau3_calc(handles);
calculate(handles);

% hObject    handle to slider33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to txtLensAS_p_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLensAS_p_value as text
%        str2double(get(hObject,'String')) returns contents of txtLensAS_p_value as a double


% --- Executes during object creation, after setting all properties.
function txtLensAS_p_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLensAS_p_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider34_Callback(hObject, eventdata, handles)
% LENS_AS - SPHERO-CYLINDRICAL PARAMETER
s_lens_as = [8;3;180];  %(p,c,theta)
 
q = get(hObject,'Value');
q = (q-3)/20;
set(handles.txtLensAS_c_value,'String',num2str((q * s_lens_as(2)) + s_lens_as(2)));
%tau3_calc(handles);
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to txtLensAS_c_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLensAS_c_value as text
%        str2double(get(hObject,'String')) returns contents of txtLensAS_c_value as a double


% --- Executes during object creation, after setting all properties.
function txtLensAS_c_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLensAS_c_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider35_Callback(hObject, eventdata, handles)
% LENS_AS - SPHERO-CYLINDRICAL PARAMETER
s_lens_as = [8;3;180];  %(p,c,theta)
 
q = get(hObject,'Value');
q = (q-3)/20;
set(handles.txtLensAS_th_value,'String',num2str((q * s_lens_as(3)) + s_lens_as(3)));
%tau3_calc(handles);
calculate(handles);


% hObject    handle to slider35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to txtLensAS_th_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLensAS_th_value as text
%        str2double(get(hObject,'String')) returns contents of txtLensAS_th_value as a double


% --- Executes during object creation, after setting all properties.
function txtLensAS_th_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLensAS_th_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider31_Callback(hObject, eventdata, handles)

% ANTERIOR CHAMBER - THICKNESS | REFRACTIVE INDEX
t_anteriorc = [3.6E-3; 1.366];  %(t,v)
q = get(hObject,'Value');
q = (q-3)/20;
ticknes = (q * t_anteriorc(1)) + t_anteriorc(1);
set(handles.txtAC_t_value,'String',num2str(ticknes));

refractive_indx = str2double(get(handles.txtAC_v_value,'String'));
set(handles.txtAC_rt_value,'String',num2str(ticknes/refractive_indx));

%tau2_calc(handles);
calculate(handles);

% hObject    handle to slider31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to txtAC_t_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtAC_t_value as text
%        str2double(get(hObject,'String')) returns contents of txtAC_t_value as a double


% --- Executes during object creation, after setting all properties.
function txtAC_t_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAC_t_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider32_Callback(hObject, eventdata, handles)
% ANTERIOR CHAMBER - THICKNESS | REFRACTIVE INDEX
t_anteriorc = [3.6E-3; 1.366];  %(t,v)

q = get(hObject,'Value');
q = (q-3)/20;
refractive_idx = (q * t_anteriorc(2)) + t_anteriorc(2);
set(handles.txtAC_v_value,'String',num2str(refractive_idx));

ticknes = str2double(get(handles.txtAC_t_value,'String'));
set(handles.txtAC_rt_value,'String',num2str(ticknes/refractive_idx));

%tau2_calc(handles);
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to txtAC_v_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtAC_v_value as text
%        str2double(get(hObject,'String')) returns contents of txtAC_v_value as a double


% --- Executes during object creation, after setting all properties.
function txtAC_v_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAC_v_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtCornea_p_value_Callback(hObject, eventdata, handles)
% hObject    handle to txtCornea_p_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCornea_p_value as text
%        str2double(get(hObject,'String')) returns contents of txtCornea_p_value as a double


% --- Executes during object creation, after setting all properties.
function txtCornea_p_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCornea_p_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider29_Callback(hObject, eventdata, handles)

% CORNEA - SPHERO-CYLINDRICAL PARAMETER
s_cornea = [41;4;145];  %(p,c,theta)
 
q = get(hObject,'Value');
q = (q-3)/20;
set(handles.txtCornea_c_value,'String',num2str((q * s_cornea(2)) + s_cornea(2)));% hObject    handle to slider29 (see GCBO)

%tau1_calc(handles);
calculate(handles);

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to txtCornea_c_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCornea_c_value as text
%        str2double(get(hObject,'String')) returns contents of txtCornea_c_value as a double


% --- Executes during object creation, after setting all properties.
function txtCornea_c_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCornea_c_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider30_Callback(hObject, eventdata, handles)

% CORNEA - SPHERO-CYLINDRICAL PARAMETER
s_cornea = [41;4;145];  %(p,c,theta)
 
q = get(hObject,'Value');
q = (q-3)/20;
set(handles.txtCornea_th_value,'String',num2str((q * s_cornea(3)) + s_cornea(3)));

%tau1_calc(handles);
calculate(handles);


% hObject    handle to slider30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to txtCornea_th_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCornea_th_value as text
%        str2double(get(hObject,'String')) returns contents of txtCornea_th_value as a double


% --- Executes during object creation, after setting all properties.
function txtCornea_th_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCornea_th_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider43_Callback(hObject, eventdata, handles)
% hObject    handle to slider43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider44_Callback(hObject, eventdata, handles)
q = get(hObject,'Value');
set(handles.txt_Offset,'String',num2str(q));
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider45_Callback(hObject, eventdata, handles)
q = get(hObject,'Value');
set(handles.txt_Degree,'String',num2str(q));
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider49_Callback(hObject, eventdata, handles)
q = get(hObject,'Value');
set(handles.txt_y1,'String',num2str(q));
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider50_Callback(hObject, eventdata, handles)
q = get(hObject,'Value');
set(handles.txt_a2,'String',num2str(q));
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider53_Callback(hObject, eventdata, handles)
q = get(hObject,'Value');
set(handles.txt_a1,'String',num2str(q));
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider54_Callback(hObject, eventdata, handles)
q = get(hObject,'Value');
set(handles.txt_y2,'String',num2str(q));
calculate(handles);

% --- Executes during object creation, after setting all properties.
function slider54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end