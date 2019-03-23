%% Filter signals longer than 250ms
thrf = 0.25; %threshold = 250ms
duration = data.sampdur;
data_ind = find(duration(:,1)>thrf);
data=data(data_ind,:); %filtered dataset
%% Truncate filtered voltage arrays A: 0-250ms B: 250-900ms
%the voltages between nspkon and nspoff
for i=1:size(data,1)
    subt_on(i) = 0.5*2020;
    subt_off(i) = int16(fix(0.5*2020+data.sampdur(i)*2020));
    vdat{i} = data.voltage{i}(subt_on(i):subt_off(i));
end
%the voltage arrays to be equal length of 900ms
thr = 1818; %correspond to 900ms
for i=1:size(data,1)
    if size(vdat{i},2) < thr
        diff(i) = thr - size(vdat{i},2);
        vdat{i} = cat(2,vdat{i},zeros(1,diff(i)));
    elseif size(vdat{i},2) > thr
        vdat{i}=vdat{i}(1,1:thr);
    end
end
%separate voltage arrays to A and B
thrA = 505; %correspond to 0-250ms
thrB = 1313; %correspond to 250-900ms
vdat_A = cell(1,size(data,1));
vdat_B = cell(1,size(data,1));
for i=1:size(data,1)
    vdat_A{i}=vdat{i}(1,1:thrA);
    vdat_B{i}=vdat{i}(1,thrA+1:1818);
    i=i+1;
end
%% Power Specturm for A and for B
pow_A = cell(1,size(data,1));
pow_B = cell(1,size(data,1));
power_A = cell(1,size(data,1));
power_B = cell(1,size(data,1));
for i=1:size(data,1)
    pow_A{i} = spectrogram(vdat_A{1,i}); %for A
    powerA{i} = pow_A{i}.^2;
    pow_B{i} = spectrogram(vdat_B{1,i}); %for B
    powerB{i} = pow_B{i}.^2;
    i = i+1;
end
%% Filter Band Frequencies: Bandpass 12-120Hz
Fs = 2020;
powerA_filt = cell(1,size(data,1));
powerB_filt = cell(1,size(data,1));
for i=1:size(data,1)
    powerA_filt{i} = bandpass(powerA{i},[12,120],Fs);
    powerB_filt{i} = bandpass(powerB{i},[12,120],Fs);
    i = i+1;
end
%% Calculate the total beta and gamma power
beta_A = cell(1,size(data,1)); beta_B = cell(1,size(data,1));
gamma_A = cell(1,size(data,1)); gamma_B = cell(1,size(data,1));
beta_A_tot = zeros(1,size(data,1)); beta_B_tot = zeros(1,size(data,1));
gamma_A_tot = zeros(1,size(data,1)); gamma_B_tot = zeros(1,size(data,1));
%beta power: total power of all bands smaller than 40Hz
%gamma power: total power of all bands bigger than 40Hz
for i=1:size(data,1)
    beta_A{i} = lowpass(powerA_filt{i},40,Fs);
    beta_A_tot(1,i) = sum(beta_A{i},'all');
    beta_B{i} = lowpass(powerB_filt{i},40,Fs);
    beta_B_tot(1,i) = sum(beta_B{i},'all');
    gamma_A{i} = highpass(powerA_filt{i},40,Fs);
    gamma_A_tot(1,i) = sum(gamma_A{i},'all');
    gamma_B{i} = highpass(powerB_filt{i},40,Fs);
    gamma_B_tot(1,i) = sum(gamma_B{i},'all');
    i = i+1;
end
%% Calculate beta/gamma ratios
ratio_A = zeros(1,size(data,1));
ratio_B = zeros(1,size(data,1));
for i=1:size(data,1)
    ratio_A(1,i) = beta_A_tot(1,i)/gamma_A_tot(1,i); %for A
    ratio_B(1,i) = beta_B_tot(1,i)/gamma_B_tot(1,i); %for B
end
%% Plots of beta/gamma ratios over trials
trial = 1:size(data,1);
ci = data.correct;
c = [ones(length(ci),1), zeros(length(ci),1), ones(length(ci),1)]; %color
for i=1:length(ci)
    if ci(i)==1
        c(i,:) = [1,0,0]; % magenta=[1,0,1]; red=[1,0,0]
    elseif ci(i)==0
        c(i,:) = [0,0,1]; % cyan=[0,1,1]; blue=[0,0,1]
    end
    i = i+1;
end
sz = 10; %size of scatter point
%dots colored according to accuracy
%For A
figure(1)
scatter(trial,ratio_A,sz,c,'filled') %warning: imaginary parts ignored
xlabel('Trial Number')
ylabel('Beta/Gamma Ratio')
title('Ratio over each trials: for section A')
%For B
%ratio_out = ratio_B(ratio_B ~= max(ratio_B));
figure(2)
scatter(trial,ratio_B,sz,c,'filled') %warning: imaginary parts ignored
xlabel('Trial Number')
ylabel('Beta/Gamma Ratio')
ylim([3.2 4])
title('Ratio over each trials: for section B')
%% Statistics
mean_A = mean(ratio_A);
mean_B = mean(ratio_B);
max_A = max(ratio_A);
max_B = max(ratio_B);
min_A = min(ratio_A);
min_B = min(ratio_B);
range_A = range(ratio_A);
range_B = range(ratio_B);
median_A = median(ratio_A);
median_B = median(ratio_A);