clear 
clc
close all

% carrega arquivo do vıdeos de entrada

video_porta = VideoReader('Chromakey.mp4');
video_nuvem = VideoReader('Clouds.mp4');


 % cria arquivo do v´ıdeo de sa´ıda
 video_saida = VideoWriter('video_saida.avi');
 video_saida.FrameRate = video_porta.FrameRate;
 open(video_saida);
 
 % Processamento
 while hasFrame(video_porta)

% Obtem quadro (imagem) atual dos videos de entrada
frame_porta = readFrame(video_porta,'native');
frame_nuvem = readFrame(video_nuvem,'native');

%Converte os quadros para o tipo Double
frame_porta = im2double(frame_porta);
frame_nuvem = im2double(frame_nuvem);

%Transforma imgem RGB para o espaço de cores CIELAB
Ic = rgb2lab(frame_porta); 

%% Processo de Limiarizaçao

%Cor de referencia obtida previamente 
rf = 79.108157927607340;
gf = -40.028273578050275;
bf = -1.813300413775920;

%Espaço RGb
R = Ic(:,:,1);
G = Ic(:,:,2);
B = Ic(:,:,3);

%Distaancia Euclidiana entre o pixel da imagem no espaco CIELAB e a cor de referencia
D = sqrt((R-rf).^2 + (G-gf).^2 + (B-bf).^2);


% limiar definido pelo projetista (obtido com base na função surf)
L = 23;  	

M = D < L;
M =im2double(M);%Converte para tipo double

N = D > L;% O inverso da imagem logica M

%%
%Posiciona as nuvens no fundo verde( que esta branco)
T = frame_nuvem.*M; 

%compoem o frame da porta com o inveso do liliar M
W = frame_porta.*N;

%Monta a imagen de saida 
final= W+(M.*T);

final = uint8(final*255);%Converte para tipo uint8

% Escreve imagem processada no vıdeo de sa´ıda
   writeVideo(video_saida,final);

end

% Finaliza e salva o v´ıdeo de sa´ıda
 close(video_saida);


