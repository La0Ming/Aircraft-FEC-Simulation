% PSK Simulation %

rng default % Default RNG for reproducible results

modOrder = 2; % Modulation order
snrRange = (0:1:14); % Signal to noise range

numberOfBits = 207900; % Number of bits to be sent
comparisonCeiling = 1e9; % Maximum number of bit comparisons
errorCeiling = 1000; % Maximum number of errors

% BCH with block size 15 and message size 5
berBCHn15k5 = zeros(length(snrRange), 1);
m = 4;
n = 2^m-1;
k = 5;
bchEncoder1 = comm.BCHEncoder();
bchEncoder1.CodewordLength = n;
bchEncoder1.MessageLength = k;
bchDecoder1 = comm.BCHDecoder();
bchDecoder1.CodewordLength = n;
bchDecoder1.MessageLength = k;

% BCH with block size 15 and message size 7
berBCHn15k7 = zeros(length(snrRange), 1);
k = 7;
bchEncoder2 = comm.BCHEncoder();
bchEncoder2.CodewordLength = n;
bchEncoder2.MessageLength = k;
bchDecoder2 = comm.BCHDecoder();
bchDecoder2.CodewordLength = n;
bchDecoder2.MessageLength = k;

% BCH with block size 15 and message size 11
berBCHn15k11 = zeros(length(snrRange), 1);
k = 11;
bchEncoder3 = comm.BCHEncoder();
bchEncoder3.CodewordLength = n;
bchEncoder3.MessageLength = k;
bchDecoder3 = comm.BCHDecoder();
bchDecoder3.CodewordLength = n;
bchDecoder3.MessageLength = k;

% Simulate transmissions
for i = 1:length(snrRange)
    snr = snrRange(i);

    % BCH(15,5)
    errorStats1 = zeros(3,1); % Error rate calculation results
    errorRateCalculator1 = comm.ErrorRate;
    while errorStats1(2) <= errorCeiling && errorStats1(3) < comparisonCeiling
        data = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        bchCode1 = bchEncoder1(data); % Encode the data
        bchModulated1 = pskmod(bchCode1, modOrder, InputType='bit'); % Modulate the code
        rxSigMod = awgn(bchModulated1, snr); % Add noise
        rxSigDemod = pskdemod(rxSigMod, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded = bchDecoder1(rxSigDemod); % Decode the code
        errorStats1 = errorRateCalculator1(data, rxDataDecoded); % Calculate error rate
    end
    berBCHn15k5(i) = errorStats1(1); % Store BER

    % BCH(15,7)
    errorStats2 = zeros(3,1); % Error rate calculation results
    errorRateCalculator2 = comm.ErrorRate;
    while errorStats2(2) <= errorCeiling && errorStats2(3) < comparisonCeiling
        data = randi([0, 1], numberOfBits, 1); % B
        % inary data to be transmitted
        bchCode2 = bchEncoder2(data); % Encode the data
        bchModulated2 = pskmod(bchCode2, modOrder, InputType='bit'); % Modulate the code
        rxSigMod = awgn(bchModulated2, snr); % Add noise
        rxSigDemod = pskdemod(rxSigMod, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded = bchDecoder2(rxSigDemod); % Decode the code
        errorStats2 = errorRateCalculator2(data, rxDataDecoded); % Calculate error rate
    end
    berBCHn15k7(i) = errorStats2(1); % Store BER

    % BCH(15,11)
    errorStats3 = zeros(3,1); % Error rate calculation results
    errorRateCalculator3 = comm.ErrorRate;
    while errorStats3(2) <= errorCeiling && errorStats3(3) < comparisonCeiling
        data = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        bchCode3 = bchEncoder3(data); % Encode the data
        bchModulated3 = pskmod(bchCode3, modOrder, InputType='bit'); % Modulate the code
        rxSigMod = awgn(bchModulated3, snr); % Add noise
        rxSigDemod = pskdemod(rxSigMod, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded = bchDecoder3(rxSigDemod); % Decode the code
        errorStats3 = errorRateCalculator3(data, rxDataDecoded); % Calculate error rate
    end
    berBCHn15k11(i) = errorStats3(1); % Store BER
end

% Plot
semilogy(snrRange, berBCHn15k5, 'g', ...
    snrRange, berBCHn15k7, 'g--', ...
    snrRange, berBCHn15k11, 'g:');
legend('BCH(15,5)', ...
    'BCH(15,7)', ...
    'BCH(15,11)');
fontsize(14,"points");
xlabel("SNR (dB)");
ylabel("BER");
title("BCH(15,k) BER in AWGN channel");
subtitle({append('Modulation: ', num2str(modOrder), '-PSK'), ...
    'Channel model: AWGN'});
grid on;