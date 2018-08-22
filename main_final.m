clc;
close all;
clear all;

[filen, pathn]=uigetfile('*.bmp; *.png; *.jpg; *.tif' , 'Select an Input Image');
I=imread([pathn, filen]);
if ndims(I)==3
    I1=rgb2gray(I);
else
    I1=I;
end

I1=imresize(I1, [300,400]);
figure, imshow(I1);
title ('Input Image');
m=zeros(size(I1,1), size(I1,2));
m(90:222,110:325) = 1;
I2=imresize(I1, 0.5);
m=imresize(m, 0.5);

figure,
subplot(2,2,1); imshow(I2); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = region_seg(I2, m, 150); %-- Run segmentation

subplot(2,2,4); imshow(seg); title('Global Region-Based Segmentation');

seg=imresize(seg, [size(I1,1), size(I1,2)]);
figure, imshow(seg);
title('Contour Image');

for i=1:300
    for j=1:400
        if seg(i,j)==0
            I1(i,j)=0;
        end
    end
end
 
figure,imshow (I1);

stats=regionprops (im2bw (I1), 'Area', 'BoundingBox');
a=[stats.Area]==max([stats.Area]);
box1=round(stats(a).BoundingBox);
hold on
rectangle('Position', box1, 'EdgeColor', 'g', 'LineWidth', 3), title('Image With Extracted Pixels');
img=imcrop(I1,box1);
figure
imshow(img);

title ('Input Image');
img=imresize(img, [300,400]);
m=zeros(size(I1,1), size(I1,2));
m(90:222,110:325) = 1;
img2=imresize(img,0.5);
m=imresize(m, 0.5);

figure,
subplot(2,2,1); imshow(img); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg1 = region_seg(img2, m, 550); %-- Run segmentation

subplot(2,2,4); imshow(seg1); title('Global Region-Based Segmentation');

figure,
BW = roipoly(seg1);

BW=edge(BW,'canny');
imshow(BW);
[y, x] = find(BW);
%x1=max(x);
%y1=max(y);
figure
a=area(x,y);
%lengthOfEdges = sum(BW);
a=a/1000;

if a<20
    disp('Glaucoma is detected');
else
    disp('No Glaucoma Detected');
end


