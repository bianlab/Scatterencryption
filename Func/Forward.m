function CCD_planeIntensity = Forward(image, Pattern, pixelSize, waveLength,z_d1, z_d2, x_shift, y_shift)

GT_patternplane=propTF_GPU(image,pixelSize,waveLength,z_d1);
for i=1:size(x_shift)
    Diffusershift = subpixelshift3GPU(Pattern,-x_shift(i,1),-y_shift(i,1));
    DiffuserPlane = GT_patternplane .* Diffusershift;
    CCD_plane = propTF_GPU(DiffuserPlane,pixelSize,waveLength,z_d2);
    CCD_planeIntensity(:,:,i) = abs(gather(CCD_plane)).^2; 
end

end