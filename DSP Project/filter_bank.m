function opAudio = filter_bank()
    % Read audio file
    % Read the shared audio file
    [audio, Fs] = audioread('/MATLAB Drive/Repositories/MPEG-converter/DSP Project/egaudio.wav');

    % Construct filter coefficients matrix using the shared "filters.txt"
    filter_coefficients = dlmread('/MATLAB Drive/Repositories/MPEG-converter/DSP Project/filters.txt');
    impulse_response = zeros(1, 512);
    impulse_response(1) = 1;
    filter_bank = zeros(32, 512);
    for i = 1:32
        filter_bank(i, :) = filter(filter_coefficients(i, :), 1, impulse_response);
    end
end