% PSK Simulation %

rng default % Default RNG for reproducible results

modOrder = 2; % Modulation order
snrRange = (0:1:14); % Signal to noise range

numberOfBits = 207900; % Number of bits to be sent
comparisonCeiling = 1e9; % Maximum number of bit comparisons
errorCeiling = 1000; % Maximum number of errors

% Reed-Solomon with block size 15 and message size 3
berRSn15k3 = zeros(length(snrRange), 1);
m = 4;
n = 2^m-1;
k = 3;
rsEncoder1 = comm.RSEncoder();
rsEncoder1.BitInput = true;
rsEncoder1.CodewordLength = n;
rsEncoder1.MessageLength = k;
rsDecoder1 = comm.RSDecoder();
rsDecoder1.BitInput = true;
rsDecoder1.CodewordLength = n;
rsDecoder1.MessageLength = k;

% Reed-Solomon with block size 15 and message size 5
berRSn15k5 = zeros(length(snrRange), 1);
k = 5;
rsEncoder2 = comm.RSEncoder();
rsEncoder2.BitInput = true;
rsEncoder2.CodewordLength = n;
rsEncoder2.MessageLength = k;
rsDecoder2 = comm.RSDecoder();
rsDecoder2.BitInput = true;
rsDecoder2.CodewordLength = n;
rsDecoder2.MessageLength = k;

% Reed-Solomon with block size 15 and message size 7
berRSn15k7 = zeros(length(snrRange), 1);
k = 7;
rsEncoder3 = comm.RSEncoder();
rsEncoder3.BitInput = true;
rsEncoder3.CodewordLength = n;
rsEncoder3.MessageLength = k;
rsDecoder3 = comm.RSDecoder();
rsDecoder3.BitInput = true;
rsDecoder3.CodewordLength = n;
rsDecoder3.MessageLength = k;

% Reed-Solomon with block size 15 and message size 11
berRSn15k11 = zeros(length(snrRange), 1);
k = 11;
rsEncoder4 = comm.RSEncoder();
rsEncoder4.BitInput = true;
rsEncoder4.CodewordLength = n;
rsEncoder4.MessageLength = k;
rsDecoder4 = comm.RSDecoder();
rsDecoder4.BitInput = true;
rsDecoder4.CodewordLength = n;
rsDecoder4.MessageLength = k;

% Simulate transmissions
for i = 1:length(snrRange)
    snr = snrRange(i);

    % RS(15,3)
    errorStats1 = zeros(3,1); % Error rate calculation results
    errorRateCalculator1 = comm.ErrorRate;
    while errorStats1(2) <= errorCeiling && errorStats1(3) < comparisonCeiling
        data1 = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        rsCode1 = rsEncoder1(data1); % Encode the data
        rsModulated1 = pskmod(rsCode1, modOrder, InputType='bit'); % Modulate the code
        rxSigMod1 = awgn(rsModulated1, snr); % Add noise
        rxSigDemod1 = pskdemod(rxSigMod1, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded1 = rsDecoder1(rxSigDemod1); % Decode the code
        errorStats1 = errorRateCalculator1(data1, rxDataDecoded1); % Calculate error rate
    end
    berRSn15k3(i) = errorStats1(1); % Store BER

    % RS(15,5)
    errorStats2 = zeros(3,1); % Error rate calculation results
    errorRateCalculator2 = comm.ErrorRate;
    while errorStats2(2) <= errorCeiling && errorStats2(3) < comparisonCeiling
        data2 = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        rsCode2 = rsEncoder2(data2); % Encode the data
        rsModulated2 = pskmod(rsCode2, modOrder, InputType='bit'); % Modulate the code
        rxSigMod2 = awgn(rsModulated2, snr); % Add noise
        rxSigMod2 = pskdemod(rxSigMod2, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded1 = rsDecoder2(rxSigMod2); % Decode the code
        errorStats2 = errorRateCalculator2(data2, rxDataDecoded1); % Calculate error rate
    end
    berRSn15k5(i) = errorStats2(1); % Store BER

    % RS(15,7)
    errorStats3 = zeros(3,1); % Error rate calculation results
    errorRateCalculator3 = comm.ErrorRate;
    while errorStats3(2) <= errorCeiling && errorStats3(3) < comparisonCeiling
        data3 = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        rsCode3 = rsEncoder3(data3); % Encode the data
        rsModulated3 = pskmod(rsCode3, modOrder, InputType='bit'); % Modulate the code
        rxSigMod3 = awgn(rsModulated3, snr); % Add noise
        rxSigMod3 = pskdemod(rxSigMod3, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded1 = rsDecoder3(rxSigMod3); % Decode the code
        errorStats3 = errorRateCalculator3(data3, rxDataDecoded1); % Calculate error rate
    end
    berRSn15k7(i) = errorStats3(1); % Store BER

    % RS(15,11)
    errorStats4 = zeros(3,1); % Error rate calculation results
    errorRateCalculator4 = comm.ErrorRate;
    while errorStats4(2) <= errorCeiling && errorStats4(3) < comparisonCeiling
        data4 = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        rsCode4 = rsEncoder4(data4); % Encode the data
        rsModulated4 = pskmod(rsCode4, modOrder, InputType='bit'); % Modulate the code
        rxSigMod4 = awgn(rsModulated4, snr); % Add noise
        rxSigMod4 = pskdemod(rxSigMod4, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded1 = rsDecoder4(rxSigMod4); % Decode the code
        errorStats4 = errorRateCalculator4(data4, rxDataDecoded1); % Calculate error rate
    end
    berRSn15k11(i) = errorStats4(1); % Store BER
end

% Plot
semilogy(snrRange, berRSn15k3, 'r', ...
    snrRange, berRSn15k5, 'r--', ...
    snrRange, berRSn15k7, 'r:', ...
    snrRange, berRSn15k11, 'r-.');
legend('RS(15,3)', ...
    'RS(15,5)', ...
    'RS(15,7)', ...
    'RS(15,11)');
fontsize(14,"points");
xlabel("SNR (dB)");
ylabel("BER");
title("Reed-Solomon BER in AWGN channel");
subtitle({append('Modulation: ', num2str(modOrder), 'PSK'), ...
    'Channel model: AWGN', ...
    'Block length: 15'});
grid on;