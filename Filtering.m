function [filtered_data, vdat] = time_filter(thr1, thr2, data)
    filtered_data = data(data.sampdur > thr1 & data.sampdur < thr2,:);
    vdat = cell(size(filtered_data,1),1);
    for i = 1:size(vdat,1)
        subt_off=int16(fix(0.5*2020+filtered_data.sampdur(i)*2020));
        vdat{i}=filtered_data.voltage{i}(0.5*2020:subt_off);
    end
    
%     pad and truncate
    thr = 1818;
    for i = 1:size(vdat,1)
        if size(vdat{i},2) < thr
            dif(i) = thr - size(vdat{i},2);
            vdat{i} = cat(2,vdat{i},zeros(1,dif(i)));
        elseif size(vdat{i},2) > thr
            vdat{i} = vdat{i}(1:thr);
        end
    end
end