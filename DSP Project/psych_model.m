% Step 1: Read the input data and store it in an array called 'inputData'
inputData = audioread('/Users/mohamedghaith/Documents/Uni/DSP/Project/MPEG-converter/DSP Project/egaudio.wav');
N = 1024; % for Layer II
n=(0:N);
k=(0:(N/2)-1);
fftinputData = fft(inputData,N);
% Load Signal Spectrum data
loadedData = load('/Users/mohamedghaith/Documents/Uni/DSP/Project/MPEG-converter/DSP Project/Signal_Spectrum.mat'); % Load the data into the variable loadedData
% Access the spectrum data (assuming it's stored in a variable named X)
X = loadedData.Signal_Spectrum; % Replace X with the variable name in your file
plot(abs(X));
xlabel('Frequency Bin');
ylabel('Magnitude');
title('Magnitude Spectrum');
X =X(N/2+1:N);
Lk = zeros(1, N/2); % Initialize an array to store Lk for each spectral line

for k = 1:N/2
    Lk(k) = 96 + 10 * log10((4 / N^2) * abs(X(k))^2 * (8 / 3));
end
figure;
plot(Lk);
xlabel('Frequencies');
ylabel('Lks');
title('Signal Levels');
thresholds = zeros(1, N/2); % Initialize an array to store the thresholds for each spectral line
% Define the frequency range for which you want to calculate the threshold
frequencies = logspace(log10(20), log10(20000), 1000); % Frequency range from 20 Hz to 20 kHz

% Calculate the threshold in quiet using the provided function for each frequency
A = 3.64 * (frequencies / 1000).^(-0.8) - 6.5 * exp(-0.6 * (frequencies / 1000 - 3.3).^2) + (10^-3) * (frequencies / 1000).^4;
% Plot the threshold curve
figure;
semilogx(frequencies, A); % Updated to plot 'thresholds'
xlabel('Frequency (Hz)');
ylabel('Threshold in Quiet (dB)');
title('Threshold in Quiet vs Frequency');
grid on;

% Copy Lk for masking
maskedLk = Lk;

% Compare Lk with the thresholds and mask out values where Lk < thresholds
for idx = 1:length(Lk)
    if Lk(idx) < A(idx)
        maskedLk(idx) = 0; % Masking out inaudible data where Lk < threshold
    end
end

% Plot maskedLk
figure;
plot(maskedLk);
xlabel('Spectral Line');
ylabel('Masked Signal Level');
title('Masked Signal Levels');

