% Hybrid-driven Decryption Algorithm
clc;clear;close all
vl_setupnn;

%%  [1] System parameters
waveLength = 0.53e-6;   % WaveLength
imNum = 16;              % Number of scattering layer shift
Compressive_ratio = 4;   % Compressive ratio
pixelSize = 1.67e-6 / Compressive_ratio;     % Camera pixel size
z_d1 = 0.708e-3;             % Distance between plaintext to scattering layer
z_d2 = 0.682e-3;             % Distance between scattering layer to camera
load('./ExpData/USAF.mat'); % scattering layer shift position
load('./ExpData/CalibratedPattern/Scatterer_pattern_real.mat'); % scattering layer shift position
load('./ExpData/CalibratedPattern/Scatterer_pattern_imag.mat'); % scattering layer shift position
load('./ScattererShift/loc_dftpc_XY_16_Exp.mat')
PatternRecovery = Pattern_real + 1j.*Pattern_imag;
%%  [3] Hybrid-driven decryption
Rec = HybridDecryption_Exp(y, PatternRecovery, Compressive_ratio, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift,0.03,0.35);

%%  [4] Show results
figure;imshow(abs(rot90(Rec,2)),[]);title('DecryptionResult');