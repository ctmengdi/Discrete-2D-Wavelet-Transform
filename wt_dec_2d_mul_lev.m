function [ c ] = wt_dec_2d_mul_lev( img, J, h )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%   Multiple levels Wavelet transform decomposition 
%   Author: Meng Di
%   Date:   07/01/2018

if J <1
    error('Error. The number of level should be greater than 0');
end

if J ==1
    c = wt_dec_2d(img, h);
    a = {c{1,1},c{1,2};c{1,3},c{1,4}};
    a = cell2mat(a);
    imshow(a,[]);
end

if J >1
    c = wt_dec_2d(img, h);
    
    for i = 2:J
        wc = wt_dec_2d(c{1}, h);
        c = [wc,c{2:end}];
        
    end
    
    a = {c{1,1},c{1,2};c{1,3},c{1,4}};
    
    for n = 2:J
        a = cell2mat(a);
        temp = {a,c{1,3*n-1};c{1,3*n},c{1,3*n+1}};
        a = temp;
    end
    
    a = cell2mat(a);
    imshow(a,[]);
    
end
end

