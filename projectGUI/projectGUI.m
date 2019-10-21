function varargout = projectGUI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projectGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @projectGUI_OutputFcn, ...
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


% --- Executes just before projectGUI is made visible.
function projectGUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);
function varargout = projectGUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function surf_Callback(hObject, eventdata, handles)

function surf_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dot_x_Callback(hObject, eventdata, handles)
function dot_x_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [out] = sym2str(sy)
 sy = sym(sy); %insure input is symbolic
    siz = prod(size(sy));   %find the number of elements in "sy"
    for i = 1:siz   %dump it into a cell array with the same number of elements
        in{i} = char(sy(i)); %convert to char
        in{i} = strrep(in{i},'^','.^');%insure that all martix opps are array opps
        in{i} = strrep(in{i},'*','.*');
        in{i} = strrep(in{i},'/','./');
        in{i} = strrep(in{i},'atan','atan2'); %fix the atan function
        in{i} = strrep(in{i},'array([[','['); %clean up any maple array notation
        in{i} = strrep(in{i},'],[',';');
        in{i} = strrep(in{i},']])',']');
    end
    if siz == 1
        in = char(in);      %revert back to a 'char' array for single answers
    end
    out = in;

function ok_Callback(hObject, eventdata, handles)
if (get(handles.explicit,'value'))
    surface = get(handles.surf,'string');
    x0 = get(handles.dot_x,'string');
    y0 = get(handles.dot_y,'string');
    z0 = get(handles.dot_z,'string');
    syms x;
    syms y;
    syms z;
    syms t;
    dx=@(s,x0,y0)subs((subs(diff(s,x),x,x0)),y,y0); %%f'(x0,y0),x)
    dy=@(s,x0,y0)subs((subs(diff(s,y),x,x0)),y,y0); %%f'(x0,y0),y)
    diff_x = dx(surface,x0,y0);
    diff_y = dy(surface,x0,y0);
    tangent_func = diff_x*(x-x0)+diff_y*(y-y0)+z0;
    %%z=f'(x0,y0),x)(x-x0)+ f'(x0,y0),y)(y-y0)+z0
    x_n = x0+t*diff_x;
    y_n = y0+t*diff_y;
    z_n = z0-t;
    set(handles.out_tangent,'string',(sym2str(tangent_func)));
    set(handles.x_normal,'string',(sym2str(x_n)));
    set(handles.y_normal,'string',(sym2str(y_n)));
    set(handles.z_normal,'string',(sym2str(z_n)));
    ezsurf(surface);
    hold on
    ezplot3(x_n, y_n, z_n);
    hold on
    ezsurf(tangent_func);
    hold off
    figure 
    ezsurf(surface);
    hold on
    ezplot3(x_n, y_n, z_n);
    hold on
    ezsurf(tangent_func);
    hold off
    set(handles.explicit,'value',0);
end
if (get(handles.parametric,'value'))
    syms x;
    syms y;
    syms z;
    syms u;
    syms v;
    syms t;
    surf_x = get(handles.surf_x,'string');
    surf_y = get(handles.surf_y,'string');
    surf_z = get(handles.surf_z,'string');
    u0 = get(handles.u_par,'string');
    v0 = get(handles.v_par,'string');
    x0 = subs(subs((surf_x),u,u0),v,v0);
    y0 = subs(subs((surf_y),u,u0),v,v0);
    z0 = subs(subs((surf_z),u,u0),v,v0);
    DXY = det([diff(surf_x,u), diff(surf_x,v); diff(surf_y,u), diff(surf_y,v)]);
    DYZ = det([diff(surf_y,u), diff(surf_y,v); diff(surf_z,u), diff(surf_z,v)]);
    DZX = det([diff(surf_z,u), diff(surf_z,v); diff(surf_x,u), diff(surf_x,v)]);
    D0XY = subs(subs(DXY,u,u0),v,v0);
    D0YZ = subs(subs(DYZ,u,u0),v,v0);
    D0ZX = subs(subs(DZX,u,u0),v,v0);
    tangent = eval((-D0YZ*(x-x0)-D0ZX*(y-y0))/D0XY+z0);
    p_normal = eval([D0YZ, D0ZX, D0XY]./sqrt(D0XY^2+D0YZ^2+D0XY^2));
    normal_x = x0+p_normal(1,1)*t;
    normal_y = y0+p_normal(1,2)*t;
    normal_z = z0+p_normal(1,3)*t;
    ezsurf(surf_x,surf_y,surf_z);
    hold on
    ezsurf(tangent);
    ezplot3(normal_x,normal_y,normal_z);
    hold off
    figure 
    ezsurf(surf_x,surf_y,surf_z);
    hold on
    ezsurf(tangent);
    hold on
    ezplot3(normal_x,normal_y,normal_z);
    hold off
    set(handles.out_tangent,'string',sym2str(tangent));
    set(handles.x_normal,'string',(sym2str(normal_x)));
    set(handles.y_normal,'string',(sym2str(normal_y)));
    set(handles.z_normal,'string',(sym2str(normal_z)));
    set(handles.parametric,'value',0);
    
end




function dot_y_Callback(hObject, eventdata, handles)

function dot_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dot_z_Callback(hObject, eventdata, handles)

function dot_z_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



function x_normal_Callback(hObject, eventdata, handles)
% hObject    handle to x_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_normal as text
%        str2double(get(hObject,'String')) returns contents of x_normal as a double


% --- Executes during object creation, after setting all properties.
function x_normal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_normal_Callback(hObject, eventdata, handles)
% hObject    handle to y_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_normal as text
%        str2double(get(hObject,'String')) returns contents of y_normal as a double


% --- Executes during object creation, after setting all properties.
function y_normal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_normal_Callback(hObject, eventdata, handles)
% hObject    handle to z_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_normal as text
%        str2double(get(hObject,'String')) returns contents of z_normal as a double


% --- Executes during object creation, after setting all properties.
function z_normal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in explicit.
function explicit_Callback(hObject, eventdata, handles)
% hObject    handle to explicit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of explicit


% --- Executes on button press in parametric.
function parametric_Callback(hObject, eventdata, handles)
% hObject    handle to parametric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of parametric



function surf_x_Callback(hObject, eventdata, handles)
% hObject    handle to surf_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of surf_x as text
%        str2double(get(hObject,'String')) returns contents of surf_x as a double


% --- Executes during object creation, after setting all properties.
function surf_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to surf_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function surf_y_Callback(hObject, eventdata, handles)
% hObject    handle to surf_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of surf_y as text
%        str2double(get(hObject,'String')) returns contents of surf_y as a double


% --- Executes during object creation, after setting all properties.
function surf_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to surf_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function surf_z_Callback(hObject, eventdata, handles)
% hObject    handle to surf_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of surf_z as text
%        str2double(get(hObject,'String')) returns contents of surf_z as a double


% --- Executes during object creation, after setting all properties.
function surf_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to surf_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function u_par_Callback(hObject, eventdata, handles)
% hObject    handle to u_par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u_par as text
%        str2double(get(hObject,'String')) returns contents of u_par as a double


% --- Executes during object creation, after setting all properties.
function u_par_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u_par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v_par_Callback(hObject, eventdata, handles)
% hObject    handle to v_par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v_par as text
%        str2double(get(hObject,'String')) returns contents of v_par as a double


% --- Executes during object creation, after setting all properties.
function v_par_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v_par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
