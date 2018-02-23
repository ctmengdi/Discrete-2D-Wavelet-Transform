% Denoising
img=double(imread('lena256.bmp'));

noisy_img=img+randn(size(img))*10;

h = [0.48296     0.83652     0.22414    -0.12941];
wc = wt_dec_2d_mul_lev(noisy_img,1,h);
%Estimation of the noise level
hf=[wc{1,3} wc{1,4} wc{1,2}];
sigma=median(abs(hf(:)))/0.6745;

threshold=3*sigma;
% Hard thresholding
wc = cell2mat(wc);
wc2 = wc.*((abs(wc)>threshold));

% Soft thresholding
%wc2=(sign(wc).*(abs(wc)-threshold)).*((abs(wc)>threshold));


rec=wt_rec_2d_mul_lev(wc2,1,h);

affiche(rec);truesize;
