% Trabalho 1 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
% Função de homografia planar
% [I10] = f_homografia(Ix,u,v,u2,v2)
% Rettorna a imagem que passou pela homografia
% Ix=imagen de entrada
% u = vetor com as quatro posiçoesde linha da imagem original
%    (cima esque - cima dir - baixo dir -baixo esque)
% v = vetor com as quatro posiçoes coluna da imagem original
%    (cima esque - cima dir - baixo dir -baixo esque)
% u2 = vetor com as quatro posiçoesde linha da tranformação
%    (cima esque - cima dir - baixo dir -baixo esque)
% v2 = vetor com as quatro posiçoes coluna da tranformação
%    (cima esque - cima dir - baixo dir -baixo esque)

function [I10] = f_homografia(Ix,u,v,u2,v2)

%%Homografia Planar
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
  
  H = inv(A)*B;
   
  T = [ H(1,1), H(2,1), H(3,1);
        H(4,1), H(5,1), H(6,1);
        H(7,1), H(8,1), 1;];
   
 tform = projective2d(T.');
 [I10] = imwarp(Ix, tform);


end