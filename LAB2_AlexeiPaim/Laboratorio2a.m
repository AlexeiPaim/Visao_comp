
clear;
clc;
close all;
%% Laboratorio 2 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264

%% Começar a seleção pelo canto superior esquerdo

Im = imread('Tatoo1.jpg');

figure; imshow(Im);

cdr = ginput(4); %% pega 4 pontos do a imagem a ser procesada

cdr = floor(cdr);

% a imagem a ser procesada
Is = Im(cdr(1,2):cdr(4,2),cdr(1,1):cdr(2,1),:); 

%  figure; imshow(Is);
 


%% Detecção de borda 

P = rgb2gray(Is);
% figure; imshow(P);

Ku = [-1 0 1; -2 0 2; -1 0 1];
Kv = Ku.';

Iu = filter2(Ku,P,'same');

Iv = filter2(Kv,P,'same');

M = sqrt(Iu.^2 + Iv.^2);

%% tira borada branca
M = imclearborder(M);

M = uint8(M);

% figure; imshow(M);
    

%% Limiarização na imagem de borda

% 
% figure; surf(M);
% title('função surf');

L = 30; % definido pelo projetista

I9 = (M > L);% forma a imagem do tipo logical

% figure; imshow(I9);

[u,v] = find(I9); % Pega os indices ods pixls difrerentes de 0

[y,lixo] = size(u); %pega o tamanho do vetor u que vai ser utlizado para o laço for 

%Abre a imagem cortada para as camada RGB
Rd = Is(:,:,1);
Gr = Is(:,:,2);
Bl = Is(:,:,3);


%% Kernel normalizado
w = 40;
K = 1/(w^2)* ones(w,w);

%% passa todas as camadas RGB pelo filtro Normalizado
R =filter2(K,Rd,'same');
R = uint8(R);

G =filter2(K,Gr,'same');
G= uint8(G);

B =filter2(K,Bl,'same');
B = uint8(B);

%Monta a imagem RGB com o filtro aplicado
I2(:,:,1)= R;
I2(:,:,2)=G; 
I2(:,:,3)=B;

% figure; imshow(I2);
% title('saiu do filtro');


%% Pega a imagem original cortada iguala as posiçoes do da imagem filtrada 
for i = 1:1:y 
    Is(u(i,1),v(i,1),:)= I2(u(i,1),v(i,1),:);  
end


%% Monta a imagem final, atribuindo a imagem processada na posição da iagem original 
T = size(I2); % tamanho da imagem filtarda

Tx = cdr(1,1)+T(1,2);
Ty = T(1,1)+cdr(1,2);
  
aux =Im(cdr(1,2)+1:Ty, cdr(1,1):Tx-1,:); % posicionamento da imagem filtrada 
Im(cdr(1,2)+1:Ty, cdr(1,1):Tx-1,:) = Is;
 

figure; imshow(Im);
title('Imagem Final');

 
 