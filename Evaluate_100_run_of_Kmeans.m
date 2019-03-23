%% evaluate k=2 clustering quality
files = {'RJ93_Phase4_OdorSet2_Day1.mat', 'RJ93_Phase4_OdorSet2_Day12.mat', 'RJ93_Phase4_OdorSet4_Day2.mat', 'RJ93_Phase4_OdorSet4_Day7.mat'};
nsim = 100;
quals = zeros(nsim, length(files));

for j = 1:nsim
    for i = 1:length(files)
        data = importdata(files{i});
        [fdat, vdat] = time_filter(.1, 1.2, data);
        instfreq = hxf(vdat);
        [cidx, ctrs] = kmeans(instfreq, 2);
        [s, f] = eval_cq(cidx, fdat);
        quals(j, i) = f;
    end
end

means = mean(quals, 1);
q = containers.Map(files, means);
disp(keys(q))
disp(values(q))
