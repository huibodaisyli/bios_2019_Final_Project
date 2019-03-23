%% evaluate clustering quality
% hilbert only returns n-1 instantaneous frequencies for n data points.
% for now we have just truncated the last point in the original data set..
% assuming they are otherwise the same size
% requires appropriately time-filtered data structure 

function [score, frac, numall] = eval_cq(cidx, data)
    tlab = data.correct(1:end-1)+1; % jank way of making indices into 1s and 2s
    score = 0;
    numall = 0;
    p = perms(unique(cidx));
    plab = zeros(length(cidx),1);
    for i = 1:size(p,1)
        for j = 1:length(cidx)
            plab(j) = p(i, cidx(j));
        end
        score = max(score, sum(tlab == plab));
        frac = score/length(cidx);
        numall = max(numall, sum(plab==1)/length(plab));
    end
end   