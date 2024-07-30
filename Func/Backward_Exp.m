function ObjectRecovery = Backward(y, Pattern,Compressive_ratio, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift, init, LoopN1)

imSize = size(y,1);
imNum = size(y,3);
mag = Compressive_ratio;
ObjectRecovery = init;
y = single(y);

for loopnum=1:LoopN1
    ObjectRecoveryProp=propTF_GPU(ObjectRecovery,pixelSize,waveLength,z_d1);
    for tt=1:imNum  
%         disp([loopnum tt]);
        patternshift=subpixelshift3GPU(Pattern,-x_shift(tt,1)*mag,-y_shift(tt,1)*mag);
        Pattern_plane = ObjectRecoveryProp.*patternshift;
        CCD_plane = propTF_GPU(Pattern_plane,pixelSize,waveLength,z_d2);
        
        CCD_planeIntensity=abs(CCD_plane).^2;
        CCD_planeIntensityDown=gpuArray(zeros(imSize,imSize,'single'));
        for ii=1:mag
            for jj=1:mag
                CCD_planeIntensityDown=CCD_planeIntensityDown+CCD_planeIntensity(ii:mag:end,jj:mag:end);
            end
        end
        CCD_planeAmpDown=sqrt(CCD_planeIntensityDown);
        CCD_plane_new=gpuArray(zeros(imSize*mag,imSize*mag,'single'));
        for iii=1:mag
            for jjj=1:mag
                CCD_plane_new(iii:mag:end,jjj:mag:end)=sqrt(y(:,:,tt)).*CCD_plane(iii:mag:end,jjj:mag:end)./CCD_planeAmpDown;
            end
        end
        
        Pattern_plane_new = propTF_GPU(CCD_plane_new,pixelSize,waveLength,-z_d2);
        ObjectRecoveryProp = ObjectRecoveryProp + conj(patternshift).*(Pattern_plane_new-Pattern_plane)./(max(max(abs(patternshift).^2)));
    end
    ObjectRecovery=propTF_GPU(ObjectRecoveryProp,pixelSize,waveLength,-z_d1);
      
    
end

end