%% Laboratorio 3 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
% Parte 2
%realiza a limiarização e deteção do pixel de borda
% f_limiar_pxborda(I)
% Valor do Limiar
% I = imagem de entrada 
% Retorna imagem binaria,Cordenadas u e v


function [Is,u,v] = f_limiar_pxborda(I,L)

I = rgb2gray(I);

%% Limiarização na imagem de borda


 % definido pelo projetista

Is = (I < L);% forma a imagem do tipo logical

%% Pixels de Borda 

[imlabel, N] = bwlabel(Is);

I2 = (imlabel == 1);

[u, v] = f_pixels_of_edge(I2);

end
 