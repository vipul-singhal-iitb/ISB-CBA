function [descriptor,pos] = extract_surf(patch,algorithm)
%     options = surfoptions;
%     options.extended = strcmp(algorithm.surf_extended,'true');
    points = detectSURFFeatures(patch,'MetricThreshold',500);
    descriptor = extractFeatures(patch,points,'Method','surf')';
    pos = getfield(points,'Location')';
end

