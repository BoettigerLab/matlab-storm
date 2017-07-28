function varargout = GUI2DParameters(varargin)
% GUI2DPARAMETERS MATLAB code for GUI2DParameters.fig
%      GUI2DPARAMETERS, by itself, creates a new GUI2DPARAMETERS or raises the existing
%      singleton*.
%
%      H = GUI2DPARAMETERS returns the handle to a new GUI2DPARAMETERS or the handle to
%      the existing singleton*.
%
%      GUI2DPARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2DPARAMETERS.M with the given input arguments.
%
%      GUI2DPARAMETERS('Property','Value',...) creates a new GUI2DPARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI2DParameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI2DParameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI2DParameters

% Last Modified by GUIDE v2.5 13-Apr-2017 08:29:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI2DParameters_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI2DParameters_OutputFcn, ...
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


% --- Executes just before GUI2DParameters is made visible.
function GUI2DParameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI2DParameters (see VARARGIN)

% Choose default command line output for GUI2DParameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI2DParameters wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI2DParameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.output;



function cameraBackground_Callback(hObject, eventdata, handles)
% hObject    handle to cameraBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cameraBackground as text
%        str2double(get(hObject,'String')) returns contents of cameraBackground as a double


% --- Executes during object creation, after setting all properties.
function cameraBackground_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameraBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minPeakHeight_Callback(hObject, eventdata, handles)
% hObject    handle to minPeakHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minPeakHeight as text
%        str2double(get(hObject,'String')) returns contents of minPeakHeight as a double


% --- Executes during object creation, after setting all properties.
function minPeakHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minPeakHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function peakBlur_Callback(hObject, eventdata, handles)
% hObject    handle to peakBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of peakBlur as text
%        str2double(get(hObject,'String')) returns contents of peakBlur as a double


% --- Executes during object creation, after setting all properties.
function peakBlur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SF

cmBack = str2double(get(handles.cameraBackground,'String'));
minPeak = str2double(get(handles.minPeakHeight,'String'));
blur = str2double(get(handles.peakBlur,'String'));

parmaHelp('cameraBackground', cmBack, 'minPeakHeight', minPeak, 'peakBlur', blur);

%pars = ParseVariableArguments(pars, SF{length(SF)}.parsFit, mfilename);
%SF{length(SF)}.parsFile = pars;
pause(.1);
close(GUI2DParameters);

function parmaHelp(varargin)
global SF
vars = SF{length(SF)}.parsFit;
defaults = cell(0,3);
defaults(end+1,:) = {'cameraBackground','float',vars.cameraBackground};
defaults(end+1,:) = {'minPeakHeight','float',vars.minPeakHeight};
defaults(end+1,:) = {'peakBlur','float',vars.peakBlur};
defaults(end+1,:) =  {'initSigmaXY', 'float', vars.initSigmaXY};
defaults(end+1,:) =  {'maxSigma', 'float', vars.maxSigma}; 
defaults(end+1,:) =  {'minSigma', 'float', vars.minSigma};
defaults(end+1,:) =  {'peakBound', 'positive' vars.peakBound};
defaults(end+1,:) = {'FiniteDifferenceType',{'central','forward'},vars.FiniteDifferenceType};
defaults(end+1,:) = {'MaxFunctionEvaluations','positive',vars.MaxFunctionEvaluations};
defaults(end+1,:) = {'OptimalityTolerance','positive',vars.OptimalityTolerance};
pars = ParseVariableArguments(varargin, defaults, mfilename);
SF{length(SF)}.parsFit = pars;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% Get default command line output from handles structure
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
else
% The GUI is no longer waiting, just close it
delete(hObject);
end

