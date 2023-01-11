
%% Laboratorio 2 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
% Parte 2
%realiza a detecção de borda pelo algoritmode Canny
% f_detec_borda_canny(I, sig,Th, Tl)
% I = imagem de entrada (escala de cinza)
% sig = parametro para filtro gaussiano
% Th = Limiar superior
% Tl = Limiar Inferior
 


function Ib = f_detec_borda_canny(I, sig,Th, Tl)



% figure; imshow(I);

%% Kernel Gaussinao
w = 15;
% sig = 4;
K = fspecial('gaussian', [w,w], sig);

%% passa a imagem em escala de cinza pelo filtro Gaussinao

Is =filter2(K,I,'same');

Is = uint8(Is);

% figure; imshow(Is);

%% Parte resposavel por Detecção de borda 

Ku = [-1 0 1; -2 0 2; -1 0 1];
Kv = Ku.';

Iu = filter2(Ku,Is,'same'); %bordas vertical

Iv = filter2(Kv,Is,'same');%Borda Horizontais 

% magnitude M
M = sqrt(Iu.^2 + Iv.^2); 
% 
% figure; imagesc(M);
% colormap gray; colorbar;


% fase α
P = atan2d(Iv,Iu);

% figure; imagesc(P);
% colormap jet;colorbar;
% title('detecção')




[u,v] = size(Is);% Encotra o tamanho da matriz/imagem que foi filtrada

Gn = zeros(u,v);  %% Cria-se uma imagem GN (com pixels nulos), com a mesma dimensão de Is.

%% faz a verificação da direcão do gradiente

for i = 2: 1:u-1
    for l = 2: 1:v-1
        
        %Seleciona os pixels vizinhos adjacentes ao 
        %pixel (u, v) na direcao do gradiente, conferme aponta a direção
        %do graiente.
        
        %Verifica se a magnitude do gradiente do pixel 
        %e maior do que a magnitude do gradiente dos dois vizinhos
        %quando afirmativo, tem-se  pixel (u, v)  de borda
        
      
        %67,5 < θ <112.5  ou  -112< θ <-67,5
        if ((P(i,l)) > 67.5  && (P(i,l)) < 112.5 )|| ((P(i,l))> -112.5  && (P(i,l)< -67.5  ))
            if (M(i,l) > M(i-1,l))&& (M(i,l) >M(i+1,l))
                Gn(i,l) =  M(i,l);
            else 
                 Gn(i,l)= 0;
            end
        end
        
            %   %22,5 < θ <67,5  ou  -157,5< θ <-112,5
        if   (P(i,l)) > 22.5  && (P(i,l)) < 67.5 || (P(i,l)) > -157.5  && (P(i,l)) < -112.5 
            if (M(i,l) > M(i-1,l-1))&& (M(i,l) >M(i+1,l+1))
                Gn(i,l) =  M(i,l);
            else 
                 Gn(i,l)= 0;
            end
        end
                %112,5 < θ <157,5  ou  -67,5< θ <-22,5
          if   (P(i,l)) >112.5  && (P(i,l))< 157.5 || (P(i,l))> -67.5  && (P(i,l)) < -22.5
            if (M(i,l) > M(i+1,l-1))&& (M(i,l) >M(i-1,l+1))
                 Gn(i,l) = M(i,l);
            else 
                 Gn(i,l)= 0;
            end
          end
          
           %157,5 < θ <- 157,5  ou  -22,5< θ <22,5
           if   (((P(i,l)) >157.5  && (P(i,l)) < 180 || (P(i,l))> -180 && (P(i,l)) < -157.5))|| ((P(i,l)) > - 22.5  && (P(i,l))< 0 || (P(i,l))> 0 && (P(i,l)) < 22.5  )
            if (M(i,l) > M(i,l-1)) && (M(i,l) > M(i,l+1))
                 Gn(i,l) = M(i,l);
            else 
                 Gn(i,l)= 0;
            end
          end
          
            

    end
end

Gn = uint8(Gn);
% figure; imagesc(Gn); colormap gray; colorbar;

%% Processo de limializacão duplo.

% Th = 42; %% definido pro tentativas
% 
% Tl = 25; %definido pro tentativas

%duas imagens binarias a partir das seguintes comparacoes
Gnh = (Gn >= Th); %Limiarização alto

Gnl = (Gn >= Tl); % Limiarização baixa
% 
% figure; subplot(2,2,1);imshow(Gnl); colormap gray; title('Gnl'); 
% subplot(2,2,2); imshow(Gnh);colormap gray; title('Gnh');
  
%%remove-se de GNL todos os pixels brancos que possue em comum com
%a imagem GNH
Gnl = Gnl - Gnh;

% subplot(2,2,3); imshow(Gnl);colormap gray; title('Gnl subtr');

%% Etapa 5 Analise de conectividade.

[u,v]= find(Gnh); %encontra os indiceces dos pontos diferentes de 0


[tamu,lix] = size(u); % tamanho da matriz encontrada no find
 
[ax,ay] = size(Gnl); %tamho para criar a matriz auxiliar

aux = zeros(ax,ay); % Matriz auxiliar composta por zeros 

%Percorre todos os pixels de borda 
%Para cada pixel de borda (u, v) de GNH, selecione a 
% regiao (janela 3 × 3) correspondente na imagem GNL.
%Na imagem GNL, marca como pixels de borda validos todos os pixels branco na
%janela analisada.


for i = 1:1:tamu
    
    aux(u(i,1)-1:u(i,1)+1,v(i,1)-1:v(i,1)+1)= Gnl(u(i,1)-1:u(i,1)+1,v(i,1)-1:v(i,1)+1) ; 

end
% 
% figure; imshow(aux);
% title('aux');
% colormap gray;
% colorbar;

%A imagem de borda final ser´a formada pelos pixels de borda v´alidos de GNH e GNL

Ib = Gnh + aux;
% 
% figure; imshow(Ib);
% title('Ib');
% colormap gray;
% colorbar;
end




