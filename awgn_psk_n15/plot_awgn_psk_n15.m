% Plot %


% Load the workspaces

% RS plot
load('rs15_awgn_bpsk.mat')
semilogy(snrRange, berRSn15k3, '-', 'Color', [0.4940 0.1840 0.5560]);
hold on;
semilogy(snrRange, berRSn15k5, 'r');
semilogy(snrRange, berRSn15k7, 'g');
semilogy(snrRange, berRSn15k11, 'b');

% BCH plot
load('bch15_awgn_bpsk.mat')
semilogy(snrRange, berBCHn15k5, '-', 'Color', [0.9290 0.6940 0.1250]);
semilogy(snrRange, berBCHn15k7, '-', 'Color', [0.4660 0.6740 0.1880]);
semilogy(snrRange, berBCHn15k11, 'c');

legend('RS(15,3)', ...
    'RS(15,5)', ...
    'RS(15,7)', ...
    'RS(15,11)', ...
    'BCH(15,5)', ...
    'BCH(15,7)', ...
    'BCH(15,11)');
xlim([0 14]);
ylim([1e-6 1]);
fontsize(14,"points");
xlabel("SNR (dB)");
ylabel("BER");
title("Coded BER in AWGN channel");
subtitle({append('Modulation: ', num2str(modOrder), 'PSK'), ...
    'Channel model: AWGN', ...
    'Block length: 15'});
grid on;