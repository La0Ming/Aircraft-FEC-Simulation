% PSK Simulation %

rng default % Default RNG for reproducible results

modOrder = 2; % Modulation order
snrRange = (0:1:14); % Signal to noise range

numberOfBits = 207900; % Number of bits to be sent
comparisonCeiling = 1e9; % Maximum number of bit comparisons
errorCeiling = 1000; % Maximum number of errors

ricianChan = comm.RicianChannel(); % Fading channel
ricianChan.KFactor = 1000; % Rician K-factor
ricianChan.MaximumDopplerShift = 0; % Static fading

% Reed-Solomon with block size 7 and message size 1
berRSn7k1 = zeros(length(snrRange), 1);
m = 3;
n = 2^m-1;
k = 1;
rsEncoder1 = comm.RSEncoder();
rsEncoder1.BitInput = true;
rsEncoder1.CodewordLength = n;
rsEncoder1.MessageLength = k;
rsDecoder1 = comm.RSDecoder();
rsDecoder1.BitInput = true;
rsDecoder1.CodewordLength = n;
rsDecoder1.MessageLength = k;

% Reed-Solomon with block size 7 and message size 3
berRSn7k3 = zeros(length(snrRange), 1);
k = 3;
rsEncoder2 = comm.RSEncoder();
rsEncoder2.BitInput = true;
rsEncoder2.CodewordLength = n;
rsEncoder2.MessageLength = k;
rsDecoder2 = comm.RSDecoder();
rsDecoder2.BitInput = true;
rsDecoder2.CodewordLength = n;
rsDecoder2.MessageLength = k;

% Reed-Solomon with block size 7 and message size 5
berRSn7k5 = zeros(length(snrRange), 1);
k = 5;
rsEncoder3 = comm.RSEncoder();
rsEncoder3.BitInput = true;
rsEncoder3.CodewordLength = n;
rsEncoder3.MessageLength = k;
rsDecoder3 = comm.RSDecoder();
rsDecoder3.BitInput = true;
rsDecoder3.CodewordLength = n;
rsDecoder3.MessageLength = k;

% Simulate transmissions
for i = 1:length(snrRange)
    snr = snrRange(i);

    % RS(7,1)
    errorStats1 = zeros(3,1); % Error rate calculation results
    errorRateCalculator1 = comm.ErrorRate;
    while errorStats1(2) <= errorCeiling && errorStats1(3) < comparisonCeiling
        data = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        rsCode1 = rsEncoder1(data); % Encode the data
        rsModulated1 = pskmod(rsCode1, modOrder, InputType='bit'); % Modulate the code
        fadedSignal1 = ricianChan(rsModulated1);
        rxSigMod = awgn(fadedSignal1, snr); % Add noise
        rxSigDemod = pskdemod(rxSigMod, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded = rsDecoder1(rxSigDemod); % Decode the code
        errorStats1 = errorRateCalculator1(data, rxDataDecoded); % Calculate error rate
    end
    berRSn7k1(i) = errorStats1(1); % Store BER

    % RS(7,3)
    errorStats2 = zeros(3,1); % Error rate calculation results
    errorRateCalculator2 = comm.ErrorRate;
    while errorStats2(2) <= errorCeiling && errorStats2(3) < comparisonCeiling
        data = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        rsCode2 = rsEncoder2(data); % Encode the data
        rsModulated2 = pskmod(rsCode2, modOrder, InputType='bit'); % Modulate the code
        fadedSignal2 = ricianChan(rsModulated2);
        rxSigMod = awgn(fadedSignal2, snr); % Add noise
        rxSigDemod = pskdemod(rxSigMod, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded = rsDecoder2(rxSigDemod); % Decode the code
        errorStats2 = errorRateCalculator2(data, rxDataDecoded); % Calculate error rate
    end
    berRSn7k3(i) = errorStats2(1); % Store BER

    % RS(7,5)
    errorStats3 = zeros(3,1); % Error rate calculation results
    errorRateCalculator3 = comm.ErrorRate;
    while errorStats3(2) <= errorCeiling && errorStats3(3) < comparisonCeiling
        data = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        rsCode3 = rsEncoder3(data); % Encode the data
        rsModulated3 = pskmod(rsCode3, modOrder, InputType='bit'); % Modulate the code
        fadedSignal3 = ricianChan(rsModulated3);
        rxSigMod = awgn(fadedSignal3, snr); % Add noise
        rxSigDemod = pskdemod(rxSigMod, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded = rsDecoder3(rxSigDemod); % Decode the code
        errorStats3 = errorRateCalculator3(data, rxDataDecoded); % Calculate error rate
    end
    berRSn7k5(i) = errorStats3(1); % Store BER
end

% Plot
semilogy(snrRange, berRSn7k1, 'r', ...
    snrRange, berRSn7k3, 'r--', ...
    snrRange, berRSn7k5, 'r:');
legend('RS(7,1)', ...
    'RS(7,3)', ...
    'RS(7,5)');
fontsize(14,"points");
xlabel("SNR (dB)");
ylabel("BER");
title("RS(7,k) BER in fading channel");
subtitle({append('Modulation: ', num2str(modOrder), '-PSK'), ...
    append('Channel model: Rician fading (K=', num2str(ricianChan.KFactor), ')')});
grid on;