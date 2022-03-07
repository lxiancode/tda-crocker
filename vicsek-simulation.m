
numSamples = 100;

eta=[0.01,0.02,0.03,0.05, 0.1, 0.19, 0.2, 0.21, 0.3, 0.5, 1, 1.5, 1.9, 1.99, 2];
for j=1:length(eta)
    %parfor i = 1:numSamples
    for i = 1:numSamples
        disp(['Currently running sample ',sprintf('%03d',i),' of ',sprintf('%03d',numSamples), ' for eta=', num2str(eta(j))]);
        outfile = ['../Data/eta=', num2str(eta(j)),'/data',sprintf('%03d',i),'.csv'];
        vicsek(eta(j),outfile);
    end
end
