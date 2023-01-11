 % Trabalho 1 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
% Função que segmenta imagens 
% [Temp_letr,p,I1]= f_seggmen_1(I,N,M)
% Rettorna uma struct contendo as imagens dos cracteres encontrados, juntamente com a sua letra correspondente
% I=imagen de entrada
% N = valor vertical para dilatação
% M = valor Horizontal para dilatação

function [Temp_letr,p,I1]= f_seggmen(I,N,M)

% Tratamento para realizar a segmentação 
s = strel('rectangle', [N, M]);% Dilatação horizontal
I6 = imdilate(I, s);
% figure;imshow(I6);

%%%Extração de carcteristica 
[imLabel,N] = bwlabel(I6);
p=0;
n=1;

%  figure; imshow(imLabel/N);
%  colormap jet;

for i = 1:N
 
% Separa Cada segmento encontrado  pela função  bwlabel
I1= (imLabel == i); 
 
[u1,v1]=find(I1);
umax = max(u1);
vmax = max(v1);
umin = min(u1);
vmin = min(v1);

% Corta do tamanho do segmento encontrado
I1 = I(umin:umax,vmin:vmax);

[hh,~]=size(I1);%obtem o tamanho da imagem cortada

    if hh > 20 %verifica o tamanho, caso a altura seja meno que 20, este segmento é descartado 
               % Maneira de eliminar os ':'
               
        Temp_letr{1,n} = I1;% salva na strutct que sera retornda
        
        p = p+1;
        n = n+1;
%         figure;imshow(I1);
    end


end