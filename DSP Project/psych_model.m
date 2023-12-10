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
%% 
%divide input signal into 32 sub-bands
% 32 sub-bands
%%
function masked_range=masking_threshold(spl,masker_freq)

    if spl>0 && spl <=10
        masked_range=masker_freq+ 100;
    elseif spl>10 && spl <=20
        masked_range=masker_freq+ 250;
    elseif spl>20 && spl <=30
        masked_range=masker_freq+ 350;
    elseif spl>30 && spl <=40
        masked_range=masker_freq+ 550;
    elseif spl>40 && spl <=50
        masked_range=masker_freq+ 850;
    elseif spl>50 && spl <=60
        masked_range=masker_freq+ 1200;
    elseif spl>60 && spl <=70
        masked_range=masker_freq+ 2000;
    elseif spl>70 && spl <=80
        masked_range=masker_freq+ 7000;
    elseif spl>80 && spl <=90
        masked_range=masker_freq+ 13000;
    else
       % do nothing  
       masked_range=masker_freq+ 13000;
    end
end

