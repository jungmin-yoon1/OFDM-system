clc; clear all; close all;

%% BPSK
%random [0,1] 범위의 정수를 8개 생성
sample=8;
modOrder=2;
tx=randi([0 modOrder-1],1,sample);

%pskmod를 이용하여 BPSK signal 생성
tx_mod=pskmod(tx,modOrder,0); 

%% Serial to Parallel
tx_mod=tx_mod';
figure; hold on; box on;
plot(real(tx_mod'),imag(tx_mod'),'.');
xlabel('In-Phase'); ylabel('Quadrature')
grid on;
axis([-1.5 1.5 -1.5 1.5])

%% IFFT
tx_ifft=ifft(tx_mod)*sqrt(sample);

figure; hold on; box on
subplot(2,1,1); stem(tx_mod','Linewidth',2); grid on;xlabel('Sample in Freq,'); ylabel('Value'); title('BPSK Symbols'); ylim([-2 2])
subplot(2,1,2); plot(abs(tx_ifft'),'r-','Linewidth',2); grid on; xlabel('Sample in Time');ylabel('Value');title('Symbols After IFFT(amplitude)');

%% Parallel to Serial
tx_ofdm=tx_ifft';
%% PAPR Check

max_pow=max((abs(tx_ofdm)).^2);
mean_pow=mean((abs(tx_ofdm)).^2);
PAPR=10+log10(max_pow/mean_pow); %dB 값

%% Receiver

%% Serial to Parallel
rx_ofdm=tx_ofdm';

%% FFT
rx_fft=fft(rx_ofdm)/sqrt(sample);
figure; hold on; box on;
stem(real(tx_mod'),'o','Linewidth',2)
stem(real(rx_fft'),'--x','Linewidth',2)
xlabel('Sample'); ylabel('Value');
legend('Before IFFT','Ater FFT')
grid on;

%% Parallel to Serial
rx_fft=rx_fft';

%% BPSK demodulation
rx=pskdemod(rx_fft,modOrder,0);

%% Check Symbol
x=[1:sample];
figure; hold on;
stem(x,tx,'o','Linewidth',2);
stem(x,rx,'--x','Linewidth',2);
grid on;
xlabel('index')
ylabel('Value')
legend('TX Bits','RX Bits')
ylim([0 1.5])









