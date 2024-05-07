% Plot %


% Load the workspaces

% RS plot
load('rs7_awgn_bpsk.mat')
semilogy(snrRange, berRSn7k1, '-', 'Color', [0.4940 0.1840 0.5560]);
hold on;
semilogy(snrRange, berRSn7k3, 'r');
semilogy(snrRange, berRSn7k5, 'g');

% BCH plot
load('bch7_awgn_bpsk.mat')
semilogy(snrRange, berBCHn7k4, 'Color', [0.9290 0.6940 0.1250]);

legend('RS(7,1)', ...
    'RS(7,3)', ...
    'RS(7,5)', ...
    'BCH(7,4)');
xlim([0 14]);
ylim([1e-6 1]);
fontsize(14,"points");
xlabel("SNR (dB)");
ylabel("BER");
title("Coded BER in AWGN channel");
subtitle({append('Modulation: ', num2str(modOrder), 'PSK'), ...
    'Channel model: AWGN', ...
    'Block length: 7'});
grid on;