function opAudio = filter_bank()
    % Read audio file
    % Read the shared audio file
    [y, Fs] = audioread('/egaudio.wav');

    % Construct filter coefficients matrix using the shared "filters.txt"
    filter_coefficients = dlmread('/Users/mohamedghaith/Documents/Uni/DSP/Project/MPEG-converter/DSP Project/filters.txt');
    h_k = zeros(32, 512);
    % Construct impulse response matrix from equation h_k[n] = h[n] * cos((k+0.5)(n-15)pi/32)
    for k = 1:32
        for n = 1:512
            h_k(k, n) = filter_coefficients(k) * cos((k+0.5)*(n-15)*pi/32);
        end
    end
    opAudio = zeros(length(y), 32);
    for k = 1:32
        opAudio(:, k) = filter(h_k(k, :), 1, y);
    end
end