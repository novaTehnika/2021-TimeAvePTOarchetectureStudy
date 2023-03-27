% this script finds the highest producing sea states on an yearly based by
% accounting for the probability of occurance

percentile = 0.5; % percentile for set of sea states to meet
nSS = length(Tp);
nRandNums = 10;

PP_peak = max(PP_w_data,[],2)';
PP_peakWeighted = weight/100.*PP_peak;
[PP_sorted, I_sorted] = sort(PP_peakWeighted);

lowerPercentileIndex = ceil(percentile*nSS);
selection = randomSelection(I_sorted(lowerPercentileIndex:end),nRandNums)

figure
scatter(1:nSS,PP_peak/max(PP_peak))
hold on
scatter(1:nSS,PP_peakWeighted/max(PP_peakWeighted))
xlabel('sea state index')
ylabel('normalized quantity')
legend('optimal power absorption','weighted optimal power absorption')

figure
plot(1:nSS,PP_peak/max(PP_peak),'-xk')
hold on
plot(1:nSS,PP_peakWeighted/max(PP_peakWeighted),'-xr')
xlabel('sea state index')
ylabel('normalized quantity')
legend('optimal power absorption','weighted optimal power absorption')
xlim([1 nSS])

cum_PP_sorted = cumtrapz(PP_sorted);

figure
plot(PP_sorted/max(PP_sorted))
hold on
plot(cum_PP_sorted/max(cum_PP_sorted))



function randNums = randomSelection(numSet,nRandNums)
    randNums = [];
    nNums = length(numSet);
    
    for i = 1:nRandNums
        % pick random number for set
        numSetIndex = floor(rand*nNums+1);
        randNums = cat(1,randNums,numSet(numSetIndex));
        
        % remove picked number from set
        numSet(numSetIndex) = [];
        nNums = length(numSet);
    
    end
end