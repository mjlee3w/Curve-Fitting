function varargout = Lee_CurveFitProgram2(varargin)
%LEE_CURVEFITPROGRAM2 MATLAB code file for Lee_CurveFitProgram2.fig
%      LEE_CURVEFITPROGRAM2, by itself, creates a new LEE_CURVEFITPROGRAM2 or raises the existing
%      singleton*.
%
%      H = LEE_CURVEFITPROGRAM2 returns the handle to a new LEE_CURVEFITPROGRAM2 or the handle to
%      the existing singleton*.
%
%      LEE_CURVEFITPROGRAM2('Property','Value',...) creates a new LEE_CURVEFITPROGRAM2 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Lee_CurveFitProgram2_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LEE_CURVEFITPROGRAM2('CALLBACK') and LEE_CURVEFITPROGRAM2('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LEE_CURVEFITPROGRAM2.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Lee_CurveFitProgram2

% Last Modified by GUIDE v2.5 22-Apr-2018 00:48:15

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Lee_CurveFitProgram2_OpeningFcn, ...
                   'gui_OutputFcn',  @Lee_CurveFitProgram2_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Lee_CurveFitProgram2 is made visible.
function Lee_CurveFitProgram2_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Lee_CurveFitProgram2
handles.output = hObject;
% ask for username and logfile name input
prompt = {'Enter a username:','Enter a log file name:'};
title = 'Welcome!';
dims = [1, 35];
definput = {'John Smith','logfile.txt'};
answer = inputdlg(prompt,title,dims,definput);
answer = string(answer);

d = datetime('today'); % today's date
d = string(d);

write2TextFile(strcat('\nUSER:: ','', answer(1)), answer(2)); % write to a logging file
write2TextFile(strcat('\tDATE:: ','', d), answer(2)); % write to a logging file
setappdata(0,'logfile', answer(2));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Lee_CurveFitProgram2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Lee_CurveFitProgram2_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in exit_Button.
function exit_Button_Callback(hObject, ~, ~)
% hObject    handle to exit_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
File = getappdata(0, 'logfile');
write2TextFile('\nExit Button Pressed By User\n',File);
clearvars -global
close();
guidata(hObject, handles);



% --- Executes on button press in browse_Button.
% loads the desired data
function browse_Button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
global filename

if isempty(filename)
    filename = uigetfile({'*.txt'}, 'File Selector');
    try
        data = load(filename);
    catch
        % if problem show error (mostly for length in x and y
        errordlg('Not a valid file. Please choose another file');
        %return;
    end

    x = data(:,1);  
    y = data(:,end);
    [x, id] = sort(x);
    y = y(id);
    set(handles.pathName_text,'String',filename);
    setappdata(0, 'x_data', x);
    setappdata(0, 'y_data', y);

    File = getappdata(0, 'logfile'); % write to a logging file
    write2TextFile(strcat('\n===DATA FILE UPLOADED BY USER:: ','', filename,'==='),File);
else
    answer = questdlg('Do you want to upload a new file or override a current file?' ,'File Upload');
    if answer == 'Yes'
        filename = uigetfile({'*.txt'}, 'File Selector');
        try
            data = load(filename);
        catch
            % if problem show error (mostly for length in x and y
            errordlg('Not a valid file. Please choose another file');
        end

        x = data(:,1);  
        y = data(:,end); 
        set(handles.pathName_text,'String',filename);
        setappdata(0, 'x_data', x);
        setappdata(0, 'y_data', y);

        File = getappdata(0, 'logfile'); % write to a logging file
        write2TextFile(strcat('\n===DATA FILE UPLOADED BY USER:: ','', filename,'==='),File);
    end
end
guidata(hObject, handles);




function graph_title_Edit_Callback(hObject, ~, ~)
% hObject    handle to graph_title_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of graph_title_Edit as text
%        str2double(get(hObject,'String')) returns contents of graph_title_Edit as a double
handles = guidata(hObject);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function graph_title_Edit_CreateFcn(hObject, ~, ~)
% hObject    handle to graph_title_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles = guidata(hObject);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);



function xLabelGraph_edit_Callback(hObject, ~, ~)
% hObject    handle to xLabelGraph_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xLabelGraph_edit as text
%        str2double(get(hObject,'String')) returns contents of xLabelGraph_edit as a double
handles = guidata(hObject);
% File = getappdata(0, 'logfile');
% write2TextFile('\nX-Axis Label Edited By User',File); % write to a logging file
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xLabelGraph_edit_CreateFcn(hObject, ~, ~)
% hObject    handle to xLabelGraph_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles = guidata(hObject);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);



function yLabelGraph_edit_Callback(hObject, ~, ~)
% hObject    handle to yLabelGraph_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yLabelGraph_edit as text
%        str2double(get(hObject,'String')) returns contents of yLabelGraph_edit as a double
handles = guidata(hObject);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function yLabelGraph_edit_CreateFcn(hObject, ~, handles)
% hObject    handle to yLabelGraph_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles = guidata(hObject);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);


% --- Executes on button press in linear_fit_intercept_Button.
function linear_fit_intercept_Button_Callback(hObject, ~, ~)
% hObject    handle to linear_fit_intercept_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

File = getappdata(0, 'logfile');
write2TextFile('\n-----Linear Fit with Intercept Performed-----',File); % write to a logging file

% plot the original given data (scatter) -----
x = getappdata(0,'x_data');
y = getappdata(0, 'y_data');
fig = figure;
plot(x,y,'o');

xLabel = get(handles.xLabelGraph_edit, 'String');   % graph labels 
yLabel = get(handles.yLabelGraph_edit, 'String');
Title = get(handles.graph_title_Edit, 'String');
xlabel(xLabel);
ylabel(yLabel);
title(Title);

hold on;

% linear regression with intercept ------
linearReg = polyfit(x,y,1);
syms X;
linearRegEqn = linearReg(1)*X + linearReg(2);% symbolic X
linearRegEqnStr = expression2str(linearReg,1);
set(handles.Equation_text, 'String', linearRegEqnStr);

write2TextFile(strcat('\nEquation:: y =','', linearRegEqnStr),File); % writing to logging file

y2 = linearReg(1)*x + linearReg(2); % using data points x
fplot(linearRegEqn, [x(1), x(end)]);

persistent linearInterceptCount   % iterating plot pdf loop 
if isempty(linearInterceptCount)
    linearInterceptCount = 0;
end
linearInterceptCount = linearInterceptCount + 1;
savePlot2pdf('plot_lin_intercept', linearInterceptCount, fig); % save plot figure

m = num2str(linearReg(1));
b = num2str(linearReg(2));
write2TextFile(strcat('\nCoefficient (m):: ', '', m),File); % writing to logging file
write2TextFile(strcat('\nConstant (b):: ', '', b), File); 

hold off;

% calculating the MSE ------
e = y - y2;
MSE = mean(e.^2);
MSE = num2str(MSE);
set(handles.MSE_text, 'String', MSE);
write2TextFile(strcat('\nMSE:: ','', MSE), File); % write to a logging file

% calculating the R and R^2 ------
n = length(x);
R = (n*sum(x.*y) - sum(x)*sum(y)) / (sqrt(n*sum(x.^2) - sum(x)^2)*sqrt(n*sum(y.^2) - sum(y)^2));
R2 = R^2;
R = num2str(R);
R2 = num2str(R2);
set(handles.R_text,'String', R);
set(handles.R2_text, 'String', R2);

write2TextFile(strcat('\nR:: ','', R),File);
write2TextFile(strcat('\nR^2:: ','', R2),File); % write to a logging file

guidata(hObject, handles);


% --- Executes on button press in linear_fit_Button.
function linear_fit_Button_Callback(hObject, ~, ~)
% hObject    handle to linear_fit_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

File = getappdata(0, 'logfile');
write2TextFile('\n-----Linear Fit No Intercept Performed-----', File); % write to a logging file

% plot the original given data (scatter) -----
x = getappdata(0,'x_data');
y = getappdata(0, 'y_data');
fig = figure;
plot(x,y,'o');

xLabel = get(handles.xLabelGraph_edit, 'String');
yLabel = get(handles.yLabelGraph_edit, 'String'); % graph labels
Title = get(handles.graph_title_Edit, 'String');
xlabel(xLabel);
ylabel(yLabel);
title(Title);

hold on;

% linear regression no intercept -----
p = pinv(x)*y;
syms X;
linearRegEqn = p(1)*X;
linearRegEqnStr = expression2str(p,2);
set(handles.Equation_text, 'String', linearRegEqnStr);

write2TextFile(strcat('\nEquation:: y =', '', linearRegEqnStr), File);

y2 = p(1)*x;
fplot(linearRegEqn, [x(1),x(end)]);

persistent linearCount   % iterating plot pdf loop 
if isempty(linearCount)
    linearCount = 0;
end
linearCount = linearCount + 1;
savePlot2pdf('plot_linear', linearCount, fig); % save plot figure

m = num2str(p(1));
write2TextFile(strcat('\nCoefficient (m):: ', m), File); % writing to logging file

hold off;

% calculating the MSE -----
e = y-y2;
MSE = mean(e.^2);
MSE = num2str(MSE);
set(handles.MSE_text, 'String', MSE);

write2TextFile(strcat('\nMSE:: ', MSE),File); % write to logging file

% calculating the R and R^2 -----
n = length(x);
R = (n*sum(x.*y) - sum(x)*sum(y)) / (sqrt(n*sum(x.^2) - sum(x)^2)*sqrt(n*sum(y.^2) - sum(y)^2));
R2 = R^2;
R = num2str(R);
R2 = num2str(R2);
set(handles.R_text,'String', R);
set(handles.R2_text, 'String', R2);

write2TextFile(strcat('\nR:: ', R),File); % write to logging file
write2TextFile(strcat('\nR^2:: ', R2),File);

% --- Executes on button press in polynomial_Button.
function polynomial_Button_Callback(hObject, eventdata, handles)
% hObject    handle to polynomial_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% user choice of which nth degree polynomial fit to graph
choice = menu('Choose a nth degree polynomial','Quadriatic', 'Cubic', 'Quartic', '5th Degree');

x = getappdata(0,'x_data');
y = getappdata(0, 'y_data');

File = getappdata(0, 'logfile');

persistent quadCount;
persistent cubicCount;
persistent quartCount;
persistent fifthCount;

% plot according to user choice
switch choice
    % quadriatic regression
    case 1
        if length(x) >= 2
            write2TextFile('\n-----Quadriatic Fit Performed-----',File); %write to logging file
            
            % plot the original given data (scatter) -----
            fig = figure;
            plot(x,y,'o');
            
            xLabel = get(handles.xLabelGraph_edit, 'String');
            yLabel = get(handles.yLabelGraph_edit, 'String');
            Title = get(handles.graph_title_Edit, 'String');
            xlabel(xLabel);
            ylabel(yLabel);
            title(Title);
            hold on;
            
            p = polyfit(x,y,2);
            quadReg = polyval(p,x);
            syms X;
            quadRegEqn = p(1)*X^2 + p(2)*X + p(3);
            quadRegEqnStr = expression2str(p,3);
            set(handles.Equation_text, 'String', quadRegEqnStr);

            write2TextFile(strcat('\nEquation:: y =', '', quadRegEqnStr),File); %write to logging file

            fplot(quadRegEqn, [x(1), x(end)]);

            % iterating plot pdf loop 
            if isempty(quadCount)
                quadCount = 0;
            end
            quadCount = quadCount + 1;
            savePlot2pdf('plot_quad', quadCount, fig); % save plot figure

            a = num2str(p(1));
            b = num2str(p(2));
            c = num2str(p(3));
            write2TextFile(strcat('\nCoefficient (a):: ', a),File); % write to logging file
            write2TextFile(strcat('\nCoefficient (b):: ', b),File);
            write2TextFile(strcat('\nCoefficient (c):: ', c),File);

            hold off;

            % calculating the MSE -----
            e = y - quadReg;
            MSE = mean(e.^2);
            MSE = num2str(MSE);
            set(handles.MSE_text, 'String', MSE);
            write2TextFile(strcat('\nMSE:: ', MSE),File); % write to logging file

            % setting R and R^2 to NA bc nonlinear fit
            R = 'NA';
            set(handles.R_text, 'String', R);
            set(handles.R2_text, 'String', R);
        else 
            errordlg('Not Enough Data Points', 'Data Points Shortage');
        end
        
    % cubic
    case 2
        if length(x) >= 3
            write2TextFile('\n-----Cubic Fit Performed-----',File); % write to logging file
            
            % plot the original given data (scatter) -----
            fig = figure;
            plot(x,y,'o');
            
            xLabel = get(handles.xLabelGraph_edit, 'String');
            yLabel = get(handles.yLabelGraph_edit, 'String');
            Title = get(handles.graph_title_Edit, 'String');
            xlabel(xLabel);
            ylabel(yLabel);
            title(Title);
            hold on;
            
            p = polyfit(x,y,3);
            cubicReg = polyval(p,x);
            syms X;
            cubicRegEqn = p(1)*X^3 + p(2)*X^2 + p(3)*X + p(4);
            cubicRegEqnStr = expression2str(p,3);
            set(handles.Equation_text, 'String', cubicRegEqnStr);

            write2TextFile(strcat('\nEquation:: y =','', cubicRegEqnStr), File);

            fplot(cubicRegEqn, [x(1), x(end)]);

            % iterating plot pdf loop 
            if isempty(cubicCount)
                cubicCount = 0;
            end
            cubicCount = cubicCount + 1;
            savePlot2pdf('plot_cubic', cubicCount, fig); % save plot figure

            a = num2str(p(1));
            b = num2str(p(2));
            c = num2str(p(3));
            d = num2str(p(4));
            write2TextFile(strcat('\nCoefficient (a):: ', a),File); % write to logging file
            write2TextFile(strcat('\nCoefficient (b):: ', b),File);
            write2TextFile(strcat('\nCoefficient (c):: ', c),File);
            write2TextFile(strcat('\nCoefficient (d):: ', d),File);

            hold off;

            % calculating the MSE -----
            e = y - cubicReg;
            MSE = mean(e.^2);
            MSE = num2str(MSE);
            set(handles.MSE_text, 'String', MSE);
            write2TextFile(strcat('\nMSE:: ', MSE),File); % write to logging file

            % setting R and R^2 to NA bc nonlinear fit
            R = 'NA';
            set(handles.R_text, 'String', R);
            set(handles.R2_text, 'String', R);
        else
            errordlg('Not Enough Data Points', 'Data Points Shortage');
        end
        
    % quartic
    case 3
        if length(x) >= 4
            write2TextFile('\n-----Quartic Fit Performed-----',File); % write to logging file
            
            % plot the original given data (scatter) -----
            fig = figure;
            plot(x,y,'o');
            
            xLabel = get(handles.xLabelGraph_edit, 'String');
            yLabel = get(handles.yLabelGraph_edit, 'String');
            Title = get(handles.graph_title_Edit, 'String');
            xlabel(xLabel);
            ylabel(yLabel);
            title(Title);
            hold on;
            
            p = polyfit(x,y,4);
            quartReg = polyval(p,x);
            syms X;
            quartRegEqn = p(1)*X^4 + p(2)*X^3 + p(3)*X^2 + p(4)*X + p(5);
            quartRegEqnStr = expression2str(p,3);
            set(handles.Equation_text, 'String', quartRegEqnStr);

            write2TextFile(strcat('\nEquation:: y =','',quartRegEqnStr),File); % write to logging file

            fplot(quartRegEqn, [x(1), x(end)]);

            % iterating plot pdf loop 
            if isempty(quartCount)
                quartCount = 0;
            end
            quartCount = quartCount + 1;
            savePlot2pdf('plot_quart', quartCount, fig); % save plot figure

            a = num2str(p(1));
            b = num2str(p(2));
            c = num2str(p(3));
            d = num2str(p(4));
            e = num2str(p(5));
            write2TextFile(strcat('\nCoefficient (a):: ', a),File); % write to logging file
            write2TextFile(strcat('\nCoefficient (b):: ', b),File);
            write2TextFile(strcat('\nCoefficient (c):: ', c),File);
            write2TextFile(strcat('\nCoefficient (d):: ', d),File);
            write2TextFile(strcat('\nCoefficient (e):: ', e),File);

            hold off;

            % calculating the MSE -----
            e = y - quartReg;
            MSE = mean(e.^2);
            MSE = num2str(MSE);
            set(handles.MSE_text, 'String', MSE);
            write2TextFile(strcat('\nMSE:: ', MSE),File); % write to logging file

            % setting R and R^2 to NA bc nonlinear fit
            R = 'NA';
            set(handles.R_text, 'String', R);
            set(handles.R2_text, 'String', R);
        else
            errordlg('Not Enough Data Points', 'Data Points Shortage');
        end
        
    % 5th degree
    case 4
        if length(x) >= 5
            write2TextFile('\n-----5th Degree Fit Performed-----',File); % write to logging file
            
            % plot the original given data (scatter) -----
            fig = figure;
            plot(x,y,'o');
            
            xLabel = get(handles.xLabelGraph_edit, 'String');
            yLabel = get(handles.yLabelGraph_edit, 'String');
            Title = get(handles.graph_title_Edit, 'String');
            xlabel(xLabel);
            ylabel(yLabel);
            title(Title);
            hold on;
            
            p = polyfit(x,y,5);
            fifthReg = polyval(p,x);
            syms X;
            fifthRegEqn = p(1)*X^5 + p(2)*X^4 + p(3)*X^3 + p(4)*X^2 + p(5)*X + p(6);
            fifthRegEqnStr = expression2str(p,3);
            set(handles.Equation_text, 'String', fifthRegEqnStr);

            write2TextFile(strcat('\nEquation:: y =','',fifthRegEqnStr),File);

            fplot(fifthRegEqn, [x(1), x(end)]);

            % iterating plot pdf loop 
            if isempty(fifthCount)
                fifthCount = 0;
            end
            fifthCount = fifthCount + 1;
            savePlot2pdf('plot_fifth', fifthCount, fig); % save plot figure

            a = num2str(p(1));
            b = num2str(p(2));
            c = num2str(p(3));
            d = num2str(p(4));
            e = num2str(p(5));
            f = num2str(p(6));
            write2TextFile(strcat('\nCoefficient (a):: ', a),File); % write to logging file
            write2TextFile(strcat('\nCoefficient (b):: ', b),File);
            write2TextFile(strcat('\nCoefficient (c):: ', c),File);
            write2TextFile(strcat('\nCoefficient (d):: ', d),File);
            write2TextFile(strcat('\nCoefficient (e):: ', e),File);
            write2TextFile(strcat('\nCoefficient (f):: ', f),File);

            hold off;

            % calculating the MSE -----
            e = y - fifthReg;
            MSE = mean(e.^2);
            MSE = num2str(MSE);
            set(handles.MSE_text, 'String', MSE);
            write2TextFile(strcat('\nMSE:: ', MSE), File); % write to logging file

            % setting R and R^2 to NA bc nonlinear fit
            R = 'NA';
            set(handles.R_text, 'String', R);
            set(handles.R2_text, 'String', R);
        else
            errordlg('Not Enough Data Points', 'Data Points Shortage');
        end
end
guidata(hObject, handles);


% --- Executes on button press in exponential_Button.
function exponential_Button_Callback(hObject, ~, ~)
% hObject    handle to exponential_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

File = getappdata(0, 'logfile');
x = getappdata(0,'x_data');
y = getappdata(0, 'y_data');

persistent expCount 

if  all(y<0) || all(y>0)  
    % plot the original given data (scatter) -----
    write2TextFile('\n-----Exponential Fit Performed-----',File); % write to logging file
    fig = figure;
    plot(x,y,'o');

    xLabel = get(handles.xLabelGraph_edit, 'String'); % graph labels
    yLabel = get(handles.yLabelGraph_edit, 'String');
    Title = get(handles.graph_title_Edit, 'String');
    xlabel(xLabel);
    ylabel(yLabel);
    title(Title);
    hold on;

    % exponential regression -----
    logY = log(y);
    linReg = polyfit(x,logY,1); % finding linear regression of x vs. log(y)
    B = linReg(1);              % find A & B coeff from the linearized fit
    A = exp(linReg(2));
    syms X;
    YFitEqn = A.*exp(B*X);
    YFitEqnStr = expression2str(linReg, 4);
    set(handles.Equation_text, 'String', YFitEqnStr);

    write2TextFile(strcat('\nEquation y =','',YFitEqnStr),File);

    YFit = A.*exp(B*x);
    fplot(YFitEqn, [x(1), x(end)]);

  % iterating plot pdf loop 
    if isempty(expCount)
        expCount = 0;
    end
    expCount = expCount + 1;
    savePlot2pdf('plot_exp', expCount, fig); % save plot figure

    m = num2str(linReg(1));
    b = num2str(linReg(2));
    write2TextFile(strcat('\nCoefficient (m):: ', '', m),File); % writing to logging file
    write2TextFile(strcat('\nCoefficient (b):: ', '', b), File); 

    hold off;

    % calculating the MSE -----
    e = y - YFit;
    MSE = mean(e.^2);
    MSE = num2str(MSE);
    set(handles.MSE_text, 'String', MSE);
    write2TextFile(strcat('\nMSE:: ', MSE), File); % write to logging file

    % setting R and R^2 to NA bc non-linear curve fit -----
    R = 'NA';
    R2 = 'NA';
    set(handles.R_text, 'String', R);
    set(handles.R2_text, 'String', R2);
else
    errordlg('Data Passes Through The Origin Or  Y Data Is Not All Positive Or Negative','Error');
end
guidata(hObject, handles);


% --- Executes on button press in power_Button.
function power_Button_Callback(hObject, ~, ~)
% hObject    handle to power_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

persistent powerCount

File = getappdata(0, 'logfile');
x = getappdata(0,'x_data');
y = getappdata(0, 'y_data');

if  all(x > 0) && all(y > 0)
    write2TextFile('\n-----Power Fit Performed-----',File); % write to logging file

    % plot the original given data (scatter) -----
    fig = figure;
    plot(x,y,'o');

    xLabel = get(handles.xLabelGraph_edit, 'String');
    yLabel = get(handles.yLabelGraph_edit, 'String'); % graph labels
    Title = get(handles.graph_title_Edit, 'String');
    xlabel(xLabel);
    ylabel(yLabel);
    title(Title);

    hold on;

    % power regression ----
    logY = log(y);
    logX = log(x);
    powerReg = polyfit(logX, logY, 1); % linear regression with log(x) vs. log(y)
    m = powerReg(1);                   % finding coeff
    B = exp(powerReg(2));
    syms X;
    YFitEqn = B.*X.^m;
    YFitEqnStr = expression2str(powerReg, 5);
    set(handles.Equation_text, 'String', YFitEqnStr);

    write2TextFile(strcat('\nEquation:: y =','',YFitEqnStr),File);

    YFit = B.*x.^m;
    fplot(YFitEqn, [x(1), x(end)]);

     % iterating plot pdf loop 
    if isempty(powerCount)
        powerCount = 0;
    end
    powerCount = powerCount + 1;
    savePlot2pdf('plot_power', powerCount, fig); % save plot figure

    m = num2str(powerReg(1));
    b = num2str(powerReg(2));
    write2TextFile(strcat('\nCoefficient (m):: ', '', m),File); % writing to logging file
    write2TextFile(strcat('\nCoefficient (b):: ', '', b), File); 

    hold off;

    % calculating the MSE -----
    e = y-YFit;
    MSE = mean(e.^2);
    MSE = num2str(MSE);
    set(handles.MSE_text, 'String', MSE);
    write2TextFile(strcat('\nMSE:: ', MSE), File); % write to logging file

    % setting R and R^2 to NA bc nonlinear curve fit -----
    R = 'NA';
    set(handles.R_text, 'String', R);
    set(handles.R2_text, 'String', R);
else
    errordlg('There Are Zeros In The Data And/Or Data Is Negative', 'Error');
end
    guidata(hObject, handles);


    % --- Executes on button press in trig_Button.
    function trig_Button_Callback(hObject, ~, ~)
    % hObject    handle to trig_Button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    handles = guidata(hObject);

    File = getappdata(0, 'logfile');
    write2TextFile('\n------Trig Fit Performed-----',File); % write in logging file

    % plot the original given data (scatter) -----
    x = getappdata(0,'x_data');
    y = getappdata(0, 'y_data');
    fig = figure;
    plot(x,y,'o');

    xLabel = get(handles.xLabelGraph_edit, 'String'); % graph labels
    yLabel = get(handles.yLabelGraph_edit, 'String');
    Title = get(handles.graph_title_Edit, 'String');
    xlabel(xLabel);
    ylabel(yLabel);
    title(Title);

    hold on;

    % trig regression -----
    p = polyfit(cos(x), y, 1); % linear fit with cos(x) vs y
    syms X;
    trigRegEqn = p(2) + p(1).*cos(X);
    trigRegEqnStr = expression2str(p,6);
    set(handles.Equation_text, 'String', trigRegEqnStr);

    write2TextFile(strcat('\nEquation:: y =','',trigRegEqnStr),File);

    y2 = polyval(p,x);
    fplot(trigRegEqn, [x(1), x(end)]);

    persistent trigCount   % iterating plot pdf loop 
    if isempty(trigCount)
        trigCount = 0;
    end
    trigCount = trigCount + 1;
    savePlot2pdf('plot_trig', trigCount, fig); % save plot figure

    m = num2str(p(1));
    b = num2str(p(2));
    write2TextFile(strcat('\nCoefficient (m):: ', '', m),File); % writing to logging file
    write2TextFile(strcat('\nConstant (b):: ', '', b), File); 

    hold off;

    % calculating the MSE ----
    e = y-y2;
    MSE = mean(e.^2);
    MSE = num2str(MSE);
    set(handles.MSE_text, 'String', MSE);
    write2TextFile(strcat('\nMSE:: ', MSE),File); % write to logging file

    % setting R and R^2 bc nonlinear curve fit -----
    R = 'NA';
    set(handles.R_text,'String', R);
    set(handles.R2_text,'String', R);
guidata(hObject, handles);


% --- Executes on button press in log_Button.
function log_Button_Callback(hObject, eventdata, handles)
% hObject    handle to log_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

File = getappdata(0, 'logfile');
x = getappdata(0,'x_data');
y = getappdata(0, 'y_data');

persistent logCount

if all(x>0) == 1
    % plot the original given data (scatter) -----
    write2TextFile('\n-----Logarithmic Fit Performed-----', File);
    fig = figure;
    plot(x,y,'o');

    xLabel = get(handles.xLabelGraph_edit, 'String'); % graph labels
    yLabel = get(handles.yLabelGraph_edit, 'String');
    Title = get(handles.graph_title_Edit, 'String');
    xlabel(xLabel);
    ylabel(yLabel);
    title(Title);
    hold on;

    % logarithmic regression -----
    logX = log(x);
    p = polyfit(logX, y, 1); % linear regression with log(x) vs y
    syms X;
    YFitEqn = p(1)*log(X) + p(2);
    YFitEqnStr = expression2str(p,7);
    set(handles.Equation_text, 'String', YFitEqnStr);

    write2TextFile(strcat('\nEquation:: y =','',YFitEqnStr),File)

    YFit = p(1)*log(x) + p(2);
    fplot(YFitEqn, [x(1), x(end)]);

       % iterating plot pdf loop 
    if isempty(logCount)
        logCount = 0;
    end
    logCount = logCount + 1;
    savePlot2pdf('plot_log', logCount, fig); % save plot figure

    m = num2str(p(1));
    b = num2str(p(2));
    write2TextFile(strcat('\nCoefficient (m):: ', '', m),File); % writing to logging file
    write2TextFile(strcat('\nConstant (b):: ', '', b), File); 

    hold off;

    % calculating the MSE -----
    e = y - YFit;
    MSE = mean(e.^2);
    MSE = num2str(MSE);
    set(handles.MSE_text, 'String', MSE);
    write2TextFile(strcat('\nMSE:: ', MSE), File); % write to logging file

    % setting R and R^2 to NA bc non-linear curve fit -----
    R = 'NA';
    set(handles.R_text, 'String', R);
    set(handles.R2_text, 'String', R);
else
    errordlg('X Data Contains Negative Values Or Zero','Error');
end

guidata(hObject, handles);


% --- Executes on button press in reciprocal_Button.
function reciprocal_Button_Callback(hObject, eventdata, handles)
% hObject    handle to reciprocal_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

File = getappdata(0, 'logfile');
x = getappdata(0,'x_data');
y = getappdata(0, 'y_data');

y_zero = find(y==0);

persistent recCount

if isempty(y_zero)
    % plot the original given data (scatter) -----
    write2TextFile('\n-----Reciprocal Fit Performed-----', File);
    fig = figure;
    plot(x,y,'o');

    xLabel = get(handles.xLabelGraph_edit, 'String'); % graph labels
    yLabel = get(handles.yLabelGraph_edit, 'String');
    Title = get(handles.graph_title_Edit, 'String');
    xlabel(xLabel);
    ylabel(yLabel);
    title(Title);
    hold on;

    % reciprocal regression -----
    y_rec = 1./y;
    p = polyfit(x, y_rec, 1); % finding linear regression of x and 1/y
    syms X;
    recRegEqn = 1/(p(1)*X + p(2));
    recRegEqnStr = expression2str(p,8);
    set(handles.Equation_text, 'String', recRegEqnStr); % write to log file

    write2TextFile(strcat('\nEquation:: y =','',recRegEqnStr),File);

    recReg = 1./(p(1).*x + p(2));
    fplot(recRegEqn, [x(1), x(end)]);

    % iterating plot pdf loop 
    if isempty(recCount)
        recCount = 0;
    end
    recCount = recCount + 1;
    savePlot2pdf('plot_rec', recCount, fig); % save plot figure

    m = num2str(p(1));
    b = num2str(p(2));
    write2TextFile(strcat('\nCoefficient (m):: ', '', m),File); % writing to logging file
    write2TextFile(strcat('\nConstant (b):: ', '', b), File); 

    hold off;

    % calculating the MSE
    e = y - recReg;
    MSE = mean(e.^2);
    MSE = num2str(MSE);
    set(handles.MSE_text, 'String', MSE);
    write2TextFile(strcat('\nMSE:: ', MSE), File); % write to logging file

    % setting R and R^2 to NA bc non-linear fit
    R = 'NA';
    set(handles.R_text, 'String', R);
    set(handles.R2_text, 'String', R);
else
    errordlg('Y Data Contains Zeros', 'Error');
end
guidata(hObject, handles);


% --- Executes on button press in help_button.
function help_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
d = dialog('Position',[300 400 250 150],'Name','Help');

txt1 = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 80 210 40],...
           'String','1. Upload data text file by clicking browse.');
       
txt2 = uicontrol('Parent',d,...
   'Style','text',...
   'Position',[20 60 210 40],...
   'String','2. Input any axes and title labels');

txt3 = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 40 210 40],...
           'String','3. Choose a regression.');

btn = uicontrol('Parent',d,...
           'Position',[85 20 70 25],...
           'String','Close',...
           'Callback','delete(gcf)');
guidata(hObject, handles);
