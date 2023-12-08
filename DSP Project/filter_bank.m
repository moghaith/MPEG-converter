function opAudio = filter_bank()
    % Read audio file
    % Read the shared audio file
    [audio, Fs] = audioread('/egaudio.wav');

    % Construct filter coefficients matrix using the shared "filters.txt"
    filter_coefficients = dlmread('/MPEG-converter/DSP Project/filters.txt');
    impulse_response = zeros(1, 512);
    % Construct impulse response matrix from equation h_k[n] = h[n] * cos((k+0.5)(n-15)pi/32)
    for i = 1:32
        impulse_response = impulse_response + filter_coefficients(i, :) .* cos((i-1+0.5) .* (0:511-15) .* pi ./ 32);
    end
    plot(impulse_response);
    % Apply filter to audio
    opAudio = zeros(1, 512);
    for i = 1:512
        opAudio(i) = sum(audio(i:i+511) .* impulse_response);
    end
    % Write audio to file
    audiowrite('/MATLAB Drive/Repositories/MPEG-converter/DSP Project/egaudio_op.wav', opAudio, Fs);
end