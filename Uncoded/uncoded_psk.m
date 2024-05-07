% PSK Simulation %

rng default % Default RNG for reproducible results

modOrder = 2; % Modulation order
snrRange = (0:1:20); % Signal to noise range

numberOfBits = 207900; % Number of bits to be sent
comparisonCeiling = 1e9; % Maximum number of bit comparisons
errorCeiling = 1000; % Maximum number of errors

ricianChan1 = comm.RicianChannel(); % Fading channel
ricianChan1.KFactor = 5; % Rician K-factor
ricianChan1.MaximumDopplerShift = 0; % Static fading

% Uncoded with additive white guassian noise
berUncodedAwgn = zeros(length(snrRange), 1);

% Uncoded with fading
berUncodedFaded1 = zeros(length(snrRange), 1);

% Simulate transmissions
for i = 1:length(snrRange)
    snr = snrRange(i);

    % Uncoded AWGN
    errorStats1 = zeros(3,1); % Error rate calculation results
    errorRateCalculator1 = comm.ErrorRate;
    while errorStats1(2) <= errorCeiling && errorStats1(3) < comparisonCeiling
        data1 = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        modulatedAwgn = pskmod(data1, modOrder, InputType='bit'); % Modulate the data
        rxSigMod1 = awgn(modulatedAwgn, snr); % Add noise
        rxSigDemod1 = pskdemod(rxSigMod1, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        errorStats1 = errorRateCalculator1(data1, rxSigDemod1); % Calculate error rate
    end
    berUncodedAwgn(i) = errorStats1(1); % Store BER

    % Uncoded Faded
    errorStats2 = zeros(3,1); % Error rate calculation results
    errorRateCalculator2 = comm.ErrorRate;
    while errorStats2(2) <= errorCeiling && errorStats2(3) < comparisonCeiling
        data2 = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        modulated2 = pskmod(data2, modOrder, InputType='bit'); % Modulate the code
        fadedSignal1 = ricianChan1(modulated2);
        rxSigMod2 = awgn(fadedSignal1, snr); % Add noise
        rxSigDemod2 = pskdemod(rxSigMod2, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        errorStats2 = errorRateCalculator2(data2, rxSigDemod2); % Calculate error rate
    end
    berUncodedFaded1(i) = errorStats2(1); % Store BER
end

% Plot
semilogy(snrRange, berUncodedAwgn, 'm', ...
    snrRange, berUncodedFaded1, 'm-.');
legend('Uncoded AWGN', ...
    append('Uncoded faded K=', num2str(ricianChan1.KFactor)));
fontsize(14,"points");
xlabel("SNR (dB)");
ylabel("BER");
title("Uncoded BER");
subtitle({append('Modulation: ', num2str(modOrder), 'PSK'), ...
    'Channel model: AWGN vs Rician fading'});
grid on;