clear 
clc
close all

% Leitura de Imagem, conversão para  em esacala de cinza e para o tipo Double 
I1 = im2double(rgb2gray(imread('left.png')));%
I2 = im2double(rgb2gray(imread('right.png')));
% 
% figure; subplot(1, 2, 1 ); imshow(I1);title('Esquerda');
% subplot(1, 2, 2 ); imshow(I2);title('Direita') 

dmin = 10;
dmax = 60;
wind = 7;

% figure; imshow(I2);
%
% figure;stdisp(I1,I2)

%chamada para a função disparidade
[Is] = f_disparidade(I1,I2,dmin,dmax,wind);
figure; imagesc(Is); colormap gray; colorbar;

