function Rec = HybridDecryption(y, Pattern, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift,theta1,theta2)
vl_setupnn;

IterNum_initial = 10;                             % initial iteration 
IterNum_GAP = 5;                                  % GAP iteration  
lambda_gap = 1e-4;                                % weight coefficient 
denoiser = 'ffdnet';                              % FFDNet denoising
load('FFDNet_gray');
para_ffdnet.net = vl_simplenn_tidy(net);
para_ffdnet.useGPU = true;                        % using GPU to denoise
if para_ffdnet.useGPU
    para_ffdnet.net = vl_simplenn_move(para_ffdnet.net, 'gpu') ;
end
para_ffdnet.ffdnetvnorm_init = true; 
para_ffdnet.ffdnetvnorm = true; 

 
% Initialization
imSize = size(y,1); %image size
imNum = size(y,3); %image number

imInitial_objpad=imresize(real(sqrt(mean(y,3))),[imSize imSize]);
Rec = Backward(y, Pattern, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift,imInitial_objpad, IterNum_initial);

% GAP optimization (FFDNET denoising)
for isig = 1:IterNum_GAP   
    yb = Forward(Rec, Pattern, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift);
	y_new = (y-lambda_gap*yb);
    Rec_new = Backward(y_new, Pattern, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift, Rec, 1);     
	Rec =  Rec_new+lambda_gap*Rec; 
        
    phi_Uo=angle(Rec);
    amp_Uo=abs(Rec);
    para_ffdnet.sigma =theta1;   % Phase denoising degree
    phi_Uo=ffdnet_denoise(phi_Uo,para_ffdnet);
    para_ffdnet1 = para_ffdnet;
    para_ffdnet1.sigma = theta2;  % Amplitue denoising degree
    amp_Uo=ffdnet_denoise(amp_Uo,para_ffdnet1);     
    Rec = amp_Uo.*exp(1j*phi_Uo);
 
end
end





