clear
close all

% Definir a taxa de amostragem e carregar o arquivo de áudio
fs = 44100; % 44.1 kHz
filename = "audio_original.wav";
[x, fs] = audioread(filename); % Carregar o arquivo de áudio
x = x(:,1); % Para garantir que estamos usando um canal em caso de áudio estéreo

% Especificações dos filtros
ripple = 1; % Ripple máximo na banda de passagem (em dB)
attenuacao = 60; % Atenuação na banda de rejeição (em dB)

% Filtro passa-baixa - 0 a 250 Hz - Graves
dlowfir = designfilt('lowpassfir', ...
    'PassbandFrequency', 250, ...
    'StopbandFrequency', 500, ...
    'StopbandAttenuation', attenuacao, ...
    'PassbandRipple', ripple, ...
    'DesignMethod', 'kaiserwin', ...
    'SampleRate', fs);

% Filtro passa-faixa - 250 a 2000 Hz - Médios
dmidfir = designfilt('bandpassfir', ...
    'StopbandFrequency1', 125, ...
    'PassbandFrequency1', 250, ...
    'PassbandFrequency2', 2000, ...
    'StopbandFrequency2', 4000, ...
    'StopbandAttenuation1', attenuacao, ...
    'PassbandRipple', ripple, ...
    'StopbandAttenuation2', attenuacao, ...
    'DesignMethod', 'kaiserwin', ...
    'SampleRate', fs);

% Filtro passa-alta - 2000 Hz - Agudos
dhighfir = designfilt('highpassfir', ...
    'StopbandFrequency', 1000, ...
    'PassbandFrequency', 2000, ...
    'StopbandAttenuation', attenuacao, ...
    'PassbandRipple', ripple, ...
    'DesignMethod', 'kaiserwin', ...
    'SampleRate', fs);

% Para filtros IIR, podemos usar um design semelhante
dlowiir = designfilt('lowpassiir', ...
    'PassbandFrequency', 250, ...
    'StopbandFrequency', 500, ...
    'PassbandRipple', ripple, ...
    'StopbandAttenuation', attenuacao, ...
    'DesignMethod', 'butter', ...
    'MatchExactly', 'stopband', ...
    'SampleRate', fs);

dmidiir = designfilt('bandpassiir', ...
    'StopbandFrequency1', 125, ...
    'PassbandFrequency1', 250, ...
    'PassbandFrequency2', 2000, ...
    'StopbandFrequency2', 4000, ...
    'PassbandRipple', ripple, ...
    'StopbandAttenuation1', attenuacao, ...
    'StopbandAttenuation2', attenuacao, ...
    'DesignMethod', 'butter', ...
    'MatchExactly', 'stopband', ...
    'SampleRate', fs);

dhighiir = designfilt('highpassiir', ...
    'StopbandFrequency', 1000, ...
    'PassbandFrequency', 2000, ...
    'PassbandRipple', ripple, ...
    'StopbandAttenuation', attenuacao, ...
    'DesignMethod', 'butter', ...
    'MatchExactly', 'stopband', ...
    'SampleRate', fs);

% Aplicar os filtros FIR e IIR ao sinal
filtered_low_fir = filter(dlowfir, x);
filtered_medium_fir = filter(dmidfir, x);
filtered_high_fir = filter(dhighfir, x);

filtered_low_iir = filter(dlowiir, x);
filtered_medium_iir = filter(dmidiir, x);
filtered_high_iir = filter(dhighiir, x);

% Resposta ao Impulso para FIR
impulse_response_low_fir = impz(dlowfir);
impulse_response_medium_fir = impz(dmidfir);
impulse_response_high_fir = impz(dhighfir);

% Resposta ao Impulso para IIR
impulse_response_low_iir = impz(dlowiir);
impulse_response_medium_iir = impz(dmidiir);
impulse_response_high_iir = impz(dhighiir);

% Plotar a resposta ao impulso para FIR
figure;
subplot(3,1,1);
stem(impulse_response_low_fir);
title('Resposta ao Impulso - FIR | Passa-Baixa');

subplot(3,1,2);
stem(impulse_response_medium_fir);
title('Resposta ao Impulso - FIR | Passa-Faixa');

subplot(3,1,3);
stem(impulse_response_high_fir);
title('Resposta ao Impulso - FIR | Passa-Alta');

% Plotar a resposta ao impulso para IIR
figure;
subplot(3,1,1);
stem(impulse_response_low_iir);
title('Resposta ao Impulso - IIR | Passa-Baixa');

subplot(3,1,2);
stem(impulse_response_medium_iir);
title('Resposta ao Impulso - IIR | Passa-Faixa');

subplot(3,1,3);
stem(impulse_response_high_iir);
title('Resposta ao Impulso - IIR | Passa-Alta');

% Plotar o sinal original
figure;
plot(x, 'r');
xlabel('Tempo');
ylabel('Sinal de Áudio');
title('Sinal Original');

% Plotar os sinais filtrados com FIR
figure;
hold on
plot(x, 'r');
plot(filtered_low_fir, 'b');
title('Sinal Filtrado com FIR - Passa-Baixa');
xlabel('Tempo');
ylabel('Sinal de Áudio');
hold off;

figure;
hold on
plot(x, 'r');
plot(filtered_medium_fir, 'b');
title('Sinal Filtrado com FIR - Passa-Faixa');
xlabel('Tempo');
ylabel('Sinal de Áudio');
hold off;

figure;
hold on
plot(x, 'r');
plot(filtered_high_fir, 'b');
title('Sinal Filtrado com FIR - Passa-Alta');
xlabel('Tempo');
ylabel('Sinal de Áudio');
hold off;

% Plotar os sinais filtrados com IIR
figure;
hold on
plot(x, 'r');
plot(filtered_low_iir, 'b');
title('Sinal Filtrado com IIR - Passa-Baixa');
xlabel('Tempo');
ylabel('Sinal de Áudio');
hold off;

figure;
hold on
plot(x, 'r');
plot(filtered_medium_iir, 'b');
title('Sinal Filtrado com IIR - Passa-Faixa');
xlabel('Tempo');
ylabel('Sinal de Áudio');
hold off;

figure;
hold on
plot(x, 'r');
plot(filtered_high_iir, 'b');
title('Sinal Filtrado com IIR - Passa-Alta');
xlabel('Tempo');
ylabel('Sinal de Áudio');
hold off;

% Exportar os sinais filtrados como arquivos de áudio
audiowrite('audio_fir_low.wav', filtered_low_fir, fs);
audiowrite('audio_fir_medium.wav', filtered_medium_fir, fs);
audiowrite('audio_fir_high.wav', filtered_high_fir, fs);

audiowrite('audio_iir_low.wav', filtered_low_iir, fs);
audiowrite('audio_iir_medium.wav', filtered_medium_iir, fs);
audiowrite('audio_iir_high.wav', filtered_high_iir, fs);

% Analisar os filtros
filterAnalyzer(dlowfir);
filterAnalyzer(dmidfir);
filterAnalyzer(dhighfir);
filterAnalyzer(dlowiir);
filterAnalyzer(dmidiir);
filterAnalyzer(dhighiir);
