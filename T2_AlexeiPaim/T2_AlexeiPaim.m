clear
close all
clc

img_arqv = dir();

for c= 11:25 %intervalo das imagens na pasta

ax = img_arqv(c).name; %Atribui o nome do arquivo a uma varialvel auxiliar  

        I = imread(ax);% Realiza a leitura da imagem correspondente     

 
%Imagem convertida para escala de cinza
Iw = rgb2gray(I);

% Funçao que calcula Limiar de uma imagem em escala de cinza 
L = graythresh(Iw); 

%Função que realiza a binarização 
Tw = imbinarize(Iw, L); 

[tamu,tamv,] = size(Tw); % tamanho da imagem

% Condicional para operaçoes mrofologicas,
% dependente do valor de Limiar calculado e Tamanho da imagem

        if L > 0.59 
            S =strel('disk',8);%Operação de Erosão
            Tw = imerode(Tw,S);
        end
        
        if L > 0.40 && L < 0.59
             if tamv >= 1000 && tamu >= 400
                    S =strel('disk',4);
                    Tw = imerode(Tw,S);%Operação de Erosão
             else
                     S =strel('disk',1);
                    Tw = imerode(Tw,S);%Operação de Erosão
             end
            
                 
        end
        
         if  L < 0.40
            S =strel('disk',1);
            Tw = imopen(Tw,S);%Operação de Abertura
            
            Tw = imclearborder(Tw);%Operação Limpa borda
         end

S =strel('disk',1);
Tw = imopen(Tw,S);
Tw = imclearborder(Tw);
         
         
%rotulamento da imagem de entrada binarizada 
[IL,N] = bwlabel(Tw);

% Variaveis auxiliares
comp = 0;maior = 0;

% Percorre todo os segmentos de imagem e armazena o com maior quantidade de
% pixesl brancos 
        for i = 1:1:N
            
             I2 = (IL == i);
            %  figure; imshow(I2);
             [M,~] = find(I2);
             [aux,~]=size(M);

                 if aux > comp
                      comp = aux; %Armazena  maior segmento 
                      maior = i; %Armazena a posição do maior segmento 
                 end
        end
%  figure; imshow(Tw);
%  title('teste')

%obtem 30% do maior valor obtido.
menor = (comp * 0.3);

%realiza um filtro, no qual os segmentos com menos de 30% do maior tamanho são eliminados 
        for k = 1:N

          I44 = (IL == k);

        %  figure; imshow(I2);

         [cx,vx] = find(I44);
         [aux2,~]=size(cx);

            if aux2 < menor
                 for p=1:aux2
                    Tw(cx(p,1),vx(p,1))= 0;
                 end

        %     figure; imshow(Tw);
            end

        end      

% figure; imshow(Tw);title('saida')


%rotulamento da imagem passado pelo filtro de tamanho dos segmentos
[IM,Z] = bwlabel(Tw);


% Cria um Retangulo para realizar a comparação das curvas de distancia com
% a as placas
Iret = zeros(800,2000);
Iret(100:500,200:1800)= 1 ;
% figure; imshow(Iret);


% Função que retorna a curva de distancia de uma imagem
% (Reutilizada do Lab 3)
[cdret]=f_pxborda_cd(Iret);

% figure; 
% plot(cdret);
% title('Curva de distancia Retangulo');

% Variaveis auxiliares
tr=0; sv =0;

%Realiza a obtenção das curvas de distancia pra cada elemento do
%rotulamento da imagem passado pelo filtro de tamanho dos segmentos.Faz
%comparaçãp das curvas com o a curva do retangulo e armazena maior o valorobtido 
        for q = 1:Z

            In =(IM == q); 
            % figure; imshow(In);

            [cdcomp]= f_pxborda_cd(In);

            [ret,plo1, plo2] = f_norm_cc(cdret,cdcomp);
            %  figure; 
            % 
            % plot(plo1)
            %     title('Curva de distancia');
            %     hold on
            %     plot(plo2)
            %     
            if ret > tr

                tr = ret;
                sv = q; %Salva a posição do segemnto com maior valor de comparação  

            end

        end

% segmento com a imagem da placa
Im =(IM == sv);  

%  figure; imshow(Im)
%  title('bhhaskrrdvhbasrbarbad')

 I1=Im; % cria uma imagem identica, para que esta passe por operaços 
 
 
 %Operação de bounding box pra isolar o segmento de interese
 [u1,v1]=find(I1);
        umax = max(u1);
        vmax = max(v1);
        umin = min(u1);
        vmin = min(v1);
        
        I1 = I1(umin:umax,vmin:vmax); %Realiza o corte 
        
        I3 = (I1 == 0); %Realiza a inverção da binarização
        
        I3 = imclearborder(I3);%Operação Limpa borda
        
%      figure; imshow(I3)
     
     Im(umin:umax,vmin:vmax)= I3;% Subtitui a imagem  da região da placa, 
     % pela imagem com os pixel "Ivertidos"
     
%      figure; imshow(Im)
     
     

%% Altura de cada letra

%rotulamento da imagem com obtida na etapa acima 
[Ig,N2] = bwlabel(Im);

% Variaveis auxiliares
comp2 = 0;mai2 = 0;

%Percorre os segemntos da imagem Im, e armazena o com maior valor de
%altura(u)
        for i2 = 1:1:N2

          I2 = (Ig == i2);

        %  figure; imshow(I2);

         [u6,v6] = find(I2);
                umax = max(u6);
                umin = min(u6);

          F = umax - umin;

             if F > comp2
              comp2 = F;  
              mai2 = i2;
             end

        end


%calcula e armazena o 50% da maior altura
comp2 = comp2*0.5;

% Realiza um filtro, onde os segmentos que tanham a altura menor que 50%,
% são eliminadas
        for i5 = 1:1:N2

             I2 = (Ig == i5);

            %  figure; imshow(I2);

             [u6,v6] = find(I2);
                    umax = max(u6);
                    umin = min(u6);

              F = umax - umin;

                     if F < comp2 
                        Im(u6(:,1),v6(:,1))= 0;
                     end


        end
%  figure; imshow(Im);

%rotulamento da imagem com somente as letras isoladas
[Io,N3] = bwlabel(Im);


figure;imshow(I);title(ax);

%para cada segemto , realiza-se a operação de bounding box, para obter-se
%as posiçãoes maximas e minimas
       for i = 1:N3

             I2 = (Io == i);

            %  figure; imshow(I2);

             [v6,u6] = find(I2);
                    umax = max(u6);
                    vmax = max(v6);
                    umin = min(u6);
                    vmin = min(v6);
                    
                %Na imagem de entrada é plotada as linhas que demarcas as
                %regios de letras.
                
              %função que plota as linhas vermelhas ao redos das letras
              plot_box(umin,vmin,umax,vmax,'r','LineWidth', 2)  

        end 
pause(0.1)

end

%Realiza a normalização das curvas e reliza a comparação entre elas
% Retorna o Valor maximo de comparação e as curvas normalizadas
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
correlacao = zeros(1,500);

% Correlacao circular 
    for k = 1:500
    
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
 
    end

 ret = max(correlacao);
% disp(ret)
end
