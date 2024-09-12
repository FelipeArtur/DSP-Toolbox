% Carregar o pacote 'signal' necessário para usar a função findpeaks
pkg load signal;

% Nome do arquivo de áudio gravado
filename = 'Amanda.wav';

% Ler o áudio do arquivo
[data, fs] = audioread(filename);

% Se o áudio for estereofônico, converter para mono
if size(data, 2) > 1
    data = mean(data, 2);
end

% Parâmetros de amostragem
N = length(data);
ts = 1 / fs;   % Intervalo de amostragem

% Vetor de tempo para plotagem
temp = (0:(N-1)) * ts;

% Plot do sinal de áudio no domínio do tempo
figure;
stem(temp, data);
title('Sinal de Áudio no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Realizar a FFT
Y = fft(data);
v_f = (0:(N-1)) * fs / N;

% Magnitude da FFT
mag = abs(Y);
mag = mag / max(mag);

% Remover a média
newMag = mag - mean(mag);

% Plotar o resultado da FFT
figure;
stem(v_f, newMag);
title('Espectro de Frequências (FFT)');
xlabel('Frequência (Hz)');
ylabel('Magnitude (normalizada)');

% Zero-padding, se necessário
if mod(N, 2) ~= 0 || log2(N) ~= floor(log2(N))
    N_pow = 2^nextpow2(N);

    % Aplicar zero-padding
    data_padded = [data; zeros(N_pow - N, 1)];

    % Recalcular a FFT com os dados preenchidos
    Y_padded = fft(data_padded);
    mag_padded = abs(Y_padded) / max(abs(Y_padded));
    mag_padded = mag_padded - mean(mag_padded);

    % Recalcular o vetor de frequências
    v_f_padded = (0:(N_pow-1)) * fs / N_pow;

    % Plotar o resultado da FFT com zero-padding
    figure;
    stem(v_f_padded, mag_padded);
    title('Espectro de Frequências com Zero-Padding');
    xlabel('Frequência (Hz)');
    ylabel('Magnitude (normalizada)');
end

% Limite superior para busca de frequências (500 Hz é razoável para vozes humanas)
limite_freq = 500;

% Índice correspondente ao limite de frequência
indice_limite = find(v_f >= limite_freq, 1);

% Encontrar o índice do primeiro pico significativo
[~, indice_fundamental] = max(mag(1:indice_limite));

% Obter a frequência fundamental correspondente
frequencia_fundamental = v_f(indice_fundamental);

disp(['A frequência fundamental é ', num2str(frequencia_fundamental), ' Hz']);

% Plot para visualizar a frequência fundamental
figure;
stem(v_f(1:indice_limite), newMag(1:indice_limite));
title('Zoom FFT - Frequência Fundamental');
xlabel('Frequência (Hz)');
ylabel('Magnitude (normalizada)');
xlim([0 limite_freq]);

% Encontrar os picos principais com a opção 'DoubleSided'
[pks, locs] = findpeaks(newMag(1:indice_limite), 'MinPeakHeight', 0.1 * max(newMag(1:indice_limite)), 'DoubleSided');

% Frequências correspondentes aos picos
frequencias_principais = v_f(locs);

disp('Frequências principais:');
disp(frequencias_principais);

% Plot do espectro com picos destacados
figure;
plot(v_f, newMag);
hold on;
plot(frequencias_principais, pks, 'ro');  % Destacar os picos em vermelho
xlabel('Frequência (Hz)');
ylabel('Magnitude (normalizada)');
title('Espectro de Frequências do Sinal de Voz');
legend('Espectro', 'Componentes Principais');
hold off;

