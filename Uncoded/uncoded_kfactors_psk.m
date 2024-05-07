% PSK Simulation %

rng default % Default RNG for reproducible results

modOrder = 2; % Modulation order
snr = 11; % Signal to noise ration

numberOfBits = 207900; % Number of bits to be sent
comparisonCeiling = 1e9; % Maximum number of bit comparisons
errorCeiling = 1000; % Maximum number of errors

kRange = (1:1:2000); % K-factor range

berUncodedFaded = zeros(length(kRange), 1);

% Simulate transmissions
for i = 1:length(kRange)
    ricianChan = comm.RicianChannel(); % Fading channel
    ricianChan.KFactor = kRange(i); % Rician K-factor
    ricianChan.MaximumDopplerShift = 0; % Static fading

    % Uncoded Faded
    errorStats1 = zeros(3,1); % Error rate calculation results
    errorRateCalculator1 = comm.ErrorRate;
    while errorStats1(2) <= errorCeiling && errorStats1(3) < comparisonCeiling
        data1 = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        modulated1 = pskmod(data1, modOrder, InputType='bit'); % Modulate the code
        fadedSignal1 = ricianChan(modulated1);
        rxSigMod1 = awgn(fadedSignal1, snr); % Add noise
        rxSigDemod1 = pskdemod(rxSigMod1, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        errStats1 = errorRateCalculator1(data1, rxSigDemod1); % Calculate error rate
    end
    berUncodedFaded(i) = errStats1(1); % Store BER
end

% Plot
semilogy(kRange, berUncodedFaded, 'k');
legend('Uncoded faded');
ylim([1e-7 1]);
fontsize(14,"points");
xlabel("K-factor");
ylabel("BER");
title("Uncoded BER in fading channel");
subtitle({append('Modulation: ', num2str(modOrder), 'PSK'), ...
    'Channel model: Rician fading', ...
    'SNR: 11 dB'});
grid on;