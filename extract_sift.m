function [feature,pos] = extract_sift(patch,algorithm)
    magnif = 5;
    binsize     = str2num(algorithm.sift_binsize);
    step        = str2num(algorithm.sift_step);
    smooth      = strcmp(algorithm.sift_smooth,'true');
    I = single(patch);
    if(smooth)
        delta = sqrt(0.5^2-0.25);
        Is = vl_imsmooth(I, delta);
    else
        Is = single(imsharpen(I,1,0.8));
    end
    
    [pos,feature] = vl_dsift(Is,'size',binsize,'step',step,'fast','FloatDescriptors');
    
end