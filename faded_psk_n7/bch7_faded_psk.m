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
        data1 = randi([0, 1], numberOfBits, 1); % Binary data to be transmitted
        bchCode1 = bchEncoder1(data1); % Encode the data
        bchModulated1 = pskmod(bchCode1, modOrder, InputType='bit'); % Modulate the code
        fadedSignal1 = ricianChan(bchModulated1);
        rxSigMod = awgn(fadedSignal1, snr); % Add noise
        rxSigDemod = pskdemod(rxSigMod, modOrder, ...
            OutputType='bit'); % Demodulate the signal
        rxDataDecoded = bchDecoder1(rxSigDemod); % Decode the code
        errorStats1 = errorRateCalculator1(data1, rxDataDecoded); % Calculate error rate
    end
    berBCHn7k4(i) = errorStats1(1); % Store BER
end

% Plot
semilogy(snrRange, berBCHn7k4, 'g');
xlim([-2 14]);
legend('BCH(7,4)');
fontsize(14,"points");
xlabel("SNR (dB)");
ylabel("BER");
title("BCH(7,k) BER in fading channel");
subtitle({append('Modulation: ', num2str(modOrder), 'PSK'), ...
    append('Channel model: Rician fading (K=', num2str(ricianChan.KFactor),')')});
grid on;