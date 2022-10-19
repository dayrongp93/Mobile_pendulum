function varargout = Simulacion_Pendulo_Movil(varargin)
% SIMULACION_PENDULO_MOVIL MATLAB code for Simulacion_Pendulo_Movil.fig
%      SIMULACION_PENDULO_MOVIL, by itself, creates a new SIMULACION_PENDULO_MOVIL or raises the existing
%      singleton*.
%
%      H = SIMULACION_PENDULO_MOVIL returns the handle to a new SIMULACION_PENDULO_MOVIL or the handle to
%      the existing singleton*.
%
%      SIMULACION_PENDULO_MOVIL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULACION_PENDULO_MOVIL.M with the given input arguments.
%
%      SIMULACION_PENDULO_MOVIL('Property','Value',...) creates a new SIMULACION_PENDULO_MOVIL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Simulacion_Pendulo_Movil_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simulacion_Pendulo_Movil_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Simulacion_Pendulo_Movil

% Last Modified by GUIDE v2.5 28-Jan-2017 11:21:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simulacion_Pendulo_Movil_OpeningFcn, ...
                   'gui_OutputFcn',  @Simulacion_Pendulo_Movil_OutputFcn, ...
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


% --- Executes just before Simulacion_Pendulo_Movil is made visible.
function Simulacion_Pendulo_Movil_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simulacion_Pendulo_Movil (see VARARGIN)

% Choose default command line output for Simulacion_Pendulo_Movil
handles.output = hObject;

handles.metodo = 1; % Se inicializa la interfaz con el metodo ode45

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Simulacion_Pendulo_Movil wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Simulacion_Pendulo_Movil_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% En esta función vamos a establecer que se resuelva el problema de valores
% iniciales planteado
global metodoRK

% Condiciones iniciales
% --------------------------------------------------------------------
% Para las masas
m1 = handles.masa1;
m2 = handles.masa2;
masas = [m1 m2];

% Intervalo de tiempo
tinicio = handles.tinicio;
tfinal = handles.tfinal;

if tinicio >= tfinal
    warndlg('El tiempo final debe ser mayor que el inicial. Se tomará como instante inicial el valor 0','ADVERTENCIA')
    set(handles.edit2,'String','0','Value',0)
    tinicio = 0;
end

tspan = [tinicio tfinal];

% Longitud del péndulo
l = handles.longitud;

% Posicion inicial Horizontal
xih = handles.xinicial;

% Velocidad inicial Horizontal
dxih = handles.dxinicial;

% Ángulo inicial
phi = handles.phinicial;

% Velocidad angular inicial
dphi = handles.dphinicial;
% --------------------------------------------------------------------
% Procedemos entonces a resolver el problema 
cond = [xih dxih phi dphi];
% Vamos a establecer cual es el método que se va a implementar
if (handles.metodo == 1)
    % Se ejecuta el método ode45
    [t,y] = ode45(@movependulum2,tspan,cond,[],masas,l);
elseif (handles.metodo == 2)
    % Se ejecuta el método ode23
    [t,y] = ode23(@movependulum2,tspan,cond,[],masas,l);
elseif (handles.metodo == 3)
    % Se ejecuta el método implemetado
    % Primeramente debemos ver si el método es RK31 o RK32
    h = handles.paso;
    if metodoRK == 1
        % Se ejecuta RK31
        [t,y] = RK31(@movependulum2,tspan,cond,h,masas,l);
    elseif metodoRK == 2
        % Se ejecuta RK32
        [t,y] = RK32(@movependulum2,tspan,cond,h,masas,l);
    end
    t = t';
    y = y';
end
y1 = y(:,3)*180/pi;
global tpart
tpart = t;

% Ya fue resuelto el sistema de ecuaciones diferenciales utilizando el
% método numérico.
% Ahora vamos a mostrar los resultados en las gráficas

% 1. Para la primera gráfica
% Mostrar posición angular. 
global q1
global p1
q1 = get(handles.popupmenu1,'Value');
p1 = get(handles.popupmenu3,'Value');
axes(handles.axes1)
global h1
h1 = plot(t,y1,'b'); 

switch q1 % Para el Símbolo Gráfica 1: 
     case 1
        set(h1,'Marker','none')
    case 2
        set(h1,'Marker','.')
    case 3
        set(h1,'Marker','o')
    case 4
        set(h1,'Marker','x')
    case 5
        set(h1,'Marker','+')
    case 6
        set(h1,'Marker','*')
    case 7
        set(h1,'Marker','s')
    case 8
        set(h1,'Marker','d')
    case 9
        set(h1,'Marker','^')
    case 10
        set(h1,'Marker','<')
    case 11
        set(h1,'Marker','>')
    case 12
        set(h1,'Marker','p')
    case 13
        set(h1,'Marker','h')
end

switch p1 % Para el tipo de línea de la gráfica 1
    case 1
        set(h1,'LineStyle','-')
    case 2
        set(h1,'LineStyle','-')
    case 3
        set(h1,'LineStyle',':')
    case 4
        set(h1,'LineStyle','-.')
    case 5
        set(h1,'LineStyle','--')
end

% 2. Para la segunda gráfica
% Mostrar posición horizontal. 
global q2
global p2
q2 = get(handles.popupmenu2,'Value');
p2 = get(handles.popupmenu4,'Value');
axes(handles.axes2)
global h2
h2 = plot(t,y(:,1),'r');
switch q2 % Para el Símbolo Gráfica 2: 
    case 1
        set(h2,'Marker','none')
    case 2
        set(h2,'Marker','.')
    case 3
        set(h2,'Marker','o')
    case 4
        set(h2,'Marker','x')
    case 5
        set(h2,'Marker','+')
    case 6
        set(h2,'Marker','*')
    case 7
        set(h2,'Marker','s')
    case 8
        set(h2,'Marker','d')
    case 9
        set(h2,'Marker','^')
    case 10
        set(h2,'Marker','<')
    case 11
        set(h2,'Marker','>')
    case 12
        set(h2,'Marker','p')
    case 13
        set(h2,'Marker','h')
end

switch p2 % Para el tipo de línea de la gráfica 2
    case 1
        set(h2,'LineStyle','-')
    case 2
        set(h2,'LineStyle','-')
    case 3
        set(h2,'LineStyle',':')
    case 4
        set(h2,'LineStyle','-.')
    case 5
        set(h2,'LineStyle','--')
end

% Para la simulacion del sistema mediante una gráfica
global movhor
global movver
movhor = y(:,1);
movver = y(:,3);
set(handles.pushbutton4,'Enable','on');
guidata(hObject,handles);


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('introduzca un valor numérico','ERROR')
    set(hObject,'String','10')
else
    aux = str2double(Val);
    if aux <= 0
        errordlg('La masa debe ser positiva','ERROR')
        set(hObject,'String','10')
    else
        Newval = str2double(Val);
        handles.masa1 = Newval;
    end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.masa1 = 10;
guidata(hObject,handles);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('Introduzca un valor numérico','ERROR')
    set(hObject,'String','10')
else
    aux = str2double(Val);
    if aux <= 0
        errordlg('La masa debe ser positiva','ERROR')
        set(hObject,'String','10')
    else
        Newval = str2double(Val);
        handles.masa2 = Newval;
    end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.masa2 = 10;
guidata(hObject,handles);

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('Introduzca un valor numérico','ERROR')
    set(hObject,'String','0')
else
    aux = str2double(Val);
    if aux < 0
        errordlg('El tiempo inicial debe ser positivo','ERROR')
        set(hObject,'String','0')
    else
        Newval = str2double(Val);
        handles.tinicio = Newval;
    end
end
guidata(hObject,handles);

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
% Para el nicio del programa
handles.tinicio = 0;
guidata(hObject,handles);


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('Introduzca un valor numérico','ERROR')
    set(hObject,'String','5')
else
    aux = str2double(Val);
    if aux <= 0
        errordlg('El tiempo final debe ser positivo','ERROR')
        set(hObject,'String','5')
    elseif handles.tinicio >= aux
        warndlg('El tiempo final debe ser mayor que el inicial','ADVERTENCIA')
        set(hObject,'String','5')
    else
        Newval = str2double(Val);
        handles.tfinal = Newval;
    end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Para el inicio de la interfaz
handles.tfinal = 5;
guidata(hObject,handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('Introduzca un valor numérico','ERROR')
    set(hObject,'String','10')
else
    aux = str2double(Val);
    if aux <= 0
        errordlg('La longitud del péndulo debe ser positiva','ERROR')
        set(hObject,'String','10')
    else
        Newval = str2double(Val);
        handles.longitud = Newval;
    end
end
guidata(hObject,handles);


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
handles.longitud = 10;
guidata(hObject,handles);


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('introduzca un valor numérico','ERROR')
    set(hObject,'String','0')
else
    Newval = str2double(Val);
    handles.dxinicial = Newval;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.dxinicial = 0;
guidata(hObject,handles);

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('introduzca un valor numérico','ERROR')
    set(hObject,'String','0')
else
    Newval = str2double(Val);
    handles.xinicial = Newval;
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.xinicial = 0;
guidata(hObject,handles);


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('introduzca un valor numérico','ERROR')
    set(hObject,'String','0')
else
    Newval = str2double(Val);
    a = Newval*pi/180;
    handles.phinicial = a;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.phinicial = 0;
guidata(hObject,handles);


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('introduzca un valor numérico','ERROR')
    set(hObject,'String','0')
else
    Newval = str2double(Val);
    a = Newval*pi/180;
    handles.dphinicial = a;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.dphinicial = 0;
guidata(hObject,handles);

%========Para que no joda========================================
function uipanel9_CreateFcn(hObject, eventdata, handles)
function pushbutton1_CreateFcn(hObject, eventdata, handles)
%========Para que no joda========================================


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
cond = get(hObject,'Value');%Ver si la opcion Hold on esta activada o no.
handles.grid=cond;
if cond==1
    axes(handles.axes1)
    grid on;
    axes(handles.axes2)
    grid on;
else
    axes(handles.axes1)
    grid off;
    axes(handles.axes2)
    grid off;
end
guidata(hObject,handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
cond = get(hObject,'Value');%Ver si la opcion Hold on esta activada o no.
handles.hol=cond;
if cond==1
    axes(handles.axes1)
    hold on;
    axes(handles.axes2)
    hold on;
else
    axes(handles.axes1)
    hold off;
    axes(handles.axes2)
    hold off;
end
guidata(hObject,handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global q1
q1 = get(handles.popupmenu1,'Value');
axes(handles.axes1)
global h1
switch q1 % Para el Símbolo Gráfica 1: 
    case 1
        set(h1,'Marker','none')
    case 2
        set(h1,'Marker','.')
    case 3
        set(h1,'Marker','o')
    case 4
        set(h1,'Marker','x')
    case 5
        set(h1,'Marker','+')
    case 6
        set(h1,'Marker','*')
    case 7
        set(h1,'Marker','s')
    case 8
        set(h1,'Marker','d')
    case 9
        set(h1,'Marker','^')
    case 10
        set(h1,'Marker','<')
    case 11
        set(h1,'Marker','>')
    case 12
        set(h1,'Marker','p')
    case 13
        set(h1,'Marker','h')
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
global q2
q2 = get(handles.popupmenu2,'Value');
axes(handles.axes2)
global h2
switch q2 % Para el Símbolo Gráfica 2: 
    case 1
        set(h2,'Marker','none')
    case 2
        set(h2,'Marker','.')
    case 3
        set(h2,'Marker','o')
    case 4
        set(h2,'Marker','x')
    case 5
        set(h2,'Marker','+')
    case 6
        set(h2,'Marker','*')
    case 7
        set(h2,'Marker','s')
    case 8
        set(h2,'Marker','d')
    case 9
        set(h2,'Marker','^')
    case 10
        set(h2,'Marker','<')
    case 11
        set(h2,'Marker','>')
    case 12
        set(h2,'Marker','p')
    case 13
        set(h2,'Marker','h')
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
global p1
p1 = get(handles.popupmenu3,'Value');
axes(handles.axes1)
global h1
switch p1 % Para el tipo de línea de la gráfica 1
    case 1
        set(h1,'LineStyle','-')
    case 2
        set(h1,'LineStyle','-')
    case 3
        set(h1,'LineStyle',':')
    case 4
        set(h1,'LineStyle','-.')
    case 5
        set(h1,'LineStyle','--')
end


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
global p2
p2 = get(handles.popupmenu4,'Value');
axes(handles.axes2)
global h2
switch p2 % Para el tipo de línea de la gráfica 2
    case 1
        set(h2,'LineStyle','-')
    case 2
        set(h2,'LineStyle','-')
    case 3
        set(h2,'LineStyle',':')
    case 4
        set(h2,'LineStyle','-.')
    case 5
        set(h2,'LineStyle','--')
end

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Para elegir el método de resolver la ecuación diferencial
if (hObject == handles.radiobutton4)
    % Metodo ode45
    handles.metodo = 1;
elseif (hObject == handles.radiobutton5)
    % Metodo ode23
    handles.metodo = 2;
elseif (hObject == handles.radiobutton6)
    % Metodo implementado
    handles.metodo = 3;
end
guidata(hObject,handles);


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
Val = get(hObject,'String');
if isnan(str2double(Val))
    errordlg('Introduzca un valor numérico','ERROR')
    set(hObject,'String','0.05')
else
    aux = str2double(Val);
    if aux <= 0
        errordlg('El paso del método debe ser positivo','ERROR')
        set(hObject,'String','0.05')
    else
        Newval = str2double(Val);
        handles.paso = Newval;
    end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.paso = 0.05;
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla
axes(handles.axes2)
cla
set(handles.pushbutton4,'Enable','off');
guidata(hObject,handles);


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
global metodoRK
metodo = get(hObject,'Value');
switch metodo % Para seleccionar el método de Runge-Kutta que se va a implementar 
    case 1
        metodoRK = 1; % Es RK31
    case 2
        metodoRK = 2; % Es RK32
end


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global metodoRK
metodoRK = 1;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
hold on
grid on
axis equal
% Para el movimiento horizontal
global movhor
global movver
global tpart
l = handles.longitud;
m1 = handles.masa1;
m2 = handles.masa2;

% Para la interpolacion
movhor1 = spline(tpart,movhor,handles.tinicio:0.01:handles.tfinal);
movver1 = spline(tpart,movver,handles.tinicio:0.01:handles.tfinal);

% Para el movimiento pendular
ho = movhor1 + l*sin(movver1);
ve = -1*l*cos(movver1);

set(gcf,'Renderer','OpenGL'); 

hl = line([movhor1(1) ho(1)],[0 ve(1)],'Color','k');
h1 = plot(movhor1(1),0,'o','MarkerSize',m1,'MarkerFaceColor','b');
h2 = plot(ho(1),ve(1),'o','MarkerSize',m2,'MarkerFaceColor','b');
set(h1,'EraseMode','normal');
set(h2,'EraseMode','normal');
set(hl,'EraseMode','normal');

limInfHor = min([movhor1 ho]);
limSupHor = max([movhor1 ho]);
xlim([limInfHor limSupHor]);
limy = max([0 max(ve)]);
ylim([min(ve) limy]);

i = 1;
while i<=length(movhor1)
    set(h1,'XData',movhor1(i));
    set(h2,'XData',ho(i),'YData',ve(i));
    set(hl,'XData',[movhor1(i) ho(i)],'YData',[0 ve(i)]);
    drawnow;
    i = i+1;
end
