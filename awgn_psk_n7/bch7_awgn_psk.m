% PSK Simulation %

rng default % Default RNG for reproducible results

modOrder = 2; % Modulation order
snrRange = (0:1:14); % Signal to noise range

numberOfBits = 207900; % Number of bits to be sent
comparisonCeiling = 1e9; % Maximum number of bit comparisons
errorCeiling = 1000; % Maximum number of errors

% BCH with block size 7 and message size 4
berBCHn7k4 = zeros(length(snrRange), 1);
m = 3;
n = 2^m-1;
k = 4;
bchEncoder1 = comm.BCHEncoder();
bchEncoder1.CodewordLength = n;
bchEncoder1.MessageLength = k;
bchDecoder1 = comm.BCHDecoder();
bchDecoder1.CodewordLength = n;
bchDecoder1.MessageLength = k;

% Simulate transmissions
for i = 1:length(snrRange)
    snr = snrRange(i);

    % BCH(7,4)
    errorStats1 = zeros(3,1); % Error rate calculation results
    errorRateCalculator1 = comm.ErrorRate;
    while errorStats1(2) <= errorCeiling && errorStats1(3) < comparisonCeiling
        data = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        bchCode1 = bchEncoder1(data); % Encode the data
        bchModulated1 = pskmod(bchCode1, modOrder, InputType='bit'); % Modulate the code
        rxSigMod1 = awgn(bchModulated1, snr); % Add noise
        rxSigDemod1 = pskdemod(rxSigMod1, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded1 = bchDecoder1(rxSigDemod1); % Decode the code
        errorStats1 = errorRateCalculator1(data, rxDataDecoded1); % Calculate error rate
    end
    berBCHn7k4(i) = errorStats1(1); % Store BER
end

% Plot
semilogy(snrRange, berBCHn7k4, 'g');
legend('BCH(7,4)');
fontsize(14,"points");
xlabel("SNR (dB)");
ylabel("BER");
title("BCH(7,k) BER in AWGN channel");
subtitle({append('Modulation: ', num2str(modOrder), '-PSK'), ...
    'Channel model: AWGN'});
grid on;