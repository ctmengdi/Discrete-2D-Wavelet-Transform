function [ coef ] = wt_dec_2d( img, h )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   inputs: an image 'img', the number of levels 'J', a low-pass filter 'h'
%   output: an array of NxN wavelet coefficients 'coef'
%   Author: Meng Di
%   Date:   07/01/2018

%img=double(imread('lena256.bmp'));
%h = [0.48296     0.83652     0.22414    -0.12941];

% Construction of high-pass filter from the low-pass filter
%g=h.*power(-1*ones(1,length(h)),(0:length(h)-1));
for n=0:length(h)-1,
   g(n+1)=h(n+1)*(-1)^(n+1);
end;
g=g(length(g):-1:1);

% Convolve the rows with low and high pass filters respectively
A0 = zeros(size(img));
D0 = zeros(size(img));
for i = 1:size(img,1)
    A0(i,:) = pconv(h, img(i,:)); 
    D0(i,:) = pconv(g, img(i,:));
end

% Downsampling columns(the even indexed columns are kept)
A1 = zeros(size(A0,1), size(A0,2)/2);
D1 = zeros(size(D0,1), size(D0,2)/2);
n1 = 1;
for i = 2:2:size(A0, 2)
    A1(:,n1) = A0(:,i);
    D1(:,n1) = D0(:,i);
    n1 = n1+1;
end

% Convolve the columns for approximation and horizontal details
A2 = zeros(size(A1));
D2 = zeros(size(A1));
for i = 1:size(A1, 2)
    A2(:,i) = pconv(h, A1(:,i)');
    D2(:,i) = pconv(g, A1(:,i)');
end

% Downsampling rows(the even indexed rows are kept)
A = zeros(size(A2,1)/2, size(A2,2));
D_hor = zeros(size(D2,1)/2, size(D2,2));
n2 = 1;
for i = 2:2:size(A2, 1)
    A(n2,:) = A2(i,:);
    D_hor(n2,:) = D2(i,:);
    n2 = n2+1;
end

% Convolve the columns for vertical and diagonal details
D3 = zeros(size(D1));
D4 = zeros(size(D1));
for i = 1:size(D1, 2)
    D3(:,i) = pconv(h, D1(:,i)');
    D4(:,i) = pconv(g, D1(:,i)');
end

% Downsampling rows(the even indexed rows are kept)
D_ver = zeros(size(D3,1)/2, size(D3,2));
D_dia = zeros(size(D4,1)/2, size(D4,2));
n3 = 1;
for i = 2:2:size(D3, 1)
    D_ver(n3,:) = D3(i,:);
    D_dia(n3,:) = D4(i,:);
    n3 = n3+1;
end

coef = {A, D_hor, D_ver, D_dia};
end

