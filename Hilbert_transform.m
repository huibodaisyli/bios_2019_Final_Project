%% do the hilbert.
function [instfreq] = hxf(vdat)

    Hilbert=zeros(size(vdat,1),size(vdat{1}, 2));
    for i = 1:size(vdat,1)

        Hilbert(i,:) = hilbert(vdat{i});

    end

    %%convert instantaneous phase to frequency
    instfreq = 2020/(2*pi)*diff(unwrap(angle(Hilbert)));
end