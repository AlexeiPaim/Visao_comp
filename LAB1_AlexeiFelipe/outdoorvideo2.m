clear 
clc
close all


% carrega arquivo do vıdeo de entrada
 video_entrada = VideoReader('video_saida.avi'); %% É O video produzido no item 1
 

 % cria arquivo do vıdeo de saıda
 video_saida2 = VideoWriter('video_saida2.avi');
 video_saida2.FrameRate = video_entrada.FrameRate;
 open(video_saida2);
 

 % Processamento dos quadros
 while hasFrame(video_entrada)    
     
% Obtem quadro (imagem) atual do video de entrada
frame_entrada = readFrame(video_entrada,'native');
 
%Carrega o arquivo de imagem outdoor
outdoor = imread('outdoor.jpg');

outdoor =im2double(outdoor); %Converte para tipo double


%% Etapa de transformação geométricas - Homografia planar 


% Os quatro pontos na imagen que ira passar pela homografia planar
u = [0;1280;1280;0];
v =[0;0;720;720];

% Pontos de saida para a homografia planar (obtido no outdoor)
u2 =[129;522;537;1.220000000000000e+02];
v2 =[64;160;364;326];


A= [u(1,1), v(1,1), 1, 0, 0, 0,(-u2(1,1)* u(1,1)), (-u2(1,1)* v(1,1));
    0, 0, 0, u(1,1), v(1,1), 1, (-v2(1,1)* u(1,1)), (-v2(1,1)* v(1,1));
    u(2,1), v(2,1), 1, 0, 0, 0, (-u2(2,1)* u(2,1)), (-u2(1,1)* v(2,1));
     0, 0, 0, u(2,1), v(2,1), 1, (-v2(2,1)* u(2,1)), (-v2(2,1)* v(2,1));
     u(3,1), v(3,1), 1, 0, 0, 0,(-u2(3,1)* u(3,1)), (-u2(3,1)* v(3,1));
    0, 0, 0, u(3,1), v(3,1), 1, (-v2(3,1)* u(3,1)), (-v2(3,1)* v(3,1));
    u(4,1), v(4,1), 1, 0, 0, 0, (-u2(4,1)* u(4,1)), (-u2(4,1)* v(4,1));
     0, 0, 0, u(4,1), v(4,1), 1, (-v2(4,1)* u(4,1)), (-v2(4,1)* v(4,1));];
 
 
 B = [u2(1,1);
      v2(1,1);
      u2(2,1);
      v2(2,1);
      u2(3,1);
      v2(3,1);
      u2(4,1);
      v2(4,1);];
  
  H = inv(A) *B;
  
  T = [ H(1,1), H(2,1), H(3,1);
        H(4,1), H(5,1), H(6,1);
        H(7,1), H(8,1), 1;];
  
  
 tform = projective2d(T.');
 [I3, ref] = imwarp( frame_entrada, tform);
 
 [x,y,r] = size(I3); %Tamanho da imagem de saida da homografia planar

%%

I3 =im2double(I3); %Converte para tipo double

I5 = 0; % zera a variavel para o proximo loop

%Transforma a parte preta em branca, na imagen de tranformação de homografia
%planar

    for v = 1:size(I3,1)
        for u = 1:size(I3,2)
            I5(v,u) = (I3(v,u,1) == 0 & I3(v,u,2) == 0 & I3(v,u,3) == 0);
        end
     end

    
I5 = I3+I5; %Monta a imagem a ser posicionada no outdoor



 %insere a imagens processada na posiçao especificada
 %posiçoes ajeitadas para melhor enquadramento
 outdoor(64:(63+x),122:(121+y),:) = outdoor(64:(63+x),122:(121+y),:).*I5 ;
  
outdoor = uint8(outdoor*255);%Converte para tipo uint8
  
 % Escreve imagem processada no vıdeo de sa´ıda
 writeVideo(video_saida2,outdoor);
 end

 % Finaliza e salva o v´ıdeo de sa´ıda
 close(video_saida2);