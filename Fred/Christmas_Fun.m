clc; clear; close all;

Fs = 11025;
Q = 50;
Fs_up = Fs * Q;
BW = 5512.5;
fc1 = 20000;
fc2 = 40000;

playChristmasJingle(Fs);

[x, Fs_actual] = audioread('makeday.wav');
if Fs_actual ~= Fs
    error('makeday.wav must be sampled at 11025 Hz');
end

plotSpectrum(x, Fs, 'Original Audio Spectrum');

x_up = resample(x, Q, 1);
t_up = (0:length(x_up)-1)' / Fs_up;

plotSpectrum(x_up, Fs_up, 'Upsampled Audio Spectrum');

carrier1 = cos(2*pi*fc1*t_up);
x_mod = x_up .* carrier1;

plotSpectrum(x_mod, Fs_up, 'DSB-SC Modulated Signal (20 kHz)');

x_demod = x_mod .* carrier1;

plotSpectrum(x_demod, Fs_up, 'Demodulated Signal (Before Filtering)');

lpFilt = designfilt('lowpassiir', 'FilterOrder', 8, ...
    'PassbandFrequency', BW, 'PassbandRipple', 0.2, ...
    'SampleRate', Fs_up);
x_filt = filtfilt(lpFilt, x_demod);

plotSpectrum(x_filt, Fs_up, 'Filtered Demodulated Signal');

x_rec = resample(x_filt, 1, Q);

audiowrite('recovered_makeday.wav', x_rec, Fs);
disp('Playing recovered audio from Part I...');
sound(x_rec, Fs);
pause(length(x_rec)/Fs + 1);

load('modulated_signal.mat');
y = y(:);
t = (0:length(y)-1)' / Fs_up;

plotSpectrum(y, Fs_up, 'Modulated Signal with Two Channels');

bp1 = designfilt('bandpassiir', 'FilterOrder', 10, ...
    'HalfPowerFrequency1', fc1 - BW/2, ...
    'HalfPowerFrequency2', fc1 + BW/2, ...
    'SampleRate', Fs_up);
bp2 = designfilt('bandpassiir', 'FilterOrder', 10, ...
    'HalfPowerFrequency1', fc2 - BW/2, ...
    'HalfPowerFrequency2', fc2 + BW/2, ...
    'SampleRate', Fs_up);

y1 = filtfilt(bp1, y); y1 = y1(:);
y2 = filtfilt(bp2, y); y2 = y2(:);

plotSpectrum(y1, Fs_up, 'Filtered Channel 1 (20 kHz)');
plotSpectrum(y2, Fs_up, 'Filtered Channel 2 (40 kHz)');

carrier1 = cos(2*pi*fc1*t);
carrier2 = cos(2*pi*fc2*t);

minLen1 = min(length(y1), length(carrier1));
minLen2 = min(length(y2), length(carrier2));

demod1 = y1(1:minLen1) .* carrier1(1:minLen1);
demod2 = y2(1:minLen2) .* carrier2(1:minLen2);

plotSpectrum(demod1, Fs_up, 'Demodulated Channel 1 (Before Filtering)');
plotSpectrum(demod2, Fs_up, 'Demodulated Channel 2 (Before Filtering)');

x1 = filtfilt(lpFilt, demod1);
x2 = filtfilt(lpFilt, demod2);

plotSpectrum(x1, Fs_up, 'Recovered Audio - Channel 1');
plotSpectrum(x2, Fs_up, 'Recovered Audio - Channel 2');

x1_rec = resample(x1, 1, Q);
x2_rec = resample(x2, 1, Q);

audiowrite('recovered_ch1.wav', x1_rec, Fs);
audiowrite('recovered_ch2.wav', x2_rec, Fs);

disp('Playing Channel 1 (20 kHz)...');
sound(x1_rec, Fs);
pause(length(x1_rec)/Fs + 1);

disp('Playing Channel 2 (40 kHz)...');
sound(x2_rec, Fs);

function plotSpectrum(x, fs, title_str)
    N = length(x);
    f = linspace(-fs/2, fs/2, N);
    X = abs(fftshift(fft(x)));
    figure;
    plot(f, X);
    grid on;
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title(title_str);
    xlim([-fs/2, fs/2]);
end

function playChristmasJingle(Fs)
    notes = [659, 659, 659, 659, 659, 659, 659, 784, 523, 587, 659];
    durations = [0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 1];
    song = [];
    for i = 1:length(notes)
        t = 0:1/Fs:durations(i);
        tone = 0.3 * sin(2*pi*notes(i)*t);
        pauseBetween = zeros(1, round(Fs*0.05));
        song = [song, tone, pauseBetween];
    end
    sound(song, Fs);
    pause(length(song)/Fs + 0.5);
end
