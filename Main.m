% Hybrid-driven Decryption Algorithm
clc;clear;close all
vl_setupnn;

%%  [1] System parameters
waveLength = 0.532e-6;   % WaveLength
imNum = 16;              % Number of scattering layer shift
pixelSize = 1.67e-6;     % Camera pixel size
Compressive_ratio = 4;   % Compressive ratio
z_d1 = 5e-2;             % Distance between plaintext to scattering layer
z_d2 = 5e-2;             % Distance between scattering layer to camera
imsize = 512;
load('./ScattererShift/loc_dftpc_XY_16.mat'); % scattering layer shift position

%%  [2] Simulate data
GT = double(imread('./Plaintext/mandril_gray.tif'));
GT = mat2gray(imresize(GT,[imsize,imsize]));
% Generate encoding patterns (amplitude and phase)
Pattern_Amp = imresize(rand(128,128),[imsize,imsize]);Pattern_Pha = imresize(rand(128,128),[imsize,imsize]);
Pattern = Pattern_Amp.*exp(1i.*Pattern_Pha);

% Forward model
y = Forward(GT, Pattern, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift);
% Compressive sampling
y = imresize(y,[512/Compressive_ratio,512/Compressive_ratio]);

%%  [3] Hybrid-driven decryption
% Interpolation
CCD_planeIntensity=imresize(y,[imsize,imsize],'nearest');
Rec = HybridDecryption(CCD_planeIntensity, Pattern, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift,0.02,0.055);

%%  [4] Show results
figure;subplot(131);imshow(GT,[]);title('Plaintext');subplot(132);imshow(abs(Rec),[]);title('DecryptionResult');subplot(133);imshow(y(:,:,1),[]);title('Rawdata example');