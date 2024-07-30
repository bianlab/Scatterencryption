function output_imageGPU=subpixelshift3GPU(AmplitudeGPU,xshift,yshift)
%====input GPU=======
%====output GPU======
% Amplitude=double(Amplitude);%double 1
[m,n]=size(AmplitudeGPU);
fx = ifftshift(gpuArray.linspace(-floor(n/2),ceil(n/2)-1,m));
fy= fx;
[FX,FY]=meshgrid(fx,fy);
Hs=exp(-1j*2*pi.*(FX.*xshift/n+FY.*yshift/m));
% Hs=double(Hs);%double 2
output_imageGPU=ifft2(fft2(AmplitudeGPU).*Hs);




