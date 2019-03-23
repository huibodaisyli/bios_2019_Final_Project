%% hierarchical clustering methods
% takes hilbert instantaneous frequency
% returns dictionaries of how good each method was
% (to manipulate dictionary, use keys(objectname) and values(objectname)
% once you know what's the best, that can be investigated
function [q, ns] = hcluster(instfreq, data)
    methods = {'average', 'centroid', 'complete', 'median', 'single', 'ward', 'weighted'};
    fracs = zeros(length(methods),1);
    ns = zeros(length(methods),1);
    for i = 1:length(methods)
        z = linkage(instfreq, methods{i});
        c = cluster(z, 'maxclust', 2);
        [s, f, n] = eval_cq(c, data);
        fracs(i) = f;
        ns(i) = n;
    end
    q = containers.Map(methods, fracs);
end