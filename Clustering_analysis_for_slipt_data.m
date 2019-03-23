%% perform clustering analysis and create plot on data set
function split_analyt(file1, file2, oset, lab1, lab2)
    files = {file1, file2};
    fracsg = zeros(7, 2);
    fracsb = zeros(7, 2);

    for filename = 1:length(files)
        data = importdata(files{filename});
        [fdat, vdat] = time_filter(.1, 1.2, data);
        
        [gvolt, bvolt] = split(vdat);
        ifg = hxf(gvolt);
        ifb = hxf(bvolt);
        qg = hcluster(ifg, fdat);
        qb = hcluster(ifb, fdat);

        valsg = values(qg);
        valsb = values(qb);
        for j = 1:length(keys(qg))
            fracsg(j,filename) = valsg{j};
            fracsb(j,filename) = valsb{j};
        end
    end
    
    b = bar(fracsb);
    b(1).FaceColor = [0.3010, 0.7450, 0.9330];
    b(2).FaceColor = [0.6350, 0.0780, 0.1840];
    set(gca,'xticklabel', keys(qb))
    title( {'Quality of Different Clustering Methods between Days; Post-250 ms'; oset} )
    xlabel('Hierarchical Clustering Distance Compuation Method')
    ylabel('Fraction of Correct Labels')
    legend(lab1, lab2)
    figure();
    g = bar(fracsg);
    g(1).FaceColor = [0.3010, 0.7450, 0.9330];
    g(2).FaceColor = [0.6350, 0.0780, 0.1840];
    set(gca,'xticklabel', keys(qg))
    title( {'Quality of Different Clustering Methods between Days; Pre-250 ms'; oset} )
    xlabel('Hierarchical Clustering Distance Compuation Method')
    ylabel('Fraction of Correct Labels')
    legend(lab1, lab2)
    
    disp('fracs g')
    disp(fracsg)
    disp('fracs b')
    disp(fracsb)
end