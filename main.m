close all;
clear all;

[filename,path] = uigetfile({'*.*';'*.jpg';'*.png';},'File Selector');
actual_path = strcat(path,filename);
I = imread(actual_path);
setappdata(0,'I_1',I);



I = getappdata(0,'I_1');
% axes(handles.axes1);
figure; imshow(I); title('Original Image');



II = getappdata(0,'I_1');
gray_image = rgb2gray(II);
%axes(handles.axes2);
figure; imshow(gray_image); title('Gray Image');
setappdata(0,'Gray_1',gray_image);

gray_image = getappdata(0,'Gray_1');
[~, threshold] = edge(gray_image, 'canny')
fudgeFactor = 1.5;
% threshold = [ 0.05, 0.5];
 canny_edge = edge(gray_image,'canny', threshold * fudgeFactor);
% canny_edge = edge(gray_image,'canny', threshold );
% axes(handles.axes3);
figure; imshow(canny_edge); title('canny edge');
setappdata(0,'canny_1',canny_edge);


se = strel('disk',1);
canny_edge = imdilate(canny_edge,se);
% axes(handles.axes3);
figure; imshow(canny_edge); title('canny edge');
setappdata(0,'canny_2',canny_edge);

pause(1);

canny_edge = getappdata(0,'canny_2');
se90 = strel('line', 1, 90);
se0 = strel('line', 1, 0);
bb = imdilate(canny_edge, [se90 se0]);
 noise_reduction= imclearborder(bb);
%  axes(handles.axes4);

figure; imshow(I); title('Original Image');
hold on;
imshow(noise_reduction);
hold  off;
 setappdata(0,'canny_edge1',canny_edge);

pause(1);

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
% set(handles.set1,'string',ccstring);
%  axes(handles.axes5);
figure; imshow(BW2); title('Filled Circles');
setappdata(0,'area_circle1',BW2);

pause(1);

BWs = getappdata(0,'canny_edge1');
BW_out = BWs;
BW_out = imclearborder(BW_out);
BW_out = imfill(BW_out, 'holes');
BW_out = bwpropfilt(BW_out, 'MajorAxisLength', [30, 90]);
BW_out = bwpropfilt(BW_out, 'MinorAxisLength', [0, 30]);
BW_out = bwpropfilt(BW_out, 'Eccentricity', [0.795, 0.907]);
BW_out = bwpropfilt(BW_out, 'Area', [300, 2700]);
cc = bwconncomp(BW_out, 4);
cc1 = cc.NumObjects;
ccstring = num2str(cc1);
% set(handles.set2,'string',ccstring);
tmp = getappdata(0,'circularcell');
totalCells = tmp+ cc1*2
% set(handles.set3,'string',num2str(totalCells));
% axes(handles.axes6);

figure; imshow(BW_out);title('overlapped');
setappdata(0,'overLapped1',BW_out);

