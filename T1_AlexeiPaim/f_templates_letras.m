% Trabalho 1 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
% Função que obtem as letras para serem comparadas
% [Temp_letr] = f_templates_letras(L)
% Rettorna uma struct contendo as imagens dos cracteres encontrados, juntamente com a sua letra correspondente
% L =Valor do limiar

function [Temp_letr] = f_templates_letras(L)

I = rgb2gray(imread('templates_letras.png'));

%limiarização
 M = I< L;
% figure; imshow(M); 
%Extração de carcteristica 

[imLabel,N] = bwlabel(M);

%  figure; imshow(imLabel/N);
%  colormap hsv;
   
for i = 1:N
 
        I1= (imLabel == i); 

        [u1,v1]=find(I1);
        umax = max(u1);
        vmax = max(v1);
        umin = min(u1);
        vmin = min(v1);


        I1 = I1(umin:umax,vmin:vmax);
        %%
        [u6,v6] = size(I1);

        %homografia para todas as imagens de template ficarem com o mesmo tamanho

        v = [0; 0; u6; u6]; 
        u = [0; v6; v6; 0] ;


        v2 = [0; 0; 50; 50] ;
        u2 = [0; 50; 50; 0] ;


        %%
        %%Homografia Planar
       [I]=f_homografia(I1,u,v,u2,v2);

        %ajuste do tamanho da imagem para 50x51 
        I44 = zeros(50,51);
        [u7,v7] = size(I);

        I44(1:u7,1:v7)= I;

        % Salva cada letra em uma posição desta struct
        Temp_letr{1,i} = I44;
%         figure; imshow(I44);

end
          %manualmente foi realizado uma atribuição de letra para cada
          %carcter encontrado no template matching
        letras = [ 'A', 'O', 'H', 'U', 'B', 'P', 'I', 'V', 'J', 'C', 'Q', 'X', 'K', 'D', 'R', 'Z', 'L', 'E', 'S','W', 'M', 'F', 'T', 'N', 'G', ];
        
        for b = 1:N
            Temp_letr{2,b} = letras(1,b);
        end

        
        
        
end

 
