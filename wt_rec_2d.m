function [ img ] = wt_rec_2d( coef, h )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   One-level wavelet transform reconstruction
%   Author: Meng Di
%   Date:   07/01/2018

%h = [0.48296     0.83652     0.22414    -0.12941];
% Construction of high-pass filter from the low-pass filter
%g=h.*power(-1*ones(1,length(h)),(0:length(h)-1));
for n=0:length(h)-1,
   g(n+1)=h(n+1)*(-1)^(n+1);
end;
g=g(length(g):-1:1);

% Conditional low and pass filters 
%h = fliplr(filter([1/sqrt(2) 1/sqrt(2)], 1, fliplr(h)));
%g = fliplr(filter([1/sqrt(2) -1/sqrt(2)], 1, fliplr(g)));

% Extract the four components from the coefficient
A = coef{1,1};
D_hor = coef{1,2};
D_ver = coef{1,3};
D_dia = coef{1,4};

% Upsampling rows (insert zeros in the odd indexed rows)
A0 = zeros(size(A,1)*2, size(A,2));
D0 = zeros(size(D_hor,1)*2, size(D_hor,2));
D1 = zeros(size(D_ver,1)*2, size(D_ver,2));
D2 = zeros(size(D_dia,1)*2, size(D_dia,2));
n1 = 1;
for i = 2:2:size(A0,1)
    A0(i,:) = A(n1,:);
    D0(i,:) = D_hor(n1,:);
    D1(i,:) = D_ver(n1,:);
    D2(i,:) = D_dia(n1,:);
    n1 = n1+1;
end

% Convolve the columns with low and high pass filters
A1 = zeros(size(A0));
D3 = zeros(size(D0));
D4 = zeros(size(D1));
D5 = zeros(size(D2));
for i = 1:size(A0, 2)
    A1(:,i) = pconv(h, A0(:,i)');
    D3(:,i) = pconv(g, D0(:,i)');
    D4(:,i) = pconv(h, D1(:,i)');
    D5(:,i) = pconv(g, D2(:,i)');
end

% Reconstruction of the approximation and the detail
A2 = A1 + D3;
D6 = D4 + D5;

% Upsampling columns (insert zeros in the odd indexed columns)
A3 = zeros(size(A2,1), size(A2,2)*2);
D7 = zeros(size(D6,1), size(D6,2)*2);
n2 = 1;
for i = 2:2:size(A3, 2)
    A3(:,i) = A2(:,n2);
    D7(:,i) = D6(:,n2);
    n2 = n2+1;
end

% Convolve the rows with low and high pass filters
A4 = zeros(size(A3));
D8 = zeros(size(D7));
for i = 1:size(A4,1)
    A4(i,:) = pconv(h, A3(i,:));
    D8(i,:) = pconv(g, D7(i,:));
end

% Reconstruction of the original image
img = A4 + D8;
end

