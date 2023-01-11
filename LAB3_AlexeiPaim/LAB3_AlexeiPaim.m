%% Laboratorio 3 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
%LAB 3 - Reconhecimento de Objetos

clear; 
clc;
close all;

%% Imagens de Compação

%carrega imagem base para à alicate
Ial = imread('alicate01.png');
[Ial2,crv_dis_al]= f_limiar_pxborda_cd(Ial,230);

%carrega imagem base para à chave de fenda
Ife = imread('chave_fenda01.png');
[Ife2,crv_dis_fe]= f_limiar_pxborda_cd(Ife,230);

%carrega imagem base para à chave de Boca
Icb = imread('chave_boca01.png');
[Icb2,crv_dis_Icb]= f_limiar_pxborda_cd(Icb,230);


%% Plotagem inicial, com as imagens base, Limiarização com operaçoes 
% morfologicas e Grafico da curva de distancia. 
figure;

subplot(3,3,1)
imshow(Ial)
title('Alicate')

subplot(3,3,2)
imshow(Ife)
title('Chave de fenda')

subplot(3,3,3)
imshow(Icb)
title('Chave de boca')

subplot(3,3,4)
imshow(Ial2)
title('Binarização Alicate')

subplot(3,3,5)
imshow(Ife2)
title('Binarização Chave de fenda')


subplot(3,3,6)
imshow(Icb2)
title('Binarização Chave de boca')


subplot(3,3,7)
plot(crv_dis_al)
title('Curva de distância Alicate')

subplot(3,3,8)
plot(crv_dis_fe)
title('Curva de distância Chave de fenda')

subplot(3,3,9)
plot(crv_dis_Icb)
title('Curva de distancia Chave de boca')




pause(1) %% pausa no programa
%%

%% Funçao responsavel por realizar a leitura dos arquivos do diretorio  
img_arqv = dir();

saida = string(zeros(30,2));

x1 = 1;

% Laço de repetição que realiza a leitura dos arquivos .png do diretorio 
for i = 6:1:35
    
    aux = img_arqv(i).name; %Atribui o nome do arquivo a uma varialvel auxiliar  
  
    Icom = imread(aux);% Realiza a leitura da imagem correspondente 
    
    %chama a funçao que retorna a imagem processada e a sua curva de
    %distancia 
    [I3,curva_distancia2]= f_limiar_pxborda_cd(Icom,240);
    
    %para cada um dos tres objetos, realiza-se a compararção das curvas de
    %distancia obtidas
    [max1,ya1,ya2] = f_norm_cc(crv_dis_al,curva_distancia2);
    
    [max2,yf1,yf2] = f_norm_cc(crv_dis_fe,curva_distancia2);
    
    [max3,yc1,yc2] = f_norm_cc(crv_dis_Icb,curva_distancia2);
    
    
    %verifica à qual dos obetos a imagem analisada, mais se aproxima 
    if max2 > max1 && max2 > max3
       T =('Esta imagem é uma Chave de fenda');
       Q = ('Chave de fenda');
       y1 = yf1;
       y2 = yf2;
        
    end
       
    if max1 > max2 && max1 > max3
        T =('Esta imagem é um Alicate');
        Q = ('Alicate');
        y1 = ya1;
        y2 = ya2;
           
    end
          
     if max3 > max2 && max3 > max1
      T = ('Esta imagem é uma Chave de boca');
      Q = ('Chave de boca');
      y1 = yc1;
      y2 = yc2;  
     end
     
%Plota a imagem analisada, com o seu respectivo titulo, obtido atraves do processamento
%juntamente com a comparação da curva de distancia. 
figure; 
subplot(1,2,1);
plot(y1);

title('Curva de distancia');
hold on
plot(y2,'r');
legend('Img. Referência','Img. Atual');

subplot(1,2,2);
imshow(Icom)
title(T);

saida(x1,1) = aux;
saida(x1,2) = Q;

x1 = x1+ 1;
     
pause(0.5) % pausa entre o laço de repetição. 
end
 
 


function [ret,plo1, plo2] = f_norm_cc(crv_dist,crv_dist_comp)

% Normalização das curvas
x1 = crv_dist - mean(crv_dist); 
x2 = crv_dist_comp - mean(crv_dist_comp);

y1 = x1/sqrt(sum(x1.^2));
y2 = x2/sqrt(sum(x2.^2));

plo1 = y1;
plo2 = y2;




% % figure('units','centimeters','position', [2 2 28 13]);
% % figure; plot(y1); hold on;plot(y2, 'k');
correlacao = zeros(1,100);

% Correlacao circular 
    for k = 1:100
    
        y2 = circshift(y2,1);
    
        correlacao(k) = sum(y1.*y2);
        
%         cla;
%         subplot(1,2,1); cla; plot(y1,'color','r','linestyle','-'); hold on;
%         subplot(1,2,1);plot(y2,'color','k','linestyle','-');
%         title('Ilustração da operação de correlação circular')
%         legend('Img. Referência','Img. Atual');
%         subplot(1,2,2);plot(correlacao(1:k)),ylim([-0.65,1]);xlim([1,100]);
%         title('Curva de Correlação')
%         
%         pause(0.1)
%         
%         
        
    
    end

 ret = max(correlacao);
end

 
 





