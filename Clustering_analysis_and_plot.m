%% perform clustering analysis and create plot on data set
function cluster_analyt(file1, file2, oset, lab1, lab2)
    files = {file1, file2};
    fracs = zeros(7, 2);

    for filename = 1:length(files)
        data = importdata(files{filename});
        [fdat, vdat] = time_filter(.1, 1.2, data);
        instfreq = hxf(vdat);
        [q, n] = hcluster(instfreq, fdat);
        vals = values(q);
        for j = 1:length(keys(q))
            fracs(j,filename) = vals{j};
        end
        disp(n)
    end
    
    b = bar(fracs);
    b(2).FaceColor = [0.3010, 0.7450, 0.9330];
    b(1).FaceColor = [0.6350, 0.0780, 0.1840];
    set(gca,'xticklabel', keys(q))
    title( {'Quality of Different Clustering Methods between Days'; oset} )
    xlabel('Hierarchical Clustering Distance Compuation Method')
    ylabel('Fraction of Correct Labels')
    legend(lab1, lab2, 'location', 'southeast')
    shg
end