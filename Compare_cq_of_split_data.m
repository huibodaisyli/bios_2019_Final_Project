%%bar graph for different splits

bdat = zeros(4, 3);

files = {'RJ93_Phase4_OdorSet2_Day1.mat', 'RJ93_Phase4_OdorSet2_Day12.mat', 'RJ93_Phase4_OdorSet4_Day2.mat', 'RJ93_Phase4_OdorSet4_Day7.mat'};

    for filename = 1:length(files)
        data = importdata(files{filename});
        [fdat, vdat] = time_filter(.1, 1.2, data);
        
        instfreq = hxf(vdat);
        q = hcluster(instfreq, fdat);
        vals = values(q);
        temp = zeros(length(vals),1);
        for i=1:length(vals)
            temp(i) = vals{i};
        end
        bdat(filename,1) = max(temp);
        
        [gvolt, bvolt] = split(vdat);
        ifg = hxf(gvolt);
        ifb = hxf(bvolt);
        qg = hcluster(ifg, fdat);
        qb = hcluster(ifb, fdat);

        valsg = values(qg);
        valsb = values(qb);
        tempg = zeros(length(vals),1);
        tempb = zeros(length(vals),1);

        for i=1:length(valsg)
            tempg(i) = valsg{i};
            tempb(i) = valsb{i};
        end
        bdat(filename, 2) = max(tempg);
        bdat(filename, 3) = max(tempb);
        
    end
    
    bar(bdat)
    set(gca,'xticklabel', {'Set 2, Day 1', 'Set 2, Day 12','Set 4, Day 2','Set 4, Day 7'})
    title('Comparison of Clustering with Full-Time and Split Data')
    xlabel('Data Set Clustered')
    ylabel('Maximum Fraction of Correct Labels between Methods')
    legend('Full Time Sample', 'Gamma-Dominated (< 250 ms)', 'Beta-Dominated (> 250 ms)', 'location', 'southeast')
    disp(bdat)
    disp(std(bdat,0,2))