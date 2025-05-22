% Generate a Gaussian Random Variable from Samples in a Uniform Distribution
rng('shuffle') % Change to 'shuffle' for differnet results
N = 3000; % Number of Samples

samples = rand(N, 1);

mu = 0; % Gaussian Random Variable Expected Value
sigma = 1; % Gaussian Random Variable Standard Deviation

output = icdf('Normal', samples, mu, sigma);

%figure;
%histogram(samples)
%figure;
histogram(output)
title('Histogram of Gaussian Samples (m = 0, \sigma = 1)')
xlabel('Value')
ylabel('Frequency')

