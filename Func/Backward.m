function ObjectRecovery = Backward(y, Pattern, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift, init, LoopN1)

imSize = size(y,1);
imNum = size(y,3); 

ObjectRecovery = init;
for loopnum=1:LoopN1
    ObjectRecoveryProp=propTF_GPU(ObjectRecovery,pixelSize,waveLength,z_d1);
    for tt=1:imNum
        patternshift=subpixelshift3GPU(Pattern,-x_shift(tt,1),-y_shift(tt,1));
        Pattern_plane = ObjectRecoveryProp.*patternshift;
        CCD_plane = propTF_GPU(Pattern_plane,pixelSize,waveLength,z_d2);
        CCD_planeIntensity=abs(CCD_plane).^2;
        CCD_planeIntensityDown=gpuArray(zeros(imSize,imSize,'single'));
        CCD_planeIntensityDown=CCD_planeIntensityDown+CCD_planeIntensity;
        CCD_planeAmpDown=sqrt(CCD_planeIntensityDown);
        CCD_plane_new=gpuArray(zeros(imSize,imSize,'single'));
        CCD_plane_new=(y(:,:,tt)).^0.7.*CCD_plane./CCD_planeAmpDown;
        Pattern_plane_new = propTF_GPU(CCD_plane_new,pixelSize,waveLength,-z_d2);
        ObjectRecoveryProp = ObjectRecoveryProp + conj(patternshift).*(Pattern_plane_new-Pattern_plane)./(max(max(abs(patternshift).^2)));
    end
    
    ObjectRecovery=propTF_GPU(ObjectRecoveryProp,pixelSize,waveLength,-z_d1);
    
end
end