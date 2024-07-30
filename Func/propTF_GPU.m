function [H2outGPU] = propTF_GPU(imGPU,psize,wlength,z)
%=========input GPU=============
%=========output GPU============
% propagation - transfer function approach
% assumes same x and y side lengths and
% uniform sampling
% u1 - source plane field
% L - source and observation plane side length
% lambda - wavelength
% z - propagation distance
% u2 - observation plane field
% im=single(im);%single 1
[M,N]=size(imGPU); %get input field array size
k0=2*pi/wlength;
padnum=round(M/2)+1;padnum=0;
u1pad=imGPU;
[M,N]=size(u1pad);
kmax=pi/psize;%the max wave vector of the OTF
kxm0 = (gpuArray.linspace(-kmax,kmax,N));
kym0= kxm0;%
[kxm,kym]=meshgrid(kxm0,kym0);
kzm=double(sqrt(complex(k0^2-kxm.^2-kym.^2)));
%==========must be double during calculation==========
H2=exp(1i.*z.*real(kzm)).*exp(-abs(z).*abs(imag(kzm))).*((k0^2-kxm.^2-kym.^2)>=0); 
H2=single(H2);
H2outGPU=ifft2(ifftshift(H2.*fftshift(fft2(u1pad))));
end