%% Laboratorio 3 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
% Parte 2
%realiza a limiarização e deteção do pixel de borda e obtenção da curva de
%distancia 
% f_limiar_pxborda_cd(I,L)
% Valor do Limiar
% I = imagem de entrada 
% L = Valor do limiar de comparão 
% Retorna imagem binaria,Cordenadas u e v


function [I2,cur_dist1] = f_limiar_pxborda_cd(I,L)

% converte para escala de cinza
I = rgb2gray(I);



%% Limiarização na imagem de borda


% O limiar é fornecido na chamada da função

Is = (I < L);% forma a imagem do tipo logical

% Realiza operaçoes morfologicas  
S =strel('diamond',2);

I2 = imclose(Is,S);
I2 = imdilate(Is,S);


%% Pixels de Borda 

%função disponiblizada pelo professor
%retorna as cordenada dos pixels de borda
[u,v]=f_pixels_of_edge(I2);

%função disponiblizada pelo professor
% Realiza a interpolação dos pontos de bordas obtidos para uma quantidade
% pré determinada
[u2,v2]= f_interpolation(u,v,100);

%% curva de Distancia e angulos 

%função que retorna os momentos
 m00 = mpq( I2,0,0);
 m10 = mpq( I2,1,0);
 m01 = mpq( I2,0,1);
 
 uc = m10/m00;
 vc = m01/m00;
%função disponiblizada pelo professor
%obtem as curvas de distencia e de anagulos de uma imagem
 [cur_dist1,lx] = f_shape_from_edge(u2,v2,uc,vc);
 
end
 