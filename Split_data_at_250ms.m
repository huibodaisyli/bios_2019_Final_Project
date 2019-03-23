%% split trials into \pm 250 ms segments.
function [gvolt, bvolt] = split(vdat)
    sampfreq = 2020; % times per second
    dt = 1/sampfreq; % interval between samples
    thr = .250/dt; % number of steps for 250 ms
    
    gvolt = cell(size(vdat,1),1);
    bvolt = cell(size(vdat,1),1);

    for i = 1:size(vdat,1)
        gvolt{i} = vdat{i}(1:thr-1); % exclusive interval
        bvolt{i} = vdat{i}(thr:end);
    end
end