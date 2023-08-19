function varargout = RBC_WBC_matlab(varargin)
% RBC_WBC_MATLAB MATLAB code for RBC_WBC_matlab.fig
%      RBC_WBC_MATLAB, by itself, creates a new RBC_WBC_MATLAB or raises the existing
%      singleton*.
%
%      H = RBC_WBC_MATLAB returns the handle to a new RBC_WBC_MATLAB or the handle to
%      the existing singleton*.
%
%      RBC_WBC_MATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RBC_WBC_MATLAB.M with the given input arguments.
%
%      RBC_WBC_MATLAB('Property','Value',...) creates a new RBC_WBC_MATLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RBC_WBC_matlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RBC_WBC_matlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RBC_WBC_matlab

% Last Modified by GUIDE v2.5 17-Apr-2017 20:41:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RBC_WBC_matlab_OpeningFcn, ...
                   'gui_OutputFcn',  @RBC_WBC_matlab_OutputFcn, ...
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


% --- Executes just before RBC_WBC_matlab is made visible.
function RBC_WBC_matlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RBC_WBC_matlab (see VARARGIN)

% Choose default command line output for RBC_WBC_matlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RBC_WBC_matlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RBC_WBC_matlab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Select_image.
function Select_image_Callback(hObject, eventdata, handles)
% hObject    handle to Select_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IN;
[filename,path] = uigetfile({'*.*';'*.jpg';'*.png';},'File Selector');
actual_path = strcat(path,filename);
I = imread(actual_path);
IN = I;
setappdata(0,'I_1',I);
axes(handles.axes1);
 imshow(I);


% --- Executes on button press in preprocess_image.
function preprocess_image_Callback(hObject, eventdata, handles)
% hObject    handle to preprocess_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IN;
global Bw;
II = getappdata(0,'I_1');
gray_image = rgb2gray(II);
axes(handles.axes2);
imshow(gray_image); 
setappdata(0,'Gray_1',gray_image);

gray_image = getappdata(0,'Gray_1');
[~, threshold] = edge(gray_image, 'canny')
fudgeFactor = 1.5;
% threshold = [ 0.05, 0.5];
 canny_edge = edge(gray_image,'canny', threshold * fudgeFactor);
% canny_edge = edge(gray_image,'canny', threshold );
setappdata(0,'canny_1',canny_edge);
se = strel('disk',1);
canny_edge = imdilate(canny_edge,se);
 axes(handles.axes3);
imshow(canny_edge);
setappdata(0,'canny_2',canny_edge);


Igray = 0.2989*IN(:,:,1)+0.5870*IN(:,:,2)+0.1140*IN(:,:,3);
compliment= imcomplement(Igray);
axes(handles.axes6);
imshow(compliment);
Bw=im2bw(compliment);

axes(handles.axes7);
imshow(Bw);

% --- Executes on button press in RBC_counting.
function RBC_counting_Callback(hObject, eventdata, handles)
% hObject    handle to RBC_counting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


pause(1);

canny_edge = getappdata(0,'canny_2');
se90 = strel('line', 1, 90);
se0 = strel('line', 1, 0);
bb = imdilate(canny_edge, [se90 se0]);
noise_reduction= imclearborder(bb);
% %  axes(handles.axes4);
% 
% imshow(noise_reduction);
% hold  off;
setappdata(0,'canny_edge1',noise_reduction);

 BWsdil = getappdata(0,'canny_edge1');
 BWdfill = imfill(BWsdil, 'holes');
% figure, imshow(BWdfill),title('binary image with filled holes');
%states = regionprops(BWdfill)
% bw = im2bw(BWdfill);
 BW2 = bwpropfilt(BWdfill,'area',[383 3500]);
cc = bwconncomp(BW2, 4);
cc1 = cc.NumObjects;
setappdata(0,'circularcell',cc1);
ccstring = num2str(cc1)
 set(handles.rbc_count_txt,'string',ccstring);
  axes(handles.axes4);
 imshow(BW2);
setappdata(0,'area_circle1',BW2);

% --- Executes on button press in WBC_find.
function WBC_find_Callback(hObject, eventdata, handles)
% hObject    handle to WBC_find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Bw;
se= strel('disk',5);
bw_erode=imerode(Bw,se);
bw_dilate= imdilate(bw_erode,se);
bw_dilate= imdilate(bw_dilate,se);
bw_open=imopen(bw_dilate,se);
bw_close=imclose(bw_open,se);
bw = bwareaopen(bw_close, 60);
axes(handles.axes5);
imshow(bw);
cc = bwconncomp(bw, 8);
wbc_c = cc.NumObjects
ccstring = num2str(wbc_c)
set(handles.WBC_count_text,'string',ccstring);
