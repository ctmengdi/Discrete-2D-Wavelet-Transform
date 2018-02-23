function [ img ] = wt_rec_2d_mul_lev( coef, J, h )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%   This function uses wavelet transform to reconstruct the image
%   from coefficients and the low-pass filter with multi-levels
%   Author: Meng Di
%   Date:   07/01/2018

if J <1
    error('Error. The number of level should be greater than 0');
end

if J ==1
    img = wt_rec_2d(coef, h);
    imshow(img,[]);
end

if J > 1
    c = {coef{1:4}};
    a = wt_rec_2d(c, h);
    
    for n = 2:J
        temp = {a,coef{1,3*n-1},coef{1,3*n},coef{1,3*n+1}};
        c = temp;
        a = wt_rec_2d(c, h);
    end
    
    img = a;
    imshow(img,[]);
end
end

