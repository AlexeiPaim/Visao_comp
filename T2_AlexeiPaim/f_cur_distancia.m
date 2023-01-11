
clear 
clc
close all

% Retangulo 
Iret = zeros(500,400);
Iret(150:250,100:300)= 1 ;

figure; imshow(Iret);


%% Pixels de Borda 
%função disponiblizada pelo professor
%retorna as cordenada dos pixels de borda
[u,v]=f_pixels_of_edge(Iret);

%função disponiblizada pelo professor
% Realiza a interpolação dos pontos de bordas obtidos para uma quantidade
% pré determinada
[u2,v2]= f_interpolation(u,v,100);

%% curva de Distancia e angulos 

%função que retorna os momentos
 m00 = mpq(Iret,0,0);
 m10 = mpq(Iret,1,0);
 m01 = mpq(Iret,0,1);
 
 uc = m10/m00;
 vc = m01/m00;
%função disponiblizada pelo professor
%obtem as curvas de distencia e de anagulos de uma imagem
 [cur_dist1,lx] = f_shape_from_edge(u2,v2,uc,vc);
 
 
 
 
 
figure; 
plot(cur_dist1);

title('Curva de distancia Retangulo');
